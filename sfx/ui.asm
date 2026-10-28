
SECTION "ui.sav - Menu Move Up", ROMX
UiMenuMoveUpSound::
  SFX_HEADER 2, %1101, 15
  SFX_CH2 3, 0, 248, C2
  SFX_CH2 4, 64, 248, G2

SECTION "ui.sav - Menu Move Down", ROMX
UiMenuMoveDownSound::
  SFX_HEADER 2, %1101, 15
  SFX_CH2 3, 64, 248, G2
  SFX_CH2 4, 0, 248, C2

SECTION "ui.sav - Confirm/Select", ROMX
UiConfirmSelectSound::
  SFX_HEADER 3, %1101, 0
  SFX_CH2 5, 0, 248, C3
  SFX_CH2 5, 0, 248, E4
  SFX_CH2 8, 0, 248, G4

SECTION "ui.sav - Cancel/Back", ROMX
UiCancelBackSound::
  SFX_HEADER 2, %1101, 0
  SFX_CH2 5, 0, 248, G3
  SFX_CH2 8, 0, 248, C3

SECTION "ui.sav - Error/Buzzer", ROMX
UiErrorBuzzerSound::
  SFX_HEADER 3, %0111, 15
  SFX_CH4 6, 255, 248, NOISE_DIV_32|NOISE_SPACESHIP
  SFX_CH4 1, 255, 8, NOISE_DIV_2|NOISE_STUTTER
  SFX_CH4 6, 255, 248, NOISE_DIV_32|NOISE_SPACESHIP

SECTION "ui.sav - Notification Ping", ROMX
UiNotificationPingSound::
  SFX_HEADER 15, %1101, 15
  SFX_CH2 1, 0, 248, C7
  SFX_CH2 1, 0, 232, C7
  SFX_CH2 1, 0, 216, C7
  SFX_CH2 1, 0, 200, C7
  SFX_CH2 1, 0, 184, C7
  SFX_CH2 1, 0, 168, C7
  SFX_CH2 1, 0, 152, C7
  SFX_CH2 1, 0, 136, C7
  SFX_CH2 1, 0, 120, C7
  SFX_CH2 1, 0, 104, C7
  SFX_CH2 1, 0, 88, C7
  SFX_CH2 1, 0, 72, C7
  SFX_CH2 1, 0, 56, C7
  SFX_CH2 1, 0, 40, C7
  SFX_CH2 1, 0, 24, C7

SECTION "ui.sav - Info/Hint Pop", ROMX
UiInfoHintPopSound::
  SFX_HEADER 6, %1101, 15
  SFX_CH2 9, 0, 248, Gb5
  SFX_CH2 9, 0, 248, Bb5
  SFX_CH2 9, 0, 248, Db6
  SFX_CH2 4, 0, 136, Db6
  SFX_CH2 4, 0, 72, Db6
  SFX_CH2 4, 0, 24, Db6

SECTION "ui.sav - Save/Success Chime", ROMX
UiSaveSuccessChimeSound::
  SFX_HEADER 12, %1101, 15
  SFX_CH2 6, 64, 248, C6
  SFX_CH2 6, 64, 248, D6
  SFX_CH2 6, 64, 248, C6
  SFX_CH2 6, 64, 248, F6
  SFX_CH2 6, 64, 248, D6
  SFX_CH2 6, 64, 248, A6
  SFX_CH2 6, 64, 248, G6
  SFX_CH2 8, 64, 248, C7
  SFX_CH2 8, 64, 136, C7
  SFX_CH2 8, 64, 56, C7
  SFX_CH2 8, 64, 24, C7
  SFX_CH2 1, 0, $08, $80 ;mute

SECTION "ui.sav - Text Confirm", ROMX
UiTextConfirmSound::
  SFX_HEADER 8, %0111, 15
  SFX_CH4 1, 255, 248, NOISE_DIV_4|NOISE_MIDDLETONE
  SFX_CH4 1, 255, 248, NOISE_DIV_32|NOISE_MIDDLETONE
  SFX_CH4 1, 255, 248, NOISE_DIV_32|NOISE_MIDDLETONE
  SFX_CH4 1, 255, 184, NOISE_DIV_4|NOISE_MIDDLETONE
  SFX_CH4 1, 255, 136, NOISE_DIV_4|NOISE_MIDDLETONE
  SFX_CH4 1, 255, 72, NOISE_DIV_4|NOISE_MIDDLETONE
  SFX_CH4 1, 255, 40, NOISE_DIV_4|NOISE_MIDDLETONE
  SFX_CH4 1, 255, 24, NOISE_DIV_4|NOISE_MIDDLETONE

SECTION "ui.sav - Text Cancel/Delete", ROMX
UiTextCancelDeleteSound::
  SFX_HEADER 1, %0111, 15
  SFX_CH4 4, 255, 200, NOISE_DIV_4|NOISE_STUTTER

SECTION "ui.sav - Open Menu", ROMX
UiOpenMenuSound::
  SFX_HEADER 6, %1101, 15
  SFX_CH2 2, 192, 248, C6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 3, 192, 248, D6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 2, 192, 248, C7
  SFX_CH2 6, 192, 248, D7

SECTION "ui.sav - Close Menu", ROMX
UiCloseMenuSound::
  SFX_HEADER 7, %1101, 0
  SFX_CH2 4, 192, 248, D6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 3, 192, 248, C6
  SFX_CH2 2, 0, 8, C2
  SFX_CH2 2, 192, 248, D5
  SFX_CH2 6, 192, 248, C5
  SFX_CH2 1, 0, $08, $80 ;mute

SECTION "ui.sav - Page Scroll", ROMX
UiPageScrollSound::
  SFX_HEADER 6, %0111, 14
  SFX_CH4 3, 255, 56, NOISE_DIV_2|NOISE_RUMBLE
  SFX_CH4 3, 255, 120, NOISE_DIV_2|NOISE_RUMBLE
  SFX_CH4 3, 255, 88, NOISE_DIV_2|NOISE_RUMBLE
  SFX_CH4 3, 255, 56, NOISE_DIV_2|NOISE_RUMBLE
  SFX_CH4 3, 255, 24, NOISE_DIV_2|NOISE_RUMBLE
  SFX_CH4 3, 255, $08, $80 ;mute

SECTION "ui.sav - System Alert/Warning", ROMX
UiSystemAlertWarningSound::
  SFX_HEADER 4, %1101, 15
  SFX_CH2 16, 192, 248, C6
  SFX_CH2 16, 192, 248, C5
  SFX_CH2 16, 192, 248, C4
  SFX_CH2 16, 192, 248, C5

SECTION "ui.sav - ui14", ROMX
Ui14Sound::
  SFX_HEADER 1, %0111, 15
  SFX_CH4 1, 255, 248, NOISE_DIV_2|NOISE_STUTTER

DEF NUM_UI_SOUNDS EQU 15

MACRO UI_TITLES
  DB "Menu Move Up", 0
  DB "Menu Move Down", 0
  DB "Confirm/Select", 0
  DB "Cancel/Back", 0
  DB "Error/Buzzer", 0
  DB "Notification Ping", 0
  DB "Info/Hint Pop", 0
  DB "Save/Success Chime", 0
  DB "Text Confirm", 0
  DB "Text Cancel/Delete", 0
  DB "Open Menu", 0
  DB "Close Menu", 0
  DB "Page Scroll", 0
  DB "System Alert/Warning", 0
  DB "ui14", 0
ENDM

MACRO UI_ADDRESSES
  DW UiMenuMoveUpSound
  DW UiMenuMoveDownSound
  DW UiConfirmSelectSound
  DW UiCancelBackSound
  DW UiErrorBuzzerSound
  DW UiNotificationPingSound
  DW UiInfoHintPopSound
  DW UiSaveSuccessChimeSound
  DW UiTextConfirmSound
  DW UiTextCancelDeleteSound
  DW UiOpenMenuSound
  DW UiCloseMenuSound
  DW UiPageScrollSound
  DW UiSystemAlertWarningSound
  DW Ui14Sound
ENDM

MACRO UI_BANKS
  DB BANK(UiMenuMoveUpSound)
  DB BANK(UiMenuMoveDownSound)
  DB BANK(UiConfirmSelectSound)
  DB BANK(UiCancelBackSound)
  DB BANK(UiErrorBuzzerSound)
  DB BANK(UiNotificationPingSound)
  DB BANK(UiInfoHintPopSound)
  DB BANK(UiSaveSuccessChimeSound)
  DB BANK(UiTextConfirmSound)
  DB BANK(UiTextCancelDeleteSound)
  DB BANK(UiOpenMenuSound)
  DB BANK(UiCloseMenuSound)
  DB BANK(UiPageScrollSound)
  DB BANK(UiSystemAlertWarningSound)
  DB BANK(Ui14Sound)
ENDM

