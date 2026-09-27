import os
import glob
import csv
import textwrap
import math
import pathlib 
from utils import *

players_per_bank = 27
bank_count = math.ceil(151 / players_per_bank)
print("Generating " + str(bank_count) + " player image banks.")

anims = [
  "lefty_batter_user",
  "righty_batter_user",
  "lefty_pitcher_user",
  "righty_pitcher_user",
  "lefty_batter_opponent",
  "righty_batter_opponent",
  "lefty_pitcher_opponent",
  "righty_pitcher_opponent",
]

def main():
  roledex = []
  with open("./data/roledex.csv") as file:
    dict_reader = csv.DictReader(file)
    for player in dict_reader:
      roledex.append(player)

  learned_moves = {}
  with open("./data/learned_moves.csv") as file:
    rows = csv.reader(file)
    next(rows)#skip count
    next(rows)#skip category
    next(rows)#skip type
    moves = next(rows)
    max_learnset = 0
    player_with_largest = ""
    for row in rows:
      player = row[1]
      player_moves = []
      for i in range(2, len(row)):
        if (row[i]):
          player_moves.append((int(row[i]), moves[i]))
      if len(player_moves) > max_learnset:
        max_learnset = len(player_moves)
        player_with_largest = player
      learned_moves[player] = sorted(player_moves)
  print(player_with_largest + " has largest learnset at " + str(max_learnset) + " moves.")

  taught_moves = {}
  with open("./data/taught_moves.csv") as file:
    rows = csv.reader(file)
    moves = next(rows)
    count = math.ceil(55/8)*8 #number of HMs + TMs rounded to the next multiple of 8
    for row in rows:
      player = row[0]
      player_moves = ["0"]*count
      for i in range(1, len(row)):
        if (row[i]):
          player_moves[i-1] = "1"
      bin_str = "".join(player_moves)
      byte_array = []
      for i in range(0,count,8):
        byte_array.append("${:02X}".format(int(bin_str[i:i+8], 2)))
      taught_moves[player] = byte_array

  generate_player_strings(roledex)
  generate_player_data(roledex, learned_moves, taught_moves)
  generate_img_bank(roledex)

def generate_img_bank(roledex):
  with open("./data/player_img.asm", "w+") as asm_file:
    asm_file.write("DEF PLAYER_IMG_BANK_COUNT EQU " + str(bank_count) + "\n")
    asm_file.write("DEF PLAYERS_PER_BANK EQU (151 + (PLAYER_IMG_BANK_COUNT- 1)) / PLAYER_IMG_BANK_COUNT\n\n")
    for bank in range(bank_count):
      player_count = players_per_bank
      if bank == bank_count-1:
        player_count = 151 - players_per_bank * (bank_count-1)

      asm_file.write("SECTION \"Player Images "+str(bank)+"\", ROMX, BANK[PLAYER_IMG_BANK+"+str(bank)+"]\n\n")
      
      asm_file.write("DW PlayerTiles"+str(bank)+"\n")
      asm_file.write("DW PlayerTileCounts"+str(bank)+"\n")
      asm_file.write("DW PlayerColumns"+str(bank)+"\n")
      asm_file.write("DW PlayerTileMaps"+str(bank)+"\n")

      for n in range(player_count):
        player = roledex[bank*players_per_bank+n]
        name = player["#"] + player["Nickname"].replace(" ","").replace("-","")
        asm_file.write("INCLUDE \"img/players/"+name+".asm\"\n")

      asm_file.write("\nPlayerTiles"+str(bank)+"::\n")
      for n in range(player_count):
        player = roledex[bank*players_per_bank+n]
        name = player["#"] + player["Nickname"].replace(" ","").replace("-","")
        asm_file.write("DW _"+name+"Tiles\n")

      asm_file.write("\nPlayerTileCounts"+str(bank)+"::\n")
      for n in range(player_count):
        player = roledex[bank*players_per_bank+n]
        name = player["#"] + player["Nickname"].replace(" ","").replace("-","")
        asm_file.write("DB _"+name.upper()+"_TILE_COUNT\n")

      asm_file.write("\nPlayerColumns"+str(bank)+"::\n")
      for n in range(player_count):
        player = roledex[bank*players_per_bank+n]
        name = player["#"] + player["Nickname"].replace(" ","").replace("-","")
        asm_file.write("DB _"+name.upper()+"_COLUMNS\n")

      asm_file.write("\nPlayerTileMaps"+str(bank)+"::\n")
      for n in range(player_count):
        player = roledex[bank*players_per_bank+n]
        name = player["#"] + player["Nickname"].replace(" ","").replace("-","")
        asm_file.write("DW _"+name+"TileMap\n")

      asm_file.write("\n")

    bank = 0
    bytes_per_anim = 65*16 + 56*4 #max 16 tiles, max 4 8x7 frames, TODO: this should be calculated instead 
    bytes_so_far = 0
    index = 0
    while index < 151:
      if bytes_so_far == 0:
        asm_file.write("SECTION \"Player Animations "+str(bank)+"\", ROMX, BANK[PLAYER_IMG_BANK+PLAYER_IMG_BANK_COUNT+"+str(bank)+"]\n\n")
        asm_file.write("\n")
      player = roledex[index]
      name = player["#"] + player["Nickname"].replace(" ","").replace("-","")
      for path in glob.glob("./img/players/"+name+"/"+name+"_*.asm"):
        path = pathlib.PurePath(path).as_posix()
        asm_file.write("INCLUDE \"" + path + "\"\n")
        bytes_so_far += bytes_per_anim
        if (bytes_so_far >= 16384):
          bank += 1
          bytes_so_far = 0
      index += 1
    print("Generated " + str(bank+1) + " banks for player animations.")

def generate_player_strings(roledex):
  with open("./data/player_strings.asm", "w+") as asm_file:
    asm_file.write("SECTION \"Player Strings\", ROMX\n")
    asm_file.write("\nPlayerNames::\n")
    for player in roledex:
      asm_file.write("DB \"{0}\", 0\n".format(player["Nickname"].upper()))
    asm_file.write("\n\nPlayerDescriptions::\n")
    for player in roledex:
      #lines = textwrap.wrap(player["Description"], 18)
      lines = textwrap.wrap(player["Pkmn Parody"], 18)
      description = "\\n".join(lines)
      asm_file.write("DB \"{0}\", 0\n".format(description))
    asm_file.write("\n")

def player_type_string(player):
  t1 = player["Type1"].upper()
  s =  "DB " + t1 + "\n"
  if player["Type2"]:
    t2 = player["Type2"].upper()
    s += "DB " + t2 + "\n"
  else:
    s += "DB NONE\n"
  return s

ev_items = {
  "Fire Ball": "FIRE_BALL_ITEM",
  "Thunder Bat": "THUNDER_BAT_ITEM",
  "Water Glove": "WATER_GLOVE_ITEM",
  "Grass Grip": "GRASS_GRIP_ITEM",
  "Moon Shoes": "MOON_SHOES_ITEM"
}
def evolves_to_string(roledex, player):
  s = ";evolution\n"
  has_ev = False
  for p in roledex:
    if player["#"] != p["EVFrom"]:
      continue
    
    has_ev = True
    ev_type = p["EVType"]
    num = int(p["#"])
    try:
      age = int(ev_type)
      s += f"DB EV_TYPE_AGE, {num}, {age}\n"
    except:
      if ev_type == "Trade":
        s += f"DB EV_TYPE_TRADE, {num}, 0\n"
      else:
        item = ev_items[ev_type]
        s += f"DB EV_TYPE_ITEM, {num}, {item}\n"

  if not has_ev:
    s += "DB EV_TYPE_NONE\n"
    return s

  s += "DB 0\n"
  return s

def height_string(player):
  h = float(player["Height"])
  feet = "{0:01X}".format(int(h))
  inches = "{0:01X}".format(int((h*100)%100))
  return "DB $" + feet + inches + " ;height\n"

def weight_string(player):
  w = float(player["Weight"])
  lbs = "{0:03X}".format(int(w))
  frac = "{0:01X}".format(int((w*10)%10))
  return "DW $" + frac + lbs + " ;weight\n"

def generate_player_data(roledex, learned_moves, taught_moves):
  with open("./data/player_data.asm", "w+") as asm_file:
    for player in roledex:
      asm_file.write("DEF NUM_"+player["Nickname"].upper().replace(" ","_").replace("-","_")+" EQU "+str(int(player["#"]))+"\n")

    asm_file.write("\nSECTION \"Player Data\", ROMX\n")
    asm_file.write(";weight format: DDDDLLLL LLLLLLLL where D is decimal and L is lbs\n")
    asm_file.write(";height format: FFFFIIII where F is feet and I is inches\n")

    var_names = ""
    for player in roledex:
      name = player["#"] + player["Nickname"].replace(" ","").replace("-","")
      var_name = "_" + name + "Roledex"
      var_names += "DW " + var_name + "\n"
      asm_file.write("\n" + var_name + ":\n")
      asm_file.write("DB " + str(int(player["#"])) + "\n")
      asm_file.write(player_type_string(player))
      asm_file.write(height_string(player))
      asm_file.write(weight_string(player))
      asm_file.write("DB " + str(player["HP"]) + " ;HP\n")
      asm_file.write("DB " + str(player["Bat"]) + " ;Bat\n")
      asm_file.write("DB " + str(player["Field"]) + " ;Field\n")
      asm_file.write("DB " + str(player["Speed"]) + " ;Speed\n")
      asm_file.write("DB " + str(player["Throw"]) + " ;Throw\n")
      asm_file.write("DB " + str(player["BodyID"]) + " ;Lineup Body\n")
      asm_file.write("DB " + str(player["HeadID"]) + " ;Lineup Head\n")
      asm_file.write("DB " + str(player["HatID"]) + " ;Lineup Hat\n")
      asm_file.write("DB " + str(player["GBPal"]) + " ;Lineup Palette\n")
      asm_file.write("DW " + str(player["SGBPal"]) + " ;Color Palette\n")

      asm_file.write(";animations\n")
      for anim in anims:
        count = anim.upper() + "_TILE_COUNT"
        label = PascalCase(anim) + "Tiles"

        path = "./img/players/"+name+"/"+name+"_"+anim+".asm"
        if os.path.exists(path):
          label = name + label
          count = name.upper() + "_" + count

        asm_file.write("DB BANK(_"+label+")\n")
        asm_file.write("DW _"+label+"\n")
        asm_file.write("DB _"+count+"\n")

      asm_file.write("DB " + ", ".join(taught_moves[player["Nickname"]]) + " ;HM/TM bit field\n")

      asm_file.write(";learnset\n")
      for move in learned_moves[player["Nickname"]]:
        move_const = move[1].upper().replace(" ","_").replace(".","").replace("-","_") + "_MOVE"
        asm_file.write("DB " + move_const + ", " + str(move[0]) + "\n")
      asm_file.write("DB 0\n")

      asm_file.write(evolves_to_string(roledex, player))
      
    asm_file.write("\nRoledex:\n"+var_names)

if __name__ == "__main__":
  main()