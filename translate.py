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

  fileNames = glob.glob("./data/*_strings.csv")
  for fileName in fileNames:
    language_map = {}
    with open(fileName, encoding='utf8') as file:
      dict_reader = csv.DictReader(file)
      name = os.path.splitext(os.path.basename(fileName))[0]
      create_strings_file(dict_reader, name)
     
def charMapReplace(text):
  # SDCC replaces unicode characters with their unicode values instead
  # of leaving them for RGBDS's charmap to replace.
  # We need to replace those values before the compiler does it wrong.
  for char, val in charMap.items():
    if char.startswith("<"): #let RGBDS handle <> replacement
      continue
    text = text.replace(char, val)
  return text

def create_strings_file(dict_reader, name):
  dir = "./data/strings/"
  if not os.path.exists(dir):
    os.mkdir(dir)

  languages = dict_reader.fieldnames[2:]
  num = len(languages)
  segments = []
  for i in range(num):
    language, code = languages[i].split('-')
    segment = '#' if i == 0 else '";\n\n#el'
    segment += f'if defined(LANG_{code.upper()})//{language}\n'
    segments.append(segment)

  main_labels = [""] * num
  for entry in dict_reader:
    comment = entry["Comment"]
    label = entry["Label"]
    for i in range(num):
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
        
  with open(dir+name+".h", "w+", encoding='utf8') as file:    
    for segment in segments:
      file.write(segment)
    file.write('";\n#endif\n')

if __name__ == "__main__":
  main()