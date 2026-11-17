; GB half of Phase 0b. The transport map is fixed: 120 tiles per page,
; 16 status tiles (last tile blank), no STAT interrupt or LCDC switching.
DEF GBFrame EQU $C110
DEF FrameBytes EQU $C112
DEF TotalBytes EQU $C114
DEF PeakBytes EQU $C118
DEF ActiveFrames EQU $C11A
DEF RttSum EQU $C11C
DEF RttMax EQU $C11E
DEF Stage EQU $C130
DEF TxSeq EQU $C132
DEF TxPage EQU $C133
DEF RxSeq EQU $C134
DEF RxFlags EQU $C135
DEF AckCount EQU $C136
DEF RejectCount EQU $C138
DEF SentFrame EQU $C13A
DEF Dest EQU $C13C
DEF TestCount EQU $C13E
DEF RawReply EQU $C140 ; B/E commit reads, C page, D flags
DEF SlotScan EQU $C148 ; four slow controller ID/byte pairs after timeout
DEF TxBuffer EQU $C200
SECTION "Bench VBlank", ROM0[$40]
  jp BenchVBlank
SECTION "Bench code", ROM0
Bench:
  di
  call LCDOff
  ld hl, $C110
  ld b, $40
  xor a
.clear
  ld [hli], a
  dec b
  jr nz, .clear
  ld hl, $8000
  ld bc, $2000
.zero
  xor a
  ld [hli], a
  dec bc
  ld a, b
  or c
  jr nz, .zero
  ld hl, $9800
  ld de, 12
  xor a
  ld c, 12
.row
  ld b, 20
.col
  ld [hli], a
  inc a
  dec b
  jr nz, .col
  add hl, de
  dec c
  jr nz, .row
  ld b, 16
.statusMap
  ld [hli], a
  inc a
  dec b
  jr nz, .statusMap
  ld a, $FF
  ld bc, $9C00-($9800+12*32+16)
.blank
  ld [hli], a
  dec bc
  ld d, a
  ld a, b
  or c
  ld a, d
  jr nz, .blank
  xor a
  ldh [rIF], a
  ld a, IEF_VBLANK
  ldh [rIE], a
  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000
  ldh [rLCDC], a
  ei
  ld b, 30
  call BenchWait
  ld a, 1
  ld [Stage], a
  ld a, 32
  ld [TestCount], a
.reliable
  call BenchNext
  call BenchSend
  call BenchAck
  ld hl, TestCount
  dec [hl]
  jr nz, .reliable
  ; An invalid checksum must produce NACK. Fix exactly that page, preserving
  ; the same sequence, and require ACK before entering the no-flow-control run.
  ld a, 2
  ld [Stage], a
  call BenchNext
  call BenchPrepare
  ld hl, TxBuffer+1918
  inc [hl]
  call BenchCopy
.badWait
  call BenchPoll
  jr nc, .badRead
  ld a, $E2
  jp BenchTimeout
.badRead
  call BenchRead
  ld a, [RxSeq]
  ld hl, TxSeq
  cp [hl]
  jr nz, .badWait
  ld a, [RxFlags]
  cp 2
  jr nz, .badWait
  ld hl, RejectCount
  inc [hl]
  call BenchSend
  call BenchAck
  ld a, 3
  ld [Stage], a
  ld a, 32
  ld [TestCount], a
.stress
  call BenchNext
  call BenchSend
  ld hl, TestCount
  dec [hl]
  jr nz, .stress
  ; Drain with a final acknowledged page; leave the finished counters visible.
  call BenchNext
  call BenchSend
  call BenchAck
  ld a, 4
  ld [Stage], a
  ld a, 6
  ld [PHASE], a
.done
  halt
  jr .done
BenchNext:
  ld hl, TxSeq
  inc [hl]
  ld a, [hl]
  and 1
  ld [TxPage], a
  ret
BenchSend:
  call BenchPrepare
BenchCopy:
  ld a, [TxPage]
  ld de, $8000
  and a
  jr z, .dest
  ld de, $8780
.dest
  ld a, e
  ld [Dest], a
  ld a, d
  ld [Dest+1], a
  ld hl, TxBuffer
  ld a, 120
  ld [TestCount+1], a
.tile
  ld b, 8
.pair
  di
.wait
  ldh a, [rSTAT]
  and STATF_BUSY
  jr nz, .wait
REPT 2
  ld a, [hli]
  ld [de], a
  inc de
ENDR
  ei
  dec b
  jr nz, .pair
  push hl
  di
  ld hl, FrameBytes
  ld a, [hl]
  add 16
  ld [hli], a
  jr nc, .counted
  inc [hl]
.counted
  ei
  pop hl
  ld a, [TestCount+1]
  dec a
  ld [TestCount+1], a
  jr nz, .tile
  ld a, [Dest]
  ld e, a
  ld a, [Dest+1]
  ld d, a
  ld a, [TxSeq]
  ld c, a
  di
.commit
  ldh a, [rSTAT]
  and STATF_BUSY
  jr nz, .commit
  ld a, c
  ld [de], a
  ld hl, FrameBytes
  inc [hl]
  jr nz, .lastCount
  inc hl
  inc [hl]
.lastCount
  ld a, [GBFrame]
  ld [SentFrame], a
  ei
  ret
BenchPrepare:
  ld hl, TxBuffer
  ld a, [TxSeq]
  ld [hli], a
  ld a, [Stage]
  ld [hli], a
  ld a, LOW(1914)
  ld [hli], a
  ld a, HIGH(1914)
  ld [hli], a
  ld bc, 1914
  ld a, [TxSeq]
.fill
  ld [hli], a
  inc a
  dec bc
  push af
  ld a, b
  or c
  jr z, .filled
  pop af
  jr .fill
.filled
  pop af
  ld hl, TxBuffer
  ld de, 0
  ld bc, 959
.sum
  ld a, [hli]
  add e
  ld e, a
  ld a, [hli]
  adc d
  ld d, a
  dec bc
  ld a, b
  or c
  jr nz, .sum
  ld [hl], e
  inc hl
  ld [hl], d
  xor a                    ; invalid until the sequence is committed last
  ld [TxBuffer], a
  ret
BenchAck:
  call BenchPoll
  jr nc, .read
  ld a, $E1
  jp BenchTimeout
.read
  call BenchRead
  ld a, [RxSeq]
  ld hl, TxSeq
  cp [hl]
  jr nz, BenchAck
  ld a, [RxFlags]
  cp 1
  jr nz, BenchAck
  ld hl, AckCount
  inc [hl]
  ld a, [GBFrame]
  ld hl, SentFrame
  sub [hl]
  ld b, a
  ld hl, RttMax
  cp [hl]
  jr c, .maxed
  ld [hl], a
.maxed
  ld hl, RttSum
  ld a, [hl]
  add b
  ld [hli], a
  ret nc
  inc [hl]
  ret
; Poll at most once per GB frame, with a bounded commit-to-reply wait.
; Preserve the raw response even when the seqlock rejects it.
BenchPoll:
  ld b, 1
  call BenchWait
  ld a, [GBFrame]
  ld hl, SentFrame
  sub [hl]
  cp 120
  ccf
  ret
BenchTimeout:
  ld [Stage], a
  ld a, $E1
  ld [PHASE], a
.hold
  call BenchScan
  halt
  jr .hold
; Diagnostic only: do not change the benchmark's mailbox reader or ACK result.
; Each select is held for >100 us; display the ID beside its corresponding byte
; so a rotated scan is still interpretable. The VBlank handler never writes P1.
BenchScan:
  di
  ld de, SlotScan
  ld c, 4
  ld a, $30
  ldh [rP1], a
.slot
  call .settle
  and 15
  ld [de], a
  inc de
  ld a, $20
  ldh [rP1], a
  call .settle
  and 15
  ld h, a
  ld a, $10
  ldh [rP1], a
  call .settle
  and 15
  swap a
  or h
  ld [de], a
  inc de
  ld a, $30
  ldh [rP1], a
  dec c
  jr nz, .slot
  ei
  ret
.settle
  ld b, 32
.wait
  ldh a, [rP1]
  dec b
  jr nz, .wait
  ret
BenchRead:
  call SNESMouseRead
  ld hl, RawReply
  ld a, b
  ld [hli], a
  ld a, e
  ld [hli], a
  ld a, c
  ld [hli], a
  ld a, d
  ld [hli], a
  ld a, b
  cp e
  ret nz
  bit 7, a
  ret nz
  ld [RxSeq], a
  ld a, d
  ld [RxFlags], a
  ret
BenchWait:
  ld a, [GBFrame]
.wait
  halt
  ld hl, GBFrame
  cp [hl]
  jr z, .wait
  dec b
  jr nz, BenchWait
  ret
BenchVBlank:
  push af
  push bc
  push de
  push hl
  ld hl, GBFrame
  inc [hl]
  jr nz, .frame
  inc hl
  inc [hl]
.frame
  ld a, [FrameBytes]
  ld e, a
  ld a, [FrameBytes+1]
  ld d, a
  or e
  jr z, .status
  ld hl, ActiveFrames
  inc [hl]
  jr nz, .active
  inc hl
  inc [hl]
.active
  ld hl, TotalBytes
  ld a, [hl]
  add e
  ld [hli], a
  ld a, [hl]
  adc d
  ld [hli], a
  jr nc, .total
  inc [hl]
  jr nz, .total
  inc hl
  inc [hl]
.total
  ld a, [PeakBytes]
  sub e
  ld a, [PeakBytes+1]
  sbc d
  jr nc, .status
  ld a, e
  ld [PeakBytes], a
  ld a, d
  ld [PeakBytes+1], a
.status
  ld hl, $8F00
  ld a, $53
  ld [hli], a
  ld a, [Stage]
  ld [hli], a
  ld a, [GBFrame]
  ld [hli], a
  ld a, [GBFrame+1]
  ld [hli], a
  ld a, e
  ld [hli], a
  ld a, d
  ld [hli], a
  ld de, PeakBytes
  ld b, 4
.peakActive
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jr nz, .peakActive
  ld de, TotalBytes
  ld b, 4
.bytes
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jr nz, .bytes
  ld a, [RxSeq]
  ld [hli], a
  ld a, [RttMax]
  ld [hli], a
  ld a, [TxSeq]
  ld [hli], a
  ld a, [RxSeq]
  ld [hli], a
  ld a, [RxFlags]
  ld [hli], a
  ld de, RawReply
  ld b, 4
.raw
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jr nz, .raw
  xor a
  ld [hli], a
  ld de, SlotScan
  ld b, 8
.scan
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jr nz, .scan
  xor a
  ld [FrameBytes], a
  ld [FrameBytes+1], a
  pop hl
  pop de
  pop bc
  pop af
  reti
INCLUDE "src/sgb/mouse_input.asm"
INCLUDE "src/sgb/mouse_select.asm"
INCLUDE "src/sgb/input_irq.asm"
