;Hardware handoff after ROM and save preparation.
PAGE LAUNCH_PAGE
;resets the Game Boy into the game fs_LoadGame copied to PSRAM, like the EverDrive's OS: $BD06 bit 3 makes the
;cart reset it through the boot ROM after the mapper is written (bit 2 switches without it). The MBC writes
;land in the OS image's RAM ($0000, $2000, $2100, $3000, $4000, $6000). Like stock
;Cart_LaunchGame, the final mapper write and reset wait execute in resident cartridge
;code. The boot path supplies the game's initial registers; there is no timed jump
;to $0100 or synthesized device ID.
_GameLaunch::
  di
  call gbdk_CPUSlow;normal speed like the EverDrive OS's launch
  xor a;CPUSlow restores IE; stock leaves it disabled before the reset request
  ldh [rIE], a
  ld a, AUDENA_ON;stock explicitly powers audio on before handing off to the cart
  ldh [rAUDENA], a
  ld a, 1;keep the stock OS compatibility flags consistent with the launch
  ld [os_game_launched], a
  ld a, [_game_ram_mask]
  and a
  jr z, .noRam
  ld a, 1
.noRam
  ld [os_snapshot_use_32k_ram], a
  ld a, $A5;the card back to idle like the EverDrive OS's launch (CMD0, deselected): it leaves it uninitialized
  ld [EDX_KEY], a
  ld hl, sd_arg
  xor a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hl], a
  ld a, SD_CMD0
  call SDCommand
  call SDDeselect
  ld a, [_game_rom_mask]
  ld [$BD04], a
  ld a, [_game_ram_mask]
  ld [$BD05], a
  ld a, [_game_bd20]
  and a
  jr z, .config
  ld [$BD20], a
.config
  ; Patch while OS mode is still established, before launch config/MBC writes.
  ld hl, $0041
  ld [hl], LOW(InGameEntry)
  inc l
  ld [hl], HIGH(InGameEntry)
  ; A warm return keeps the live OS image. Preserve bytes before mapper writes
  ; so restarting the editor does not execute modified resident instructions.
  ld a, [$0000]
  ld [ingame_os_bytes+0], a
  ld a, [$2000]
  ld [ingame_os_bytes+1], a
  ld a, [$2100]
  ld [ingame_os_bytes+2], a
  ld a, [$3000]
  ld [ingame_os_bytes+3], a
  ld a, [$4000]
  ld [ingame_os_bytes+4], a
  ld a, [$6000]
  ld [ingame_os_bytes+5], a
  ld a, [_game_config]
  ld [EDX_CONFIG], a
  xor a
  ld [$BD09], a
  ld [rRAMG], a
  ld [$3000], a
  ld [rRAMB], a
  ld [$6000], a
  inc a
  ld [$2100], a
  ld [$2000], a
  ld a, [_game_mapper]
  jp LaunchStub
ASSERT BANK(_GameLaunch) == BANK(_LaunchGame), "LaunchGame calls it in its page"

SECTION "Launch Stub", ROM0[$01E0];resident reset handoff, a = mapper
LaunchStub:
  ld [$BD07], a
.wait
  jp .wait;stock waits in cartridge code for reset, without an HRAM fallback
LaunchStubEnd:

SECTION "Reboot", ROM0

_Reboot::;starts the OS again (after a failed game load, the text comes back from the swap file)
  di
  ld a, FIRST_PAGE
  ld [EDX_PAGE], a
  jp $0100

SECTION "Device Restart", ROM0

_RestartDevice::;the browser's full reset; SD services have unlocked the cart registers
  di
  ld a, $10
  ld [EDX_CONFIG], a
.wait
  jr .wait;wait for the cartridge to reset the hardware through the boot ROM
