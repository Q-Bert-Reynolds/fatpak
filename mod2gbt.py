import os
import subprocess
import shutil

def main():
  py_change = os.path.getmtime("./mod2gbt.py")
  for root, folders, files in os.walk("./music"):
    for file in files:
      path = os.path.join(root, file)
      base, ext = os.path.splitext(path)
      if ext != ".mod":
        continue

      name = os.path.basename(base)
      asm_path = f"./music/{name}.asm"
      if os.path.isfile(asm_path):
        mod_change = os.path.getmtime(path)
        asm_change = os.path.getmtime(asm_path)
        if mod_change < asm_change and py_change < asm_change:
          print(f'Skipping "{file}". Generated assembly is up to date.')
          continue

      mod2gbt = os.path.join(os.getcwd(), "bin", "mod2gbt") 
      subprocess.Popen("{0} {1} {2}".format(mod2gbt, path, name), shell=True).wait()
      shutil.move(f"./{name}.asm", asm_path)

if __name__ == "__main__":
    main()