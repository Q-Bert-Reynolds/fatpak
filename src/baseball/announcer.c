//
// src/baseball/announcer.c
//

#include "announcer.h"

void AnnounceTest() {
    unsigned long num = math_Divide(1000, 10);
    str_Number(num);
    RevealTextAndWait(name_buffer);

    str_Copy("", str_buffer);
    for (int i = 170; i < 250; i += 10) {
        AnnounceSwingContact(i, 20, 45);
    }
}

//----------------------------------------------------------------------
// AnnounceBeginningOfFrame - called at beginning of each frame
//
//   "GINGER steps on the mound."
//   "BUBBI walks up to the plate."
// 
//----------------------------------------------------------------------
void AnnounceBeginningOfFrame() {
    char* inning_text = str_FromArray(frame>>1, InningTexts);
    str_Copy(inning_text, name_buffer);
    const char* top_bottom_text = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
    str_Replace(top_bottom_text, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
    AnnouncePitcher();
    AnnounceBatter();
}

// "GINGER steps on the mound."
void AnnouncePitcher() {
    ShowPitcher();
    GetCurrentPitcherName();
    str_Replace(TakesTheMoundText, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
}

// "BUBBI walks up to the plate."
void AnnounceBatter() {
    DrawCountOutsInning();
    ShowBatter();
    GetCurrentBatterName();
    str_Replace(WalksToThePlateText, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
}

void AnnounceNextBatter() {
    SetBalls(0);
    SetStrikes(0);
    NextBatter();
    AnnounceBatter();
}

// "BUBBI steps into the box."
void AnnounceBatterStepsIntoBox() {
    GetCurrentBatterName();
    str_Replace(BatterStepsIntoTheBoxText, str_buffer, name_buffer);
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
}

// "GINGER sets."
void AnnouncePitcherSets() {
    GetCurrentPitcherName();
    str_Replace(PitcherSetsText, str_buffer, name_buffer);
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
}

// "And the pitch."
void AnnounceAndThePitch() {
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, AndThePitchText);
}

// "A fireball!"
void AnnouncePitchName() {
    GetMoveName(pitch_move_id);//"PITCH_NAME" in name_buffer
    str_Copy(AndThePitchText, str_buffer);//"And the pitch.""
    str_Replace(ThrewAPitchText, tile_buffer, name_buffer);//"\nA PITCH_NAME."
    str_Append(tile_buffer, str_buffer);//"And the pitch.\nA PITCH_NAME."
    DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
}

// "Strike 1."
void AnnounceStrike(const char* strike_out_text) {
    str_Copy(strike_out_text, tile_buffer);
    unsigned char strikes = GetStrikes();
    strikes++;
    if (strikes == 3) {//strikeout
        GetCurrentBatterName();
        str_Replace(tile_buffer, str_buffer, name_buffer);
        RevealTextAndWait(str_buffer);
        HideBatter();
        unsigned char outs = IncrementOuts();
        if (outs < 3) AnnounceNextBatter();
    }
    else {
        SetStrikes(strikes);
        str_Number(strikes);
        str_Replace(StrikeText, str_buffer, name_buffer);
        DrawCountOutsInning();
        RevealTextAndWait(str_buffer);
    }
}

//----------------------------------------------------------------------
// AnnounceNoSwing - called if the player doesn't swing
//
//   "Ball 1."
//
//----------------------------------------------------------------------
void AnnounceNoSwing() {
    unsigned char was_strike = CheckStrike();
    if (was_strike) { //strike
        AnnounceStrike(StrikeOutLookingText);
    }
    else { //ball
        unsigned char balls = GetBalls();
        if (balls < 3) {
            SetBalls(++balls);
            str_Number(balls);
            str_Replace(BallText, str_buffer, name_buffer);
            DrawCountOutsInning();
            RevealTextAndWait(str_buffer);
        }
        else { //walk
            PutBatterOnFirst();
            GetCurrentBatterName();
            str_Replace(WalkText, str_buffer, name_buffer);
            RevealTextAndWait(str_buffer);
            HideBatter();
            AnnounceRunScored();
            AnnounceNextBatter();
        }
    }
}

void AnnounceWildPitchOrPassedBall() {
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
void AnnounceSwingMiss() {
    // TODO: check for wild pitch, passed ball, dropped 3rd strike
    AnnounceStrike(StrikeOutSwingingText);
}

void AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {

    //update ball state
    ball_state = BALL_STATE_IN_PLAY;
    if (launch < 0) ball_state |= BALL_STATE_LANDED;
    if (launch < 90 && launch > -90 && spray >= -45 && spray <= 45) {
        ball_state |= BALL_STATE_FAIR;
    }
    
    //check for foul balls where there's no play 
    if (launch > 100 || launch < -90) {
        if (launch > 120 || launch < -120) {
            AnnounceFoulBall(HitFoulTipText);
            //TODO: random chance it ends up in catcher's glove for strike 3
        }
        else if (launch >= 100) AnnounceFoulBall(HitFoulBackText);
        else AnnounceFoulBall(HitFoulBallText);//hit on the ground
        return;
    }
    
    //find landing spot and closest fielder
    unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
    unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
    unsigned int xy = LocationFromDistSprayAngle(distance, spray);
    unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
    unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
    unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball >> 8);//distance in upper nibble
    ball_state |= fielder_position;

    //hit type from launch angle and distance
    const char* hit_text;
    if (launch > 15)
    {
        if (distance > 180) hit_text = HitDeepFlyBallText;
        else if (distance > 140) hit_text = HitFlyBallText;
        else if (distance > 110) hit_text = HitShallowFlyBallText;
        else if (distance > 80) hit_text = HitPopFlyText;
        else hit_text = HitPopUpText;
    }
    else if (launch > 0) hit_text = HitLineDriveText;
    else if (launch > -45) hit_text = HitGroundBallText;
    else hit_text = HitChopperText;

    //append location text and show it
    str_Copy(hit_text, str_buffer);
    if (distance > 100 && launch > 15) AppendOutfieldLocationTextByAngle(spray);
    else AppendInfieldLocationTextByAngle(spray);
    RevealTextAndWait(str_buffer);

    //out of play
    if (distance > 200 && launch > 0) { 
        if ((ball_state & BALL_STATE_FAIR) == 0) { 
            AnnounceFoulBall(HitFoulBallText);
            return;
        }
        //home run
        unsigned char order = CurrentOrderInLineup();
        unsigned char runs_scored = AdvanceRunners(4, ++order);//current batter is 0 to 8, needs to be 1 to 9
        const char* home_run_text = (runs_scored == 4) ? HitGrandSlamText : HitHomeRunText;
        RevealTextAndWait(home_run_text);
        DrawScore();
        DrawBases();
        AnnounceNextBatter();
        return;
    }

    AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
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

//player name in name_buffer
void AnnounceCaughtBy() {
    str_Replace(CaughtByText, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
    RevealTextAndWait(OutText);
    unsigned char outs = IncrementOuts();
    if (outs < 3) AnnounceNextBatter();
}

//----------------------------------------------------------------------
// AnnounceFieldingText - called after announcing where the ball was hit
//
//   "Fielded by DUCK."
//   "Throws to second."
//   "Stoop makes the catch."
//   "Out at second."
//   "Throws to first."
//   "Double play!"
//
//----------------------------------------------------------------------
void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
    PlayerData* player = GetPositionPlayerAndName(position);//player in hl, name in name_buffer
    int speed = GetPlayerSpeed(player);
    int dist_covered = math_Multiply(speed, hang_time);//dist covered = player speed * hang time, doesn't affect bc
    if (hang_time > 0 && (char)(dist_covered >> 8) > distance) {//if player speed * hang time > dist from player, caught
        AnnounceCaughtBy();
        return;
    }
    
    // otherwise, landed
    ball_state |= BALL_STATE_LANDED;
    if ((ball_state & BALL_STATE_FAIR) == 0) {
        AnnounceFoulBall(HitFoulBallText);
        return;//early exit
    }

    str_Replace(FieldedByText, str_buffer, name_buffer);
    RevealTextAndWait(str_buffer);
    
    if (position > 6) AnnounceHit(1); //hit the ground in the outfield
    else AnnounceForcePlay(); //hit the ground in the infield
}

void AnnounceHit(char bases) {
    //TODO: handle doubles, triples... move logic to AnnounceAdvanceRunners
    RevealTextAndWait(HitBaseHitText);
    unsigned char order = CurrentOrderInLineup() + 1;
    unsigned char runs_scored = AdvanceRunners(bases, order);
    DrawBases();
    if (runs_scored > 0) AnnounceRunScored();
    AnnounceNextBatter();
}

void AnnounceForcePlay() {
    unsigned char outs = GetOuts();
    if ((runners_on_base & 0x000F) != 0 && outs < 2) {//double play
        // Throw to second
        char* second_base = str_FromArray(1, BaseTexts);
        str_Replace(ThrowsToText, str_buffer, second_base);
        RevealTextAndWait(str_buffer);
        RevealTextAndWait(OutText);
        outs = IncrementOuts();
        runners_on_base &= 0xFFF0; //first base runner out
        
        // Throw to first
        char* first_base = str_FromArray(0, BaseTexts);
        str_Replace(ThrowsToText, str_buffer, first_base);
        RevealTextAndWait(str_buffer);
        RevealTextAndWait(DoublePlayText);
        outs = IncrementOuts();
    } 
    else {//ground out
        char* first_base = str_FromArray(0, BaseTexts);
        str_Replace(ThrowsToText, str_buffer, first_base);
        RevealTextAndWait(str_buffer);
        RevealTextAndWait(OutText);
        outs = IncrementOuts();
    }

    if (outs < 3) {
        unsigned char runs = AdvanceRunners(1, 0); 
        if (runs > 0) AnnounceRunScored();
        DrawBases();
        AnnounceNextBatter();
    }
}

void AnnounceFoulBall(const char* foul_ball_text) {
    FoulBall();
    RevealTextAndWait(foul_ball_text);
    ShowBatter();
    DrawCountOutsInning();
}

void AnnounceAdvanceRunners() {

}

void AnnounceRunnersOn() {
    unsigned char index = 0;
    
    // Check each base's nibble based on the ASM masks
    if (runners_on_base & 0x000F) index |= 1; // First base
    if (runners_on_base & 0x00F0) index |= 2; // Second base
    if (runners_on_base & 0x0F00) index |= 4; // Third base
    
    char* runners_text = str_FromArray(index, RunnersOnBaseTexts);
    RevealTextAndWait(runners_text);
}

// TODO: handle more than one run -> TwoPlayersScoreText, BasesClearedScoreText
void AnnounceRunScored() {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
    unsigned char scoring_runner = (char)(runners_on_base >> 12);
    if (scoring_runner == 0) return;

    runners_on_base &= 0x0FFF;
    scoring_runner--;
    if (IsUserFielding() == 0) {// user is batting
        PlayerData* player = GetUserPlayerInLineup(scoring_runner);
        GetUserPlayerName(player);
    }
    else {// opponentIsBatting
        PlayerData* player = GetOpposingPlayerInLineup(scoring_runner);
        GetPlayerName(player->number);
    }
    DrawScore();
    str_Copy(name_buffer, str_buffer);
    str_Append(PlayerScoresText, str_buffer);
    RevealTextAndWait(str_buffer);
}

void AnnounceEndOfGame() {
    // end of game
    RevealTextAndWait(AndThatsTheBallGameText);
}
