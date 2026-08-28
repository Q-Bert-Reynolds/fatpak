;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	; MODULE announcer
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _AnnounceTest
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
	EXPORT _GetStrikes
	EXPORT _GetBalls
	EXPORT _IsUserFielding
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
	EXPORT _AnnouncePitcher
	EXPORT _AnnounceBatter
	EXPORT _AnnounceBeginningOfFrame
	EXPORT _AnnouncePitcherSets
	EXPORT _AnnounceAndThePitch
	EXPORT _AnnouncePitchName
	EXPORT _AnnounceNextBatter
	EXPORT _AnnounceBatterStepsIntoBox
	EXPORT _AnnounceStrike
	EXPORT _AnnounceNoSwing
	EXPORT _AnnounceWildPitchOrPassedBall
	EXPORT _AnnounceSwingMiss
	EXPORT _AnnounceSwingContact
	EXPORT _AnnounceHitOnGround
	EXPORT _AnnounceHitInAir
	EXPORT _AnnounceHitInAirToOutfield
	EXPORT _AppendOutfieldLocationTextByAngle
	EXPORT _AnnounceHitInAirToInfield
	EXPORT _AppendInfieldLocationTextByAngle
	EXPORT _AnnounceBuntText
	EXPORT _AnnounceFieldingText
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
;src/baseball/announcer.c:185: void AnnouncePitcher(void) {
;	---------------------------------
; Function AnnouncePitcher
; ---------------------------------
_AnnouncePitcher::
;src/baseball/announcer.c:189: __endasm;
	TRAMPOLINE	ShowPitcher
	TRAMPOLINE	GetCurrentPitcherName
;src/baseball/announcer.c:190: str_Replace(TakesTheMoundText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _TakesTheMoundText
	call	_str_Replace
;src/baseball/announcer.c:191: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:192: }
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
;src/baseball/announcer.c:194: void AnnounceBatter(void) {
;	---------------------------------
; Function AnnounceBatter
; ---------------------------------
_AnnounceBatter::
;src/baseball/announcer.c:199: __endasm;
	TRAMPOLINE	DrawCountOutsInning
	TRAMPOLINE	ShowBatter
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:200: str_Replace(WalksToThePlateText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalksToThePlateText
	call	_str_Replace
;src/baseball/announcer.c:201: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:202: }
	ret
;src/baseball/announcer.c:211: void AnnounceBeginningOfFrame(void) {
;	---------------------------------
; Function AnnounceBeginningOfFrame
; ---------------------------------
_AnnounceBeginningOfFrame::
;src/baseball/announcer.c:212: char* inning_text = str_FromArray(frame>>1, InningTexts);
	ld	bc, _InningTexts+0
	ld	hl, _frame
	ld	e, [hl]
	srl	e
	ld	d, $00
	call	_str_FromArray
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:213: str_Copy(inning_text, name_buffer);
	ld	bc, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:214: const char* top_bottom_text = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
	push	hl
	ld	hl, _frame
	bit	0, [hl]
	pop	hl
	jr	Z, .l00111
.l00110:
	jr	.l00103
.l00111:
	ld	de, _TopOfTheText+0
	jr	.l00104
.l00103:
	ld	de, _BottomOfTheText+0
.l00104:
;src/baseball/announcer.c:215: str_Replace(top_bottom_text, str_buffer, name_buffer);
	ld	bc, _name_buffer
	push	bc
	ld	bc, _str_buffer
	call	_str_Replace
;src/baseball/announcer.c:216: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:217: AnnouncePitcher();
	call	_AnnouncePitcher
;src/baseball/announcer.c:218: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:219: }
	ret
;src/baseball/announcer.c:221: void AnnouncePitcherSets(void) {
;	---------------------------------
; Function AnnouncePitcherSets
; ---------------------------------
_AnnouncePitcherSets::
;src/baseball/announcer.c:224: __endasm;
	TRAMPOLINE	GetCurrentPitcherName
;src/baseball/announcer.c:225: str_Replace(PitcherSetsText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _PitcherSetsText
	call	_str_Replace
;src/baseball/announcer.c:226: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:227: }
	ret
;src/baseball/announcer.c:229: void AnnounceAndThePitch(void) {
;	---------------------------------
; Function AnnounceAndThePitch
; ---------------------------------
_AnnounceAndThePitch::
;src/baseball/announcer.c:230: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, AndThePitchText);
	ld	de, _AndThePitchText
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:231: }
	ret
;src/baseball/announcer.c:233: void AnnouncePitchName(void) {
;	---------------------------------
; Function AnnouncePitchName
; ---------------------------------
_AnnouncePitchName::
;src/baseball/announcer.c:234: GetMoveName(pitch_move_id);//"PITCH_NAME" in name_buffer
	ld	hl, _pitch_move_id
	ld	a, [hl]
	call	_GetMoveName
;src/baseball/announcer.c:235: str_Copy(AndThePitchText, str_buffer);//"And the pitch.""
	ld	bc, _str_buffer
	ld	de, _AndThePitchText
	call	_str_Copy
;src/baseball/announcer.c:236: str_Replace(ThrewAPitchText, tile_buffer, name_buffer);//"\nA PITCH_NAME."
	ld	de, _name_buffer
	push	de
	ld	bc, _tile_buffer
	ld	de, _ThrewAPitchText
	call	_str_Replace
;src/baseball/announcer.c:237: str_Append(tile_buffer, str_buffer);//"And the pitch.\nA PITCH_NAME."
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Append
;src/baseball/announcer.c:238: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:239: }
	ret
;src/baseball/announcer.c:241: void AnnounceNextBatter(void) {
;	---------------------------------
; Function AnnounceNextBatter
; ---------------------------------
_AnnounceNextBatter::
;src/baseball/announcer.c:242: SetBalls(0);
	xor	a, a
	call	_SetBalls
;src/baseball/announcer.c:243: SetStrikes(0);
	xor	a, a
	call	_SetStrikes
;src/baseball/announcer.c:244: __asm__("TRAMPOLINE NextBatter");
	TRAMPOLINE	NextBatter
;src/baseball/announcer.c:245: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:246: }
	ret
;src/baseball/announcer.c:248: void AnnounceBatterStepsIntoBox(void) {
;	---------------------------------
; Function AnnounceBatterStepsIntoBox
; ---------------------------------
_AnnounceBatterStepsIntoBox::
;src/baseball/announcer.c:249: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:250: str_Replace(BatterStepsIntoTheBoxText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BatterStepsIntoTheBoxText
	call	_str_Replace
;src/baseball/announcer.c:251: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:252: }
	ret
;src/baseball/announcer.c:254: void AnnounceStrike(const char strike_out_text[]) {
;	---------------------------------
; Function AnnounceStrike
; ---------------------------------
_AnnounceStrike::
	dec	sp
;src/baseball/announcer.c:255: str_Copy(strike_out_text, tile_buffer);
	ld	bc, _tile_buffer
	call	_str_Copy
;src/baseball/announcer.c:256: unsigned char strikes = GetStrikes();
	call	_GetStrikes
;src/baseball/announcer.c:257: strikes++;
	inc	a
	ld	hl, sp+0
;src/baseball/announcer.c:258: if (strikes == 3) {//strikeout
	ld	[hl], a
	sub	a, $03
	jr	Z, .l00119
.l00118:
	jp	.l00104
.l00119:
;src/baseball/announcer.c:259: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:260: str_Replace(tile_buffer, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Replace
;src/baseball/announcer.c:261: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:262: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:263: unsigned char outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:264: if (outs != 3) {
	sub	a, $03
	jp	Z,.l00106
.l00120:
;src/baseball/announcer.c:265: AnnounceNextBatter();
	inc	sp
	jp	_AnnounceNextBatter
	jp	.l00106
.l00104:
;src/baseball/announcer.c:269: SetStrikes(strikes);
	ld	hl, sp+0
	ld	a, [hl]
	call	_SetStrikes
;src/baseball/announcer.c:270: str_Number(strikes);
	ld	hl, sp+0
	ld	c, [hl]
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:271: str_Replace(StrikeText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeText
	call	_str_Replace
;src/baseball/announcer.c:272: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:273: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	inc	sp
	jp	_RevealTextAndWait
.l00106:
;src/baseball/announcer.c:275: }
	inc	sp
	ret
;src/baseball/announcer.c:283: void AnnounceNoSwing(void) {
;	---------------------------------
; Function AnnounceNoSwing
; ---------------------------------
_AnnounceNoSwing::
;src/baseball/announcer.c:284: unsigned char was_strike = CheckStrike();
	call	_CheckStrike
;src/baseball/announcer.c:285: if (was_strike) { //strike
	or	a, a
	jr	Z, .l00105
;src/baseball/announcer.c:286: AnnounceStrike(StrikeOutLookingText);
	ld	de, _StrikeOutLookingText
	jp	_AnnounceStrike
.l00105:
;src/baseball/announcer.c:289: unsigned char balls = GetBalls();
	call	_GetBalls
;src/baseball/announcer.c:290: if (balls < 3) {
	cp	a, $03
	jp	NC, .l00102
;src/baseball/announcer.c:291: SetBalls(++balls);
	ld	c, a
	inc	c
	push	bc
	ld	a, c
	call	_SetBalls
	pop	bc
;src/baseball/announcer.c:292: str_Number(balls);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:293: str_Replace(BallText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BallText
	call	_str_Replace
;src/baseball/announcer.c:294: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:295: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00102:
;src/baseball/announcer.c:298: __asm__("TRAMPOLINE PutBatterOnFirst");
	TRAMPOLINE	PutBatterOnFirst
;src/baseball/announcer.c:299: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:300: str_Replace(WalkText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalkText
	call	_str_Replace
;src/baseball/announcer.c:301: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:302: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:303: AnnounceRunScored();
	call	_AnnounceRunScored
;src/baseball/announcer.c:304: AnnounceNextBatter();
	jp	_AnnounceNextBatter
.l00107:
;src/baseball/announcer.c:307: }
	ret
;src/baseball/announcer.c:309: void AnnounceWildPitchOrPassedBall(void) {
;	---------------------------------
; Function AnnounceWildPitchOrPassedBall
; ---------------------------------
_AnnounceWildPitchOrPassedBall::
;src/baseball/announcer.c:312: }
.l00101:
	ret
;src/baseball/announcer.c:321: void AnnounceSwingMiss(void) {
;	---------------------------------
; Function AnnounceSwingMiss
; ---------------------------------
_AnnounceSwingMiss::
;src/baseball/announcer.c:323: AnnounceStrike(StrikeOutSwingingText);
	ld	de, _StrikeOutSwingingText
	jp	_AnnounceStrike
.l00101:
;src/baseball/announcer.c:324: }
	ret
;src/baseball/announcer.c:326: void AnnounceTest(void) {
;	---------------------------------
; Function AnnounceTest
; ---------------------------------
_AnnounceTest::
;src/baseball/announcer.c:331: str_Copy("", str_buffer);
	ld	bc, _str_buffer
	ld	de, ___str_66
	call	_str_Copy
;src/baseball/announcer.c:332: for (int i = 170; i < 250; i += 10) {
	ld	hl, $00AA
.l00103:
	ld	a, l
	sub	a, $FA
	ld	a, h
	rla
	ccf
	rra
	sbc	a, $80
	ret	NC
;src/baseball/announcer.c:333: AnnounceSwingContact(i, 20, 45);
	ld	c, l
	push	hl
	ld	a, $2D
	push	af
	inc	sp
	ld	e, $14
	ld	a, c
	call	_AnnounceSwingContact
	pop	hl
;src/baseball/announcer.c:332: for (int i = 170; i < 250; i += 10) {
	ld	bc, $000A
	add	hl, bc
	jr	.l00103
.l00105:
;src/baseball/announcer.c:336: }
	ret
___str_66:
	DB $00
;src/baseball/announcer.c:339: void AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceSwingContact
; ---------------------------------
_AnnounceSwingContact::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:342: ball_state = BALL_STATE_IN_PLAY;
	ld	hl, _ball_state
	ld	[hl], $10
;src/baseball/announcer.c:344: if (spray > -45 && spray < 45) {
	ld	e, b
	ld	a, $D3
	ld	d, a
	ld	a, $D3
	sub	a, b
	bit	7, e
	jr	Z, .l00124
	bit	7, d
	jr	NZ, .l00125
	cp	a, a
	jr	.l00125
.l00124:
	bit	7, d
	jr	Z, .l00125
	scf
.l00125:
	jr	NC, .l00102
	ld	a, b
	xor	a, $80
	sub	a, $AD
	jr	NC, .l00102
;src/baseball/announcer.c:345: ball_state |= BALL_STATE_FAIR; 
	ld	[hl], $30
.l00102:
;src/baseball/announcer.c:348: if (launch > 0) {
	ld	hl, sp+2
	ld	a, [hl]
	ld	e, a
	ld	a, $00
	ld	d, a
	xor	a, a
	sub	a, [hl]
	bit	7, e
	jr	Z, .l00126
	bit	7, d
	jr	NZ, .l00127
	cp	a, a
	jr	.l00127
.l00126:
	bit	7, d
	jr	Z, .l00127
	scf
.l00127:
	jr	NC, .l00105
;src/baseball/announcer.c:349: AnnounceHitInAir(speed, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	ld	e, b
	ld	a, c
	call	_AnnounceHitInAir
	jr	.l00107
.l00105:
;src/baseball/announcer.c:352: ball_state |= BALL_STATE_LANDED;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $40
	ld	[hl], a
;src/baseball/announcer.c:353: AnnounceHitOnGround(speed, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	ld	e, b
	ld	a, c
	call	_AnnounceHitOnGround
.l00107:
;src/baseball/announcer.c:355: }
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:357: void AnnounceHitOnGround(char speed, char spray, signed char launch) {
;	---------------------------------
; Function AnnounceHitOnGround
; ---------------------------------
_AnnounceHitOnGround::
	add	sp, -3
	ld	hl, sp+2
;src/baseball/announcer.c:358: const char* hit_text = HitGroundBallText;
	dec	hl
	ld	[hl], e
	ld	a, LOW(_HitGroundBallText)
	ld	[hl], a
	ld	a, HIGH(_HitGroundBallText)
	ld	[hl], a
;src/baseball/announcer.c:361: if (launch < -20) {
	ld	hl, sp+5
	ld	a, [hl]
	xor	a, $80
	sub	a, $6C
	jr	NC, .l00102
;src/baseball/announcer.c:362: hit_text = HitChopperText;
	ld	hl, sp+0
	inc	hl
	ld	a, LOW(_HitChopperText)
	ld	[hl], a
	ld	a, HIGH(_HitChopperText)
	ld	[hl], a
.l00102:
;src/baseball/announcer.c:365: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	pop	de
	push	de
	call	_str_Copy
;src/baseball/announcer.c:366: AppendInfieldLocationTextByAngle(spray);
	ld	hl, sp+2
	ld	a, [hl]
	call	_AppendInfieldLocationTextByAngle
;src/baseball/announcer.c:367: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
.l00103:
;src/baseball/announcer.c:370: }
	add	sp, 3
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:372: void AnnounceHitInAir(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceHitInAir
; ---------------------------------
_AnnounceHitInAir::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:373: unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	ld	a, c
	call	_DistanceFromSpeedLaunchAngle
	pop	bc
;src/baseball/announcer.c:374: if (distance < 100) {//infield
	ld	e, a
	sub	a, $64
	jr	NC, .l00102
;src/baseball/announcer.c:375: AnnounceHitInAirToInfield(speed, distance, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, c
	call	_AnnounceHitInAirToInfield
	jr	.l00104
.l00102:
;src/baseball/announcer.c:378: AnnounceHitInAirToOutfield(speed, distance, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, c
	call	_AnnounceHitInAirToOutfield
.l00104:
;src/baseball/announcer.c:380: }
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:382: void AnnounceHitInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {   
;	---------------------------------
; Function AnnounceHitInAirToOutfield
; ---------------------------------
_AnnounceHitInAirToOutfield::
	add	sp, -3
	ld	hl, sp+2
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:385: if (distance > 200) { //out of play
	ld	a, $C8
	sub	a, [hl]
	jp	NC, .l00104
;src/baseball/announcer.c:386: if ((ball_state & BALL_STATE_FAIR) != 0) { //home run
	ld	hl, _ball_state
	ld	a, [hl]
	bit	5, a
	jp	Z,.l00102
.l00148:
;src/baseball/announcer.c:387: unsigned char order = CurrentOrderInLineup();
	call	_CurrentOrderInLineup
;src/baseball/announcer.c:388: unsigned char runs_scored = AdvanceRunners(4, ++order);//current batter is 0 to 8, needs to be 1 to 9
	ld	e, a
	inc	e
	ld	a, $04
	call	_AdvanceRunners
;src/baseball/announcer.c:389: const char* home_run_text = (runs_scored == 4) ? HitGrandSlamText : HitHomeRunText;
	sub	a, $04
	jr	Z, .l00150
.l00149:
	jr	.l00116
.l00150:
	ld	de, _HitGrandSlamText+0
	jr	.l00117
.l00116:
	ld	de, _HitHomeRunText+0
.l00117:
;src/baseball/announcer.c:390: RevealTextAndWait(home_run_text);
	call	_RevealTextAndWait
;src/baseball/announcer.c:391: __asm__("TRAMPOLINE DrawScore");
	TRAMPOLINE	DrawScore
;src/baseball/announcer.c:392: AnnounceNextBatter();
	call	_AnnounceNextBatter
;src/baseball/announcer.c:393: return;
	jr	.l00114
.l00102:
;src/baseball/announcer.c:397: AnnounceFoulBall();
	call	_AnnounceFoulBall
;src/baseball/announcer.c:398: return;
	jr	.l00114
.l00104:
;src/baseball/announcer.c:402: if (distance > 180) {
	ld	a, $B4
	ld	hl, sp+1
	sub	a, [hl]
	jr	NC, .l00112
;src/baseball/announcer.c:403: hit_text = HitDeepFlyBallText;
	ld	de, _HitDeepFlyBallText+0
	jr	.l00113
.l00112:
;src/baseball/announcer.c:405: else if (distance > 120) {
	ld	a, $78
	ld	hl, sp+1
	sub	a, [hl]
	jr	NC, .l00109
;src/baseball/announcer.c:406: hit_text = HitFlyBallText;
	ld	de, _HitFlyBallText
	jr	.l00113
.l00109:
;src/baseball/announcer.c:408: else if (distance > 100) {
	ld	a, $64
	ld	hl, sp+1
	sub	a, [hl]
	jr	NC, .l00106
;src/baseball/announcer.c:409: hit_text = HitShallowFlyBallText;
	ld	de, _HitShallowFlyBallText
	jr	.l00113
.l00106:
;src/baseball/announcer.c:412: hit_text = HitPopFlyText;
	ld	de, _HitPopFlyText
.l00113:
;src/baseball/announcer.c:414: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:415: AppendOutfieldLocationTextByAngle(spray);
	ld	hl, sp+5
	ld	a, [hl]
	call	_AppendOutfieldLocationTextByAngle
;src/baseball/announcer.c:416: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:418: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+5
	ld	e, [hl]
	ld	hl, sp+1
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:419: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:420: unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
	ld	a, e
	and	a, $0F
	ld	c, a
;src/baseball/announcer.c:421: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball >> 8);//distance in upper nibble
	ld	[hl], d
;src/baseball/announcer.c:422: ball_state |= fielder_position;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, c
	ld	[hl], a
;src/baseball/announcer.c:423: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
	push	bc
	ld	hl, sp+8
	ld	e, [hl]
	ld	hl, sp+4
	ld	a, [hl]
	call	_HangTimeFromSpeedLaunchAngle
	pop	bc
;src/baseball/announcer.c:424: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
	push	af
	inc	sp
	ld	hl, sp+1
	ld	e, [hl]
	ld	a, c
	call	_AnnounceFieldingText
.l00114:
;src/baseball/announcer.c:425: }
	add	sp, 3
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/baseball/announcer.c:427: void AppendOutfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
;	---------------------------------
; Function AppendOutfieldLocationTextByAngle
; ---------------------------------
_AppendOutfieldLocationTextByAngle::
;src/baseball/announcer.c:429: if (spray >= -45 && spray <= 45) { //fair ball
	ld	c, a
	xor	a, $80
	sub	a, $53
	jr	C, .l00102
	ld	e, c
	ld	a, $2D
	ld	d, a
	ld	a, $2D
	sub	a, c
	bit	7, e
	jr	Z, .l00117
	bit	7, d
	jr	NZ, .l00118
	cp	a, a
	jr	.l00118
.l00117:
	bit	7, d
	jr	Z, .l00118
	scf
.l00118:
	jr	C, .l00102
;src/baseball/announcer.c:430: unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 15);
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
;src/baseball/announcer.c:431: location_text = str_FromArray(index, OutfieldLocationTexts);
	ld	bc, _OutfieldLocationTexts
	call	_str_FromArray
	ld	e, c
	ld	d, b
	jr	.l00103
.l00102:
;src/baseball/announcer.c:434: location_text = InFoulTerritoryText;
	ld	de, _InFoulTerritoryText
.l00103:
;src/baseball/announcer.c:436: str_Append(location_text, str_buffer);
	ld	bc, _str_buffer
	jp	_str_Append
.l00105:
;src/baseball/announcer.c:437: }
	ret
;src/baseball/announcer.c:439: void AnnounceHitInAirToInfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceHitInAirToInfield
; ---------------------------------
_AnnounceHitInAirToInfield::
	add	sp, -6
	ld	hl, sp+5
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:440: const char* hit_text = HitPopUpText;
	ld	de, _HitPopUpText+0
;src/baseball/announcer.c:441: if (distance > 200) {
	ld	a, $C8
	sub	a, [hl]
	jr	NC, .l00107
;src/baseball/announcer.c:442: hit_text = HitLineDriveText;
	ld	de, _HitLineDriveText
	jr	.l00108
.l00107:
;src/baseball/announcer.c:444: else if (distance > 140) {
	ld	a, $8C
	ld	hl, sp+4
	sub	a, [hl]
	jr	NC, .l00104
;src/baseball/announcer.c:445: hit_text = HitGroundBallText;
	ld	de, _HitGroundBallText
	jr	.l00108
.l00104:
;src/baseball/announcer.c:447: else if (distance > 100) {
	ld	a, $64
	ld	hl, sp+4
	sub	a, [hl]
	jr	NC, .l00108
;src/baseball/announcer.c:448: hit_text = HitChopperText;
	ld	de, _HitChopperText
.l00108:
;src/baseball/announcer.c:450: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:452: AppendInfieldLocationTextByAngle(spray);
	ld	hl, sp+8
	ld	a, [hl]
	call	_AppendInfieldLocationTextByAngle
;src/baseball/announcer.c:453: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:455: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+8
	ld	e, [hl]
	ld	hl, sp+4
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:456: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
	ld	[hl], b
	ld	hl, sp+3
	dec	hl
	dec	hl
;src/baseball/announcer.c:457: unsigned char fielder_position = (char)(position_and_distance_from_ball & BALL_STATE_FIELDER);//position in first 4 bits of lower nibble
	ld	a,[hl]
	and	a, $0F
;src/baseball/announcer.c:458: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball >> 8);//distance in upper nibble
	ld	[hl], a
;src/baseball/announcer.c:459: ball_state |= fielder_position;
	ld	hl, _ball_state
	ld	a, [hl]
	ld	hl, sp+2
	or	a, [hl]
	ld	[hl], a
;src/baseball/announcer.c:460: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
	ld	hl, sp+9
	ld	e, [hl]
	ld	hl, sp+5
	ld	a, [hl]
	call	_HangTimeFromSpeedLaunchAngle
;src/baseball/announcer.c:461: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
	push	af
	inc	sp
	ld	hl, sp+4
	dec	hl
	ld	a,[hl]
	ld	e,a
	call	_AnnounceFieldingText
.l00109:
;src/baseball/announcer.c:462: }
	add	sp, 6
	pop	hl
	inc	sp
	inc	sp
	jp hl 
;src/baseball/announcer.c:464: void AppendInfieldLocationTextByAngle(signed char spray) {
;	---------------------------------
; Function AppendInfieldLocationTextByAngle
; ---------------------------------
_AppendInfieldLocationTextByAngle::
;src/baseball/announcer.c:466: if (spray >= -45 && spray <= 45) { //fair ball
	ld	c, a
	xor	a, $80
	sub	a, $53
	jr	C, .l00102
	ld	e, c
	ld	a, $2D
	ld	d, a
	ld	a, $2D
	sub	a, c
	bit	7, e
	jr	Z, .l00117
	bit	7, d
	jr	NZ, .l00118
	cp	a, a
	jr	.l00118
.l00117:
	bit	7, d
	jr	Z, .l00118
	scf
.l00118:
	jr	C, .l00102
;src/baseball/announcer.c:467: unsigned int index = (unsigned int)math_Divide((unsigned long)(spray+45), 11);
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
;src/baseball/announcer.c:468: location_text = str_FromArray(index, InfieldLocationTexts);
	ld	bc, _InfieldLocationTexts
	call	_str_FromArray
	ld	e, c
	ld	d, b
	jr	.l00103
.l00102:
;src/baseball/announcer.c:471: location_text = InFoulTerritoryText;
	ld	de, _InFoulTerritoryText
.l00103:
;src/baseball/announcer.c:473: str_Append(location_text, str_buffer);
	ld	bc, _str_buffer
	jp	_str_Append
.l00105:
;src/baseball/announcer.c:474: }
	ret
;src/baseball/announcer.c:476: void AnnounceBuntText(char launch, char spray) {
;	---------------------------------
; Function AnnounceBuntText
; ---------------------------------
_AnnounceBuntText::
;src/baseball/announcer.c:477: str_Copy(HitBuntText, tile_buffer);
	ld	bc, _tile_buffer
	ld	de, _HitBuntText
	call	_str_Copy
;src/baseball/announcer.c:478: str_Append(ToThePositionText, tile_buffer);
	ld	bc, _tile_buffer
	ld	de, _ToThePositionText
	call	_str_Append
;src/baseball/announcer.c:479: char* position_text = str_FromArray(1, PositionTexts);
	ld	bc, _PositionTexts
	ld	de, $0001
	call	_str_FromArray
;src/baseball/announcer.c:480: str_Replace(tile_buffer, str_buffer, position_text);
	push	bc
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Replace
;src/baseball/announcer.c:481: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:482: }
	ret
;src/baseball/announcer.c:484: void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
;	---------------------------------
; Function AnnounceFieldingText
; ---------------------------------
_AnnounceFieldingText::
	dec	sp
;src/baseball/announcer.c:485: int player = GetPositionPlayerAndName(position);//player in hl, name in name_buffer
	ld	[hl], e
	call	_GetPositionPlayerAndName
;src/baseball/announcer.c:486: int speed = GetPlayerSpeed(player);
	ld	e, c
	ld	d, b
	call	_GetPlayerSpeed
;src/baseball/announcer.c:487: int dist_covered = math_Multiply(speed, hang_time);//dist covered = player speed * hang time, doesn't affect bc
	ld	hl, sp+3
	ld	a, [hl]
	ld	e, c
	ld	d, b
	call	_math_Multiply
;src/baseball/announcer.c:488: if ((char)(dist_covered >> 8) > distance) {//if player speed * hang time > dist from player, caught
	ld	hl, sp+0
	ld	a, [hl]
	sub	a, b
	jp	NC, .l00106
;src/baseball/announcer.c:489: str_Replace(CaughtByText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _CaughtByText
	call	_str_Replace
;src/baseball/announcer.c:490: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:491: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:492: RevealTextAndWait(OutText);
	ld	de, _OutText
	call	_RevealTextAndWait
;src/baseball/announcer.c:493: unsigned char outs = IncrementOuts();
	call	_IncrementOuts
;src/baseball/announcer.c:494: if (outs == 3) AnnounceNextBatter();
	sub	a, $03
	jr	Z, .l00126
.l00125:
	jr	.l00102
.l00126:
	call	_AnnounceNextBatter
.l00102:
;src/baseball/announcer.c:495: return;
	jr	.l00108
.l00106:
;src/baseball/announcer.c:498: ball_state |= BALL_STATE_LANDED;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $40
;src/baseball/announcer.c:499: if ((ball_state & BALL_STATE_FAIR) == 0) {
	ld	[hl], a
	bit	5, a
	jr	Z, .l00128
.l00127:
	jr	.l00104
.l00128:
;src/baseball/announcer.c:500: AnnounceFoulBall();
	call	_AnnounceFoulBall
;src/baseball/announcer.c:501: return;
	jr	.l00108
.l00104:
;src/baseball/announcer.c:504: str_Replace(FieldedByText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _FieldedByText
	call	_str_Replace
;src/baseball/announcer.c:505: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:506: AnnounceNextBatter();
	call	_AnnounceNextBatter
.l00108:
;src/baseball/announcer.c:527: }
	inc	sp
	pop	hl
	inc	sp
	jp hl 
;src/baseball/announcer.c:529: void AnnounceFoulBall(void) {
;	---------------------------------
; Function AnnounceFoulBall
; ---------------------------------
_AnnounceFoulBall::
;src/baseball/announcer.c:530: FoulBall();
	call	_FoulBall
;src/baseball/announcer.c:532: RevealTextAndWait(HitFoulBallText);
	ld	de, _HitFoulBallText
	call	_RevealTextAndWait
;src/baseball/announcer.c:533: __asm__("TRAMPOLINE ShowBatter");
	TRAMPOLINE	ShowBatter
;src/baseball/announcer.c:534: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
.l00101:
;src/baseball/announcer.c:535: }
	ret
;src/baseball/announcer.c:537: void AnnounceAdvanceRunners(void) {
;	---------------------------------
; Function AnnounceAdvanceRunners
; ---------------------------------
_AnnounceAdvanceRunners::
;src/baseball/announcer.c:539: }
.l00101:
	ret
;src/baseball/announcer.c:541: void AnnounceRunnersOn(void) {
;	---------------------------------
; Function AnnounceRunnersOn
; ---------------------------------
_AnnounceRunnersOn::
;src/baseball/announcer.c:542: unsigned char index = 0;
	ld	e, $00
;src/baseball/announcer.c:545: if (runners_on_base & 0x000F) index |= 1; // First base
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $0F
	jr	Z, .l00102
.l00124:
	ld	e, $01
.l00102:
;src/baseball/announcer.c:546: if (runners_on_base & 0x00F0) index |= 2; // Second base
	ld	hl, _runners_on_base
	ld	a, [hl]
	and	a, $F0
	jr	Z, .l00104
.l00125:
	set	1, e
.l00104:
;src/baseball/announcer.c:547: if (runners_on_base & 0x0F00) index |= 4; // Third base
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	and	a, $0F
	jr	Z, .l00106
.l00126:
	set	2, e
.l00106:
;src/baseball/announcer.c:549: char* runners_text = str_FromArray(index, RunnersOnBaseTexts);
	ld	bc, _RunnersOnBaseTexts+0
	ld	d, $00
	call	_str_FromArray
;src/baseball/announcer.c:550: RevealTextAndWait(runners_text);
	ld	e, c
	ld	d, b
	jp	_RevealTextAndWait
.l00107:
;src/baseball/announcer.c:551: }
	ret
;src/baseball/announcer.c:554: void AnnounceRunScored(void) {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
;	---------------------------------
; Function AnnounceRunScored
; ---------------------------------
_AnnounceRunScored::
;src/baseball/announcer.c:555: unsigned char scoring_runner = (char)(runners_on_base >> 12);
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	swap	a
	and	a, $0F
	ld	c, a
	ld	b, $00
;src/baseball/announcer.c:556: if (scoring_runner == 0) return;
	ld	a, c
	or	a, a
	jp	Z,.l00112
.l00102:
;src/baseball/announcer.c:558: runners_on_base &= 0b0000111111111111;
	ld	hl, _runners_on_base + 1
	ld	a, [hl]
	and	a, $0F
	ld	[hl], a
;src/baseball/announcer.c:559: scoring_runner--;
	ld	b, c
	dec	b
;src/baseball/announcer.c:560: if (IsUserFielding() == 0) {// user is batting
	push	bc
	call	_IsUserFielding
	pop	bc
;src/baseball/announcer.c:561: if (home_team == 0) away_score++;
	ld	hl, _away_score
	ld	c, [hl]
	inc	c
;src/baseball/announcer.c:562: else home_score++;
	ld	hl, _home_score
	ld	e, [hl]
	inc	e
;src/baseball/announcer.c:560: if (IsUserFielding() == 0) {// user is batting
	or	a, a
	jr	NZ, .l00110
;src/baseball/announcer.c:561: if (home_team == 0) away_score++;
	ld	hl, _home_team
	ld	a, [hl]
	or	a, a
	jr	NZ, .l00104
	ld	hl, _away_score
	ld	[hl], c
	jr	.l00105
.l00104:
;src/baseball/announcer.c:562: else home_score++;
	ld	[hl], e
.l00105:
;src/baseball/announcer.c:563: unsigned int player = GetUserPlayerInLineup(scoring_runner);
	ld	a, b
	call	_GetUserPlayerInLineup
;src/baseball/announcer.c:564: GetUserPlayerName(player);
	ld	e, c
	ld	d, b
	call	_GetUserPlayerName
	jr	.l00111
.l00110:
;src/baseball/announcer.c:567: if (home_team == 0) home_score++;
	ld	hl, _home_team
	ld	a, [hl]
	or	a, a
	jr	NZ, .l00107
	ld	hl, _home_score
	ld	[hl], e
	jr	.l00108
.l00107:
;src/baseball/announcer.c:568: else away_score++;
	ld	[hl], c
.l00108:
;src/baseball/announcer.c:570: unsigned int player = GetOpposingPlayerInLineup(scoring_runner);//TODO: make return structs
	ld	a, b
	call	_GetOpposingPlayerInLineup
;src/baseball/announcer.c:571: GetPlayerName(1);
	ld	a, $01
	call	_GetPlayerName
.l00111:
;src/baseball/announcer.c:573: __asm__("TRAMPOLINE DrawScore");
	TRAMPOLINE	DrawScore
;src/baseball/announcer.c:574: str_Copy(name_buffer, str_buffer);
	ld	bc, _str_buffer
	ld	de, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:575: str_Append(PlayerScoresText, str_buffer);
	ld	bc, _str_buffer
	ld	de, _PlayerScoresText
	call	_str_Append
;src/baseball/announcer.c:576: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00112:
;src/baseball/announcer.c:577: }
	ret
;src/baseball/announcer.c:579: void AnnounceEndOfGame(void) {
;	---------------------------------
; Function AnnounceEndOfGame
; ---------------------------------
_AnnounceEndOfGame::
;src/baseball/announcer.c:581: RevealTextAndWait(AndThatsTheBallGameText);
	ld	de, _AndThatsTheBallGameText
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:582: }
	ret
	SECTION FRAGMENT "src/baseball/announcer.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
