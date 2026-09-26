Priority

- running out of room in ROM0, move stuff to other banks
  - less than 1Kb left
  - move colors.asm out of ROM0
  - core.asm should not include core_strings.asm
  - move collision response code (doors, items, etc.) from map_loader to world
  - helper routines that don't take any args should use TRAMPOLINE instead
- load sprite colors with map
- announcer mode
  - double plays
  - beat the throw
- baseball simulation
  - move a fielder to a position
  - move fielders to positions based on result
- using the computer
  - bedroom PC is not working anymore
  - Bill's PC (will allow roster changes!!!)
  - Doc's PC
  - League PC
- end game, get experience, level up!!!
- generic animation system

Bugs

- colliders with offscreen origins will fail to register hits
- in Calvin's bedroom, when you first turn on the PC, the SGB console sprite sits on top of the text box
- map sprite culling still has issues at times
- on SGB, viewing a player on your team during a ballgame crashes the game
- can't deposit special items
- if holding more than one directional button, can't hop ledge
- color of version name incorrect after returning from new game/continue/options screen
- USB keyboard sometimes freezes title screen
- PS/2 keyboard causes flickering on LCDC interrupts
- SGB sound test doesn't seem to work, test on hardware

General

- remove manual ROMX assignments, let linker handle bank management instead
- link cable support!
- give math subroutines more appropriate names
- cut off sprites with the text box using an LCD interrupt (see https://gbdev.io/pandocs/LCDC.html#faux-layer-textboxstatus-bar)
- use GB Printer to print stats, records, rolédex, baseball cards

Optimization

- reduce stack thrashing in favor of repeated loading from WRAM 
- collision checks should only happen on first step, not every pixel!
- if all sprite stamps are 2x2, remove data from export and simplify stamp drawing
- COPY_TILE_BLOCK macro in GBDK.asm should be a subroutine, add HRAM vars to allow for this
- utilize remaining HRAM (after DMA routine)
- replace long chains of compares and jumps with jump tables
- remove use of temp_bank in rolédex to free up RAM
- player image data need to be compressed to fit more
- 16 and 24 bit math and string functions are probably unnecessary, ditch in favor of 32 bit functions
- SetSpriteTiles, SetSpriteTilesProps, and SetSpriteTilesXY can likely be merged
- Load/Set User/Opposing PlayerBkgTiles subroutines share a ton of code
- palette ids are at most 7, so two palettes could fit in a byte, cutting palette data in half
- use halt and stop where appropriate (see https://gbdev.io/pandocs/Reducing_Power_Consumption.html)

Python scripts

- handle translated player and item text
- support these languages: en, es, fr, it, pt, de, jp
- add colors and palette maps to player data?
- roledex description parser should print warning when more than 6 lines
- avatar directional maps should be organized into arrays
- SGB borders should (optionally?) use PNG palettes directly
- handle 1bpp and rle images

Start

- replace intro images, use full color
- intro home version batter has too many tiles, is also ugly
- make intro ball movement smooth

Play Ball

- offers accepted by unsigned players should end game
- set contact power from move, player, and barrel
- if opposing pitcher is ahead - throw more balls, behind - throw more strikes
- pitches in the dirt should bounce
- hit the batter with pitches
- hide strikezone after pitcher sets
- reduce pitching frames to 3, batting to 2, make trail fx a sprite
- ball should go behind lefty user batter, righty opposing batter
- ball should fly off screen after contact
- slide batter (and stats) across screen right after contact, walk, etc.
- more pitching/batting animations
- change color of move info based on type
- bunting
- update user player stats

Game Results

- Show box score
- Learn moves at certain ages. (sepatrate learn move logic from UseItemOnPlayer subroutine)

Announcer

- finish (deterministic) announcer mode baseball logic
- fix range calculation in AnnounceFieldingText subroutine
- Announce "Squirt looks done for out there." when out of HP. 
- Announce things like "Ghost runners on first and third." when playing against an unsigned player

Simulation

- ball should bounce off fences
- running
- catching throwing
- implement basic rules
- iterative landing spot calc slightly off, direct method often way off
- field should probably be bigger than 32x32
- runners are commented out (ie. ghost runners), turn on/off based on runnes actual positions
- runners have wrong palette
- reuse the lineup sprites on the field

Team Menu

- add hair/skin palette data
- pressing left and right cycles between stats
- missing moves in stat page move list should show "-"
- stat page should be accessible from PC
- show pitch or bat icon next to move PP
- show appropriate stat (ie. BA, ERA) below age

Map System

- regions should have their own music, palettes, tiles, etc
- map scripts should optionally have collision check
- sanitize maps before export (ie. objects with text should always have a collider and be on the text layer)
- handle temporary bg tiles (ie. trees that can be cut down)
- add support for animated tiles
- use Unity's collision trigger property for finer control over GB collisions
- bg palette 0 is used for UI, should not be exported
- sprite palette 7 is used for player avatar, should be switched to palette 0 and not exported
- chunks should be exported as tile arrays when more efficient than objects
- print errors for more than 255 chunks, text, doors, etc. when exporting a scene
- make legs go behind things
- map stamps should be referenced from an index to a jump table instead of directly addressed
- default collision type for chunk
- a chunk index of 0 should fill the chunk with some default tile
- add diagonal lines to map system, (already implemented(ish) in editor)
- make the editor a standalone application

Items

- list shrinks after selecting special item
- change select arrow to empty after selecting item
- hide play/item/team/run when item menu selected
- use protein, carbos, etc.
- add music/text when playing harmonica in overworld
- wake player when playing harmonica in game
- use select to swap items in list
- add town names and cursor to town map
- status clearing items should have more specific messages (ie. "Chu is no longer paralyzed.")
 
Rolédex

- update seen/signed after games, transformations, and signings
- update player descriptions
- fix player descriptions that are longer than 6 lines
- if player descriptions only span 1 page, garbage text is drawn on the next
- create tileset specific to dex
- show player home towns / recruitment locations

Audio

- pitch, hit, wiff, catch SFX
- on/off PC SFX

Super GameBoy

- set tiles to palette 0 when drawing UI boxes (currently only works on GBC)
- GBCSetPalette (used to match SGB and GBC palettes) can cause problems with GBC specific palettes
- use color palette data
- use additional sprites (bottom row of tiles will be trashed)
- borders for each city when walking
- borders for different fields
- extra music voices
- fix LCD interrupt flickering when sending packets
- use second controller?

Keyboard

- add shortcut keys
  - F1 for help (ie. pull up Rolédex page of opposing player)
  - F2 to rename a player that has been selected in the lineup
  - F3 to search through Rolédex, items, etc.
  - ALT+F4 to restart the game
  - CTRL+S to save anytime (save state?)
  - num keys to select move? maybe to change the lineup
- allow user to change the Rolédex page

Design Notes

- big list of "real names" to use in place of ID and OT
- break large areas of repeated tiles, should be at least 2 different tiles on any given 20x18 tile region
- Ghost runners appear when an unrecruited player gets on base
- you can only see/sign Ghost runners after you've bought a ticket to the Field of Dreams
- player stats should peak at their prime age (~25)
- after prime age, speed and throw stats begin to decline (bat and field don't)
- when a player dies (~75), their second type becomes Ghost
- rather than selecting a player, you're selecting one of Doc Hicory's three teams (you get to name it?)
- play against Doc Hicory (the Billet Town team that neither you nor your rival picked) anytime you want to
- pitch speed should be a relative speed so that pitches appear faster when the pitcher's Throw stat is higher than the batter's Bat stat
- each town has age restrictions for their league (ie. <8, <12, <18, <30, unrestricted, 30+, 40+, 50+)
- you should be able to replay teams more than once
- Bill (of Bill's PC fame) is Bill James.
- teammates in their 20s and 30s have a small chance of producing a child
- A storm has cut off the path to the weather tower. It's cleared after you beat the game. That's where you meet the weather man, Mike.
- after becoming the world champions, the northern pass opens... encounter Mike at top of weather research tower
- You can use items as often as you want, but using an item on your pitcher while they're pitching requires a mound visit. Umps won't let you make more than one mound visit per inning per pitcher.
- Pitchers must complete a plate appearance before they can be swapped out.
- Low HP means more errors and bad pitches, slower movement.
- You get a frozen head (ie. Ted Williams) in the equivalent of Pewter City's Museum of Science.
- replace "PC" with "server"
- When a player reaches 0 HP, they're hurt and come out of the game. Whenever there is no player for a lineup spot, an out is recorded for that batter.
- Batting/Pitching sprites should be shown on appropriate stat screens.
- Main player image should be flipped to show correct handedness.
- make some players only available on certain hardware (DMG, GBC, SGB 1/2, GBP, GBA, emulators)
- age should be independent of experience and based instead on game time
  - if 30 minutes of playing is 1 month, you would need to play for 6 hours for your initial team of 5-year-olds to turn 6
  - experience would be tied to Grade (the equivalent to Level)
  - steroid use would then affect Grade instead of Age
  - steroids use should be tracked separately
  - steroids stop working after they've been taken 20 times
  - some transformations (Gio to OT, for example) require steroid use
- max offer should depend on ball (baseball = $100, game ball = $1000, etc.)