
def PascalCase(name):
  s = name.split("_")
  for i in range(len(s)):
    s[i] = s[i][0].upper() + s[i][1:]
  s = "".join(s)
  s = s.replace(" ", "")
  s = s.replace("-", "")
  s = s.replace("\n", "")
  s = s.replace("\t", "")
  s = s.replace("\\", "")
  s = s.replace("/", "")
  return s

def ConstString(name):
  name = name.replace("-", "")
  name = name.replace("'", "")
  name = name.replace(" ", "_")
  return name.upper()


def constants(path="src/constants.asm"):
  """Numeric DEF ... EQU values from src/constants.asm ($hex, %binary or decimal).
  Expressions are skipped; anything Python needs must be a literal."""
  import re
  values = {}
  with open(path, encoding="utf8") as file:
    for line in file:
      match = re.match(r"\s*DEF\s+(\w+)\s+EQU\s+(\$[0-9A-Fa-f]+|%[01]+|\d+)\s*(?:;|$)", line)
      if match:
        text = match.group(2)
        values[match.group(1)] = int(text[1:], 16) if text[0] == "$" else int(text[1:], 2) if text[0] == "%" else int(text)
  return values
