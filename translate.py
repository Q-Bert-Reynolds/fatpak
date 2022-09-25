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

  languages = ["English", "Spanish"]
  segments = ['#if defined(LANG_EN)//English\n', '";\n\n#elif defined(LANG_ES)//Spanish\n']
  main_labels = ["", ""]
  for entry in dict_reader:
    comment = entry["Comment"]
    label = entry["Label"]
    for i in range(len(languages)):
      language = languages[i]
      segment = segments[i]

      text = entry[language]
      if not text:
        text = entry["English"]
      text = text.replace("\\n", "\\x80") #sdcc replaces \n with $0A, but we need $80
      
      label_parts = label.split('.')
      is_array = len(label_parts) > 1
      is_first = False
      if label_parts[0] != main_labels[i]:
        is_first = True
        if main_labels[i] != "":
          # if is_array:
          #   segment += '"'
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
        
  with open(dir+name+".c", "w+", encoding='utf8') as file:    
    for segment in segments:
      file.write(segment)
    file.write('";\n#endif\n')

if __name__ == "__main__":
  main()