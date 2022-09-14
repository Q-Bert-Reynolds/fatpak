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

  main_labels = ["",""]
  languages = ["English", "Spanish"]
  assemblies = ['IF LANGUAGE == "en";English\n', '\nELIF LANGUAGE == "es";Spanish\n']
  for entry in dict_reader:
    comment = entry["Comment"]
    label = entry["Label"]
    for i in range(len(languages)):
      language = languages[i]
      asm = assemblies[i]
      if comment:
        asm += "\n;" + comment + "\n"

      text = entry[language]
      if not text:
        text = entry["English"]

      label_parts = label.split('.')
      sub_label = len(label_parts) > 1
      if label_parts[0] != main_labels[i]:
        main_labels[i] = label_parts[0]
        asm += (main_labels[i]+'::').ljust(32)
        if sub_label:
          asm += '\n'

      if sub_label:
        asm += ('  .' + label_parts[1] + ':').ljust(32)
      asm += ' DB "' + text + '",0\n'
      assemblies[i] = asm
        
  with open(dir+name+".asm", "w+", encoding='utf8') as file:    
    for asm in assemblies:
      file.write(asm)
    file.write('ENDC\n')

if __name__ == "__main__":
  main()