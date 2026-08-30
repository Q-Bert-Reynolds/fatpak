#ifndef ANNOUNCER
#define ANNOUNCER

#include "../constants.h"
#include "../../data/strings/announcer_strings.h"

// src/baseball/play_ball.asm
extern void DrawCountOutsInning();
extern void DrawScore();

// src/ui.asm
extern void RevealTextAndWait(const char text[]);
extern void DisplayText(char drawFlags, const char text[]);

// src/math.asm
extern unsigned long math_Divide(unsigned long num, unsigned char div);
extern unsigned int math_Multiply(unsigned int word, unsigned char byte);

// src/strings.asm
extern char* str_FromArray(unsigned int index, char strings[]);
extern void str_Copy(const char src[], const char dest[]);
extern void str_Append(const char append[], const char dest[]);
extern void str_Replace(const char src[], const char dest[], const char replacement[]);
extern void str_Number(unsigned long n);

// src/utils.asm
extern void SetBalls(unsigned char balls);
extern void SetStrikes(unsigned char strikes);
extern void FoulBall();
extern void GetCurrentBatterName();
extern void GetCurrentPitcherName();
extern void NextBatter();
extern void ShowBatter();
extern void HideBatter();
extern void ShowPitcher();
extern void PutBatterOnFirst();
extern unsigned char IsUserFielding();
extern unsigned char GetBalls();
extern unsigned char GetStrikes();
extern unsigned char GetOuts();
extern unsigned char CheckStrike();
extern unsigned char IncrementOuts();
extern unsigned char DistanceFromSpeedLaunchAngle(unsigned char speed, signed char launch);
extern unsigned char HangTimeFromSpeedLaunchAngle(unsigned char speed, signed char launch);
extern unsigned char CurrentOrderInLineup();
extern unsigned char AdvanceRunners(unsigned char num_bases, unsigned char batter);// batter is lineup order (1-9) to put on first or 0 if no batter on 1st
extern unsigned int LocationFromDistSprayAngle(unsigned char distance, signed char spray);//returns xy in de
extern unsigned int GetClosestFielderByLocation(unsigned int xy);//de = xy, returns position number in a, distance in b
extern unsigned int GetPositionPlayerAndName(unsigned char position);//a = position number (1-9), returns position player in hl, name in [name_buffer]

// src/players.asm
extern void GetMoveName(char index);
extern void GetUserPlayerName(unsigned int player);//hl = user player, returns name in name_buffer
extern unsigned int GetPlayerSpeed(unsigned int player);//hl = player, returns speed in hl
extern unsigned int GetUserPlayerInLineup(unsigned char lineup_index);//a = lineup index, returns player in hl
extern unsigned int GetOpposingPlayerInLineup(unsigned char lineup_index);//a = lineup index, returns player in hl

// src/roledex.asm
extern void GetPlayerName(unsigned char num);//a = number, returns name in name_buffer

// src/wram.asm
extern unsigned char ball_state;
extern unsigned int runners_on_base;
extern unsigned char pitch_move_id;
extern unsigned char frame;
extern unsigned char home_team;
extern unsigned char away_score;
extern unsigned char home_score;
extern char tile_buffer[];
extern char str_buffer[];
extern char name_buffer[];

void AnnounceTest();

void AnnouncePitcher();
void AnnounceBatter();
void AnnounceBeginningOfFrame();
void AnnouncePitcherSets();
void AnnounceAndThePitch();
void AnnouncePitchName();
void AnnounceNextBatter();
void AnnounceBatterStepsIntoBox();

void AnnounceNoSwing();
void AnnounceWildPitchOrPassedBall();
void AnnounceStrike(const char* strike_out_text);
void AnnounceSwingMiss();
void AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch);

void AnnounceBattedOnGround(char speed, char spray, signed char launch);
void AnnounceBattedInAir(unsigned char speed, signed char spray, signed char launch);
void AnnounceBattedInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch);
void AnnounceBattedInAirToInfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch);
void AnnounceBuntText(char launch, char spray);
void AnnounceHit(char bases);

void AppendOutfieldLocationTextByAngle(signed char spray);
void AppendInfieldLocationTextByAngle(signed char spray);
void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time);
void AnnounceCaughtBy();
void AnnounceForcePlay();
void AnnounceFoulBall();

void AnnounceAdvanceRunners();
void AnnounceRunnersOn();
void AnnounceRunScored();
void AnnounceEndOfGame();

#endif //ANNOUNCER
