//
// src/baseball/announcer.c
//

#include "../constants.h"
#include "../../data/strings/announcer_strings.h"

// src/ui.asm
extern void RevealTextAndWait(const char text[]);
extern void DisplayText(char drawFlags, const char text[]);

// src/strings.asm
extern char* str_FromArray(int index, char strings[]);
extern void str_Copy(const char src[], const char dest[]);
extern void str_Append(const char append[], const char dest[]);
extern void str_Replace(const char src[], const char dest[], const char replacement[]);
extern void str_Number(unsigned long n);

// src/utils.asm
extern unsigned char GetBalls(void);
extern void SetBalls(unsigned char balls);
extern unsigned char GetStrikes(void);
extern void SetStrikes(unsigned char strikes);
extern unsigned char CheckStrike(void);
extern unsigned char IncrementOuts(void);
extern unsigned char DistanceFromSpeedLaunchAngle(unsigned char speed, signed char launch);
extern unsigned char HangTimeFromSpeedLaunchAngle(unsigned char speed, signed char launch);
extern unsigned char CurrentOrderInLineup(void);
extern unsigned char AdvanceRunners(unsigned char num_bases, unsigned char batter);// batter is lineup order (1-9) to put on first or 0 if no batter on 1st
extern unsigned int LocationFromDistSprayAngle(unsigned char distance, signed char spray);//returns xy in de
extern unsigned int GetClosestFielderByLocation(unsigned int xy);//de = xy, returns position number in a, distance in b


// src/players.asm
extern void GetMoveName(char index);

// src/wram.asm
extern char ball_state;
extern int runners_on_base;
extern char pitch_move_id;
extern char frame;
extern char tile_buffer[];
extern char str_buffer[];
extern char name_buffer[];

void AnnouncePitcher(void);
void AnnounceBatter(void);
void AnnounceBeginningOfFrame(void);
void AnnouncePitcherSets(void);
void AnnounceAndThePitch(void);
void AnnouncePitchName(void);
void AnnounceNextBatter(void);
void AnnounceBatterStepsIntoBox(void);
void AnnounceNoSwing(void);
void AnnounceWildPitchOrPassedBall(void);
void AnnounceSwingMiss(void);
void _AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch);
void AnnounceHitOnGround(char speed, char spray);
void AnnounceHitInAir(unsigned char speed, signed char spray, signed char launch);
void AnnounceHitInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch);
void AppendOutfieldLocationTextByAngle(signed char spray);
void AnnounceHitInAirToInfield(unsigned char distance, signed char spray, signed char launch);
void AppendInfieldLocationTextByAngle(signed char spray);
void AnnounceBuntText(char launch, char spray);
void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time);
void AnnounceFoulBall(void);
void AnnounceAdvanceRunners(void);
void AnnounceRunnersOn(void);
void AnnounceRunScored(void);
void AnnounceEndOfGame(void);

//script
    // "Unsigned GINGER appeared!" or  "CALVIN wants to play 3 innings."
    // "Play ball!"
    //
    // "GINGER steps on the mound."
    // "BUBBI walks up to the plate."
    // 
    // SHOW MENU, SELECT PLAY, SELECT A MOVE
    //   "BUBBI steps into the box."
    //   "GINGER sets."
    //   "And the pitch."
    //   "A fireball!"
    //   "Swing and a miss."
    //   "Strike 1."
    //
    // SHOW MENU, SELECT PLAY, SELECT A MOVE
    //   "BUBBI steps into the box."
    //   "GINGER sets."
    //   "And the pitch."
    //   "A changeup!"
    //   "Foulled back."
    //
    // SHOW MENU, SELECT PLAY, SELECT A MOVE
    //   "BUBBI steps into the box."
    //   "GINGER sets."
    //   "And the pitch."
    //   "A changeup!"
    //   "Ball 1."
    //
    // SHOW MENU, SELECT PLAY, SELECT A MOVE
    //   "BUBBI steps into the box."
    //   "GINGER sets."
    //   "And the pitch."
    //   "A fireball!"
    //   "A deep fly ball to right center."
    //   "CHU makes the catch."
    //   "Out!"
    //
    // "YOGI walks up to the plate."
    //
    // SHOW MENU, SELECT PLAY, SELECT A MOVE
    //   "YOGI steps into the box."
    //   "GINGER sets."
    //   "And the pitch."
    //   "A fireball!"
    //   "Line drive ball down the right field line."
    //   "OT at the wall."
    //   "HOME RUN!"
    //
    // "PIDGE walks up to the plate."
    //
    // SHOW MENU, SELECT PLAY, SELECT A MOVE
    //   "PIDGE steps into the box."
    //   "GINGER sets."
    //   "And the pitch."
    //   "A fireball!"
    //   "Shallow fly to center field."
    //   "Base hit!"
    //
    // "RATS walks up to the plate."
    //
    // SHOW MENU, SELECT PLAY, SELECT A MOVE
    //   "RATS steps into the box."
    //   "GINGER sets."
    //   "And the pitch."
    //   "A fireball!"
    //   "Ground ball to short."
    //   "Fielded by DUCK."
    //   "Throws to second."
    //   "Stoop makes the catch."
    //   "Out at second."
    //   "Throws to first."
    //   "Double play!"
    //
    // "That brings us to the bottom of the 1st."
    // "BRUH steps on the mound."
    // "GINGER walks up to the plate."
    //
    // ...
    //
    // "That brings us to the top of the 9th."
    // "GINGER takes the mound."
    // "CHU walks up to the plate."
    //
    // ...
    //
    // SHOW MENU, SELECT TEAM, CHANGE PITCHER
    //   "BUBBI takes the mound."
    // 
    //
    // "And that's the ballgame."
    //
    //  OPPOSING COACH WIN/LOSS STATEMENT
    //  "That win brings you to 16W - 5L"

void AnnouncePitcher(void) {
    __asm
    TRAMPOLINE ShowPitcher
    TRAMPOLINE GetCurrentPitcherName
    __endasm;
    str_Replace(TakesTheMoundText, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
}

void AnnounceBatter(void) {
    __asm
    TRAMPOLINE DrawCountOutsInning
    TRAMPOLINE ShowBatter
    TRAMPOLINE GetCurrentBatterName
    __endasm;
    str_Replace(WalksToThePlateText, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
}

//----------------------------------------------------------------------
// AnnounceBeginningOfFrame - called at beginning of each frame
//
//   "GINGER steps on the mound."
//   "BUBBI walks up to the plate."
// 
//----------------------------------------------------------------------
void AnnounceBeginningOfFrame(void) {
    char* inningText = str_FromArray(frame>>1, InningTexts);
    str_Copy(inningText, name_buffer);
    const char* topBottomText = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
    str_Replace(topBottomText, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
    AnnouncePitcher();
    AnnounceBatter();
}

void AnnouncePitcherSets(void) {
    __asm
    TRAMPOLINE GetCurrentPitcherName
    __endasm;
    str_Replace(PitcherSetsText, str_buffer, name_buffer);
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
}

void AnnounceAndThePitch(void) {
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, AndThePitchText);
}

void AnnouncePitchName(void) {
    GetMoveName(pitch_move_id);//"PITCH_NAME" in name_buffer
    str_Copy(AndThePitchText, str_buffer);//"And the pitch.""
    str_Replace(ThrewAPitchText, tile_buffer, name_buffer);//"\nA PITCH_NAME."
    str_Append(tile_buffer, str_buffer);//"And the pitch.\nA PITCH_NAME."
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
}

void AnnounceNextBatter(void) {
    SetBalls(0);
    SetStrikes(0);
    __asm__("TRAMPOLINE NextBatter");
    AnnounceBatter();
}

void AnnounceBatterStepsIntoBox(void) {
    __asm__("TRAMPOLINE GetCurrentBatterName");
    str_Replace(BatterStepsIntoTheBoxText, str_buffer, name_buffer);
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
}


//----------------------------------------------------------------------
// AnnounceNoSwing - called if the player doesn't swing
//
//   "Ball 1."
//
//----------------------------------------------------------------------
void AnnounceNoSwing(void) {

    if (CheckStrike()) { //strike
        unsigned char strikes = GetStrikes();
        if (strikes < 2) {
            SetStrikes(++strikes);
            __asm__("TRAMPOLINE DrawCountOutsInning");
            str_Number(strikes);
            str_Replace(StrikeText, str_buffer, name_buffer);
            RevealTextAndWait(str_buffer);
        }
        else { //strikeout
            __asm__("TRAMPOLINE GetCurrentBatterName");
            str_Replace(StrikeOutLookingText, str_buffer, name_buffer);
            RevealTextAndWait(str_buffer);
            __asm__("TRAMPOLINE HideBatter");
            if (IncrementOuts() < 3) {
                AnnounceNextBatter();
            }
        }
    }
    else { //ball
        unsigned char balls = GetBalls();
        if (balls < 3) {
            SetBalls(++balls);
            __asm__("TRAMPOLINE DrawCountOutsInning");
            str_Number(balls);
            str_Replace(BallText, str_buffer, name_buffer);
            RevealTextAndWait(str_buffer);
        }
        else { //walk
            __asm__("TRAMPOLINE PutBatterOnFirst");
            __asm__("TRAMPOLINE GetCurrentBatterName");
            str_Replace(WalkText, str_buffer, name_buffer);
            RevealTextAndWait(str_buffer);
            __asm__("TRAMPOLINE HideBatter");
            AnnounceRunScored();
            AnnounceNextBatter();
        }
    }
}

void AnnounceWildPitchOrPassedBall(void) {
    // PassedBallText
    // WildPitchText
}

//----------------------------------------------------------------------
// AnnounceSwingMiss - called if the player swings and misses
//
//   "Swing and a miss."
//   "Strike 1."
//
//----------------------------------------------------------------------
void AnnounceSwingMiss(void) {
    // TODO: check for wild pitch, passed ball, dropped 3rd strike

    char strikes = GetStrikes();
    if (strikes < 2) {
        SetStrikes(++strikes);
        __asm__("TRAMPOLINE DrawCountOutsInning");
        str_Number(strikes);
        str_Replace(StrikeText, str_buffer, name_buffer);
        RevealTextAndWait(str_buffer);
    }
    else { //strikeout
        __asm__("TRAMPOLINE GetCurrentBatterName");
        str_Replace(StrikeOutSwingingText, str_buffer, name_buffer);
        RevealTextAndWait(str_buffer);
        __asm__("TRAMPOLINE HideBatter");
        if (IncrementOuts() < 3) {
            AnnounceNextBatter();
        }
    }
}


void _AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {
    //TODO: foul tip caught, foul bunt K

    ball_state = BALL_STATE_IN_PLAY;

    if (spray > -45 && spray < 45) {
        ball_state |= BALL_STATE_FAIR; 
    }

    if (launch > 0) {
        AnnounceHitInAir(speed, spray, launch);
    }
    else { //on ground
        ball_state |= BALL_STATE_LANDED;
        AnnounceHitOnGround(speed, spray);
    }
}

void AnnounceHitOnGround(char speed, char spray) {

}

void AnnounceHitInAir(unsigned char speed, signed char spray, signed char launch) {
    unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
    if (distance < 100) {//infield
        AnnounceHitInAirToInfield(distance, spray, launch);
    }
    else {//outfield
        AnnounceHitInAirToOutfield(speed, distance, spray, launch);
    }
}

void AnnounceHitInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {   
    //TODO: LeapingCatchByText

    if (distance > 240) { //out of play
        if (ball_state & BALL_STATE_FAIR != 0) { //home run
            unsigned char order = CurrentOrderInLineup();
            unsigned char runs_scored = AdvanceRunners(4, ++order);//current batter is 0 to 8, needs to be 1 to 9
            const char* home_run_text = (runs_scored == 4) ? HitGrandSlamText : HitHomeRunText;
            RevealTextAndWait(home_run_text);
            __asm__("TRAMPOLINE DrawScore");
            AnnounceNextBatter();
            return;
        }

        //else, foul ball
        AnnounceFoulBall();
        return;
    }

    const char* hitText = HitPopFlyText;
    if (distance > 220) {
        hitText = HitDeepFlyBallText;
    }
    else if (distance > 180) {
        hitText = HitFlyBallText;
    }
    else if (distance > 140) {
        hitText = HitShallowFlyBallText;
    }
    str_Copy(hitText, str_buffer);
    AppendOutfieldLocationTextByAngle(spray);
    RevealTextAndWait(str_buffer);

    unsigned int xy = LocationFromDistSprayAngle(distance, spray);
    unsigned char x = (char)(xy >> 8);//x in upper nibble
    unsigned char y = (char)(xy & 255);//y in lower nibble
    unsigned int posDist = GetClosestFielderByLocation(xy);
    unsigned char pos = (char)((posDist >> 8) & BALL_STATE_FIELDER);//position in first 4 bits of upper nibble
    unsigned char dist = (char)(posDist & 255);//distance in lower nibble
    ball_state |= pos;

    unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
    AnnounceFieldingText(pos, dist, hang_time);
}

void AppendOutfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
//   ld a, b
//   cp a, 45
//   jr c, .outfieldLocation
//   cp a, -46
//   jr nc, .outfieldLocation
//   ld hl, InFoulTerritoryText
//   jr .append
// .outfieldLocation
//   add a, 46
//   ld h, 0
//   ld l, a
//   ld c, 15
//   call math_Divide
//   ld b, h
//   ld c, l
//   ld hl, OutfieldLocationTexts;7 locations
//   call str_FromArray
// .append
//   ld de, str_buffer
//   call str_Append
//   ret
}

void AnnounceHitInAirToInfield(unsigned char distance, signed char spray, signed char launch) {  
//   push bc;spray,launch
//   push af;distance
// .lineDrive
//   cp 200
//   jr c, .grounder
//   ld hl, HitLineDriveText
//   jr .copyString
// .grounder
//   cp 140
//   jr c, .chopper
//   ld hl, HitGroundBallText
//   jr .copyString
// .chopper
//   cp 100
//   jr c, .popUp
//   ld hl, HitChopperText
//   jr .copyString
// .popUp
//   ld hl, HitPopUpText
// .copyString
//   ld de, str_buffer
//   call str_Copy

//   call AppendInfieldLocationTextByAngle
//   ld hl, str_buffer
//   call RevealTextAndWait

//   pop af;distance
//   pop bc;spray,launch
//   call LocationFromDistSprayAngle
//   call GetClosestFielderByLocation
//   jp AnnounceFieldingText
}

void AppendInfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
//   ld a, b
//   cp a, 40
//   jr c, .infieldLocation
//   cp a, -40
//   jr nc, .infieldLocation
//   ld hl, InFoulTerritoryText
//   jr .append
// .infieldLocation
//   add a, 40
//   ld h, 0
//   ld l, a
//   ld c, 10
//   call math_Divide
//   ld b, h
//   ld c, l
//   ld hl, InfieldLocationTexts;9 locations
//   call str_FromArray
// .append
//   ld de, str_buffer
//   call str_Append
//   ret
}

void AnnounceBuntText(char launch, char spray) {
//   ld hl, HitBuntText
//   ld de, tile_buffer
//   call str_Copy

//   ld hl, ToThePositionText
//   ld de, tile_buffer
//   call str_Append

//   ld hl, PositionTexts
//   ld bc, 1
//   call str_FromArray

//   ld hl, PositionTexts
//   add hl, bc
//   ld b, h
//   ld c, l

//   ld hl, tile_buffer
//   ld de, str_buffer
//   call str_Replace

//   ld hl, str_buffer
//   call RevealTextAndWait
//   ret
}

void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
//   push bc;dist, hang time
//   call GetPositionPlayerAndName;player in hl, name in name_buffer
//   call GetPlayerSpeed
//   ld d, h
//   ld e, l
//   pop bc;dist, hang time
//   ld a, c;hang time
//   call math_Multiply;dist covered = player speed * hang time, doesn't affect bc
//   ld [_breakpoint], a
//   ld a, h;discard lower byte of range
//   sub a, b;if player speed * hang time > dist from player, caught
//   jr c, .landed

// .caught 
//   ld hl, CaughtByText
//   ;TODO: DivingCatchByText
//   ld bc, name_buffer
//   ld de, str_buffer
//   call str_Replace

//   ld hl, str_buffer
//   call RevealTextAndWait

//   TRAMPOLINE HideBatter
//   ld hl, OutText
//   call RevealTextAndWait

//   call IncrementOuts
//   cp 3
//   jp nz, AnnounceNextBatter
//   ret

// .landed
//   ld a, [ball_state]
//   or a, BALL_STATE_LANDED
//   ld [ball_state], a
//   and a, BALL_STATE_FAIR
//   jp z, AnnounceFoulBall

//   ld hl, FieldedByText
  
//   ld bc, name_buffer
//   ld de, str_buffer
//   call str_Replace

//   ld hl, str_buffer
//   call RevealTextAndWait
//   jp nz, AnnounceNextBatter
  

//   ; ;errors
//   ; OffTheGloveOfText
//   ; BobbledByText
//   ; BadThrowByText

//   ; ;throw
//   ; ThrowsToText

//   ; ;tag
//   ; PlacesTheTagText

//   ; ;tagging up
//   ; TaggingFromTexts

//   ; ;safe/out
//   ; SafeText
//   ; OutText
//   ; DoublePlayText
//   ; TriplePlayText
//   ret
}

void AnnounceFoulBall(void) {
//   call FoulBall
//   ld hl, HitFoulBallText
//   ;TODO: HitFoulBackText
//   call RevealTextAndWait
//   TRAMPOLINE ShowBatter
//   TRAMPOLINE DrawCountOutsInning
//   ret
}

void AnnounceAdvanceRunners(void) {

}

void AnnounceRunnersOn(void) {
    // RunnersOnBaseTexts
}

// TODO: handle more than one run -> TwoPlayersScoreText, BasesClearedScoreText
void AnnounceRunScored(void) {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
//   ld a, [runners_on_base]
//   ld b, a
//   and a, %00001111
//   ld [runners_on_base], a
//   swap b
//   ld a, b
//   and a, %00001111
//   ret z;no one scored if a == 0
//   dec a
//   ld b, a;batting order index(0-8)
//   call IsUserFielding
//   jr z, .userIsBatting
// .opponentIsBatting
//   ld a, [home_team]
//   and a
//   jr z, .opponentIsHome
// .opponentIsAway
//   ld a, [away_score]
//   inc a
//   ld [away_score], a
//   jr .getOpponentPlayerName
// .opponentIsHome
//   ld a, [home_score]
//   inc a
//   ld [home_score], a
// .getOpponentPlayerName
//   push bc
//   TRAMPOLINE DrawScore
//   pop bc
//   ld a, b
//   call GetOpposingPlayerInLineup
//   call GetPlayerName
//   jr .announceScoringPlayer
// .userIsBatting
//   ld a, [home_team]
//   and a
//   jr nz, .userIsHome
// .userIsAway
//   ld a, [away_score]
//   inc a
//   ld [away_score], a
//   jr .getUserPlayerName
// .userIsHome
//   ld a, [home_score]
//   inc a
//   ld [home_score], a
// .getUserPlayerName
//   push bc
//   TRAMPOLINE DrawScore
//   pop bc
//   ld a, b
//   call GetUserPlayerInLineup
//   call GetUserPlayerName
// .announceScoringPlayer
//   ld hl, name_buffer
//   ld de, str_buffer
//   call str_Copy
//   ld hl, PlayerScoresText
//   ld de, str_buffer
//   call str_Append
//   ld hl, str_buffer
//   call RevealTextAndWait
//   ret
}

void AnnounceEndOfGame(void) {
    // end of game
    RevealTextAndWait(AndThatsTheBallGameText);
}
