Priority

- use tile speed properly
- fix swing timing
- fix timing for score bug vs player data
- add swing/pitch fx

Optimization

- reduce stack thrashing in favor of repeated loading from WRAM 
- if all sprite stamps are 2x2, remove data from export and simplify stamp drawing
- COPY_TILE_BLOCK macro in GBDK.asm should be a subroutine, add HRAM vars to allow for this
- utilize remaining HRAM space and RST vectors
- replace long chains of compares and jumps with jump tables
- remove use of temp_bank in rolédex to free up RAM
- player image data need to be compressed to fit more
- 16 and 24 bit math and string functions are probably unnecessary, ditch in favor of 32 bit functions
- SetSpriteTiles, SetSpriteTilesProps, and SetSpriteTilesXY can likely be merged
- Load/Set User/Opposing PlayerBkgTiles subroutines share a ton of code
- palette ids are at most 7, so two palettes could fit in a byte, cutting palette data in half
- use halt and stop where appropriate (see https://gbdev.io/pandocs/Reducing_Power_Consumption.html)
- use HDMA transfers on GBC (see https://gbdev.io/pandocs/CGB_Registers.html#lcd-vram-dma-transfers)
- running out of room in ROM0, move stuff to other banks
  - move map_stamps out of ROM0
  - move color palettes out of ROM0
  - core.asm should not include core_strings.asm
  - move collision response code (doors, items, etc.) from map_loader to world
  - helper routines that don't take any args should use TRAMPOLINE instead
- remove the last few manual ROMX assignments, let linker handle bank management instead
- profiler to map out most called addresses 

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

- end game, get experience, level up
- update seen/signed after games, transformations, and signings
- offers accepted by unsigned players should end game
- set contact power from move, player, and barrel
- if opposing pitcher is ahead - throw more balls, behind - throw more strikes
- pitches in the dirt should bounce
- hit the batter with pitches
- hide strikezone after pitcher sets
- different sized strike zones for each player
- reduce pitching frames to 3, batting to 2, make trail fx a sprite
- ball should go behind lefty user batter, righty opposing batter
- ball should fly off screen after contact
- slide batter (and stats) across screen right after contact, walk, etc.
- more pitching/batting animations
- change color of move info based on type
- bunting
- update user player stats
- Show box score
- Learn moves at certain ages. (sepatrate learn move logic from UseItemOnPlayer subroutine)

Announcer

- double plays
- beat the throw
- finish (deterministic) announcer mode baseball logic
- fix range calculation in AnnounceFieldingText subroutine
- Announce "Squirt looks done for out there." when out of HP. 
- Announce things like "Ghost runners on first and third." when playing against an unsigned player

Simulation

- move a fielder to a position
- move fielders to positions based on result
- ball should bounce off fences
- running
- catching throwing
- implement basic rules
- iterative landing spot calc slightly off, direct method often way off
- field should use map system
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

- maps.py should maintain map order to avoid corrupting save data
- regions should have their own music, palettes, tiles, etc
- map scripts should optionally have collision check
- sanitize maps before export (ie. objects with text should always have a collider and be on the text layer)
  - add export warnings when neighbor chains are inconsistent (ie. north->west != west->north, this != south->east->north->west)
  - empty chunks should be generated for missing neighbors
- handle temporary bg tiles (ie. trees that can be cut down)
- use Unity's collision trigger property for finer control over GB collisions
- chunks should be exported as tile arrays when more efficient than objects
- make legs go behind things
- map stamps should be referenced from an index to a jump table instead of directly addressed
- default collision type for chunk
- add diagonal lines to map system, (already implemented(ish) in editor)
- make the editor a standalone application

Items

- change select arrow to empty after selecting item
- hide play/item/team/run when item menu selected
- use protein, carbos, etc.
- add music/text when playing harmonica in overworld
- wake player when playing harmonica in game
- use select to swap items in list
- add town names and cursor to town map
- status clearing items should have more specific messages (ie. "Chu is no longer paralyzed.")
- if holding more than one directional button, can't hop ledge

Rolédex

- update player descriptions
- fix player descriptions that are longer than 6 lines
- if player descriptions only span 1 page, garbage text is drawn on the next
- create tileset specific to dex
- show player home towns / recruitment locations

Computers

- Bill's PC (will allow roster changes!!!)
- Doc's PC
- League PC

Audio

- pitch, hit, wiff, catch SFX
- utilize panning from fxhammer files
- shrink sfx format
  - combine channel and ticks (CCTTTTTT)
  - only include sweep byte in ch1 data
- test hUGEDriver (too big to fit in ROM0 currently)

Animation

- handle looped vs once animations
- shuffle sprite_obj_buffer so its size can be increased (will add flicker)

Super GameBoy

- replace all uses of GBCSetPalette with SetPalettesIndirect
- build sgb attribute files with palette data
- construct sgb packet headers at runtime instead of taking up space in ROM0 using macros
- colors not restored correctly when returning to world
- user player tiles flash grey when drawing opponent stats
- draws garbage when returning to world from ballgame
- sound test doesn't seem to work, test on hardware
- set tiles to palette 0 when drawing UI boxes (currently only works on GBC)
- borders for each city when walking
- borders for different fields
- extra music voices
- use second controller

Serial Port

- trade players over link cable
- use GB Printer to print stats, records, rolédex, baseball cards
- USB keyboard sometimes freezes title screen
- PS/2 keyboard causes flickering on LCDC interrupts
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