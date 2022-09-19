; String Manipulation Code
;  Started 05-Jan-20
;
; Initials: NB = Nolan Baker
; V1.0 - 05-Jan-20 : Original Release - NB
;
; Library Subroutines:
;   str_Copy
;     Copy a string from hl to de
;     Entry: hl = src string, de = dest string
;   str_Length
;     Length of a string
;     Entry: hl = string
;     Return: de = length
;   str_FromArray
;     gets string by index
;     Entry: bc = index, hl = string array
;     Return: hl = string at index bc
;   str_CopyLine 
;     Copies line (\n) from hl to de
;     Entry: hl = src string, de = dest string
;     Return: bc = length of line, hl = start of next line
;   str_Append
;     Appends one string to another
;     Entry: hl = append string, de = dest string
;   str_AppendChar
;     Appends a character to a string
;     Entry: a = character, hl = string
;   str_Replace
;     Replaces string bc in source hl with string af in destination de
;     Entry: hl = src string, de = dest string, bc = replace string, af = with string
;   str_Number
;     Converts number hl to string de, legacy code convenience wrapper for str_Number16
;     Entry: hl = 16 bit number, de = dest string
;   str_Number16
;     Converts number hl to string bc
;     Entry: hl = 16 bit number, bc = dest string
;   str_Number24
;     Converts number ehl to string bc
;     Entry: ehl = 24 bit number, bc = dest string
;   str_Number32
;     Converts number dehl to string bc
;     Entry: dehl = 32 bit number, bc = dest string


IF !DEF(STRINGS_ASM)
STRINGS_ASM SET 1

rev_Check_strings_asm: MACRO
  IF \1 > 1
    WARN "Version \1 or later of 'strings.asm' is required."
  ENDC
ENDM

INCLUDE "src/math.asm"
  rev_Check_math_asm 1

SECTION "Strings Code", ROM0
;***************************************************************************
;
; str_Copy - Copy a string
;
; input:
;   hl - src string
;   de - dst string
;
;***************************************************************************
str_Copy::
  ld   a, [hli]
  ld   [de], a
  inc  de
  and  a
  jr   nz, str_Copy
  ret

;***************************************************************************
;
; str_Length - Length of a string
;
; input:
;   hl - string
; output:
;   de - length
;
;***************************************************************************
str_Length::
  ld de, 0
.loop
    ld a, [hli]
    and a
    ret z
    inc de
    jr .loop

;***************************************************************************
;
; str_FromArray - gets string by index
;
; input:
;   bc - index
;   hl - string array
; output:
;   hl - string at index bc
;
;***************************************************************************
str_FromArray::
  inc bc
  jr .test
.loop; find end of string
    ld a, [hli]
    and a
    jr nz, .loop
  .test; check bc == 0
    xor a
    dec bc
    cp b
    jr nz, .loop
    cp c
    jr nz, .loop
  ret 

;***************************************************************************
;
; str_CopyLine - Copies line
;
; input:
;   hl - string
;   de - dest
; output:
;   bc - length of line
;   hl - start of next line
;
;***************************************************************************
str_CopyLine::
  ld bc, 0
.loop
    ld a, [hli]
    cp 128;"\n"
    ret z
    and a
    ret z
    ld [de], a
    inc de
    inc bc
    jr .loop

;***************************************************************************
;
; str_Append - Appends string hl to de
;
; input:
;   hl - append string
;   de - dest string
;
;***************************************************************************
str_Append::
  ld a, [de]
  inc de
  and a
  jr nz, str_Append
  dec de
  call str_Copy
  ret 

;***************************************************************************
;
; str_AppendChar - Appends char a to hl
;
; input:
;   a - character
;   hl - string
;
;***************************************************************************
str_AppendChar:
  push af;char
.loop
    ld a, [hli]
    and a
    jr nz, .loop
  xor a
  ld [hld], a
  pop af;char
  ld [hl], a
  ret

;***************************************************************************
;
; str_Replace - Replaces %s in src with bc, results in dest
;
; input:
;   hl - src string
;   de - dest string
;   bc - replace data
;
;***************************************************************************
str_Replace::
  ld a, [hli]
  and a
  jr z, .done
  cp "%"
  jp nz, .copyToDest
  ld a, [hli]
  cp "s"
  jr z, .stringReplace
  dec hl
  jr str_Replace
.copyToDest
  ld [de], a
  inc de
  jr str_Replace
.stringReplace
    ld a, [bc]
    and a
    jr z, str_Copy
    ld [de], a
    inc bc
    inc de
    jr .stringReplace
.done
  ld [de], a
  ret


_StringNumber::;extern void StringNumber(unsigned long n);
  ;n is debc, needs to be dehl
  push bc
  pop hl
  ld bc, name_buffer
  jr str_Number32

;***************************************************************************
;
; str_Number - a wrapper around str_Number16 for compatibility with old code
;
; input:
;   hl - number
;   de - dest string
;
;***************************************************************************
str_Number::
  push bc
  push de;dest string
  pop bc;dest string
  call str_Number16
  inc hl
  push hl;dest string
  pop de;dest_string
  pop bc
  ret

;***************************************************************************
;
; str_Number16 - converts number hl to string bc
;
; input:
;   hl - number
;   bc - dest string
;
;***************************************************************************
str_Number16::
  ld e, 0;fall through to str_Number24

;***************************************************************************
;
; str_Number24 - converts number ehl to string bc
;
; input:
;   ehl - number
;   bc - dest string
;
;***************************************************************************
str_Number24::
  ld d, 0;fall through to str_Number32

;***************************************************************************
;
; str_Number32 - converts number dehl to string bc
;
; input:
;   dehl - number
;   bc - dest string
;
;***************************************************************************
str_Number32::
  ld a, d ; if dehl == 0, return "0",0
  and a
  jr nz, .nonZero;if d != 0
  ld a, e
  and a
  jr nz, .nonZero;if e != 0
  ld a, h
  and a
  jr nz, .nonZero;if h != 0
  ld a, l
  and a
  jr nz, .nonZero;if l != 0
  
.returnZero
  ld a, "0"
  ld [bc], a
  inc bc
  xor a
  ld [bc], a
  ret

.nonZero
  xor a
  push bc ;dest string start
  push af ;num digits
  push bc ;dest string
.divLoop
    ld c, 10
    call math_Divide32
    add a, "0";convert num to string

    pop bc;dest string
    ld [bc], a
    inc bc
    pop af;num digits
    inc a 
    push af;num digits
    push bc;dest string
    
    ld a, d ; if dehl > 0, loop
    and a
    jr nz, .divLoop
    ld a, e
    and a
    jr nz, .divLoop
    ld a, h
    and a
    jr nz, .divLoop
    ld a, l
    and a
    jr nz, .divLoop

  pop bc ;dest string
  xor a
  ld [bc], a;terminate string
  pop af;num digits
  cp 1
  pop hl ;dest string start
  ret z ;no need to swap if only one digit
  
  ld d, a;num digits
  srl d;num digits / 2
  dec bc
.swapLoop
    ld a, [hl]
    ld e, a
    ld a, [bc]
    ld [hli], a
    ld a, e
    ld [bc], a
    dec bc
    dec d
    jr nz, .swapLoop
  ret

ENDC ;STRINGS_ASM