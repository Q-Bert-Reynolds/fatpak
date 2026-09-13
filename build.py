import glob
import os

def main():
  with open("src/constants.asm", encoding="utf8") as in_file:
    with open("src/constants.h", "w+", encoding="utf8") as out_file:

      out_file.write("#ifndef CONSTANTS\n")
      out_file.write("#define CONSTANTS\n\n")

      for line in in_file:
        line = line.replace("DEF ", "#define ")
        line = line.replace(" EQU ", " ")
        line = line.replace(";", "//")
        line = line.replace(" %", " 0b")
        line = line.replace(" $", " 0x")
        out_file.write(line)

      out_file.write("\n#endif //CONSTANTS\n")

if __name__ == "__main__":
  main()