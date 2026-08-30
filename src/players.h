#ifndef PLAYERS
#define PLAYERS

#include "constants.h"

typedef struct {
  unsigned char number;
  unsigned char age;
  unsigned char position;
  unsigned char moves[MAX_MOVES];
  unsigned char pp[MAX_MOVES];
  unsigned char hand;
  unsigned char status;
  unsigned int hp;
  unsigned int max_hp;
  unsigned int bat;
  unsigned int field;
  unsigned int speed;
  unsigned int throw;
} PlayerData;

#endif//PLAYERS