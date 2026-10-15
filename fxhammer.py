import os
import glob
from utils import *

note_table = [
  "C2", "Db2", "D2", "Eb2", "E2", "F2", "Gb2", "G2", "Ab2", "A2", "Bb2", "B2",
  "C3", "Db3", "D3", "Eb3", "E3", "F3", "Gb3", "G3", "Ab3", "A3", "Bb3", "B3", 
  "C4", "Db4", "D4", "Eb4", "E4", "F4", "Gb4", "G4", "Ab4", "A4", "Bb4", "B4", 
  "C5", "Db5", "D5", "Eb5", "E5", "F5", "Gb5", "G5", "Ab5", "A5", "Bb5", "B5", 
  "C6", "Db6", "D6", "Eb6", "E6", "F6", "Gb6", "G6", "Ab6", "A6", "Bb6", "B6", 
  "C7", "Db7", "D7", "Eb7", "E7", "F7", "Gb7", "G7", "Ab7", "A7", "Bb7", "B7"
]

shift_table = [
  "NOISE_DIV_2",  "NOISE_DIV_4",  "NOISE_DIV_8",  "NOISE_DIV_16",  "NOISE_DIV_32",  
  "NOISE_DIV_64",  "NOISE_DIV_128",  "NOISE_DIV_256",  "NOISE_DIV_512",  "NOISE_DIV_1K",  
  "NOISE_DIV_2K",  "NOISE_DIV_4K",  "NOISE_DIV_8K",  "NOISE_DIV_16K", "$E0", "$F0"
]

div_table = [
  "NOISE_STUTTER",  "NOISE_RUMBLE",  "NOISE_ENGINE",  "NOISE_LOW_TONE",  "NOISE_UNDERTONE",  
  "NOISE_MIDDLETONE",  "NOISE_OVERTONE",  "NOISE_HIGH_TONE",  "NOISE_EARTHQUAKE",  "NOISE_SPACESHIP",  
  "NOISE_OCEAN",  "NOISE_SCRATCH",  "NOISE_GLITCH",  "NOISE_VOLCANO",  "NOISE_SCREAM",  "NOISE_STATIC"
]

def all_zero(data):
  for i in range(8):
    if data[i] != 0:
      return False
  return True

def note(byte):
  index = (byte - 0x40) // 2
  return note_table[index]

def freq_div(byte):
  upperNibble = int((byte & 0xF0) >> 4)
  lowerNibble = int((byte & 0xF))
  return f'{shift_table[upperNibble]}|{div_table[lowerNibble]}'

def main():
  for path in glob.glob("./sfx/*.sav"):
    name = os.path.basename(path).replace(".sav", "")
    with open(path, "rb") as sav_file:
      data = sav_file.read()

    byte_list = list(data)
    priority = data[0x200:0x240]
    notes = data[0x240:0x2D0]
    channels = data[0x300:0x340] 

    with open(path.replace(".sav", ".asm"), "w+", encoding="utf8") as asm_file:
      for i in range(0x400, 0x4000, 0x100):
        if all_zero(data[i:i+8]):
          break

        index = int((i-0x400) / 0x100)
        mask = channels[index]
        mask_str = "11"
        if mask & 0x30 != 0:
          mask_str = "01"
        if mask & 0x3 != 0:
          mask_str += "01"
        else:
          mask_str += "11"

        steps = 0
        chunk = []
        for j in range(i, i+0x100, 8):
          if all_zero(byte_list[j:j+8]):
            break
          chunk += byte_list[j:j+8]
          steps += 1

        asm_file.write(f'\nSECTION "{name}.sav {index}", ROMX\n')
        asm_file.write(f'{PascalCase(name)}Sound{index}::\n')
        asm_file.write(f'  DB {steps} ;steps\n\n')

        ch2_was_enabled = False
        ch4_was_enabled = False
        for j in range(0, len(chunk), 8):
          # TODO: use pan/mute values
          ticks = int(chunk[j])       # TM - Duration in frames, 0 to stop
          ch2_pan_mute = chunk[j+1]   # P  - Ch2 pan/mute ($20 = left, $02 = right)
          ch2_vol_env = chunk[j+2]    # L  - Ch 2 volume/envelope (rNR22)
          ch2_duty_len = chunk[j+3]   # W  - Ch 2 duty/length (rNR21)
          ch2_note = note(chunk[j+4]) # NT - note index
          ch4_pan_mute = chunk[j+5]   # P  - Ch 4 pan/mute ($80 = left, $08 = right)
          ch4_vol_env = chunk[j+6]    # L  - Ch 4 volume and envelope (written to rNR42)
          ch4_freq_div = chunk[j+7]#freq_div(chunk[j+7]) # FR - Ch 4 noise frequency/divisor (written to rNR43)

          ch2_enabled = ch2_pan_mute > 0
          ch4_enabled = ch4_pan_mute > 0
          start = 0 if (ch4_enabled or ch4_was_enabled) else ticks
          if ch2_enabled:
              asm_file.write(f'  SFX_CH2 {start}, %{mask_str}, {ch2_duty_len}, {ch2_vol_env}, {ch2_note}\n')
              ch2_was_enabled = True
          elif ch2_was_enabled:
              # Mute Channel 2: volume 0 ($08), re-trigger
              asm_file.write(f'  SFX_CH2 {start}, %{mask_str}, 0, $08, $80\n')
              ch2_was_enabled = False

          # Determine if Ch4 needs to play or be muted
          if ch4_enabled:
              asm_file.write(f'  SFX_CH4 {ticks}, %{mask_str}, 255, {ch4_vol_env}, {ch4_freq_div}\n\n')
              ch4_was_enabled = True
          elif ch4_was_enabled:
              # Mute Channel 4: volume 0 ($08)
              asm_file.write(f'  SFX_CH4 {ticks}, %{mask_str}, 255, $08, $80\n\n')
              ch4_was_enabled = False

if __name__ == "__main__":
  main()