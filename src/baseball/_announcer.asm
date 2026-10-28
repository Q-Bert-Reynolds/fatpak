;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE announcer
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _GetPlayerName
	EXPORT _GetOpposingPlayerInLineup
	EXPORT _GetUserPlayerInLineup
	EXPORT _GetPlayerSpeed
	EXPORT _GetUserPlayerName
	EXPORT _GetMoveName
	EXPORT _GetPositionPlayerAndName
	EXPORT _GetClosestFielderByAngle
	EXPORT _GetClosestFielderByLocation
	EXPORT _LocationFromDistSprayAngle
	EXPORT _AdvanceRunners
	EXPORT _CurrentOrderInLineup
	EXPORT _HangTimeFromSpeedLaunchAngle
	EXPORT _DistanceFromSpeedLaunchAngle
	EXPORT _IncrementOuts
	EXPORT _CheckStrike
	EXPORT _GetOuts
	EXPORT _GetStrikes
	EXPORT _GetBalls
	EXPORT _IsUserFielding
	EXPORT _PutBatterOnFirst
	EXPORT _ShowPitcher
	EXPORT _HideBatter
	EXPORT _ShowBatter
	EXPORT _NextBatter
	EXPORT _GetCurrentPitcherName
	EXPORT _GetCurrentBatterName
	EXPORT _FoulBall
	EXPORT _SetStrikes
	EXPORT _SetBalls
	EXPORT _str_Number
	EXPORT _str_Replace
	EXPORT _str_Append
	EXPORT _str_Copy
	EXPORT _str_FromArray
	EXPORT _math_Multiply
	EXPORT _math_Divide
	EXPORT _DisplayText
	EXPORT _RevealTextAndWait
	EXPORT _DrawBases
	EXPORT _DrawScore
	EXPORT _DrawCountOutsInning
	EXPORT _AndThatsTheBallGameText
	EXPORT _TopOfTheText
	EXPORT _BottomOfTheText
	EXPORT _BasesClearedScoreText
	EXPORT _TwoPlayersScoreText
	EXPORT _PlayerScoresText
	EXPORT _CriticalHitText
	EXPORT _HitGrandSlamText
	EXPORT _HitHomeRunText
	EXPORT _HitTripleText
	EXPORT _HitDoubleText
	EXPORT _HitBaseHitText
	EXPORT _InFoulTerritoryText
	EXPORT _HitFoulBallText
	EXPORT _HitFoulBackText
	EXPORT _HitFoulTipText
	EXPORT _TriplePlayText
	EXPORT _DoublePlayText
	EXPORT _OutText
	EXPORT _SafeText
	EXPORT _TaggingFromTexts
	EXPORT _RunnersOnBaseTexts
	EXPORT _BenchesClearText
	EXPORT _HitByPitchText
	EXPORT _WildPitchText
	EXPORT _PassedBallText
	EXPORT _WalkText
	EXPORT _BallText
	EXPORT _StrikeOutSwingingText
	EXPORT _StrikeOutLookingText
	EXPORT _StrikeText
	EXPORT _DeadBallText
	EXPORT _PlacesTheTagText
	EXPORT _ThrowsToText
	EXPORT _BadThrowByText
	EXPORT _BobbledByText
	EXPORT _OffTheGloveOfText
	EXPORT _FieldedByText
	EXPORT _DivingCatchByText
	EXPORT _LeapingCatchByText
	EXPORT _CaughtByText
	EXPORT _ToThePositionText
	EXPORT _InfieldLocationTexts
	EXPORT _HitBuntText
	EXPORT _HitPopUpText
	EXPORT _HitChopperText
	EXPORT _HitGroundBallText
	EXPORT _HitSoftLinerText
	EXPORT _HitLineDriveText
	EXPORT _OutfieldLocationTexts
	EXPORT _HitPopFlyText
	EXPORT _HitShallowFlyBallText
	EXPORT _HitFlyBallText
	EXPORT _HitDeepFlyBallText
	EXPORT _HitBarrelText
	EXPORT _SwingAndMissText
	EXPORT _LateSwingText
	EXPORT _EarlySwingText
	EXPORT _ThrewAPitchText
	EXPORT _AndThePitchText
	EXPORT _PitcherSetsText
	EXPORT _BatterStepsIntoTheBoxText
	EXPORT _WalksToThePlateText
	EXPORT _TakesTheMoundText
	EXPORT _BaseTexts
	EXPORT _InningTexts
	EXPORT _PositionTexts
	EXPORT _AnnounceTest
	EXPORT _AnnounceBeginningOfFrame
	EXPORT _AnnouncePitcher
	EXPORT _AnnounceBatter
	EXPORT _AnnounceNextBatter
	EXPORT _AnnounceBatterStepsIntoBox
	EXPORT _AnnouncePitcherSets
	EXPORT _AnnounceAndThePitch
	EXPORT _AnnouncePitchName
	EXPORT _AnnounceStrike
	EXPORT _AnnounceNoSwing
	EXPORT _AnnounceWildPitchOrPassedBall
	EXPORT _AnnounceSwingMiss
	EXPORT _AnnounceSwingContact
	EXPORT _AppendOutfieldLocationTextByAngle
	EXPORT _AppendInfieldLocationTextByAngle
	EXPORT _AnnounceBuntText
	EXPORT _AnnounceCaughtBy
	EXPORT _AnnounceFieldingText
	EXPORT _AnnounceHit
	EXPORT _AnnounceForcePlay
	EXPORT _AnnounceFoulBall
	EXPORT _AnnounceAdvanceRunners
	EXPORT _AnnounceRunnersOn
	EXPORT _AnnounceRunScored
	EXPORT _AnnounceEndOfGame
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "src/baseball/announcer.c_DATA",WRAMX
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION FRAGMENT "_INITIALIZED",ROM0
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	SECTION FRAGMENT "_DABS (ABS)",ROM0
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION FRAGMENT "_HOME",ROM0
	SECTION FRAGMENT "_GSINIT",ROM0
	SECTION FRAGMENT "_GSFINAL",ROM0
	SECTION FRAGMENT "_GSINIT",ROM0
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION FRAGMENT "src/baseball/announcer.c_HOME",ROM0
	SECTION FRAGMENT "src/baseball/announcer.c_HOME",ROM0
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION FRAGMENT "src/baseball/announcer.c_CODE",ROMX
;src/baseball/announcer.c:7: void AnnounceTest() {
;	---------------------------------
; Function AnnounceTest
; ---------------------------------
_AnnounceTest::
;src/baseball/announcer.c:17: for (signed char ang = -45; ang < 45; ang += 3)
	ld	l, $D3
;	spillPairReg hl
;	spillPairReg hl
.l00103:
	ld	a, l
	xor	a, $80
	sub	a, $AD
	jp	NC, .l00105
;src/baseball/announcer.c:19: unsigned int position_and_distance_from_ball = GetClosestFielderByAngle(ang, 100);
	push	hl
	ld	e, $64
	ld	a, l
	call	_GetClosestFielderByAngle
	pop	hl
	ld	a, c
;src/baseball/announcer.c:20: unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
	and	a, $0F
;src/baseball/announcer.c:22: char* position_text = str_FromArray(fielder_position, PositionTexts);
	ld	bc, _PositionTexts
	ld	e, a
	ld	d, $00
	push	hl
	call	_str_FromArray
	pop	hl
;src/baseball/announcer.c:23: RevealTextAndWait(position_text);
	push	hl
	ld	e, c
	ld	d, b
	call	_RevealTextAndWait
	pop	hl
;src/baseball/announcer.c:17: for (signed char ang = -45; ang < 45; ang += 3)
	inc	l
	inc	l
	inc	l
	jp	.l00103
.l00105:
;src/baseball/announcer.c:25: }
	ret
_PositionTexts:
	DB "pitcher"
	DB $00
	DB "catcher"
	DB $00
	DB "first baseman"
	DB $00
	DB "second baseman"
	DB $00
	DB "third baseman"
	DB $00
	DB "shortstop"
	DB $00
	DB "left fielder"
	DB $00
	DB "center fielder"
	DB $00
	DB "right fielder"
	DB $00
_InningTexts:
	DB "1st"
	DB $00
	DB "2nd"
	DB $00
	DB "3rd"
	DB $00
	DB "4th"
	DB $00
	DB "5th"
	DB $00
	DB "6th"
	DB $00
	DB "7th"
	DB $00
	DB "8th"
	DB $00
	DB "9th"
	DB $00
	DB "10th"
	DB $00
	DB "11th"
	DB $00
	DB "12th"
	DB $00
_BaseTexts:
	DB "first"
	DB $00
	DB "second"
	DB $00
	DB "third"
	DB $00
	DB "home plate"
	DB $00
_TakesTheMoundText:
	DB "%s takes"
	DB $80
	DB "the mound."
	DB $00
_WalksToThePlateText:
	DB "%s walks"
	DB $80
	DB "up to the plate."
	DB $00
_BatterStepsIntoTheBoxText:
	DB "%s steps"
	DB $80
	DB "into the box."
	DB $00
_PitcherSetsText:
	DB "%s sets."
	DB $00
_AndThePitchText:
	DB "And the pitch."
	DB $00
_ThrewAPitchText:
	DB $80
	DB "A %s."
	DB $00
_EarlySwingText:
	DB "Early swing."
	DB $00
_LateSwingText:
	DB "Late swing."
	DB $00
_SwingAndMissText:
	DB "Swing and a miss."
	DB $00
_HitBarrelText:
	DB "Really got the"
	DB $80
	DB "barrel on that one."
	DB $00
_HitDeepFlyBallText:
	DB "Deep fly ball "
	DB $00
_HitFlyBallText:
	DB "Fly ball "
	DB $00
_HitShallowFlyBallText:
	DB "Shallow fly "
	DB $00
_HitPopFlyText:
	DB "Pop fly "
	DB $00
_OutfieldLocationTexts:
	DB "down"
	DB $80
	DB "the <LF> line."
	DB $00
	DB "to"
	DB $80
	DB "left field."
	DB $00
	DB "to"
	DB $80
	DB "left center."
	DB $00
	DB "to"
	DB $80
	DB "center field."
	DB $00
	DB "to"
	DB $80
	DB "right center."
	DB $00
	DB "to"
	DB $80
	DB "right field."
	DB $00
	DB "down"
	DB $80
	DB "the <RF> line."
	DB $00
_HitLineDriveText:
	DB "Line drive "
	DB $00
_HitSoftLinerText:
	DB "Soft liner"
	DB $00
_HitGroundBallText:
	DB "Ground ball "
	DB $00
_HitChopperText:
	DB "A chopper "
	DB $00
_HitPopUpText:
	DB "Popped up "
	DB $00
_HitBuntText:
	DB "Bunted "
	DB $00
_InfieldLocationTexts:
	DB "down"
	DB $80
	DB "the <3B> line"
	DB $00
	DB $80
	DB "to third."
	DB $00
	DB $80
	DB "in the <SS>-<3B> hole."
	DB $00
	DB $80
	DB "to short."
	DB $00
	DB $80
	DB "up the middle."
	DB $00
	DB $80
	DB "to second."
	DB $00
	DB $80
	DB "in the <1B>-<2B> hole."
	DB $00
	DB $80
	DB "to first."
	DB $00
	DB "down"
	DB $80
	DB "the <1B> line"
	DB $00
_ToThePositionText:
	DB "to the"
	DB $80
	DB "%s."
	DB $00
_CaughtByText:
	DB "%s makes"
	DB $80
	DB "the catch."
	DB $00
_LeapingCatchByText:
	DB "%s leaps"
	DB $80
	DB " and snags it."
	DB $00
_DivingCatchByText:
	DB "%s with"
	DB $80
	DB "the diving grab."
	DB $00
_FieldedByText:
	DB "Fielded by"
	DB $80
	DB "%s."
	DB $00
_OffTheGloveOfText:
	DB "Off the glove of"
	DB $80
	DB "%s."
	DB $00
_BobbledByText:
	DB "Bobbled by"
	DB $80
	DB "%s."
	DB $00
_BadThrowByText:
	DB "A bad throw"
	DB $80
	DB "from %s."
	DB $00
_ThrowsToText:
	DB "Throws to %s."
	DB $00
_PlacesTheTagText:
	DB "%s"
	DB $80
	DB "places the tag."
	DB $00
_DeadBallText:
	DB "Dead ball!"
	DB $00
_StrikeText:
	DB "Strike %s!"
	DB $00
_StrikeOutLookingText:
	DB "%s strikes"
	DB $80
	DB "out looking!"
	DB $00
_StrikeOutSwingingText:
	DB "%s strikes"
	DB $80
	DB "out swinging!"
	DB $00
_BallText:
	DB "Ball %s."
	DB $00
_WalkText:
	DB "%s on base"
	DB $80
	DB "with a walk."
	DB $00
_PassedBallText:
	DB "Passed ball!"
	DB $00
_WildPitchText:
	DB "Wild pitch!"
	DB $00
_HitByPitchText:
	DB "That hit 'em, so"
	DB $80
	DB "%s is on <1B>."
	DB $00
_BenchesClearText:
	DB "And the benches"
	DB $80
	DB "clear."
	DB $00
_RunnersOnBaseTexts:
	DB "Nobody on base."
	DB $00
	DB "Runner on first."
	DB $00
	DB "Runner on second."
	DB $00
	DB "Runners on first"
	DB $80
	DB "and second."
	DB $00
	DB "Runner on third."
	DB $00
	DB "Runners on first"
	DB $80
	DB "and third."
	DB $00
	DB "Runners on second"
	DB $80
	DB "and third."
	DB $00
	DB "Bases loaded."
	DB $00
_TaggingFromTexts:
	DB "%s tags from"
	DB $80
	DB "first."
	DB $00
	DB "%s will"
	DB $80
	DB "tag from second."
	DB $00
	DB "Tagging from third"
	DB $80
	DB "is %s."
	DB $00
_SafeText:
	DB "Safe!"
	DB $00
_OutText:
	DB "Out!"
	DB $00
_DoublePlayText:
	DB "Double Play!"
	DB $00
_TriplePlayText:
	DB "Triple Play!"
	DB $00
_HitFoulTipText:
	DB "Foul tip."
	DB $00
_HitFoulBackText:
	DB "Foulled back."
	DB $00
_HitFoulBallText:
	DB "Foul Ball!"
	DB $00
_InFoulTerritoryText:
	DB "in"
	DB $80
	DB "foul territory."
	DB $00
_HitBaseHitText:
	DB "Base hit!"
	DB $00
_HitDoubleText:
	DB "Double!"
	DB $00
_HitTripleText:
	DB "Triple!"
	DB $00
_HitHomeRunText:
	DB "HOME RUN!"
	DB $00
_HitGrandSlamText:
	DB "GRAND SLAM!"
	DB $00
_CriticalHitText:
	DB "Critical hit!"
	DB $00
_PlayerScoresText:
	DB " scores."
	DB $00
_TwoPlayersScoreText:
	DB " and"
	DB $80
	DB "%s score."
	DB $00
_BasesClearedScoreText:
	DB "And that clears"
	DB $80
	DB "the bases."
	DB $00
_BottomOfTheText:
	DB "Bottom of"
	DB $80
	DB "the %s."
	DB $00
_TopOfTheText:
	DB "Top of"
	DB $80
	DB "the %s."
	DB $00
_AndThatsTheBallGameText:
	DB "And that's the"
	DB $80
	DB "ball game."
	DB $00
;src/baseball/announcer.c:34: void AnnounceBeginningOfFrame() {
;	---------------------------------
; Function AnnounceBeginningOfFrame
; ---------------------------------
_AnnounceBeginningOfFrame::
;src/baseball/announcer.c:35: char* inning_text = str_FromArray(frame>>1, InningTexts);
	ld	bc, _InningTexts+0
	ld	hl, _frame
	ld	e, [hl]
	srl	e
	ld	d, $00
	call	_str_FromArray
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:36: str_Copy(inning_text, name_buffer);
	ld	bc, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:37: const char* top_bottom_text = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
	push	hl
	ld	hl, _frame
	bit	0, [hl]
	pop	hl
	jp	NZ,.l00110
	jp	.l00111
.l00110:
	jp	.l00103
.l00111:
	ld	de, _TopOfTheText+0
	jp	.l00104
.l00103:
	ld	de, _BottomOfTheText+0
.l00104:
;src/baseball/announcer.c:38: str_Replace(top_bottom_text, str_buffer, name_buffer);
	ld	bc, _name_buffer
	push	bc
	ld	bc, _str_buffer
	call	_str_Replace
;src/baseball/announcer.c:39: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:40: AnnouncePitcher();
	call	_AnnouncePitcher
;src/baseball/announcer.c:41: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:42: }
	ret
;src/baseball/announcer.c:45: void AnnouncePitcher() {
;	---------------------------------
; Function AnnouncePitcher
; ---------------------------------
_AnnouncePitcher::
;src/baseball/announcer.c:46: ShowPitcher();
	call	_ShowPitcher
;src/baseball/announcer.c:47: GetCurrentPitcherName();
	call	_GetCurrentPitcherName
;src/baseball/announcer.c:48: str_Replace(TakesTheMoundText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _TakesTheMoundText
	call	_str_Replace
;src/baseball/announcer.c:49: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:50: }
	ret
;src/baseball/announcer.c:53: void AnnounceBatter() {
;	---------------------------------
; Function AnnounceBatter
; ---------------------------------
_AnnounceBatter::
;src/baseball/announcer.c:54: DrawCountOutsInning();
	call	_DrawCountOutsInning
;src/baseball/announcer.c:55: ShowBatter();
	call	_ShowBatter
;src/baseball/announcer.c:56: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:57: str_Replace(WalksToThePlateText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalksToThePlateText
	call	_str_Replace
;src/baseball/announcer.c:58: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:59: }
	ret
;src/baseball/announcer.c:61: void AnnounceNextBatter() {
;	---------------------------------
; Function AnnounceNextBatter
; ---------------------------------
_AnnounceNextBatter::
;src/baseball/announcer.c:62: SetBalls(0);
	xor	a, a
	call	_SetBalls
;src/baseball/announcer.c:63: SetStrikes(0);
	xor	a, a
	call	_SetStrikes
;src/baseball/announcer.c:64: NextBatter();
	call	_NextBatter
;src/baseball/announcer.c:65: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:66: }
	ret
;src/baseball/announcer.c:69: void AnnounceBatterStepsIntoBox() {
;	---------------------------------
; Function AnnounceBatterStepsIntoBox
; ---------------------------------
_AnnounceBatterStepsIntoBox::
;src/baseball/announcer.c:70: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:71: str_Replace(BatterStepsIntoTheBoxText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BatterStepsIntoTheBoxText
	call	_str_Replace
;src/baseball/announcer.c:72: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:73: }
	ret
;src/baseball/announcer.c:76: void AnnouncePitcherSets() {
;	---------------------------------
; Function AnnouncePitcherSets
; ---------------------------------
_AnnouncePitcherSets::
;src/baseball/announcer.c:77: GetCurrentPitcherName();
	call	_GetCurrentPitcherName
;src/baseball/announcer.c:78: str_Replace(PitcherSetsText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _PitcherSetsText
	call	_str_Replace
;src/baseball/announcer.c:79: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:80: }
	ret
;src/baseball/announcer.c:83: void AnnounceAndThePitch() {
;	---------------------------------
; Function AnnounceAndThePitch
; ---------------------------------
_AnnounceAndThePitch::
;src/baseball/announcer.c:84: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, AndThePitchText);
	ld	de, _AndThePitchText
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:85: }
	ret
;src/baseball/announcer.c:88: void AnnouncePitchName() {
;	---------------------------------
; Function AnnouncePitchName
; ---------------------------------
_AnnouncePitchName::
;src/baseball/announcer.c:89: GetMoveName(pitch_move_id);//"PITCH_NAME" in name_buffer
	ld	hl, _pitch_move_id
	ld	a, [hl]
	call	_GetMoveName
;src/baseball/announcer.c:90: str_Copy(AndThePitchText, str_buffer);//"And the pitch.""
	ld	bc, _str_buffer
	ld	de, _AndThePitchText
	call	_str_Copy
;src/baseball/announcer.c:91: str_Replace(ThrewAPitchText, tile_buffer, name_buffer);//"\nA PITCH_NAME."
	ld	de, _name_buffer
	push	de
	ld	bc, _tile_buffer
	ld	de, _ThrewAPitchText
	call	_str_Replace
;src/baseball/announcer.c:92: str_Append(tile_buffer, str_buffer);//"And the pitch.\nA PITCH_NAME."
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Append
;src/baseball/announcer.c:93: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:94: }
	ret
;src/baseball/announcer.c:97: void AnnounceStrike(const char* strike_out_text) {
;	---------------------------------
; Function AnnounceStrike
; ---------------------------------
_AnnounceStrike::
	dec	sp
;src/baseball/announcer.c:98: str_Copy(strike_out_text, tile_buffer);
	ld	bc, _tile_buffer
	call	_str_Copy
;src/baseball/announcer.c:99: unsigned char strikes = GetStrikes();
	call	_GetStrikes
;src/baseball/announcer.c:100: strikes++;
	inc	a
	ld	hl, sp+0
	ld	[hl], a
;src/baseball/announcer.c:101: if (strikes == 3) {//strikeout
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00118
	jp	.l00119
.l00118:
	jp	.l00104
.l00119:
;src/baseball/announcer.c:102: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:103: str_Replace(tile_buffer, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Replace
;src/baseball/announcer.c:104: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:105: HideBatter();
	call	_HideBatter
;src/baseball/announcer.c:106: unsigned char outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:107: if (outs < 3) AnnounceNextBatter();
	sub	a, $03
	jp	NC, .l00106
	inc	sp
	jp	_AnnounceNextBatter
	jp	.l00106
.l00104:
;src/baseball/announcer.c:110: SetStrikes(strikes);
	ld	hl, sp+0
	ld	a, [hl]
	call	_SetStrikes
;src/baseball/announcer.c:111: str_Number(strikes);
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:112: str_Replace(StrikeText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeText
	call	_str_Replace
;src/baseball/announcer.c:113: DrawCountOutsInning();
	call	_DrawCountOutsInning
;src/baseball/announcer.c:114: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	inc	sp
	jp	_RevealTextAndWait
.l00106:
;src/baseball/announcer.c:116: }
	inc	sp
	ret
;src/baseball/announcer.c:124: void AnnounceNoSwing() {
;	---------------------------------
; Function AnnounceNoSwing
; ---------------------------------
_AnnounceNoSwing::
;src/baseball/announcer.c:125: unsigned char was_strike = CheckStrike();
	call	_CheckStrike
;src/baseball/announcer.c:126: if (was_strike) { //strike
	or	a, a
	jp	Z, .l00105
;src/baseball/announcer.c:127: AnnounceStrike(StrikeOutLookingText);
	ld	de, _StrikeOutLookingText
	jp	_AnnounceStrike
	jp	.l00107
.l00105:
;src/baseball/announcer.c:130: unsigned char balls = GetBalls();
	call	_GetBalls
;src/baseball/announcer.c:131: if (balls < 3) {
	cp	a, $03
	jp	NC, .l00102
;src/baseball/announcer.c:132: SetBalls(++balls);
	ld	c, a
	inc	c
	push	bc
	ld	a, c
	call	_SetBalls
	pop	bc
;src/baseball/announcer.c:133: str_Number(balls);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:134: str_Replace(BallText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BallText
	call	_str_Replace
;src/baseball/announcer.c:135: DrawCountOutsInning();
	call	_DrawCountOutsInning
;src/baseball/announcer.c:136: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
	jp	.l00107
.l00102:
;src/baseball/announcer.c:139: PutBatterOnFirst();
	call	_PutBatterOnFirst
;src/baseball/announcer.c:140: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:141: str_Replace(WalkText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalkText
	call	_str_Replace
;src/baseball/announcer.c:142: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:143: HideBatter();
	call	_HideBatter
;src/baseball/announcer.c:144: AnnounceRunScored();
	call	_AnnounceRunScored
;src/baseball/announcer.c:145: AnnounceNextBatter();
	jp	_AnnounceNextBatter
.l00107:
;src/baseball/announcer.c:148: }
	ret
;src/baseball/announcer.c:150: void AnnounceWildPitchOrPassedBall() {
;	---------------------------------
; Function AnnounceWildPitchOrPassedBall
; ---------------------------------
_AnnounceWildPitchOrPassedBall::
;src/baseball/announcer.c:153: }
.l00101:
	ret
;src/baseball/announcer.c:162: void AnnounceSwingMiss() {
;	---------------------------------
; Function AnnounceSwingMiss
; ---------------------------------
_AnnounceSwingMiss::
;src/baseball/announcer.c:164: AnnounceStrike(StrikeOutSwingingText);
	ld	de, _StrikeOutSwingingText
	jp	_AnnounceStrike
.l00101:
;src/baseball/announcer.c:165: }
	ret
;src/baseball/announcer.c:167: void AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceSwingContact
; ---------------------------------
_AnnounceSwingContact::
	add	sp, -8
	ld	hl, sp+7
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:170: ball_state = BALL_STATE_IN_PLAY;
	ld	hl, _ball_state
	ld	[hl], $10
;src/baseball/announcer.c:171: if (launch < 0) ball_state |= BALL_STATE_LANDED;
	ld	hl, sp+10
	ld	a, [hl]
	bit	7, a
	jp	Z, .l00102
	ld	hl, _ball_state
	ld	[hl], $50
.l00102:
;src/baseball/announcer.c:172: if (launch < 90 && launch > -90 && spray >= -45 && spray <= 45) {
	ld	hl, sp+10
	ld	a, [hl]
	xor	a, $80
	sub	a, $DA
	jp	NC, .l00104
	ld	a, [hl]
	ld	e, a
	ld	a, $A6
	ld	d, a
	ld	a, $A6
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00257
	bit	7, d
	jp	NZ, .l00258
	cp	a, a
	jp	.l00258
.l00257:
	bit	7, d
	jp	Z, .l00258
	scf
.l00258:
	jp	NC, .l00104
	ld	hl, sp+6
	ld	a, [hl]
	xor	a, $80
	sub	a, $53
	jp	C, .l00104
	ld	a, [hl]
	ld	e, a
	ld	a, $2D
	ld	d, a
	ld	a, $2D
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00259
	bit	7, d
	jp	NZ, .l00260
	cp	a, a
	jp	.l00260
.l00259:
	bit	7, d
	jp	Z, .l00260
	scf
.l00260:
	jp	C, .l00104
;src/baseball/announcer.c:173: ball_state |= BALL_STATE_FAIR;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $20
	ld	[hl], a
.l00104:
;src/baseball/announcer.c:177: if (launch > 100 || launch < -90) {
	ld	hl, sp+10
	ld	a, [hl]
	ld	e, a
	ld	a, $64
	ld	d, a
	ld	a, $64
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00261
	bit	7, d
	jp	NZ, .l00262
	cp	a, a
	jp	.l00262
.l00261:
	bit	7, d
	jp	Z, .l00262
	scf
.l00262:
	jp	C, .l00115
	ld	hl, sp+10
	ld	a, [hl]
	xor	a, $80
	sub	a, $26
	jp	NC, .l00116
.l00115:
;src/baseball/announcer.c:178: if (launch > 120 || launch < -120) {
	ld	hl, sp+10
	ld	a, [hl]
	ld	e, a
	ld	a, $78
	ld	d, a
	ld	a, $78
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00263
	bit	7, d
	jp	NZ, .l00264
	cp	a, a
	jp	.l00264
.l00263:
	bit	7, d
	jp	Z, .l00264
	scf
.l00264:
	jp	C, .l00111
	ld	hl, sp+10
	ld	a, [hl]
	xor	a, $80
	sub	a, $08
	jp	NC, .l00112
.l00111:
;src/baseball/announcer.c:179: AnnounceFoulBall(HitFoulTipText);
	ld	de, _HitFoulTipText
	call	_AnnounceFoulBall
	jp	.l00113
.l00112:
;src/baseball/announcer.c:182: else if (launch >= 100) AnnounceFoulBall(HitFoulBackText);
	ld	hl, sp+10
	ld	a, [hl]
	xor	a, $80
	sub	a, $E4
	jp	C, .l00109
	ld	de, _HitFoulBackText
	call	_AnnounceFoulBall
	jp	.l00113
.l00109:
;src/baseball/announcer.c:183: else AnnounceFoulBall(HitFoulBallText);//hit on the ground
	ld	de, _HitFoulBallText
	call	_AnnounceFoulBall
.l00113:
;src/baseball/announcer.c:184: return;
	jp	.l00148
.l00116:
;src/baseball/announcer.c:188: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
	ld	hl, sp+10
	ld	e, [hl]
	ld	hl, sp+7
	ld	a, [hl]
	call	_HangTimeFromSpeedLaunchAngle
	ld	hl, sp+0
	ld	[hl], a
;src/baseball/announcer.c:189: unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
	ld	hl, sp+10
	ld	e, [hl]
	ld	hl, sp+7
	ld	a, [hl]
	call	_DistanceFromSpeedLaunchAngle
	ld	hl, sp+1
	ld	[hl], a
;src/baseball/announcer.c:190: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+6
	ld	e, [hl]
	ld	hl, sp+1
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:191: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
;src/baseball/announcer.c:192: unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
	ld	a, c
	and	a, $0F
	ld	hl, sp+2
	ld	[hl], a
;src/baseball/announcer.c:193: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball >> 8);//distance in upper nibble
	inc	hl
	ld	[hl], b
;src/baseball/announcer.c:194: ball_state |= fielder_position;
	ld	hl, _ball_state
	ld	a, [hl]
	ld	hl, sp+2
	or	a, [hl]
	ld	hl, _ball_state
	ld	[hl], a
;src/baseball/announcer.c:198: if (launch > 15)
	ld	hl, sp+10
	ld	a, [hl]
	ld	e, a
	ld	a, $0F
	ld	d, a
	ld	a, $0F
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00265
	bit	7, d
	jp	NZ, .l00266
	cp	a, a
	jp	.l00266
.l00265:
	bit	7, d
	jp	Z, .l00266
	scf
.l00266:
	ld	a, $00
	rla
	ld	hl, sp+4
	ld	[hl], a
;src/baseball/announcer.c:206: else if (launch > 0) hit_text = HitLineDriveText;
	ld	hl, sp+10
	ld	a, [hl]
	ld	e, a
	ld	a, $00
	ld	d, a
	xor	a, a
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00267
	bit	7, d
	jp	NZ, .l00268
	cp	a, a
	jp	.l00268
.l00267:
	bit	7, d
	jp	Z, .l00268
	scf
.l00268:
	ld	a, $00
	rla
	ld	hl, sp+5
	ld	[hl], a
;src/baseball/announcer.c:198: if (launch > 15)
	dec	hl
	ld	a, [hl]
	or	a, a
	jp	Z, .l00137
;src/baseball/announcer.c:200: if (distance > 180) hit_text = HitDeepFlyBallText;
	ld	a, $B4
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00128
	ld	de, _HitDeepFlyBallText+0
	jp	.l00138
.l00128:
;src/baseball/announcer.c:201: else if (distance > 140) hit_text = HitFlyBallText;
	ld	a, $8C
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00125
	ld	de, _HitFlyBallText
	jp	.l00138
.l00125:
;src/baseball/announcer.c:202: else if (distance > 110) hit_text = HitShallowFlyBallText;
	ld	a, $6E
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00122
	ld	de, _HitShallowFlyBallText
	jp	.l00138
.l00122:
;src/baseball/announcer.c:203: else if (distance > 80) hit_text = HitPopFlyText;
	ld	a, $50
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00119
	ld	de, _HitPopFlyText
	jp	.l00138
.l00119:
;src/baseball/announcer.c:204: else hit_text = HitPopUpText;
	ld	de, _HitPopUpText
	jp	.l00138
.l00137:
;src/baseball/announcer.c:206: else if (launch > 0) hit_text = HitLineDriveText;
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00134
	ld	de, _HitLineDriveText
	jp	.l00138
.l00134:
;src/baseball/announcer.c:207: else if (launch > -45) hit_text = HitGroundBallText;
	ld	hl, sp+10
	ld	a, [hl]
	ld	e, a
	ld	a, $D3
	ld	d, a
	ld	a, $D3
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00269
	bit	7, d
	jp	NZ, .l00270
	cp	a, a
	jp	.l00270
.l00269:
	bit	7, d
	jp	Z, .l00270
	scf
.l00270:
	jp	NC, .l00131
	ld	de, _HitGroundBallText
	jp	.l00138
.l00131:
;src/baseball/announcer.c:208: else hit_text = HitChopperText;
	ld	de, _HitChopperText
.l00138:
;src/baseball/announcer.c:211: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:212: if (distance > 100 && launch > 15) AppendOutfieldLocationTextByAngle(spray);
	ld	a, $64
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00140
	ld	hl, sp+4
	ld	a, [hl]
	or	a, a
	jp	Z, .l00140
	inc	hl
	inc	hl
	ld	a, [hl]
	call	_AppendOutfieldLocationTextByAngle
	jp	.l00141
.l00140:
;src/baseball/announcer.c:213: else AppendInfieldLocationTextByAngle(spray);
	ld	hl, sp+6
	ld	a, [hl]
	call	_AppendInfieldLocationTextByAngle
.l00141:
;src/baseball/announcer.c:214: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:215: HideBatter();
	call	_HideBatter
;src/baseball/announcer.c:218: if (distance > 200 && launch > 0) { 
	ld	a, $C8
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00146
	ld	hl, sp+5
	ld	a, [hl]
	or	a, a
	jp	Z, .l00146
;src/baseball/announcer.c:219: if ((ball_state & BALL_STATE_FAIR) == 0) { 
	ld	hl, _ball_state
	ld	a, [hl]
	bit	5, a
	jp	NZ,.l00271
	jp	.l00272
.l00271:
	jp	.l00144
.l00272:
;src/baseball/announcer.c:220: AnnounceFoulBall(HitFoulBallText);
	ld	de, _HitFoulBallText
	call	_AnnounceFoulBall
;src/baseball/announcer.c:221: return;
	jp	.l00148
.l00144:
;src/baseball/announcer.c:224: unsigned char order = CurrentOrderInLineup();
	call	_CurrentOrderInLineup
;src/baseball/announcer.c:225: unsigned char runs_scored = AdvanceRunners(4, ++order);//current batter is 0 to 8, needs to be 1 to 9
	ld	e, a
	inc	e
	ld	a, $04
	call	_AdvanceRunners
;src/baseball/announcer.c:226: const char* home_run_text = (runs_scored == 4) ? HitGrandSlamText : HitHomeRunText;
	sub	a, $04
	jp	NZ,.l00273
	jp	.l00274
.l00273:
	jp	.l00150
.l00274:
	ld	de, _HitGrandSlamText+0
	jp	.l00151
.l00150:
	ld	de, _HitHomeRunText+0
.l00151:
;src/baseball/announcer.c:227: RevealTextAndWait(home_run_text);
	call	_RevealTextAndWait
;src/baseball/announcer.c:228: DrawScore();
	call	_DrawScore
;src/baseball/announcer.c:229: DrawBases();
	call	_DrawBases
;src/baseball/announcer.c:230: AnnounceNextBatter();
	call	_AnnounceNextBatter
;src/baseball/announcer.c:231: return;
	jp	.l00148
.l00146:
;src/baseball/announcer.c:234: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
	ld	hl, sp+0
	ld	a, [hl]
	push	af
	inc	sp
	ld	hl, sp+4
	ld	e, [hl]
	dec	hl
	ld	a, [hl]
	call	_AnnounceFieldingText
.l00148:
;src/baseball/announcer.c:235: }
	add	sp, 8
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:237: void AppendOutfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
;	---------------------------------
; Function AppendOutfieldLocationTextByAngle
; ---------------------------------
_AppendOutfieldLocationTextByAngle::
	ld	c, a
;src/baseball/announcer.c:239: if (spray >= -45 && spray <= 45) { //fair ball
	ld	a, c
	xor	a, $80
	sub	a, $53
	jp	C, .l00102
	ld	a, c
	ld	e, a
	ld	a, $2D
	ld	d, a
	ld	a, $2D
	sub	a, c
	bit	7, e
	jp	Z, .l00117
	bit	7, d
	jp	NZ, .l00118
	cp	a, a
	jp	.l00118
.l00117:
	bit	7, d
	jp	Z, .l00118
	scf
.l00118:
	jp	C, .l00102
;src/baseball/announcer.c:240: unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 15);
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, $002D
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, b
	rlca
	sbc	a, a
	ld	e, a
	ld	d, a
	ld	a, $0F
	push	af
	inc	sp
	call	_math_Divide
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:241: location_text = str_FromArray(index, OutfieldLocationTexts);
	ld	bc, _OutfieldLocationTexts
	call	_str_FromArray
	ld	e, c
	ld	d, b
	jp	.l00103
.l00102:
;src/baseball/announcer.c:244: location_text = InFoulTerritoryText;
	ld	de, _InFoulTerritoryText
.l00103:
;src/baseball/announcer.c:246: str_Append(location_text, str_buffer);
	ld	bc, _str_buffer
	jp	_str_Append
.l00105:
;src/baseball/announcer.c:247: }
	ret
;src/baseball/announcer.c:249: void AppendInfieldLocationTextByAngle(signed char spray) {
;	---------------------------------
; Function AppendInfieldLocationTextByAngle
; ---------------------------------
_AppendInfieldLocationTextByAngle::
	ld	c, a
;src/baseball/announcer.c:251: if (spray >= -45 && spray <= 45) { //fair ball
	ld	a, c
	xor	a, $80
	sub	a, $53
	jp	C, .l00102
	ld	a, c
	ld	e, a
	ld	a, $2D
	ld	d, a
	ld	a, $2D
	sub	a, c
	bit	7, e
	jp	Z, .l00117
	bit	7, d
	jp	NZ, .l00118
	cp	a, a
	jp	.l00118
.l00117:
	bit	7, d
	jp	Z, .l00118
	scf
.l00118:
	jp	C, .l00102
;src/baseball/announcer.c:252: unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 11);
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, $002D
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, b
	rlca
	sbc	a, a
	ld	e, a
	ld	d, a
	ld	a, $0B
	push	af
	inc	sp
	call	_math_Divide
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:253: location_text = str_FromArray(index, InfieldLocationTexts);
	ld	bc, _InfieldLocationTexts
	call	_str_FromArray
	ld	e, c
	ld	d, b
	jp	.l00103
.l00102:
;src/baseball/announcer.c:256: location_text = InFoulTerritoryText;
	ld	de, _InFoulTerritoryText
.l00103:
;src/baseball/announcer.c:258: str_Append(location_text, str_buffer);
	ld	bc, _str_buffer
	jp	_str_Append
.l00105:
;src/baseball/announcer.c:259: }
	ret
;src/baseball/announcer.c:261: void AnnounceBuntText(char launch, char spray) {
;	---------------------------------
; Function AnnounceBuntText
; ---------------------------------
_AnnounceBuntText::
;src/baseball/announcer.c:262: str_Copy(HitBuntText, tile_buffer);
	ld	bc, _tile_buffer
	ld	de, _HitBuntText
	call	_str_Copy
;src/baseball/announcer.c:263: str_Append(ToThePositionText, tile_buffer);
	ld	bc, _tile_buffer
	ld	de, _ToThePositionText
	call	_str_Append
;src/baseball/announcer.c:264: char* position_text = str_FromArray(1, PositionTexts);
	ld	bc, _PositionTexts
	ld	de, $0001
	call	_str_FromArray
;src/baseball/announcer.c:265: str_Replace(tile_buffer, str_buffer, position_text);
	push	bc
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Replace
;src/baseball/announcer.c:266: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:267: }
	ret
;src/baseball/announcer.c:270: void AnnounceCaughtBy() {
;	---------------------------------
; Function AnnounceCaughtBy
; ---------------------------------
_AnnounceCaughtBy::
;src/baseball/announcer.c:271: str_Replace(CaughtByText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _CaughtByText
	call	_str_Replace
;src/baseball/announcer.c:272: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:273: RevealTextAndWait(OutText);
	ld	de, _OutText
	call	_RevealTextAndWait
;src/baseball/announcer.c:274: unsigned char outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:275: if (outs < 3) AnnounceNextBatter();
	sub	a, $03
	jp	NC, .l00103
	jp	_AnnounceNextBatter
.l00103:
;src/baseball/announcer.c:276: }
	ret
;src/baseball/announcer.c:289: void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
;	---------------------------------
; Function AnnounceFieldingText
; ---------------------------------
_AnnounceFieldingText::
	ld	d, a
;src/baseball/announcer.c:290: PlayerData* player = GetPositionPlayerAndName(position);//player in hl, name in name_buffer
	push	de
	ld	a, d
	call	_GetPositionPlayerAndName
	pop	de
;src/baseball/announcer.c:291: int speed = GetPlayerSpeed(player);
	push	de
	ld	e, c
	ld	d, b
	call	_GetPlayerSpeed
	pop	de
;src/baseball/announcer.c:292: int dist_covered = math_Multiply(speed, hang_time);//dist covered = player speed * hang time, doesn't affect bc
	push	de
	ld	hl, sp+4
	ld	a, [hl]
	ld	e, c
	ld	d, b
	call	_math_Multiply
	pop	de
;src/baseball/announcer.c:293: if (hang_time > 0 && (char)(dist_covered >> 8) > distance) {//if player speed * hang time > dist from player, caught
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, e
	sub	a, b
	jp	NC, .l00102
;src/baseball/announcer.c:294: AnnounceCaughtBy();
	call	_AnnounceCaughtBy
;src/baseball/announcer.c:295: return;
	jp	.l00109
.l00102:
;src/baseball/announcer.c:299: ball_state |= BALL_STATE_LANDED;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $40
	ld	[hl], a
;src/baseball/announcer.c:300: if ((ball_state & BALL_STATE_FAIR) == 0) {
	ld	a, [hl]
	bit	5, a
	jp	NZ,.l00131
	jp	.l00132
.l00131:
	jp	.l00105
.l00132:
;src/baseball/announcer.c:301: AnnounceFoulBall(HitFoulBallText);
	ld	de, _HitFoulBallText
	call	_AnnounceFoulBall
;src/baseball/announcer.c:302: return;//early exit
	jp	.l00109
.l00105:
;src/baseball/announcer.c:305: str_Replace(FieldedByText, str_buffer, name_buffer);
	push	de
	ld	bc, _name_buffer
	push	bc
	ld	bc, _str_buffer
	ld	de, _FieldedByText
	call	_str_Replace
	pop	de
;src/baseball/announcer.c:306: RevealTextAndWait(str_buffer);
	push	de
	ld	de, _str_buffer
	call	_RevealTextAndWait
	pop	de
;src/baseball/announcer.c:308: if (position > 6) AnnounceHit(1); //hit the ground in the outfield
	ld	a, $06
	sub	a, d
	jp	NC, .l00107
	ld	a, $01
	call	_AnnounceHit
	jp	.l00109
.l00107:
;src/baseball/announcer.c:309: else AnnounceForcePlay(); //hit the ground in the infield
	call	_AnnounceForcePlay
.l00109:
;src/baseball/announcer.c:310: }
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:312: void AnnounceHit(char bases) {
;	---------------------------------
; Function AnnounceHit
; ---------------------------------
_AnnounceHit::
	dec	sp
	ld	hl, sp+0
	ld	[hl], a
;src/baseball/announcer.c:314: RevealTextAndWait(HitBaseHitText);
	ld	de, _HitBaseHitText
	call	_RevealTextAndWait
;src/baseball/announcer.c:315: unsigned char order = CurrentOrderInLineup() + 1;
	call	_CurrentOrderInLineup
	ld	e, a
	inc	e
;src/baseball/announcer.c:316: unsigned char runs_scored = AdvanceRunners(bases, order);
	ld	hl, sp+0
	ld	a, [hl]
	call	_AdvanceRunners
	ld	c, a
;src/baseball/announcer.c:317: DrawBases();
	push	bc
	call	_DrawBases
	pop	bc
;src/baseball/announcer.c:318: if (runs_scored > 0) AnnounceRunScored();
	ld	a, c
	or	a, a
	jp	Z, .l00102
	call	_AnnounceRunScored
.l00102:
;src/baseball/announcer.c:319: AnnounceNextBatter();
	inc	sp
	jp	_AnnounceNextBatter
.l00103:
;src/baseball/announcer.c:320: }
	inc	sp
	ret
;src/baseball/announcer.c:322: void AnnounceForcePlay() {
;	---------------------------------
; Function AnnounceForcePlay
; ---------------------------------
_AnnounceForcePlay::
;src/baseball/announcer.c:323: unsigned char outs = GetOuts();
	call	_GetOuts
	ld	c, a
;src/baseball/announcer.c:324: if ((runners_on_base & 0x000F) != 0 && outs < 2) {//double play
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $0F
	jp	NZ,.l00131
	jp	.l00102
.l00131:
	ld	a, c
	sub	a, $02
	jp	NC, .l00102
;src/baseball/announcer.c:326: char* second_base = str_FromArray(1, BaseTexts);
	ld	bc, _BaseTexts
	ld	de, $0001
	call	_str_FromArray
;src/baseball/announcer.c:327: str_Replace(ThrowsToText, str_buffer, second_base);
	push	bc
	ld	bc, _str_buffer
	ld	de, _ThrowsToText
	call	_str_Replace
;src/baseball/announcer.c:328: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:329: RevealTextAndWait(OutText);
	ld	de, _OutText
	call	_RevealTextAndWait
;src/baseball/announcer.c:330: outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:331: runners_on_base &= 0xFFF0; //first base runner out
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $F0
	ld	[hl], a
;src/baseball/announcer.c:334: char* first_base = str_FromArray(0, BaseTexts);
	ld	bc, _BaseTexts
	ld	de, $0000
	call	_str_FromArray
;src/baseball/announcer.c:335: str_Replace(ThrowsToText, str_buffer, first_base);
	push	bc
	ld	bc, _str_buffer
	ld	de, _ThrowsToText
	call	_str_Replace
;src/baseball/announcer.c:336: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:337: RevealTextAndWait(DoublePlayText);
	ld	de, _DoublePlayText
	call	_RevealTextAndWait
;src/baseball/announcer.c:338: outs = IncrementOuts();
	call	_IncrementOuts
	jp	.l00103
.l00102:
;src/baseball/announcer.c:341: char* first_base = str_FromArray(0, BaseTexts);
	ld	bc, _BaseTexts
	ld	de, $0000
	call	_str_FromArray
;src/baseball/announcer.c:342: str_Replace(ThrowsToText, str_buffer, first_base);
	push	bc
	ld	bc, _str_buffer
	ld	de, _ThrowsToText
	call	_str_Replace
;src/baseball/announcer.c:343: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:344: RevealTextAndWait(OutText);
	ld	de, _OutText
	call	_RevealTextAndWait
;src/baseball/announcer.c:345: outs = IncrementOuts();
	call	_IncrementOuts
.l00103:
;src/baseball/announcer.c:348: if (outs < 3) {
	sub	a, $03
	jp	NC, .l00109
;src/baseball/announcer.c:349: unsigned char runs = AdvanceRunners(1, 0); 
	ld	e, $00
	ld	a, $01
	call	_AdvanceRunners
;src/baseball/announcer.c:350: if (runs > 0) AnnounceRunScored();
	or	a, a
	jp	Z, .l00106
	call	_AnnounceRunScored
.l00106:
;src/baseball/announcer.c:351: DrawBases();
	call	_DrawBases
;src/baseball/announcer.c:352: AnnounceNextBatter();
	jp	_AnnounceNextBatter
.l00109:
;src/baseball/announcer.c:354: }
	ret
;src/baseball/announcer.c:356: void AnnounceFoulBall(const char* foul_ball_text) {
;	---------------------------------
; Function AnnounceFoulBall
; ---------------------------------
_AnnounceFoulBall::
;src/baseball/announcer.c:357: FoulBall();
	push	de
	call	_FoulBall
	pop	de
;src/baseball/announcer.c:358: RevealTextAndWait(foul_ball_text);
	call	_RevealTextAndWait
;src/baseball/announcer.c:359: ShowBatter();
	call	_ShowBatter
;src/baseball/announcer.c:360: DrawCountOutsInning();
	jp	_DrawCountOutsInning
.l00101:
;src/baseball/announcer.c:361: }
	ret
;src/baseball/announcer.c:363: void AnnounceAdvanceRunners() {
;	---------------------------------
; Function AnnounceAdvanceRunners
; ---------------------------------
_AnnounceAdvanceRunners::
;src/baseball/announcer.c:365: }
.l00101:
	ret
;src/baseball/announcer.c:367: void AnnounceRunnersOn() {
;	---------------------------------
; Function AnnounceRunnersOn
; ---------------------------------
_AnnounceRunnersOn::
;src/baseball/announcer.c:368: unsigned char index = 0;
	ld	e, $00
;src/baseball/announcer.c:371: if (runners_on_base & 0x000F) index |= 1; // First base
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $0F
	jp	NZ,.l00124
	jp	.l00102
.l00124:
	ld	e, $01
.l00102:
;src/baseball/announcer.c:372: if (runners_on_base & 0x00F0) index |= 2; // Second base
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $F0
	jp	NZ,.l00125
	jp	.l00104
.l00125:
	set	1, e
.l00104:
;src/baseball/announcer.c:373: if (runners_on_base & 0x0F00) index |= 4; // Third base
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	and	a, $0F
	jp	NZ,.l00126
	jp	.l00106
.l00126:
	set	2, e
.l00106:
;src/baseball/announcer.c:375: char* runners_text = str_FromArray(index, RunnersOnBaseTexts);
	ld	bc, _RunnersOnBaseTexts+0
	ld	d, $00
	call	_str_FromArray
;src/baseball/announcer.c:376: RevealTextAndWait(runners_text);
	ld	e, c
	ld	d, b
	jp	_RevealTextAndWait
.l00107:
;src/baseball/announcer.c:377: }
	ret
;src/baseball/announcer.c:380: void AnnounceRunScored() {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
;	---------------------------------
; Function AnnounceRunScored
; ---------------------------------
_AnnounceRunScored::
;src/baseball/announcer.c:381: unsigned char scoring_runner = (char)(runners_on_base >> 12);
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	swap	a
	and	a, $0F
	ld	c, a
	ld	b, $00
;src/baseball/announcer.c:382: if (scoring_runner == 0) return;
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	jp	.l00106
.l00102:
;src/baseball/announcer.c:384: runners_on_base &= 0x0FFF;
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	and	a, $0F
	ld	[hl], a
;src/baseball/announcer.c:385: scoring_runner--;
	dec	c
;src/baseball/announcer.c:386: if (IsUserFielding() == 0) {// user is batting
	push	bc
	call	_IsUserFielding
	ld	e, a
	pop	bc
	ld	a, e
	or	a, a
	jp	NZ, .l00104
;src/baseball/announcer.c:387: PlayerData* player = GetUserPlayerInLineup(scoring_runner);
	ld	a, c
	call	_GetUserPlayerInLineup
;src/baseball/announcer.c:388: GetUserPlayerName(player);
	ld	e, c
	ld	d, b
	call	_GetUserPlayerName
	jp	.l00105
.l00104:
;src/baseball/announcer.c:391: PlayerData* player = GetOpposingPlayerInLineup(scoring_runner);
	ld	a, c
	call	_GetOpposingPlayerInLineup
;src/baseball/announcer.c:392: GetPlayerName(player->number);
	ld	a, [bc]
	ld	c, a
	ld	a, c
	call	_GetPlayerName
.l00105:
;src/baseball/announcer.c:394: DrawScore();
	call	_DrawScore
;src/baseball/announcer.c:395: str_Copy(name_buffer, str_buffer);
	ld	bc, _str_buffer
	ld	de, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:396: str_Append(PlayerScoresText, str_buffer);
	ld	bc, _str_buffer
	ld	de, _PlayerScoresText
	call	_str_Append
;src/baseball/announcer.c:397: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00106:
;src/baseball/announcer.c:398: }
	ret
;src/baseball/announcer.c:400: void AnnounceEndOfGame() {
;	---------------------------------
; Function AnnounceEndOfGame
; ---------------------------------
_AnnounceEndOfGame::
;src/baseball/announcer.c:402: RevealTextAndWait(AndThatsTheBallGameText);
	ld	de, _AndThatsTheBallGameText
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:403: }
	ret
	SECTION FRAGMENT "src/baseball/announcer.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
