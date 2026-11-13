IF !DEF(STRINGS_ASM)
DEF STRINGS_ASM EQU 1

INCLUDE "src/math.asm"

SECTION "Strings HRAM", HRAM
put_dest: DS 2
put_part: DB;PutStr: the pieces to skip
put_block: DB;and the low byte of the block in the window
_lang_count:: DW;strings in the language at LANG_BLOCK, 0 if none is loaded

SECTION "Strings text", WRAMX
_str_text:: DS LANG_MAX + 1;Str's copy, until the next Str

ASSERT LOW(LANG_BLOCK + LANG_TABLE) + LANG_BLOCKS <= $FF && HIGH(LANG_BLOCK) == HIGH(LANG_BLOCK + LANG_BLOCKS - 1)
ASSERT LANG_BLOCK >= $3C00 + $A4 && LANG_BLOCK + LANG_BLOCKS <= MODULE_STAGE5;past the snapshot staging

SECTION "Strings Code", ROM0
; char* PutNumber(char* dest, unsigned long n): n's decimal digits at dest, without a
; terminator; returns the address after them. dest in de, n on the stack (popped here).
; The digits come out lowest first, so they go on the stack above a 0 and are popped in order.
_PutNumber::
  ld a, e
  ldh [put_dest], a
  ld a, d
  ldh [put_dest+1], a
  ld hl, sp+2
  ld a, [hl+]
  ld c, a
  ld a, [hl+]
  ld b, a
  ld a, [hl+]
  ld e, a
  ld d, [hl]
  ld h, b
  ld l, c;dehl = n
  xor a
  push af;the end mark: digits are never 0
.digit
  ld c, 10
  call math_Divide32
  add a, 48;'0'
  push af
  ld a, d
  or a, e
  or a, h
  or a, l
  jr nz, .digit
  ldh a, [put_dest]
  ld c, a
  ldh a, [put_dest+1]
  ld b, a
.store
  pop af
  or a, a
  jr z, .done
  ld [bc], a
  inc bc
  jr .store
.done
  pop hl
  add sp, 4
  jp hl

; char* PutStr(char* dest, unsigned int id): string id (bits 0-11) of the loaded language at dest,
; or the piece of it after its nth {} (bits 12-15, S_PART), up to the next; then a 0. Returns the
; address of that 0. Nothing but the 0 if there's no such string. de = dest, bc = id; the window
; (and its PSRAM/save RAM bit) are put back
_PutStr::
  ld a, [EDX_CONFIG]
  push af
  and a, ~2
  ld [EDX_CONFIG], a
  ld a, [EDX_BLOCK]
  push af
  ld a, [EDX_BLOCK+1]
  push af
  ld a, b
  swap a
  and a, $0F
  ldh [put_part], a
  ld a, b
  and a, $0F
  ld b, a;bc = the string
  ldh a, [_lang_count]
  ld l, a
  ldh a, [_lang_count+1]
  ld h, a
  ld a, c
  sub a, l
  ld a, b
  sbc a, h
  jr nc, .end;past the last one, or none loaded
  ld h, b
  ld l, c
  add hl, hl
  call StrAt;its offset (entries never cross a block)
  ld a, [hl+]
  ld h, [hl]
  ld l, a
  call StrAt
  ldh a, [put_part]
  ld c, a
.char
  ld a, h
  cp a, HIGH(EDX_WINDOW) + 2
  jr nz, .read
  ldh a, [put_block];on into the next block
  inc a
  ldh [put_block], a
  ld [EDX_BLOCK], a
  ld h, HIGH(EDX_WINDOW)
.read
  ld a, [hl+]
  or a, a
  jr z, .end
  cp a, $1F;PART_SEPARATOR
  jr z, .separator
  inc c
  dec c
  jr nz, .char;an earlier piece
  ld [de], a
  inc de
  jr .char
.separator
  ld a, c
  or a, a
  jr z, .end;the piece is done
  dec c
  jr .char
.end
  xor a, a
  ld [de], a
  pop af
  ld [EDX_BLOCK+1], a;high byte first, then low: the low byte write switches the window
  pop af
  ld [EDX_BLOCK], a
  pop af
  ld [EDX_CONFIG], a
  ld b, d
  ld c, e
  ret

;hl = an offset in the string table: shows its block, hl = its address in the window
StrAt:
  ld a, HIGH(LANG_BLOCK + LANG_TABLE)
  ld [EDX_BLOCK+1], a
  ld a, h
  srl a
  add a, LOW(LANG_BLOCK + LANG_TABLE)
  ldh [put_block], a
  ld [EDX_BLOCK], a
  ld a, h
  and a, 1
  or a, HIGH(EDX_WINDOW)
  ld h, a
  ret

; const char* Str(unsigned int id): the string in str_text, until the next Str. de = id
_Str::
  ld b, d
  ld c, e
  ld de, _str_text
  call _PutStr
  ld bc, _str_text
  ret

ENDC ;STRINGS_ASM
