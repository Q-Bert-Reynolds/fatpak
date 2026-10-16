
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
