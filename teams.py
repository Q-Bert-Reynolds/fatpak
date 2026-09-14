import csv
import glob
import math
import os
from utils import *

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
    num = f'NUM_{ConstString(self.name)},'.ljust(15)
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

CITY_IDX = 0
NAME_IDX = 1
COACH_IDX = 2
IMAGE_IDX = 3
INNINGS_IDX = 4
MONEY_IDX = 5
RESTRICTION_IDX = 6
FLAG_IDX = 7
ITEM_IDX = 8

class Team:
  city = ""
  name = ""
  coach = ""
  image = ""
  innings = 0
  money = 0
  restriction = 0
  flag = "0"
  item = "0"
  lineup = []
  translations = []

  def addData(self, index, data):
    data = data.strip()
    if not data:
      return
    if index == CITY_IDX: 
      self.city = data
    elif index == NAME_IDX:
      self.name = data
    elif index == COACH_IDX:
      self.coach = data
    elif index == IMAGE_IDX:
      self.image = data
    elif index == INNINGS_IDX:
      self.innings = int(data)
    elif index == MONEY_IDX:
      self.money = int(data)
    elif index == RESTRICTION_IDX:
      if data.endswith("U"):
        self.restriction = -int(data[:-1])
      elif data.endswith("+"):
        self.restriction = int(data[:-1])
      else:
        self.restriction = 0
    elif index == FLAG_IDX:
      self.flag = ConstString(data) + "_FLAG"
    elif index == ITEM_IDX:
      self.item = ConstString(data) + "_ITEM"

  def label(self):
    n = self.name if len(self.name) > 0 else self.coach
    label = f"{self.city}{n}".replace(" ", "")
    return label

  def check(self):
    # check for duplicate positions
    for i in range(9):
      for j in range(i+1, 9):
        a = self.lineup[i]
        b = self.lineup[j]
        if a.position == b.position:
          print(f'Warning: {a.name} and {b.name} both play {a.position} on the {self.city} {self.name}')
    
    #check team name <= 7 chars
    if len(self.name) > 7:
      print(f'Warning: {self.name} has {len(self.name)} characters. Must be less than 8')
    
    #check coach name <= 15 chars
    if len(self.coach) > 15:
      print(f'Warning: {self.coach} has {len(self.coach)} characters. Must be less than 16')
  
    #TODO: check for age restriction violations
    #TODO: check impossible evolutions (ie. Ton can't be 16)
    #TODO: check for moves that can't be learned

  def __str__(self):
    s  = f'{self.label()}Team::\n'
    s += f'.name: DB "{self.name}"{",0"*(8-len(self.name))}\n'
    s += f'.coach: DB "{self.coach}"{",0"*(16-len(self.coach))}\n'
    s += f'.innings: DB {self.innings}\n'
    s += f'.money: D24 {self.money}\n'
    s += f'.restriction: DB {self.restriction}\n'
    s += f'.flag: DB {self.flag}\n'
    s += f'.item: DB {self.item}\n'
    s += f'.image: DB COACH_{self.image.upper()}\n'
    s += f'.lineup:\n'
    for player in self.lineup:
      s += f'{player}\n'
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

  coaches_per_bank = 27
  coach_images = [img for img in glob.glob("./img/coaches/*.asm") if not img.endswith("_2x.asm")]
  bank_count = math.ceil(len(coach_images) / coaches_per_bank)
  print("Generating " + str(bank_count) + " coach image banks.")

  with open(f"data/coach_img.asm", "w+", encoding='utf8') as file:    

    for i, img in enumerate(coach_images):
      if i % coaches_per_bank == 0:
        bank = math.floor(i / coaches_per_bank)
        file.write(f'SECTION "Coach Images {bank}", ROMX, BANK[COACH_IMG_BANK+{bank}]\n\n')
      file.write(f'INCLUDE "{img}"\n')
    file.write("\n")

    file.write('SECTION "Coach Data", ROMX, BANK[COACHES_BANK]\n\n')
    for i, img in enumerate(coach_images):
      name = os.path.basename(img).replace(".asm", "")
      coach_images[i] = name
      file.write(f'DEF COACH_{ConstString(name).ljust(15)} EQU {i}\n')
    file.write(f'DEF COACHES_COUNT         EQU {len(coach_images)}\n\n')

    file.write("CoachTiles:\n")
    for img in coach_images:
      file.write(f'  DW _{PascalCase(img)}Tiles\n')
    file.write("\n")

    file.write("CoachTileMaps:\n")
    for img in coach_images:
      file.write(f'  DW _{PascalCase(img)}TileMap\n')
    file.write("\n")

    file.write("CoachTileCounts:\n")
    for img in coach_images:
      file.write(f'  DB _{img.upper()}_TILE_COUNT\n')
    file.write("\n")

    file.write("CoachColors:\n")
    for img in coach_images:
      file.write(f'  DW _{PascalCase(img)}Colors\n')
    file.write("\n")

    file.write("CoachPaletteMaps:\n")
    for img in coach_images:
      file.write(f'  DW _{PascalCase(img)}PaletteMap\n')
    file.write("\n")

    file.write("CoachPaletteCounts:\n")
    for img in coach_images:
      file.write(f'  DB _{img.upper()}_PALETTE_COUNT\n')
    file.write("\n")

    file.write("CoachBanks:\n")
    for img in coach_images:
      file.write(f'  DB BANK(_{PascalCase(img)}Tiles)\n')
    file.write("\n")

  with open(f"data/team_data.asm", "w+", encoding='utf8') as file:    
    for team in teams:
      file.write(str(team) + "\n")

if __name__ == "__main__":
  main()