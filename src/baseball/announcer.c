//
// src/baseball/announcer.c
//

#include "../constants.h"
#include "../../data/strings/announcer_strings.h"

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
extern void FoulBall(void);
extern unsigned char IsUserFielding(void);
extern unsigned char GetBalls(void);
extern unsigned char GetStrikes(void);
extern unsigned char CheckStrike(void);
extern unsigned char IncrementOuts(void);
extern unsigned char DistanceFromSpeedLaunchAngle(unsigned char speed, signed char launch);
extern unsigned char HangTimeFromSpeedLaunchAngle(unsigned char speed, signed char launch);
extern unsigned char CurrentOrderInLineup(void);
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

// TODO: this should be in src/announcer.h
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
void AnnounceStrike(const char strike_out_text[]);
void AnnounceSwingMiss(void);
void AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch);
void AnnounceHitOnGround(char speed, char spray);
void AnnounceHitInAir(unsigned char speed, signed char spray, signed char launch);
void AnnounceHitInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch);
void AppendOutfieldLocationTextByAngle(signed char spray);
void AnnounceHitInAirToInfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch);
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
    char* inning_text = str_FromArray(frame>>1, InningTexts);
    str_Copy(inning_text, name_buffer);
    const char* top_bottom_text = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
    str_Replace(top_bottom_text, str_buffer, name_buffer);
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

void AnnounceStrike(const char strike_out_text[]) {
    str_Copy(strike_out_text, tile_buffer);
    unsigned char strikes = GetStrikes();
    strikes++;
    if (strikes == 3) {//strikeout
        __asm__("TRAMPOLINE GetCurrentBatterName");
        str_Replace(tile_buffer, str_buffer, name_buffer);
        RevealTextAndWait(str_buffer);
        __asm__("TRAMPOLINE HideBatter");
        unsigned char outs = IncrementOuts();
        if (outs != 3) {
            AnnounceNextBatter();
        }
    }
    else {
        SetStrikes(strikes);
        str_Number(strikes);
        str_Replace(StrikeText, str_buffer, name_buffer);
        __asm__("TRAMPOLINE DrawCountOutsInning");
        RevealTextAndWait(str_buffer);
    }
}

//----------------------------------------------------------------------
// AnnounceNoSwing - called if the player doesn't swing
//
//   "Ball 1."
//
//----------------------------------------------------------------------
void AnnounceNoSwing(void) {
    unsigned char was_strike = CheckStrike();
    if (was_strike) { //strike
        AnnounceStrike(StrikeOutLookingText);
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
    AnnounceStrike(StrikeOutSwingingText);
}

void AnnounceTest(void) {
    // unsigned long num = math_Divide(1000, 10);
    // str_Number(num);
    // RevealTextAndWait(name_buffer);

    str_Copy("", str_buffer);
    for (int i = 170; i < 250; i += 10) {
        AnnounceSwingContact(i, 20, 45);
    }

}


void AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {
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
    //TODO
    AnnounceHitInAir(speed, spray, 0);
}

void AnnounceHitInAir(unsigned char speed, signed char spray, signed char launch) {
    unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
    if (distance < 100) {//infield
        AnnounceHitInAirToInfield(speed, distance, spray, launch);
    }
    else {//outfield
        AnnounceHitInAirToOutfield(speed, distance, spray, launch);
    }
}

void AnnounceHitInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {   
    //TODO: LeapingCatchByText

    if (distance > 200) { //out of play
        if ((ball_state & BALL_STATE_FAIR) != 0) { //home run
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

    const char* hit_text;
    if (distance > 180) {
        hit_text = HitDeepFlyBallText;
    }
    else if (distance > 120) {
        hit_text = HitFlyBallText;
    }
    else if (distance > 100) {
        hit_text = HitShallowFlyBallText;
    }
    else {
        hit_text = HitPopFlyText;
    }
    str_Copy(hit_text, str_buffer);
    AppendOutfieldLocationTextByAngle(spray);
    RevealTextAndWait(str_buffer);

    // unsigned int xy = LocationFromDistSprayAngle(distance, spray);
    // unsigned char x = (char)(xy >> 8);//x in upper nibble
    // unsigned char y = (char)(xy & 255);//y in lower nibble
    // unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
    // unsigned char fielder_position = (char)((position_and_distance_from_ball >> 8) & BALL_STATE_FIELDER);//position in first 4 bits of upper nibble
    // unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball & 255);//distance in lower nibble
    // ball_state |= fielder_position;

    // unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
    // AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
}

void AppendOutfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
    const char* location_text;
    if (spray >= -45 && spray <= 45) { //fair ball
        unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 15);
        location_text = str_FromArray(index, OutfieldLocationTexts);
    }
    else {
        location_text = InFoulTerritoryText;
    }
    str_Append(location_text, str_buffer);
}

void AnnounceHitInAirToInfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {
    const char* hit_text = HitPopUpText;
    if (distance > 200) {
        hit_text = HitLineDriveText;
    }
    else if (distance > 140) {
        hit_text = HitGroundBallText;
    }
    else if (distance > 100) {
        hit_text = HitChopperText;
    }
    str_Copy(hit_text, str_buffer);

    AppendInfieldLocationTextByAngle(spray);
    RevealTextAndWait(str_buffer);

    // unsigned int xy = LocationFromDistSprayAngle(distance, spray);
    // unsigned char x = (char)(xy >> 8);//x in upper nibble
    // unsigned char y = (char)(xy & 255);//y in lower nibble
    // unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
    // unsigned char fielder_position = (char)((position_and_distance_from_ball >> 8) & BALL_STATE_FIELDER);//position in first 4 bits of upper nibble
    // unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball & 255);//distance in lower nibble
    // ball_state |= fielder_position;

    // unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
    // AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
}

void AppendInfieldLocationTextByAngle(signed char spray) {
    const char* location_text;
    if (spray >= -45 && spray <= 45) { //fair ball
        unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 11);
        location_text = str_FromArray(index, InfieldLocationTexts);
    }
    else {
        location_text = InFoulTerritoryText;
    }
    str_Append(location_text, str_buffer);
}

void AnnounceBuntText(char launch, char spray) {
    str_Copy(HitBuntText, tile_buffer);
    str_Append(ToThePositionText, tile_buffer);
    char* position_text = str_FromArray(1, PositionTexts);
    str_Replace(tile_buffer, str_buffer, position_text);
    RevealTextAndWait(str_buffer);
}

void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
    int player = GetPositionPlayerAndName(position);//player in hl, name in name_buffer
    int speed = GetPlayerSpeed(player);
    int dist_covered = math_Multiply(speed, hang_time);//dist covered = player speed * hang time, doesn't affect bc
    if ((char)(dist_covered >> 8) > distance) {//if player speed * hang time > dist from player, caught
        str_Replace(CaughtByText, str_buffer, name_buffer);
        RevealTextAndWait(str_buffer);
        __asm__("TRAMPOLINE HideBatter");
        RevealTextAndWait(OutText);
        unsigned char outs = IncrementOuts();
        if (outs == 3) AnnounceNextBatter();
        return;
    }
    else {// otherwise, landed
        ball_state |= BALL_STATE_LANDED;
        if ((ball_state & BALL_STATE_FAIR) == 0) {
            AnnounceFoulBall();
            return;
        }

        str_Replace(FieldedByText, str_buffer, name_buffer);
        RevealTextAndWait(str_buffer);
        AnnounceNextBatter();
    }
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
}

void AnnounceFoulBall(void) {
    FoulBall();
//   ;TODO: HitFoulBackText
    RevealTextAndWait(HitFoulBallText);
    __asm__("TRAMPOLINE ShowBatter");
    __asm__("TRAMPOLINE DrawCountOutsInning");
}

void AnnounceAdvanceRunners(void) {

}

void AnnounceRunnersOn(void) {
    // RunnersOnBaseTexts
}

// TODO: handle more than one run -> TwoPlayersScoreText, BasesClearedScoreText
void AnnounceRunScored(void) {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
    unsigned char scoring_runner = (char)(runners_on_base >> 12);
    if (scoring_runner == 0) return;

    runners_on_base &= 0b0000111111111111;
    scoring_runner--;
    if (IsUserFielding() == 0) {// user is batting
        if (home_team == 0) away_score++;
        else home_score++;
        unsigned int player = GetUserPlayerInLineup(scoring_runner);
        GetUserPlayerName(player);
    }
    else {// opponentIsBatting
        if (home_team == 0) home_score++;
        else away_score++;

        unsigned int player = GetOpposingPlayerInLineup(scoring_runner);//TODO: make return structs
        GetPlayerName(1);
    }
    __asm__("TRAMPOLINE DrawScore");
    str_Copy(name_buffer, str_buffer);
    str_Append(PlayerScoresText, str_buffer);
    RevealTextAndWait(str_buffer);
}

void AnnounceEndOfGame(void) {
    // end of game
    RevealTextAndWait(AndThatsTheBallGameText);
}
