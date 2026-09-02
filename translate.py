import csv
import glob
import os

charMap = {}

def main():
  with open("src/charmap.asm", encoding="utf8") as file:
    inverseMap = {}
    for line in file:
      if line.startswith("; Standard printable ASCII characters"):
        break
      if not line.startswith("charmap"):
        continue
      line = line.split(";")[0] #discard comments
      char, val = line.split(",")
      char = char.split("\"")[1] #discard "charmap" and quotes
      if val in inverseMap:
        val = inverseMap[val]
      else:
        inverseMap[val] = char
        val =  "\\"+oct(int(val)).replace("0o","").zfill(3)
      charMap[char] = val

  fileNames = glob.glob("./data/strings/*_strings.*.csv")
  for fileName in fileNames:
    language_map = {}
    name,output = os.path.splitext(os.path.basename(fileName))[0].split('.')
    with open(fileName, encoding='utf8') as file:
      dict_reader = csv.DictReader(file)
      if output == "h":
        create_c_strings_files(dict_reader, name)
      elif output == "asm":
        create_asm_strings_files(dict_reader, name)
     
def charMapReplace(text):
  # SDCC replaces unicode characters with their unicode values instead
  # of leaving them for RGBDS's charmap to replace.
  # We need to replace those values before the compiler does it wrong.
  for char, val in charMap.items():
    if char.startswith("<"): #let RGBDS handle <> replacement
      continue
    text = text.replace(char, val)
  return text

def create_c_strings_files(dict_reader, name):
  dir = "./data/strings/"
  if not os.path.exists(dir):
    os.mkdir(dir)

  languages = dict_reader.fieldnames[2:]
  numLanguages = len(languages)
  segments = []
  codes = []
  with open(dir+name+".h", "w+", encoding='utf8') as file:    
    for i in range(numLanguages):
      language, code = languages[i].split('-')
      segments.append(f"//\n// {name}.{code}.h\n//\n")
      codes.append(code)
      s = '#' if i == 0 else '#el'
      s += f'if defined(LANG_{code.upper()})//{language}\n'
      s += f'#include "{name}.{code}.h"\n'
      file.write(s)
    file.write("#endif\n")

  main_labels = [""] * numLanguages
  for entry in dict_reader:
    comment = entry["Comment"]
    label = entry["Label"]
    for i in range(numLanguages):
      language = languages[i]
      segment = segments[i]

      text = entry[language]
      if not text:
        text = entry["English-en"]
      text = charMapReplace(text)
      
      label_parts = label.split('.')
      is_array = len(label_parts) > 1
      is_first = False
      if label_parts[0] != main_labels[i]:
        is_first = True
        if main_labels[i] != "":
          segment += '";\n'
        if comment:
          segment += "\n//" + comment + "\n"
        main_labels[i] = label_parts[0]
        segment += ('const char ' + main_labels[i]+'[] = ').ljust(42)
      if is_array and not is_first:
        segment += '\\0"\n'
        segment += ' ' * 42
      segment += '"' + text
      segments[i] = segment
        
  for i in range(numLanguages):
    with open(f"{dir}{name}.{codes[i]}.h", "w+", encoding='utf8') as file:    
      file.write(segments[i]+'";\n')

def create_asm_strings_files(dict_reader, name):
  dir = "./data/strings/"
  if not os.path.exists(dir):
    os.mkdir(dir)

  languages = dict_reader.fieldnames[2:]
  numLanguages = len(languages)
  segments = []
  codes = []
  with open(dir+name+".asm", "w+", encoding='utf8') as file:    
    for i in range(numLanguages):
      language, code = languages[i].split('-')
      segments.append(f";\n; {name}.{code}.asm\n;\n")
      codes.append(code)
      s = '' if i == 0 else 'EL'
      s += f'IF DEF(LANG_{code.upper()});{language}\n'
      s += f'INCLUDE "data/strings/{name}.{code}.asm"\n'
      file.write(s)
    file.write("ENDC\n")

  main_labels = [""] * numLanguages
  for entry in dict_reader:
    comment = entry["Comment"]
    label = entry["Label"]
    for i in range(numLanguages):
      language = languages[i]
      segment = segments[i]

      text = entry[language]
      if not text:
        text = entry["English-en"]
      
      label_parts = label.split('.')
      is_array = len(label_parts) > 1
      is_first = False
      if label_parts[0] != main_labels[i]:
        is_first = True
        if comment:
          segment += "\n;" + comment + "\n"
        main_labels[i] = label_parts[0]
        segment += (main_labels[i]+'::').ljust(42)
      if is_array and not is_first:
        segment += ' ' * 42
      segment += 'DB "' + text + '", 0\n'
      segments[i] = segment
        
  for i in range(numLanguages):
    with open(f"{dir}{name}.{codes[i]}.asm", "w+", encoding='utf8') as file:    
      file.write(segments[i])

if __name__ == "__main__":
  main()