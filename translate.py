import csv
import glob
import os

def main():
  fileNames = glob.glob("./data/*_strings.csv")
  for fileName in fileNames:
    language_map = {}
    with open(fileName, encoding='utf8') as file:
      dict_reader = csv.DictReader(file)
      name = os.path.splitext(os.path.basename(fileName))[0]
      create_strings_file(dict_reader, name)
     

def create_strings_file(dict_reader, name):
  dir = "./data/strings/"
  if not os.path.exists(dir):
    os.mkdir(dir)

  main_label = ""
  with open(dir+name+".asm", "w+", encoding='utf8') as asm:    
    for entry in dict_reader:
      label = entry["Label"]
      english = entry["English"]
      spanish = entry["Spanish"]

      label_parts = label.split('.')
      if label_parts[0] != main_label:
        main_label = label_parts[0]
        asm.write('\n'+main_label+'::')

      if len(label_parts) > 1:
        asm.write('\n.'+label_parts[1]+':')

      if not spanish.strip():
        asm.write(' DB "'+english+'",0')
      else:
        asm.write('\nIF DEF(_LANG_ES)')
        asm.write('\n  DB "'+spanish+'",0')
        asm.write('\nELSE')
        asm.write('\n  DB "'+english+'",0')
        asm.write('\nENDC')

if __name__ == "__main__":
  main()