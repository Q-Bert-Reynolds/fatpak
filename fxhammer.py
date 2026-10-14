import os
import glob

def all_zero(data):
  for i in range(8):
    if data[i] != 0:
      return False
  return True

def main():
  for path in glob.glob("./sfx/*.sav"):
    name = os.path.basename(path).replace(".sav", "")
    with open(path, "rb") as sav_file:
      data = sav_file.read()
      
    priority = data[0x200:0x240]
    notes = data[0x240:0x2D0]
    channels = data[0x300:0x340] 

    with open(path.replace(".sav", ".asm"), "w+", encoding="utf8") as asm_file:
      for i in range(0x600, 0x4000, 0x100):
        if all_zero(data[i:i+8]):
          break

        index = int((i-0x600) / 0x100)
        mask = channels[index]
        mask_str = "00"
        if mask & 0x30 != 0:
          mask_str = "01"
        if mask & 0x3 != 0:
          mask_str += "01"
        else:
          mask_str += "00"

        steps = 0
        chunk = []
        for j in range(i, i+0x100, 8):
          if all_zero(data[j:j+8]):
            break
          chunk.append(data[j:j+8])
          steps += 1

        asm_file.write(f'SECTION "{name} {index}", ROMX\n')
        asm_file.write(f'{name}{index}::\n')
        asm_file.write(f'DB {steps};steps\n')
        asm_file.write(f'DB %{mask_str};disable mask\n\n')







    with open(path.replace(".sav", ".bin"), "wb") as out_file:
      out_file.write(data[0x200:0x4000])

if __name__ == "__main__":
  main()