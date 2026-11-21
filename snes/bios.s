; The SGB BIOS's state across the kernel's session, so EXIT (SGBFS_CMD_EXIT) can hand the SNES back to it: to
; the BIOS's 160x144 picture, its menu and its command loop, with the GB still running (notes/SGB.md, "Returning
; to the BIOS at run time").
;
; BiosSave runs first thing at JUMP, on the BIOS's stack, before the kernel touches anything. It sends the BIOS's
; sound driver to the IPL ROM ($FE on port 0: it keys off, mutes and jumps there; $FF, SOU_TRN's, is the driver's
; own loader, which returns to the driver), loads a small SPC700 transfer server through the IPL and parks in
; ARAM, over the driver's samples, what the kernel will overwrite: the BIOS's video (VRAM, CGRAM, OAM, DMA'd
; through a staging buffer) and the WRAM it keeps live there. The server then waits, the DSP muted, for the rest
; of the session. The extension's FarBiosReturn (EXIT) reads it all back, puts the samples back from the BIOS
; ROM, restarts the driver, writes the BIOS's PPU/IRQ registers (write-only: this BIOS's known values) and
; returns into the BIOS through its stack, as the Phase 0c handoff probe does. Only the BIOS whose header
; checksum is known (SGB1 1.2) is saved; on any other, BiosFlag stays 0 and the kernel doesn't offer EXIT.
;
; No direct page and no WRAM of the BIOS's is used for work: the state below lives in the kernel's image ($7F,
; long addressing), and the streams index bank $7E (or the ROM's bank) with X.
.setcpu "65816"
.export BiosSave, BiosFlag, _BiosReturn
.export BiosStateEnd, IplRd ; (tests/sgb/kernel.lua: the image bytes BiosSave changes are BiosFlag up to here)
.import __BSS_RUN__, __BSS_SIZE__
.assert __BSS_RUN__ + __BSS_SIZE__ <= $5400, lderror, "the kernel's BSS runs past the BIOS snapshot's $5000-$53FF"

STASH = $4DB0   ; ARAM: the driver's samples' block ($4DB0-$EEEF), the snapshot goes over its start
SERVER = $EE40  ; ARAM: the transfer server, the samples' last 176 bytes
DRIVER = $0400  ; ARAM: the sound driver's entry (each of the BIOS's uploads ends there)
IPL = $FFC0     ; the SPC's IPL ROM
SAMPLES_AT = $32999 ; the BIOS ROM (a file offset): the samples' block's data (its upload stream from $06:8000)
SAMPLES = (SAMPLES_AT >> 15) << 16 | $8000 | (SAMPLES_AT & $7FFF) ; (LoROM)
BANK6 = ($10000 - (SAMPLES & $FFFF)) / 3 ; its groups of 3 in bank 6 (exactly: the rest start at $07:8000)
.assert (SAMPLES & $FFFF) + BANK6 * 3 = $10000, error, "the samples' bank 6 part isn't whole groups"
BIOS_RTS = $00AC88 ; an RTS in the BIOS's bank 0: the JUMP handler's caller is returned to through it
BIOS_NMI = $00B50A ; the BIOS's NMI pointer at $00BB (JUMP set it to the kernel's)
SERVER_AT = SAMPLES_AT + SERVER - STASH ; the samples' bytes under the server
SERVER_ROM = (SERVER_AT >> 15) << 16 | $8000 | (SERVER_AT & $7FFF)
STAGE = $6000   ; $7E: the PPU's memories pass through here (the kernel's row cache; not the BIOS's live state)

KIND_WRAM = 1   ; $7E:address, streamed in place
KIND_VRAM = 2   ; word address
KIND_CGRAM = 3
KIND_OAM = 4

SRV_WRITE = 1
SRV_READ = 2
SRV_JUMP = 3

.segment "CODE"
; What the kernel overwrites that the BIOS needs back, in stream order: kind, address, bytes, groups of 3 (a
; segment's last group may run 2 bytes on; WRAM's are the BIOS's own bytes there, saved and put back). VRAM: the
; border's tiles and map, BG1's (the menu's) tiles and map, the sprites' tiles, the GB screen's map (its tiles are
; refreshed from the ICD2 every frame). WRAM: the kernel's direct page, flags and stack, the start of its BSS
; (the link check above keeps it below $5400) and its capture buffer where the BIOS's measured live state is.
.macro SEG kind, address, bytes
 .byte kind
 .word address, bytes, (bytes + 2) / 3
.endmacro
SEG_SIZE = 7
List:
 SEG KIND_VRAM, $0000, $2000
 SEG KIND_VRAM, $3800, $1000
 SEG KIND_VRAM, $4000, $2000
 SEG KIND_VRAM, $6000, $2000
 SEG KIND_VRAM, $7C00, $0800
 SEG KIND_CGRAM, 0, 512
 SEG KIND_OAM, 0, 544
 SEG KIND_WRAM, $0000, $0100
 SEG KIND_WRAM, $1000, $0200
 SEG KIND_WRAM, $1F00, $0100
 SEG KIND_WRAM, $5000, $0400
 SEG KIND_WRAM, $C000, $0100
 SEG KIND_WRAM, $CB00, $0200
ListEnd:
GROUPS = ($2000 + 2) / 3 * 3 + ($1000 + 2) / 3 + ($0800 + 2) / 3 + (512 + 2) / 3 + (544 + 2) / 3 + ($0100 + 2) / 3 * 3 + ($0200 + 2) / 3 * 2 + ($0400 + 2) / 3
.assert STASH + GROUPS * 3 <= SERVER, error, "the BIOS snapshot overruns the transfer server"

; The DMA for a kind's PPU memory: B-bus register to read it, to write it, transfer mode
DmaRead: .byte 0, 0, $39, $3B, $38
DmaWrite: .byte 0, 0, $18, $22, $04
DmaMode: .byte 0, 0, 1, 0, 0

; The SPC700 transfer server, loaded at SERVER through the IPL. Ports: the SNES writes a packet's bytes 1-3 and
; then a new value in port 0; the server echoes port 0 once it has them. A command packet is (command, address);
; WRITE and READ then take a count packet (groups of 3 bytes) and that many data packets (READ: the server puts
; the 3 bytes in ports 1-3 before its echo); JUMP goes to the address. X keeps port 0's last value; zero page:
; $00 pointer, $02 count, $10-$12 a group. It starts by muting the DSP (soft reset, echo writes off) and says
; it's ready with $A5 in port 1.
.macro BR op, target
 .byte op
 .byte <(target - * - 1) ; (* is this byte's address: the branch counts from the next instruction)
.endmacro
.macro STEP ; the pointer's next byte (y stays 0)
 .byte $3A, $00      ; incw $00
.endmacro
Server:
.org SERVER
 .byte $8F, $6C, $F2 ; mov $F2,#$6C
 .byte $8F, $E0, $F3 ; mov $F3,#$E0
 .byte $F8, $F4      ; mov x,$F4
 .byte $D8, $F4      ; mov $F4,x
 .byte $8F, $A5, $F5 ; mov $F5,#$A5
@command:
 .byte $3E, $F4      ; cmp x,$F4
 BR $F0, @command    ; beq
 .byte $F8, $F4      ; mov x,$F4
 .byte $FA, $F6, $00 ; mov $00,$F6
 .byte $FA, $F7, $01 ; mov $01,$F7
 .byte $E4, $F5      ; mov a,$F5
 .byte $D8, $F4      ; mov $F4,x
 .byte $68, SRV_JUMP ; cmp a,#JUMP
 BR $D0, @count      ; bne
 .byte $CD, $00      ; mov x,#0
 .byte $1F, $00, $00 ; jmp [$0000+x]
@count:
 .byte $3E, $F4      ; cmp x,$F4
 BR $F0, @count      ; beq
 .byte $F8, $F4      ; mov x,$F4
 .byte $FA, $F5, $02 ; mov $02,$F5
 .byte $FA, $F6, $03 ; mov $03,$F6
 .byte $D8, $F4      ; mov $F4,x
 .byte $8D, $00      ; mov y,#0
 .byte $68, SRV_WRITE ; cmp a,#WRITE (a: the command)
 BR $D0, @read       ; bne
@write:
 .byte $3E, $F4      ; cmp x,$F4
 BR $F0, @write      ; beq
 .byte $F8, $F4      ; mov x,$F4
 .byte $FA, $F5, $10 ; mov $10,$F5
 .byte $FA, $F6, $11 ; mov $11,$F6
 .byte $E4, $F7      ; mov a,$F7
 .byte $D8, $F4      ; mov $F4,x (the SNES sends the next group while these are stored)
 .byte $C4, $12      ; mov $12,a
 .byte $E4, $10      ; mov a,$10
 .byte $D7, $00      ; mov [$00]+y,a
 STEP
 .byte $E4, $11      ; mov a,$11
 .byte $D7, $00      ; mov [$00]+y,a
 STEP
 .byte $E4, $12      ; mov a,$12
 .byte $D7, $00      ; mov [$00]+y,a
 STEP
 .byte $1A, $02      ; decw $02
 BR $D0, @write      ; bne
 BR $2F, @command    ; bra
@read:
 .byte $F7, $00      ; mov a,[$00]+y
 .byte $C4, $10      ; mov $10,a
 STEP
 .byte $F7, $00      ; mov a,[$00]+y
 .byte $C4, $11      ; mov $11,a
 STEP
 .byte $F7, $00      ; mov a,[$00]+y
 .byte $C4, $12      ; mov $12,a
 STEP
@request:
 .byte $3E, $F4      ; cmp x,$F4
 BR $F0, @request    ; beq
 .byte $F8, $F4      ; mov x,$F4
 .byte $FA, $10, $F5 ; mov $F5,$10
 .byte $FA, $11, $F6 ; mov $F6,$11
 .byte $FA, $12, $F7 ; mov $F7,$12
 .byte $D8, $F4      ; mov $F4,x
 .byte $1A, $02      ; decw $02
 BR $D0, @read       ; bne
 BR $2F, @command    ; bra
@end:
SERVER_SIZE = @end - SERVER
.reloc
.assert SERVER + SERVER_SIZE <= $EEF0, error, "the transfer server overruns the samples' block"

; ---- state (the image's; long addressing) ----
BiosFlag: .byte 0 ; 1: the BIOS is saved, EXIT can return to it
BiosSp: .word 0   ; its stack pointer after Boot pushed its registers
Seq: .byte 0      ; port 0's last value
Count: .word 0
IplEntry: .word 0
Entry: .word 0   ; the current segment's List offset
BiosStateEnd:

.a8
.i16
; Wait for the IPL's $BBAA. Carry set on a timeout (about a second). (JSL: the extension calls it too)
IplReady:
 ldy #8
@outer:
 ldx #0
@poll:
 lda f:$002140
 cmp #$AA
 bne @no
 lda f:$002141
 cmp #$BB
 beq @ok
@no:
 dex
 bne @poll
 dey
 bne @outer
 sec
 rtl
@ok:
 clc
 rtl

; IPL transfer: X bytes from IplRd's operand to ARAM Count, then run ARAM IplEntry. (JSL)
IplSend:
 rep #$20
.a16
 lda f:$7F0000+Count
 sta f:$002142
 sep #$20
.a8
 lda #1
 sta f:$002141
 lda #$CC
 sta f:$002140
@cc:
 cmp f:$002140
 bne @cc
 ldy #0
IplByte:
IplRd:
 lda f:$000000
 sta f:$002141
 rep #$20
.a16
 lda f:$7F0000+IplRd+1
 inc a
 sta f:$7F0000+IplRd+1
 sep #$20
.a8
 tya
 sta f:$002140
@echo:
 cmp f:$002140
 bne @echo
 iny
 dex
 bne IplByte
 rep #$20
.a16
 lda f:$7F0000+IplEntry
 sta f:$002142
 sep #$20
.a8
 lda #0
 sta f:$002141
 tya
 inc a
 bne @kick
 inc a
@kick:
 sta f:$002140
@run:
 cmp f:$002140
 bne @run
 rtl

; Ports 1-3 are set: the next port 0 value (never the IPL's $CC: after JUMP to it, a stale $CC would begin a
; transfer); wait for its echo.
Request:
 lda f:$7F0000+Seq
 inc a
 cmp #$CC
 bne @seq
 inc a
@seq:
 sta f:$7F0000+Seq
 sta f:$002140
@echo:
 cmp f:$002140
 bne @echo
 rts

; A command packet (A command, X address) then a count packet (GROUPS).
Command:
 sta f:$002141
 rep #$20
.a16
 txa
 sta f:$002142
 sep #$20
.a8
 jsr Request
 rep #$20
.a16
 lda #GROUPS
 sta f:$002141
 sep #$20
.a8
 jmp Request

; Segment Entry's PPU memory to the staging buffer (carry clear) or from it (carry set), by DMA channel 0. Keeps
; X, Y.
PpuDma:
 php
 phx
 rep #$20
.a16
 lda f:$7F0000+Entry
 tax
 sep #$20
.a8
 lda #$80
 sta f:$002115
 rep #$20
.a16
 lda f:$7F0000+List+1, x
 sta f:$002116 ; (VRAM's word address; the others start from 0)
 lda f:$7F0000+List+3, x
 sta f:$004305
 lda #STAGE
 sta f:$004302
 lda f:$7F0000+List, x
 and #$00FF
 tax ; the kind
 sep #$20
.a8
 lda #0
 sta f:$002121
 sta f:$002102
 sta f:$002103
 lda #$7E
 sta f:$004304
 lda 3, s ; the caller's carry (php's P)
 lsr a
 bcs @write
 lda f:$00213A ; (a VRAM read gives the latch first: one word to load it with the first)
 lda f:$7F0000+DmaRead, x
 sta f:$004301
 lda f:$7F0000+DmaMode, x
 ora #$80
 bra @go
@write:
 lda f:$7F0000+DmaWrite, x
 sta f:$004301
 lda f:$7F0000+DmaMode, x
@go:
 sta f:$004300
 lda #1
 sta f:$00420B
 plx
 plp
 rts

; Segment X (to Entry): its start in $7E in X (its WRAM address, or the staging buffer: carry, its kind isn't
; WRAM), its groups in Y.
Where:
 rep #$20
.a16
 txa
 sta f:$7F0000+Entry
 lda f:$7F0000+List+5, x
 tay
 sep #$20
.a8
 lda f:$7F0000+List, x
 cmp #KIND_VRAM ; (carry: a PPU memory's)
 rep #$20
.a16
 lda #STAGE
 bcs @ppu
 lda f:$7F0000+List+1, x
@ppu:
 tax
 sep #$20
.a8
 rts

; Boot calls this at JUMP, on the BIOS's stack with its registers pushed (A8, I16, X its stack pointer).
BiosSave:
 rep #$20
.a16
 txa
 sta f:$7F0000+BiosSp
 lda f:$00FFDC ; SGB1 1.2: checksum complement $09CD, checksum $F632
 cmp #$09CD
 bne @other
 lda f:$00FFDE
 cmp #$F632
@other:
 sep #$20
.a8
 beq @known
 rts
@known:
 lda #$80
 sta f:$002100 ; forced blank: the PPU's memories can be read
 lda #0
 sta f:$004200
 sta f:$00420C
 ; the driver to the IPL ROM. It acts on port 0 only when it changes (each timer tick), so 0 first
 sta f:$002140
 ldx #0 ; (about 0.1 s: the driver's tick is 2 ms)
@wait:
 dex
 bne @wait
 lda #$FE
 sta f:$002140
 jsl $7F0000+IplReady
 bcc @ipl
 rts
@ipl:
 rep #$20
.a16
 lda #SERVER
 sta f:$7F0000+Count
 sta f:$7F0000+IplEntry
 lda #.loword($7F0000 + Server)
 sta f:$7F0000+IplRd+1
 sep #$20
.a8
 lda #$7F
 sta f:$7F0000+IplRd+3
 ldx #SERVER_SIZE
 jsl $7F0000+IplSend
@ready:
 lda f:$002141
 cmp #$A5
 bne @ready
 lda f:$002140
 sta f:$7F0000+Seq
 lda #SRV_WRITE
 ldx #STASH
 jsr Command
 ldx #0
@segment:
 phx
 jsr Where
 bcc @group
 clc
 jsr PpuDma
@group:
 lda f:$7E0000, x
 sta f:$002141
 lda f:$7E0001, x
 sta f:$002142
 lda f:$7E0002, x
 sta f:$002143
 inx
 inx
 inx
 jsr Request
 dey
 bne @group
 rep #$20
.a16
 pla
 clc
 adc #SEG_SIZE
 tax
 sep #$20
.a8
 cpx #ListEnd - List
 bne @segment
 lda #1
 sta f:$7F0000+BiosFlag
 rts

; The extension's way into the routines above (it runs in $7E: JSL here, RTL back)
FarRequest:
 jsr Request
 rtl
FarCommand:
 jsr Command
 rtl
FarPpuDma:
 jsr PpuDma
 rtl
FarWhere:
 jsr Where
 rtl

; EXIT (kernel.c, once the extension is loaded): the return is the extension's, the image has no room for it
_BiosReturn:
 jml $7E0000+FarBiosReturn

; ---- the extension's part: EXIT's (CODE sends it; it runs from $7E:DC00 on) ----
.segment "EXT"
.a8
.i16
; The samples, from the BIOS ROM's bank (DBR), X its first byte, Y groups of 3, to the server
Samples:
 lda a:$0000, x
 sta f:$002141
 lda a:$0001, x
 sta f:$002142
 lda a:$0002, x
 sta f:$002143
 inx
 inx
 inx
 jsl $7F0000+FarRequest
 dey
 bne Samples
 rts

; EXIT: give the SNES back to the BIOS (from _BiosReturn, any state); never returns.
FarBiosReturn:
 sei
 clc
 xce
 sep #$20
 rep #$10
.a8
.i16
 lda #0
 sta f:$004200
 sta f:$00420C
 lda #$80
 sta f:$002100
 rep #$20
.a16
 lda f:$7F0000+BiosSp
 tcs ; the BIOS's stack from here: the kernel's WRAM is about to be the BIOS's again
 sep #$20
.a8
 ; VRAM clear first (what the BIOS doesn't use was 0 at JUMP), then the saved parts over it
 lda #$80
 sta f:$002115
 rep #$20
.a16
 lda #0
 sta f:$002116
 sta f:$004305 ; (64 KiB)
 lda #Zero
 sta f:$004302
 sep #$20
.a8
 lda #$7E
 sta f:$004304
 lda #$09 ; fixed source, two registers
 sta f:$004300
 lda #$18
 sta f:$004301
 lda #1
 sta f:$00420B
 lda #SRV_READ
 ldx #STASH
 jsl $7F0000+FarCommand
 ldx #0
@segment:
 phx
 jsl $7F0000+FarWhere
 php
@group:
 jsl $7F0000+FarRequest
 lda f:$002141
 sta f:$7E0000, x
 lda f:$002142
 sta f:$7E0001, x
 lda f:$002143
 sta f:$7E0002, x
 inx
 inx
 inx
 dey
 bne @group
 plp
 plx
 bcc @next
 sec
 jsl $7F0000+FarPpuDma
@next:
 rep #$20
.a16
 txa
 clc
 adc #SEG_SIZE
 tax
 sep #$20
.a8
 cpx #ListEnd - List
 bne @segment
 ; the samples the snapshot covered, from the BIOS ROM (bank 6, then 7)
 lda #SRV_WRITE
 ldx #STASH
 jsl $7F0000+FarCommand
 lda #.bankbyte(SAMPLES)
 pha
 plb
 ldx #.loword(SAMPLES)
 ldy #BANK6
 jsr Samples
 lda #.bankbyte(SAMPLES) + 1
 pha
 plb
 ldx #$8000
 ldy #GROUPS - BANK6
 jsr Samples
 ; the server's own bytes through the IPL, then the driver from its entry
 rep #$20
.a16
 lda #IPL
 sta f:$002142
 sep #$20
.a8
 lda #SRV_JUMP
 sta f:$002141
 jsl $7F0000+FarRequest
 jsl $7F0000+IplReady
 rep #$20
.a16
 lda #SERVER
 sta f:$7F0000+Count
 lda #DRIVER
 sta f:$7F0000+IplEntry
 lda #.loword(SERVER_ROM)
 sta f:$7F0000+IplRd+1
 sep #$20
.a8
 lda #.bankbyte(SERVER_ROM)
 sta f:$7F0000+IplRd+3
 ldx #$EEF0 - SERVER
 jsl $7F0000+IplSend
 ; the BIOS's NMI pointer (JUMP made it the kernel's), its registers, then back into it
 lda #<BIOS_NMI
 sta f:$7E00BB
 lda #>BIOS_NMI
 sta f:$7E00BC
 lda #.bankbyte(BIOS_NMI)
 sta f:$7E00BD
 ldx #0
RetReg:
 rep #$20
.a16
 lda f:$7E0000+Regs, x
 beq RetBack
 sta f:$7E0000+RegWr+1
 sep #$20
.a8
 lda f:$7E0000+Regs+2, x
RegWr:
 sta f:$000000
 inx
 inx
 inx
 bra RetReg
RetBack:
 rep #$30
.i16
 plb
 pld
 ply
 plx
 pla
 plp
 cli ; (the JUMP handler set I just before it jumped: the BIOS's loop waits on its IRQs)
 jml BIOS_RTS

; The BIOS's registers as it left them at JUMP (Mesen, SGB1 1.2): register (bank 0), value; 0 ends. Scroll
; registers are written twice (the PPU takes two bytes). INIDISP and NMITIMEN last.
.macro REG register, value
 .word register
 .byte value
.endmacro
Regs:
 REG $2101, $02
 REG $2102, $00
 REG $2103, $00
 REG $2105, $01
 REG $2106, $00
 REG $2107, $38
 REG $2108, $3C
 REG $2109, $7C
 REG $210A, $7C
 REG $210B, $06
 REG $210C, $07
 REG $210D, $00
 REG $210D, $00
 REG $210E, $00
 REG $210E, $00
 REG $210F, $00
 REG $210F, $00
 REG $2110, $00
 REG $2110, $00
 REG $2111, $00
 REG $2111, $00
 REG $2112, $00
 REG $2112, $00
 REG $2115, $80
 REG $2123, $00
 REG $2124, $00
 REG $2125, $01
 REG $2126, $00
 REG $2127, $00
 REG $2128, $00
 REG $2129, $00
 REG $212A, $00
 REG $212B, $00
 REG $212C, $17
 REG $212D, $00
 REG $212E, $00
 REG $212F, $00
 REG $2130, $02
 REG $2131, $00
 REG $2132, $E0
 REG $2133, $00
 REG $420C, $00
 REG $420D, $01
 REG $4201, $FF
 REG $4207, $40
 REG $4208, $00
 REG $4209, $DF
 REG $420A, $00
 REG $6003, $81 ; the ICD2: one player, GB running (the kernel's four-player mailbox off)
 REG $6004, $FF
 REG $6005, $FF
 REG $6006, $FF
 REG $6007, $FF
 REG $2100, $0F
 REG $4200, $31 ; H and V IRQs and auto-read, as the BIOS runs; no NMI
Zero:
 .word 0
