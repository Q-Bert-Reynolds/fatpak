import os
import glob

def main():
  map_paths = glob.glob("./maps/*.gbmap")
  map_names = [os.path.basename(path).replace(".gbmap", "") for path in map_paths]

  img_paths = glob.glob("./img/maps/*.asm")
  img_names = [os.path.basename(path).replace(".asm", "") for path in img_paths]

  with open("data/map_data.asm", "w+", encoding="utf8") as file:
    file.write('\nSECTION "Map Images", ROMX\n')
    for path in img_paths:
      file.write(f'INCLUDE "{path.replace("./", "")}"\n')

    file.write('\nSECTION "Map Loader Data", ROM0\n')
    for i, name in enumerate(map_names):
      file.write(f"DEF MAP_{name.upper().ljust(15)} EQU {i}\n")

    file.write("\nMapBanks:\n");
    for i, name in enumerate(map_names):
      file.write(f"  DB BANK(Map{name})\n")

    file.write("\nMapAddresses:\n");
    for i, name in enumerate(map_names):
      file.write(f"  DW Map{name}\n")

    for i, name in enumerate(map_names):
      file.write(f'\nSECTION "{name} Map Bank", ROMX\n')
      file.write(f'INCLUDE "{map_paths[i].replace("./", "")}"\n')

if __name__ == "__main__":
  main()