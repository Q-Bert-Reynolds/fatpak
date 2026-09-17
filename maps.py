import os
import glob

def main():
  paths = glob.glob("./maps/*.gbmap")
  names = [os.path.basename(path).replace(".gbmap", "") for path in paths]
  with open("data/map_data.asm", "w+", encoding="utf8") as file:
    file.write(";constants\n")
    for i, name in enumerate(names):
      file.write(f"DEF MAP_{name.upper().ljust(15)} EQU {i}\n")

    file.write("\nMapBanks:\n");
    for i, name in enumerate(names):
      file.write(f"  DB BANK(Map{name})\n")

    file.write("\nMapAddresses:\n");
    for i, name in enumerate(names):
      file.write(f"  DW Map{name}\n")

if __name__ == "__main__":
  main()