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
	EXPORT _AnnounceBattedOnGround
	EXPORT _AnnounceBattedInAir
	EXPORT _AnnounceBattedInAirToOutfield
	EXPORT _AppendOutfieldLocationTextByAngle
	EXPORT _AnnounceBattedInAirToInfield
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
;src/baseball/announcer.c:8: unsigned long num = math_Divide(1000, 10);
	ld	a, $0A
	push	af
	inc	sp
	ld	bc, $03E8
	ld	de, $0000
	call	_math_Divide
;src/baseball/announcer.c:9: str_Number(num);
	call	_str_Number
;src/baseball/announcer.c:10: RevealTextAndWait(name_buffer);
	ld	de, _name_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:12: str_Copy("", str_buffer);
	ld	bc, _str_buffer
	ld	de, ___str_0
	call	_str_Copy
;src/baseball/announcer.c:13: for (int i = 170; i < 250; i += 10) {
	ld	hl, $00AA
.l00103:
	ld	a, l
	sub	a, $FA
	ld	a, h
	rla
	ccf
	rra
	sbc	a, $80
	jp	NC, .l00105
;src/baseball/announcer.c:14: AnnounceSwingContact(i, 20, 45);
	ld	c, l
	push	hl
	ld	a, $2D
	push	af
	inc	sp
	ld	e, $14
	ld	a, c
	call	_AnnounceSwingContact
	pop	hl
;src/baseball/announcer.c:13: for (int i = 170; i < 250; i += 10) {
	ld	bc, $000A
	add	hl, bc
	jp	.l00103
.l00105:
;src/baseball/announcer.c:16: }
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
	DB "And the benches clear."
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
	DB "%s tags from first."
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
___str_0:
	DB $00
;src/baseball/announcer.c:25: void AnnounceBeginningOfFrame() {
;	---------------------------------
; Function AnnounceBeginningOfFrame
; ---------------------------------
_AnnounceBeginningOfFrame::
;src/baseball/announcer.c:26: char* inning_text = str_FromArray(frame>>1, InningTexts);
	ld	bc, _InningTexts+0
	ld	hl, _frame
	ld	e, [hl]
	srl	e
	ld	d, $00
	call	_str_FromArray
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:27: str_Copy(inning_text, name_buffer);
	ld	bc, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:28: const char* top_bottom_text = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
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
;src/baseball/announcer.c:29: str_Replace(top_bottom_text, str_buffer, name_buffer);
	ld	bc, _name_buffer
	push	bc
	ld	bc, _str_buffer
	call	_str_Replace
;src/baseball/announcer.c:30: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:31: AnnouncePitcher();
	call	_AnnouncePitcher
;src/baseball/announcer.c:32: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:33: }
	ret
;src/baseball/announcer.c:36: void AnnouncePitcher() {
;	---------------------------------
; Function AnnouncePitcher
; ---------------------------------
_AnnouncePitcher::
;src/baseball/announcer.c:37: ShowPitcher();
	call	_ShowPitcher
;src/baseball/announcer.c:38: GetCurrentPitcherName();
	call	_GetCurrentPitcherName
;src/baseball/announcer.c:39: str_Replace(TakesTheMoundText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _TakesTheMoundText
	call	_str_Replace
;src/baseball/announcer.c:40: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:41: }
	ret
;src/baseball/announcer.c:44: void AnnounceBatter() {
;	---------------------------------
; Function AnnounceBatter
; ---------------------------------
_AnnounceBatter::
;src/baseball/announcer.c:45: DrawCountOutsInning();
	call	_DrawCountOutsInning
;src/baseball/announcer.c:46: ShowBatter();
	call	_ShowBatter
;src/baseball/announcer.c:47: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:48: str_Replace(WalksToThePlateText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalksToThePlateText
	call	_str_Replace
;src/baseball/announcer.c:49: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:50: }
	ret
;src/baseball/announcer.c:52: void AnnounceNextBatter() {
;	---------------------------------
; Function AnnounceNextBatter
; ---------------------------------
_AnnounceNextBatter::
;src/baseball/announcer.c:53: SetBalls(0);
	xor	a, a
	call	_SetBalls
;src/baseball/announcer.c:54: SetStrikes(0);
	xor	a, a
	call	_SetStrikes
;src/baseball/announcer.c:55: NextBatter();
	call	_NextBatter
;src/baseball/announcer.c:56: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:57: }
	ret
;src/baseball/announcer.c:60: void AnnounceBatterStepsIntoBox() {
;	---------------------------------
; Function AnnounceBatterStepsIntoBox
; ---------------------------------
_AnnounceBatterStepsIntoBox::
;src/baseball/announcer.c:61: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:62: str_Replace(BatterStepsIntoTheBoxText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BatterStepsIntoTheBoxText
	call	_str_Replace
;src/baseball/announcer.c:63: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:64: }
	ret
;src/baseball/announcer.c:67: void AnnouncePitcherSets() {
;	---------------------------------
; Function AnnouncePitcherSets
; ---------------------------------
_AnnouncePitcherSets::
;src/baseball/announcer.c:68: GetCurrentPitcherName();
	call	_GetCurrentPitcherName
;src/baseball/announcer.c:69: str_Replace(PitcherSetsText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _PitcherSetsText
	call	_str_Replace
;src/baseball/announcer.c:70: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:71: }
	ret
;src/baseball/announcer.c:74: void AnnounceAndThePitch() {
;	---------------------------------
; Function AnnounceAndThePitch
; ---------------------------------
_AnnounceAndThePitch::
;src/baseball/announcer.c:75: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, AndThePitchText);
	ld	de, _AndThePitchText
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:76: }
	ret
;src/baseball/announcer.c:79: void AnnouncePitchName() {
;	---------------------------------
; Function AnnouncePitchName
; ---------------------------------
_AnnouncePitchName::
;src/baseball/announcer.c:80: GetMoveName(pitch_move_id);//"PITCH_NAME" in name_buffer
	ld	hl, _pitch_move_id
	ld	a, [hl]
	call	_GetMoveName
;src/baseball/announcer.c:81: str_Copy(AndThePitchText, str_buffer);//"And the pitch.""
	ld	bc, _str_buffer
	ld	de, _AndThePitchText
	call	_str_Copy
;src/baseball/announcer.c:82: str_Replace(ThrewAPitchText, tile_buffer, name_buffer);//"\nA PITCH_NAME."
	ld	de, _name_buffer
	push	de
	ld	bc, _tile_buffer
	ld	de, _ThrewAPitchText
	call	_str_Replace
;src/baseball/announcer.c:83: str_Append(tile_buffer, str_buffer);//"And the pitch.\nA PITCH_NAME."
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Append
;src/baseball/announcer.c:84: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:85: }
	ret
;src/baseball/announcer.c:88: void AnnounceStrike(const char* strike_out_text) {
;	---------------------------------
; Function AnnounceStrike
; ---------------------------------
_AnnounceStrike::
	dec	sp
;src/baseball/announcer.c:89: str_Copy(strike_out_text, tile_buffer);
	ld	bc, _tile_buffer
	call	_str_Copy
;src/baseball/announcer.c:90: unsigned char strikes = GetStrikes();
	call	_GetStrikes
;src/baseball/announcer.c:91: strikes++;
	inc	a
	ld	hl, sp+0
	ld	[hl], a
;src/baseball/announcer.c:92: if (strikes == 3) {//strikeout
	ld	a, [hl]
	sub	a, $03
	jp	NZ,.l00118
	jp	.l00119
.l00118:
	jp	.l00104
.l00119:
;src/baseball/announcer.c:93: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:94: str_Replace(tile_buffer, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Replace
;src/baseball/announcer.c:95: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:96: HideBatter();
	call	_HideBatter
;src/baseball/announcer.c:97: unsigned char outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:98: if (outs < 3) AnnounceNextBatter();
	sub	a, $03
	jp	NC, .l00106
	inc	sp
	jp	_AnnounceNextBatter
	jp	.l00106
.l00104:
;src/baseball/announcer.c:101: SetStrikes(strikes);
	ld	hl, sp+0
	ld	a, [hl]
	call	_SetStrikes
;src/baseball/announcer.c:102: str_Number(strikes);
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:103: str_Replace(StrikeText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeText
	call	_str_Replace
;src/baseball/announcer.c:104: DrawCountOutsInning();
	call	_DrawCountOutsInning
;src/baseball/announcer.c:105: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	inc	sp
	jp	_RevealTextAndWait
.l00106:
;src/baseball/announcer.c:107: }
	inc	sp
	ret
;src/baseball/announcer.c:115: void AnnounceNoSwing() {
;	---------------------------------
; Function AnnounceNoSwing
; ---------------------------------
_AnnounceNoSwing::
;src/baseball/announcer.c:116: unsigned char was_strike = CheckStrike();
	call	_CheckStrike
;src/baseball/announcer.c:117: if (was_strike) { //strike
	or	a, a
	jp	Z, .l00105
;src/baseball/announcer.c:118: AnnounceStrike(StrikeOutLookingText);
	ld	de, _StrikeOutLookingText
	jp	_AnnounceStrike
	jp	.l00107
.l00105:
;src/baseball/announcer.c:121: unsigned char balls = GetBalls();
	call	_GetBalls
;src/baseball/announcer.c:122: if (balls < 3) {
	cp	a, $03
	jp	NC, .l00102
;src/baseball/announcer.c:123: SetBalls(++balls);
	ld	c, a
	inc	c
	push	bc
	ld	a, c
	call	_SetBalls
	pop	bc
;src/baseball/announcer.c:124: str_Number(balls);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:125: str_Replace(BallText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BallText
	call	_str_Replace
;src/baseball/announcer.c:126: DrawCountOutsInning();
	call	_DrawCountOutsInning
;src/baseball/announcer.c:127: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
	jp	.l00107
.l00102:
;src/baseball/announcer.c:130: PutBatterOnFirst();
	call	_PutBatterOnFirst
;src/baseball/announcer.c:131: GetCurrentBatterName();
	call	_GetCurrentBatterName
;src/baseball/announcer.c:132: str_Replace(WalkText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalkText
	call	_str_Replace
;src/baseball/announcer.c:133: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:134: HideBatter();
	call	_HideBatter
;src/baseball/announcer.c:135: AnnounceRunScored();
	call	_AnnounceRunScored
;src/baseball/announcer.c:136: AnnounceNextBatter();
	jp	_AnnounceNextBatter
.l00107:
;src/baseball/announcer.c:139: }
	ret
;src/baseball/announcer.c:141: void AnnounceWildPitchOrPassedBall() {
;	---------------------------------
; Function AnnounceWildPitchOrPassedBall
; ---------------------------------
_AnnounceWildPitchOrPassedBall::
;src/baseball/announcer.c:144: }
.l00101:
	ret
;src/baseball/announcer.c:153: void AnnounceSwingMiss() {
;	---------------------------------
; Function AnnounceSwingMiss
; ---------------------------------
_AnnounceSwingMiss::
;src/baseball/announcer.c:155: AnnounceStrike(StrikeOutSwingingText);
	ld	de, _StrikeOutSwingingText
	jp	_AnnounceStrike
.l00101:
;src/baseball/announcer.c:156: }
	ret
;src/baseball/announcer.c:158: void AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceSwingContact
; ---------------------------------
_AnnounceSwingContact::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:161: ball_state = BALL_STATE_IN_PLAY;
	ld	hl, _ball_state
	ld	[hl], $10
;src/baseball/announcer.c:163: if (spray > -45 && spray < 45) {
	ld	a, b
	ld	e, a
	ld	a, $D3
	ld	d, a
	ld	a, $D3
	sub	a, b
	bit	7, e
	jp	Z, .l00124
	bit	7, d
	jp	NZ, .l00125
	cp	a, a
	jp	.l00125
.l00124:
	bit	7, d
	jp	Z, .l00125
	scf
.l00125:
	jp	NC, .l00102
	ld	a, b
	xor	a, $80
	sub	a, $AD
	jp	NC, .l00102
;src/baseball/announcer.c:164: ball_state |= BALL_STATE_FAIR; 
	ld	hl, _ball_state
	ld	[hl], $30
.l00102:
;src/baseball/announcer.c:167: if (launch > 0) {
	ld	hl, sp+2
	ld	a, [hl]
	ld	e, a
	ld	a, $00
	ld	d, a
	xor	a, a
	sub	a, [hl]
	bit	7, e
	jp	Z, .l00126
	bit	7, d
	jp	NZ, .l00127
	cp	a, a
	jp	.l00127
.l00126:
	bit	7, d
	jp	Z, .l00127
	scf
.l00127:
	jp	NC, .l00105
;src/baseball/announcer.c:168: AnnounceBattedInAir(speed, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	ld	e, b
	ld	a, c
	call	_AnnounceBattedInAir
	jp	.l00107
.l00105:
;src/baseball/announcer.c:171: ball_state |= BALL_STATE_LANDED;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $40
	ld	[hl], a
;src/baseball/announcer.c:172: AnnounceBattedOnGround(speed, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	ld	e, b
	ld	a, c
	call	_AnnounceBattedOnGround
.l00107:
;src/baseball/announcer.c:174: }
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:176: void AnnounceBattedOnGround(char speed, char spray, signed char launch) {
;	---------------------------------
; Function AnnounceBattedOnGround
; ---------------------------------
_AnnounceBattedOnGround::
	add	sp, -7
	ld	hl, sp+6
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:179: if (launch < -20) hit_text = HitChopperText;
	ld	hl, sp+9
	ld	a, [hl]
	xor	a, $80
	sub	a, $6C
	jp	NC, .l00102
	ld	de, _HitChopperText+0
	jp	.l00103
.l00102:
;src/baseball/announcer.c:180: else hit_text = HitGroundBallText;
	ld	de, _HitGroundBallText
.l00103:
;src/baseball/announcer.c:182: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:183: AppendInfieldLocationTextByAngle(spray);
	ld	hl, sp+5
	ld	a, [hl]
	call	_AppendInfieldLocationTextByAngle
;src/baseball/announcer.c:184: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:186: unsigned int distance = 120;
	ld	hl, sp+0
	ld	[hl], $78
	xor	a, a
	inc	hl
	ld	[hl], a
;src/baseball/announcer.c:187: if (speed < distance) distance = speed;
	ld	hl, sp+6
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	inc	hl
	ld	[hl], $00
	dec	hl
	ld	a, [hl]
	sub	a, $78
	inc	hl
	ld	a, [hl]
	sbc	a, $00
	jp	NC, .l00105
	dec	hl
	ld	a, [hl]
	ld	hl, sp+0
	ld	[hl], a
	ld	hl, sp+4
	ld	a, [hl]
	ld	hl, sp+1
	ld	[hl], a
.l00105:
;src/baseball/announcer.c:188: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+0
	ld	c, [hl]
	ld	hl, sp+5
	ld	e, [hl]
	ld	a, c
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:189: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
;src/baseball/announcer.c:190: unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
	ld	a, c
	and	a, $0F
	ld	d, a
;src/baseball/announcer.c:191: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball >> 8);//distance in upper nibble
;src/baseball/announcer.c:192: ball_state |= fielder_position;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, d
	ld	[hl], a
;src/baseball/announcer.c:193: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, 0);
	xor	a, a
	push	af
	inc	sp
	ld	e, b
	ld	a, d
	call	_AnnounceFieldingText
.l00106:
;src/baseball/announcer.c:194: }
	add	sp, 7
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:196: void AnnounceBattedInAir(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceBattedInAir
; ---------------------------------
_AnnounceBattedInAir::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:197: unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	ld	a, c
	call	_DistanceFromSpeedLaunchAngle
	pop	bc
	ld	e, a
;src/baseball/announcer.c:198: if (distance < 100) {//infield
	ld	a, e
	sub	a, $64
	jp	NC, .l00102
;src/baseball/announcer.c:199: AnnounceBattedInAirToInfield(speed, distance, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, c
	call	_AnnounceBattedInAirToInfield
	jp	.l00104
.l00102:
;src/baseball/announcer.c:202: AnnounceBattedInAirToOutfield(speed, distance, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, c
	call	_AnnounceBattedInAirToOutfield
.l00104:
;src/baseball/announcer.c:204: }
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:206: void AnnounceBattedInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {   
;	---------------------------------
; Function AnnounceBattedInAirToOutfield
; ---------------------------------
_AnnounceBattedInAirToOutfield::
	add	sp, -3
	ld	hl, sp+2
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:209: if (distance > 200) { //out of play
	ld	a, $C8
	sub	a, [hl]
	jp	NC, .l00104
;src/baseball/announcer.c:210: if ((ball_state & BALL_STATE_FAIR) != 0) { //home run
	ld	hl, _ball_state
	ld	a, [hl]
	bit	5, a
	jp	NZ,.l00148
	jp	.l00102
.l00148:
;src/baseball/announcer.c:211: unsigned char order = CurrentOrderInLineup();
	call	_CurrentOrderInLineup
;src/baseball/announcer.c:212: unsigned char runs_scored = AdvanceRunners(4, ++order);//current batter is 0 to 8, needs to be 1 to 9
	ld	e, a
	inc	e
	ld	a, $04
	call	_AdvanceRunners
;src/baseball/announcer.c:213: const char* home_run_text = (runs_scored == 4) ? HitGrandSlamText : HitHomeRunText;
	sub	a, $04
	jp	NZ,.l00149
	jp	.l00150
.l00149:
	jp	.l00116
.l00150:
	ld	de, _HitGrandSlamText+0
	jp	.l00117
.l00116:
	ld	de, _HitHomeRunText+0
.l00117:
;src/baseball/announcer.c:214: RevealTextAndWait(home_run_text);
	call	_RevealTextAndWait
;src/baseball/announcer.c:215: DrawScore();
	call	_DrawScore
;src/baseball/announcer.c:216: AnnounceNextBatter();
	call	_AnnounceNextBatter
;src/baseball/announcer.c:217: return;
	jp	.l00114
.l00102:
;src/baseball/announcer.c:221: AnnounceFoulBall();
	call	_AnnounceFoulBall
;src/baseball/announcer.c:222: return;
	jp	.l00114
.l00104:
;src/baseball/announcer.c:226: if (distance > 180) hit_text = HitDeepFlyBallText;
	ld	a, $B4
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00112
	ld	de, _HitDeepFlyBallText+0
	jp	.l00113
.l00112:
;src/baseball/announcer.c:227: else if (distance > 120) hit_text = HitFlyBallText;
	ld	a, $78
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00109
	ld	de, _HitFlyBallText
	jp	.l00113
.l00109:
;src/baseball/announcer.c:228: else if (distance > 100) hit_text = HitShallowFlyBallText;
	ld	a, $64
	ld	hl, sp+1
	sub	a, [hl]
	jp	NC, .l00106
	ld	de, _HitShallowFlyBallText
	jp	.l00113
.l00106:
;src/baseball/announcer.c:229: else hit_text = HitPopFlyText;
	ld	de, _HitPopFlyText
.l00113:
;src/baseball/announcer.c:230: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:231: AppendOutfieldLocationTextByAngle(spray);
	ld	hl, sp+5
	ld	a, [hl]
	call	_AppendOutfieldLocationTextByAngle
;src/baseball/announcer.c:232: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:234: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+5
	ld	e, [hl]
	ld	hl, sp+1
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:235: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:236: unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
	ld	a, e
	and	a, $0F
	ld	c, a
;src/baseball/announcer.c:237: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball >> 8);//distance in upper nibble
	ld	hl, sp+0
	ld	[hl], d
;src/baseball/announcer.c:238: ball_state |= fielder_position;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, c
	ld	[hl], a
;src/baseball/announcer.c:239: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
	push	bc
	ld	hl, sp+8
	ld	e, [hl]
	ld	hl, sp+4
	ld	a, [hl]
	call	_HangTimeFromSpeedLaunchAngle
	pop	bc
;src/baseball/announcer.c:240: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
	push	af
	inc	sp
	ld	hl, sp+1
	ld	e, [hl]
	ld	a, c
	call	_AnnounceFieldingText
.l00114:
;src/baseball/announcer.c:241: }
	add	sp, 3
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/baseball/announcer.c:243: void AppendOutfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
;	---------------------------------
; Function AppendOutfieldLocationTextByAngle
; ---------------------------------
_AppendOutfieldLocationTextByAngle::
	ld	c, a
;src/baseball/announcer.c:245: if (spray >= -45 && spray <= 45) { //fair ball
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
;src/baseball/announcer.c:246: unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 15);
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
;src/baseball/announcer.c:247: location_text = str_FromArray(index, OutfieldLocationTexts);
	ld	bc, _OutfieldLocationTexts
	call	_str_FromArray
	ld	e, c
	ld	d, b
	jp	.l00103
.l00102:
;src/baseball/announcer.c:250: location_text = InFoulTerritoryText;
	ld	de, _InFoulTerritoryText
.l00103:
;src/baseball/announcer.c:252: str_Append(location_text, str_buffer);
	ld	bc, _str_buffer
	jp	_str_Append
.l00105:
;src/baseball/announcer.c:253: }
	ret
;src/baseball/announcer.c:255: void AnnounceBattedInAirToInfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceBattedInAirToInfield
; ---------------------------------
_AnnounceBattedInAirToInfield::
	add	sp, -6
	ld	hl, sp+5
	ld	[hl], a
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:257: if (distance > 200) hit_text = HitLineDriveText;
	ld	a, $C8
	sub	a, [hl]
	jp	NC, .l00108
	ld	de, _HitLineDriveText+0
	jp	.l00109
.l00108:
;src/baseball/announcer.c:258: else if (distance > 140) hit_text = HitGroundBallText;
	ld	a, $8C
	ld	hl, sp+4
	sub	a, [hl]
	jp	NC, .l00105
	ld	de, _HitGroundBallText
	jp	.l00109
.l00105:
;src/baseball/announcer.c:259: else if (distance > 100) hit_text = HitChopperText;
	ld	a, $64
	ld	hl, sp+4
	sub	a, [hl]
	jp	NC, .l00102
	ld	de, _HitChopperText
	jp	.l00109
.l00102:
;src/baseball/announcer.c:260: else hit_text = HitPopUpText;
	ld	de, _HitPopUpText
.l00109:
;src/baseball/announcer.c:261: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:263: AppendInfieldLocationTextByAngle(spray);
	ld	hl, sp+8
	ld	a, [hl]
	call	_AppendInfieldLocationTextByAngle
;src/baseball/announcer.c:264: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:266: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+8
	ld	e, [hl]
	ld	hl, sp+4
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:267: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
	ld	hl, sp+2
	ld	[hl], c
	inc	hl
	ld	[hl], b
	ld	hl, sp+2
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
	ld	hl, sp+3
	ld	a, [hl]
	dec	hl
	dec	hl
	ld	[hl], a
;src/baseball/announcer.c:268: unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
	dec	hl
	ld	a, [hl]
	ld	hl, sp+3
	ld	[hl], a
	ld	a, [hl]
	and	a, $0F
	dec	hl
	ld	[hl], a
;src/baseball/announcer.c:269: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball >> 8);//distance in upper nibble
	dec	hl
	ld	a, [hl]
	inc	hl
	inc	hl
	ld	[hl], a
;src/baseball/announcer.c:270: ball_state |= fielder_position;
	ld	hl, _ball_state
	ld	a, [hl]
	ld	hl, sp+2
	or	a, [hl]
	ld	hl, _ball_state
	ld	[hl], a
;src/baseball/announcer.c:271: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
	ld	hl, sp+9
	ld	e, [hl]
	ld	hl, sp+5
	ld	a, [hl]
	call	_HangTimeFromSpeedLaunchAngle
;src/baseball/announcer.c:272: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
	push	af
	inc	sp
	ld	hl, sp+4
	ld	e, [hl]
	dec	hl
	ld	a, [hl]
	call	_AnnounceFieldingText
.l00110:
;src/baseball/announcer.c:273: }
	add	sp, 6
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/baseball/announcer.c:275: void AppendInfieldLocationTextByAngle(signed char spray) {
;	---------------------------------
; Function AppendInfieldLocationTextByAngle
; ---------------------------------
_AppendInfieldLocationTextByAngle::
	ld	c, a
;src/baseball/announcer.c:277: if (spray >= -45 && spray <= 45) { //fair ball
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
;src/baseball/announcer.c:278: unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 11);
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
;src/baseball/announcer.c:279: location_text = str_FromArray(index, InfieldLocationTexts);
	ld	bc, _InfieldLocationTexts
	call	_str_FromArray
	ld	e, c
	ld	d, b
	jp	.l00103
.l00102:
;src/baseball/announcer.c:282: location_text = InFoulTerritoryText;
	ld	de, _InFoulTerritoryText
.l00103:
;src/baseball/announcer.c:284: str_Append(location_text, str_buffer);
	ld	bc, _str_buffer
	jp	_str_Append
.l00105:
;src/baseball/announcer.c:285: }
	ret
;src/baseball/announcer.c:287: void AnnounceBuntText(char launch, char spray) {
;	---------------------------------
; Function AnnounceBuntText
; ---------------------------------
_AnnounceBuntText::
;src/baseball/announcer.c:288: str_Copy(HitBuntText, tile_buffer);
	ld	bc, _tile_buffer
	ld	de, _HitBuntText
	call	_str_Copy
;src/baseball/announcer.c:289: str_Append(ToThePositionText, tile_buffer);
	ld	bc, _tile_buffer
	ld	de, _ToThePositionText
	call	_str_Append
;src/baseball/announcer.c:290: char* position_text = str_FromArray(1, PositionTexts);
	ld	bc, _PositionTexts
	ld	de, $0001
	call	_str_FromArray
;src/baseball/announcer.c:291: str_Replace(tile_buffer, str_buffer, position_text);
	push	bc
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Replace
;src/baseball/announcer.c:292: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:293: }
	ret
;src/baseball/announcer.c:296: void AnnounceCaughtBy() {
;	---------------------------------
; Function AnnounceCaughtBy
; ---------------------------------
_AnnounceCaughtBy::
;src/baseball/announcer.c:297: str_Replace(CaughtByText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _CaughtByText
	call	_str_Replace
;src/baseball/announcer.c:298: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:299: RevealTextAndWait(OutText);
	ld	de, _OutText
	call	_RevealTextAndWait
;src/baseball/announcer.c:300: unsigned char outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:301: if (outs < 3) AnnounceNextBatter();
	sub	a, $03
	jp	NC, .l00103
	jp	_AnnounceNextBatter
.l00103:
;src/baseball/announcer.c:302: }
	ret
;src/baseball/announcer.c:315: void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
;	---------------------------------
; Function AnnounceFieldingText
; ---------------------------------
_AnnounceFieldingText::
	ld	d, a
;src/baseball/announcer.c:316: PlayerData* player = GetPositionPlayerAndName(position);//player in hl, name in name_buffer
	push	de
	ld	a, d
	call	_GetPositionPlayerAndName
	pop	de
;src/baseball/announcer.c:317: int speed = GetPlayerSpeed(player);
	push	de
	ld	e, c
	ld	d, b
	call	_GetPlayerSpeed
	pop	de
;src/baseball/announcer.c:318: int dist_covered = math_Multiply(speed, hang_time);//dist covered = player speed * hang time, doesn't affect bc
	push	de
	ld	hl, sp+4
	ld	a, [hl]
	ld	e, c
	ld	d, b
	call	_math_Multiply
	pop	de
;src/baseball/announcer.c:319: if (hang_time > 0 && (char)(dist_covered >> 8) > distance) {//if player speed * hang time > dist from player, caught
	ld	hl, sp+2
	ld	a, [hl]
	or	a, a
	jp	Z, .l00102
	ld	a, e
	sub	a, b
	jp	NC, .l00102
;src/baseball/announcer.c:320: AnnounceCaughtBy();
	call	_AnnounceCaughtBy
;src/baseball/announcer.c:321: return;
	jp	.l00109
.l00102:
;src/baseball/announcer.c:325: ball_state |= BALL_STATE_LANDED;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $40
	ld	[hl], a
;src/baseball/announcer.c:326: if ((ball_state & BALL_STATE_FAIR) == 0) {
	ld	a, [hl]
	bit	5, a
	jp	NZ,.l00131
	jp	.l00132
.l00131:
	jp	.l00105
.l00132:
;src/baseball/announcer.c:327: AnnounceFoulBall();
	call	_AnnounceFoulBall
;src/baseball/announcer.c:328: return;//early exit
	jp	.l00109
.l00105:
;src/baseball/announcer.c:331: HideBatter();
	push	de
	call	_HideBatter
	pop	de
;src/baseball/announcer.c:332: str_Replace(FieldedByText, str_buffer, name_buffer);
	push	de
	ld	bc, _name_buffer
	push	bc
	ld	bc, _str_buffer
	ld	de, _FieldedByText
	call	_str_Replace
	pop	de
;src/baseball/announcer.c:333: RevealTextAndWait(str_buffer);
	push	de
	ld	de, _str_buffer
	call	_RevealTextAndWait
	pop	de
;src/baseball/announcer.c:335: if (position > 6) AnnounceHit(1); //hit the ground in the outfield
	ld	a, $06
	sub	a, d
	jp	NC, .l00107
	ld	a, $01
	call	_AnnounceHit
	jp	.l00109
.l00107:
;src/baseball/announcer.c:336: else AnnounceForcePlay(); //hit the ground in the infield
	call	_AnnounceForcePlay
.l00109:
;src/baseball/announcer.c:337: }
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:339: void AnnounceHit(char bases) {
;	---------------------------------
; Function AnnounceHit
; ---------------------------------
_AnnounceHit::
	dec	sp
	ld	hl, sp+0
	ld	[hl], a
;src/baseball/announcer.c:341: RevealTextAndWait(HitBaseHitText);
	ld	de, _HitBaseHitText
	call	_RevealTextAndWait
;src/baseball/announcer.c:342: unsigned char order = CurrentOrderInLineup() + 1;
	call	_CurrentOrderInLineup
	ld	e, a
	inc	e
;src/baseball/announcer.c:343: unsigned char runs_scored = AdvanceRunners(bases, order);
	ld	hl, sp+0
	ld	a, [hl]
	call	_AdvanceRunners
	ld	c, a
;src/baseball/announcer.c:344: DrawBases();
	push	bc
	call	_DrawBases
	pop	bc
;src/baseball/announcer.c:345: if (runs_scored > 0) AnnounceRunScored();
	ld	a, c
	or	a, a
	jp	Z, .l00102
	call	_AnnounceRunScored
.l00102:
;src/baseball/announcer.c:346: AnnounceNextBatter();
	inc	sp
	jp	_AnnounceNextBatter
.l00103:
;src/baseball/announcer.c:347: }
	inc	sp
	ret
;src/baseball/announcer.c:349: void AnnounceForcePlay() {
;	---------------------------------
; Function AnnounceForcePlay
; ---------------------------------
_AnnounceForcePlay::
;src/baseball/announcer.c:350: unsigned char outs = GetOuts();
	call	_GetOuts
	ld	c, a
;src/baseball/announcer.c:351: if ((runners_on_base & 0x000F) != 0 && outs < 2) {//double play
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $0F
	jp	NZ,.l00131
	jp	.l00102
.l00131:
	ld	a, c
	sub	a, $02
	jp	NC, .l00102
;src/baseball/announcer.c:353: char* second_base = str_FromArray(1, BaseTexts);
	ld	bc, _BaseTexts
	ld	de, $0001
	call	_str_FromArray
;src/baseball/announcer.c:354: str_Replace(ThrowsToText, str_buffer, second_base);
	push	bc
	ld	bc, _str_buffer
	ld	de, _ThrowsToText
	call	_str_Replace
;src/baseball/announcer.c:355: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:356: RevealTextAndWait(OutText);
	ld	de, _OutText
	call	_RevealTextAndWait
;src/baseball/announcer.c:357: outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:358: runners_on_base &= 0xFFF0; //first base runner out
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $F0
	ld	[hl], a
;src/baseball/announcer.c:361: char* first_base = str_FromArray(0, BaseTexts);
	ld	bc, _BaseTexts
	ld	de, $0000
	call	_str_FromArray
;src/baseball/announcer.c:362: str_Replace(ThrowsToText, str_buffer, first_base);
	push	bc
	ld	bc, _str_buffer
	ld	de, _ThrowsToText
	call	_str_Replace
;src/baseball/announcer.c:363: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:364: RevealTextAndWait(DoublePlayText);
	ld	de, _DoublePlayText
	call	_RevealTextAndWait
;src/baseball/announcer.c:365: outs = IncrementOuts();
	call	_IncrementOuts
	jp	.l00103
.l00102:
;src/baseball/announcer.c:368: char* first_base = str_FromArray(0, BaseTexts);
	ld	bc, _BaseTexts
	ld	de, $0000
	call	_str_FromArray
;src/baseball/announcer.c:369: str_Replace(ThrowsToText, str_buffer, first_base);
	push	bc
	ld	bc, _str_buffer
	ld	de, _ThrowsToText
	call	_str_Replace
;src/baseball/announcer.c:370: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:371: RevealTextAndWait(OutText);
	ld	de, _OutText
	call	_RevealTextAndWait
;src/baseball/announcer.c:372: outs = IncrementOuts();
	call	_IncrementOuts
.l00103:
;src/baseball/announcer.c:375: if (outs < 3) {
	sub	a, $03
	jp	NC, .l00109
;src/baseball/announcer.c:376: unsigned char runs = AdvanceRunners(1, 0); 
	ld	e, $00
	ld	a, $01
	call	_AdvanceRunners
;src/baseball/announcer.c:377: if (runs > 0) AnnounceRunScored();
	or	a, a
	jp	Z, .l00106
	call	_AnnounceRunScored
.l00106:
;src/baseball/announcer.c:378: DrawBases();
	call	_DrawBases
;src/baseball/announcer.c:379: AnnounceNextBatter();
	jp	_AnnounceNextBatter
.l00109:
;src/baseball/announcer.c:381: }
	ret
;src/baseball/announcer.c:383: void AnnounceFoulBall() {
;	---------------------------------
; Function AnnounceFoulBall
; ---------------------------------
_AnnounceFoulBall::
;src/baseball/announcer.c:384: FoulBall();
	call	_FoulBall
;src/baseball/announcer.c:386: RevealTextAndWait(HitFoulBallText);
	ld	de, _HitFoulBallText
	call	_RevealTextAndWait
;src/baseball/announcer.c:387: ShowBatter();
	call	_ShowBatter
;src/baseball/announcer.c:388: DrawCountOutsInning();
	jp	_DrawCountOutsInning
.l00101:
;src/baseball/announcer.c:389: }
	ret
;src/baseball/announcer.c:391: void AnnounceAdvanceRunners() {
;	---------------------------------
; Function AnnounceAdvanceRunners
; ---------------------------------
_AnnounceAdvanceRunners::
;src/baseball/announcer.c:393: }
.l00101:
	ret
;src/baseball/announcer.c:395: void AnnounceRunnersOn() {
;	---------------------------------
; Function AnnounceRunnersOn
; ---------------------------------
_AnnounceRunnersOn::
;src/baseball/announcer.c:396: unsigned char index = 0;
	ld	e, $00
;src/baseball/announcer.c:399: if (runners_on_base & 0x000F) index |= 1; // First base
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $0F
	jp	NZ,.l00124
	jp	.l00102
.l00124:
	ld	e, $01
.l00102:
;src/baseball/announcer.c:400: if (runners_on_base & 0x00F0) index |= 2; // Second base
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $F0
	jp	NZ,.l00125
	jp	.l00104
.l00125:
	set	1, e
.l00104:
;src/baseball/announcer.c:401: if (runners_on_base & 0x0F00) index |= 4; // Third base
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	and	a, $0F
	jp	NZ,.l00126
	jp	.l00106
.l00126:
	set	2, e
.l00106:
;src/baseball/announcer.c:403: char* runners_text = str_FromArray(index, RunnersOnBaseTexts);
	ld	bc, _RunnersOnBaseTexts+0
	ld	d, $00
	call	_str_FromArray
;src/baseball/announcer.c:404: RevealTextAndWait(runners_text);
	ld	e, c
	ld	d, b
	jp	_RevealTextAndWait
.l00107:
;src/baseball/announcer.c:405: }
	ret
;src/baseball/announcer.c:408: void AnnounceRunScored() {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
;	---------------------------------
; Function AnnounceRunScored
; ---------------------------------
_AnnounceRunScored::
;src/baseball/announcer.c:409: unsigned char scoring_runner = (char)(runners_on_base >> 12);
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	swap	a
	and	a, $0F
	ld	c, a
	ld	b, $00
;src/baseball/announcer.c:410: if (scoring_runner == 0) return;
	ld	a, c
	or	a, a
	jp	NZ, .l00102
	jp	.l00106
.l00102:
;src/baseball/announcer.c:412: runners_on_base &= 0x0FFF;
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	and	a, $0F
	ld	[hl], a
;src/baseball/announcer.c:413: scoring_runner--;
	dec	c
;src/baseball/announcer.c:414: if (IsUserFielding() == 0) {// user is batting
	push	bc
	call	_IsUserFielding
	ld	e, a
	pop	bc
	ld	a, e
	or	a, a
	jp	NZ, .l00104
;src/baseball/announcer.c:415: PlayerData* player = GetUserPlayerInLineup(scoring_runner);
	ld	a, c
	call	_GetUserPlayerInLineup
;src/baseball/announcer.c:416: GetUserPlayerName(player);
	ld	e, c
	ld	d, b
	call	_GetUserPlayerName
	jp	.l00105
.l00104:
;src/baseball/announcer.c:419: PlayerData* player = GetOpposingPlayerInLineup(scoring_runner);
	ld	a, c
	call	_GetOpposingPlayerInLineup
;src/baseball/announcer.c:420: GetPlayerName(player->number);
	ld	a, [bc]
	ld	c, a
	ld	a, c
	call	_GetPlayerName
.l00105:
;src/baseball/announcer.c:422: DrawScore();
	call	_DrawScore
;src/baseball/announcer.c:423: str_Copy(name_buffer, str_buffer);
	ld	bc, _str_buffer
	ld	de, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:424: str_Append(PlayerScoresText, str_buffer);
	ld	bc, _str_buffer
	ld	de, _PlayerScoresText
	call	_str_Append
;src/baseball/announcer.c:425: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00106:
;src/baseball/announcer.c:426: }
	ret
;src/baseball/announcer.c:428: void AnnounceEndOfGame() {
;	---------------------------------
; Function AnnounceEndOfGame
; ---------------------------------
_AnnounceEndOfGame::
;src/baseball/announcer.c:430: RevealTextAndWait(AndThatsTheBallGameText);
	ld	de, _AndThatsTheBallGameText
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:431: }
	ret
	SECTION FRAGMENT "src/baseball/announcer.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
