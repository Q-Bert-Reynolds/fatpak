SECTION "Input", ROM0
;   UPDATE_INPUT_AND_JUMP_TO_IF_BUTTONS   JumpAddress, buttons8
;   JUMP_TO_IF_BUTTONS                    JumpAddress, buttons8
;   EXITABLE_DELAY                        JumpAddress, buttons8, frames8
;   WAITPAD_UP                                    
;   WAITPAD_UP_OR_FRAMES                  frames8

UpdateInput::;https://gbdev.io/pandocs/Joypad_Input.html
  PUSH_ALL

  ;copy button_state to last_button_state
  ld a, [button_state]
  ld [last_button_state], a

  ;read DPad
  ld hl, rP1
  ld a, P1F_GET_DPAD
  ld [hl], a ;switch to P15
REPT INPUT_REPEAT;multiple cycles to avoid button bounce
  ld a, [hl] ;load DPad
ENDR
  and %00001111 ;discard upper nibble
  swap a ;move low nibble to high nibble
  ld b, a ;store DPad in b

  ;read A,B,Select,Start
  ld a, P1F_GET_BTN
  ld [hl], a ;switch to P14
REPT INPUT_REPEAT
  ld a, [hl] ;load buttons
ENDR
  and %00001111 ;discard upper nibble
  or b ;combine DPad with other buttons
  cpl ;flip bits so 1 means pressed
  ld hl, button_state
  ld [hl], a

  TRAMPOLINE ProcessKeyCodes
  POP_ALL
  ret

MACRO UPDATE_INPUT_AND_JUMP_TO_IF_BUTTONS ; \1=address, \2=buttons
  call UpdateInput
  JUMP_TO_IF_BUTTONS \1, \2
ENDM

MACRO JUMP_TO_IF_BUTTONS ; \1=address, \2=buttons
  ld a, [last_button_state]
  and a
  jr nz, .skip\@
  ld a, [button_state]
  and \2
  jp nz, \1
.skip\@
ENDM

MACRO EXITABLE_DELAY ; \1=address, \2=buttons, \3=frames
  ld a, \3
.loop\@
    push af
    UPDATE_INPUT_AND_JUMP_TO_IF_BUTTONS .jump\@, \2
    call gbdk_WaitVBL
    pop af
    dec a
    jr nz, .loop\@
  jr .exit\@
.jump\@
  pop af
  jp \1
.exit\@
ENDM

MACRO WAITPAD_UP
.loop\@
  call gbdk_WaitVBL
  call UpdateInput
  ld a, [last_button_state]
  and a
  jr nz, .loop\@
ENDM

MACRO WAITPAD_UP_OR_FRAMES ; \1=frames
  ld a, \1
.loop\@
    push af;frames
    call gbdk_WaitVBL
    call UpdateInput
    ld a, [last_button_state]
    and a
    jr z, .exit\@
    pop af;frames
    dec a
    jr nz, .loop\@
  push af;frames
.exit\@
  pop af;frames
ENDM