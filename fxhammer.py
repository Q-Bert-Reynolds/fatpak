import os
import glob

def main():
  for path in glob.glob("./sfx/*.sav"):
    with open(path, "rb") as sav_file:
      data = sav_file.read()
      with open(path.replace(".sav", ".bin"), "wb") as out_file:
        out_file.write(data[0x200:0x4000])


if __name__ == "__main__":
  main()