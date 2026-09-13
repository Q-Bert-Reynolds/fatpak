import csv

position_map = {
  "P":  "PITCHER", 
  "C":  "CATCHER", 
  "1B": "FIRST_BASEMAN", 
  "2B": "SECOND_BASEMAN", 
  "3B": "THIRD_BASEMAN", 
  "SS": "SHORTSTOP",
  "LF": "LEFT_FIELDER",
  "CF": "CENTER_FIELDER",
  "RF": "RIGHT_FIELDER"
}
class Player:
  name = "Bubbi"
  position = "SS"
  age = 5
  bat = "Switch"
  throw = "Right"
  moves = []

  def __init__(self, row):
    self.name = row["Lineup"]
    self.position = row["Position"]
    self.age = int(row["Age"])
    self.bat = row["Bat"]
    self.throw = row["Throw"]

  def __str__(self):
    num = f'NUM_{self.name.upper().replace(" ","_").replace("-","_")},'.ljust(15)
    lv = f'{self.age},'.rjust(4)
    pos = f'{position_map[self.position]},'.ljust(15)
    hand = f"THROW_{self.throw.upper()}".ljust(12)
    hand += f"| BAT_{self.bat.upper()}"
    return f'  DB {num} {lv} {pos} {hand}'


class Translations:
  en = ""
  es = ""
  fr = ""
  it = ""
  pt = ""
  de = ""
  ja = ""

  def __init__(self, row):
    self.en = row["English-en"]
    self.es = row["Spanish-es"]
    self.fr = row["French-fr"]
    self.it = row["Italian-it"]
    self.pt = row["Portuguese-pt"]
    self.de = row["German-de"]
    self.ja = row["Japanese-ja"]

class Team:
  city = ""
  name = ""
  coach = ""
  restriction = ""
  flag = ""
  item = ""
  lineup = []
  translations = []

  def addData(self, index, data):
    if index == 0: 
      self.city = data
    elif index == 1:
      self.name = data
    elif index == 2:
      self.coach = data
    elif index == 3:
      self.restriction = data
    elif index == 4:
      self.flag = data
    elif index == 5:
      self.item = data

  def check(self):
    # check for duplicate positions
    for i in range(9):
      for j in range(i+1, 9):
        a = self.lineup[i]
        b = self.lineup[j]
        if a.position == b.position:
          print(f'{a.name} and {b.name} both play {a.position} on the {self.city} {self.name}')
    
    #TODO: check team name <= 8 chars
    #TODO: check for age restriction violations
    #TODO: check impossible evolutions (ie. Ton can't be 16)
    #TODO: check for moves that can't be learned

  def __str__(self):
    n = self.name if len(self.name) > 0 else self.coach
    s = f"{self.city}{n}Lineup:\n".replace(" ", "")
    for player in self.lineup:
      s += str(player) + "\n"
    return s

def main():
  teams = []
  with open("./data/teams.csv", encoding='utf8') as file:
    dict_reader = csv.DictReader(file)
    team = Team()
    lineup = []
    translations = []
    i = 0
    for row in dict_reader:
      lineup.append(Player(row))
      translations.append(Translations(row))
      team.addData(i, row["Team"])
      i += 1
      if i == 9:
        team.lineup = lineup
        team.check()
        team.translations = translations
        teams.append(team)
        team = Team()
        lineup = []
        i = 0
  
  #TODO: write strings files
  #TODO: handle move overrides
  with open(f"teams.asm", "w+", encoding='utf8') as file:    
    for team in teams:
      file.write(str(team) + "\n")

if __name__ == "__main__":
  main()