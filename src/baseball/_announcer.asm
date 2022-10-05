;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.2.8 #13684 (MINGW64)
;--------------------------------------------------------
	; MODULE announcer
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _GetMoveName
	EXPORT _GetClosestFielderByLocation
	EXPORT _LocationFromDistSprayAngle
	EXPORT _AdvanceRunners
	EXPORT _CurrentOrderInLineup
	EXPORT _HangTimeFromSpeedLaunchAngle
	EXPORT _DistanceFromSpeedLaunchAngle
	EXPORT _IncrementOuts
	EXPORT _CheckStrike
	EXPORT _SetStrikes
	EXPORT _GetStrikes
	EXPORT _SetBalls
	EXPORT _GetBalls
	EXPORT _str_Number
	EXPORT _str_Replace
	EXPORT _str_Append
	EXPORT _str_Copy
	EXPORT _str_FromArray
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
	EXPORT _AnnounceNoSwing
	EXPORT _AnnounceWildPitchOrPassedBall
	EXPORT _AnnounceSwingMiss
	EXPORT __AnnounceSwingContact
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
;src/baseball/announcer.c:169: void AnnouncePitcher(void) {
;	---------------------------------
; Function AnnouncePitcher
; ---------------------------------
_AnnouncePitcher::
;src/baseball/announcer.c:173: __endasm;
	TRAMPOLINE	ShowPitcher
	TRAMPOLINE	GetCurrentPitcherName
;src/baseball/announcer.c:174: str_Replace(TakesTheMoundText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _TakesTheMoundText
	call	_str_Replace
;src/baseball/announcer.c:175: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:176: }
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
;src/baseball/announcer.c:178: void AnnounceBatter(void) {
;	---------------------------------
; Function AnnounceBatter
; ---------------------------------
_AnnounceBatter::
;src/baseball/announcer.c:183: __endasm;
	TRAMPOLINE	DrawCountOutsInning
	TRAMPOLINE	ShowBatter
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:184: str_Replace(WalksToThePlateText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalksToThePlateText
	call	_str_Replace
;src/baseball/announcer.c:185: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:186: }
	ret
;src/baseball/announcer.c:195: void AnnounceBeginningOfFrame(void) {
;	---------------------------------
; Function AnnounceBeginningOfFrame
; ---------------------------------
_AnnounceBeginningOfFrame::
;src/baseball/announcer.c:196: char* inning_text = str_FromArray(frame>>1, InningTexts);
	ld	bc, _InningTexts+0
	ld	hl, _frame
	ld	e, [hl]
	srl	e
	ld	d, $00
	call	_str_FromArray
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:197: str_Copy(inning_text, name_buffer);
	ld	bc, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:198: const char* top_bottom_text = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
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
;src/baseball/announcer.c:199: str_Replace(top_bottom_text, str_buffer, name_buffer);
	ld	bc, _name_buffer
	push	bc
	ld	bc, _str_buffer
	call	_str_Replace
;src/baseball/announcer.c:200: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:201: AnnouncePitcher();
	call	_AnnouncePitcher
;src/baseball/announcer.c:202: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:203: }
	ret
;src/baseball/announcer.c:205: void AnnouncePitcherSets(void) {
;	---------------------------------
; Function AnnouncePitcherSets
; ---------------------------------
_AnnouncePitcherSets::
;src/baseball/announcer.c:208: __endasm;
	TRAMPOLINE	GetCurrentPitcherName
;src/baseball/announcer.c:209: str_Replace(PitcherSetsText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _PitcherSetsText
	call	_str_Replace
;src/baseball/announcer.c:210: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:211: }
	ret
;src/baseball/announcer.c:213: void AnnounceAndThePitch(void) {
;	---------------------------------
; Function AnnounceAndThePitch
; ---------------------------------
_AnnounceAndThePitch::
;src/baseball/announcer.c:214: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, AndThePitchText);
	ld	de, _AndThePitchText
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:215: }
	ret
;src/baseball/announcer.c:217: void AnnouncePitchName(void) {
;	---------------------------------
; Function AnnouncePitchName
; ---------------------------------
_AnnouncePitchName::
;src/baseball/announcer.c:218: GetMoveName(pitch_move_id);//"PITCH_NAME" in name_buffer
	ld	hl, _pitch_move_id
	ld	a, [hl]
	call	_GetMoveName
;src/baseball/announcer.c:219: str_Copy(AndThePitchText, str_buffer);//"And the pitch.""
	ld	bc, _str_buffer
	ld	de, _AndThePitchText
	call	_str_Copy
;src/baseball/announcer.c:220: str_Replace(ThrewAPitchText, tile_buffer, name_buffer);//"\nA PITCH_NAME."
	ld	de, _name_buffer
	push	de
	ld	bc, _tile_buffer
	ld	de, _ThrewAPitchText
	call	_str_Replace
;src/baseball/announcer.c:221: str_Append(tile_buffer, str_buffer);//"And the pitch.\nA PITCH_NAME."
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Append
;src/baseball/announcer.c:222: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:223: }
	ret
;src/baseball/announcer.c:225: void AnnounceNextBatter(void) {
;	---------------------------------
; Function AnnounceNextBatter
; ---------------------------------
_AnnounceNextBatter::
;src/baseball/announcer.c:226: SetBalls(0);
	xor	a, a
	call	_SetBalls
;src/baseball/announcer.c:227: SetStrikes(0);
	xor	a, a
	call	_SetStrikes
;src/baseball/announcer.c:228: __asm__("TRAMPOLINE NextBatter");
	TRAMPOLINE	NextBatter
;src/baseball/announcer.c:229: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:230: }
	ret
;src/baseball/announcer.c:232: void AnnounceBatterStepsIntoBox(void) {
;	---------------------------------
; Function AnnounceBatterStepsIntoBox
; ---------------------------------
_AnnounceBatterStepsIntoBox::
;src/baseball/announcer.c:233: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:234: str_Replace(BatterStepsIntoTheBoxText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BatterStepsIntoTheBoxText
	call	_str_Replace
;src/baseball/announcer.c:235: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:236: }
	ret
;src/baseball/announcer.c:245: void AnnounceNoSwing(void) {
;	---------------------------------
; Function AnnounceNoSwing
; ---------------------------------
_AnnounceNoSwing::
;src/baseball/announcer.c:247: if (CheckStrike()) { //strike
	call	_CheckStrike
	ld	c, a
	or	a, a
	jp	Z, .l00110
;src/baseball/announcer.c:248: unsigned char strikes = GetStrikes();
	call	_GetStrikes
;src/baseball/announcer.c:249: if (strikes < 2) {
	cp	a, $02
	jp	NC, .l00104
;src/baseball/announcer.c:250: SetStrikes(++strikes);
	ld	c, a
	inc	c
	push	bc
	ld	a, c
	call	_SetStrikes
	pop	bc
;src/baseball/announcer.c:251: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:252: str_Number(strikes);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:253: str_Replace(StrikeText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeText
	call	_str_Replace
;src/baseball/announcer.c:254: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00104:
;src/baseball/announcer.c:257: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:258: str_Replace(StrikeOutLookingText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeOutLookingText
	call	_str_Replace
;src/baseball/announcer.c:259: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:260: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:261: if (IncrementOuts() < 3) {
	call	_IncrementOuts
	sub	a, $03
	jp	NC, .l00112
;src/baseball/announcer.c:262: AnnounceNextBatter();
	jp	_AnnounceNextBatter
	jp	.l00112
.l00110:
;src/baseball/announcer.c:267: unsigned char balls = GetBalls();
	call	_GetBalls
;src/baseball/announcer.c:268: if (balls < 3) {
	cp	a, $03
	jp	NC, .l00107
;src/baseball/announcer.c:269: SetBalls(++balls);
	ld	c, a
	inc	c
	push	bc
	ld	a, c
	call	_SetBalls
	pop	bc
;src/baseball/announcer.c:270: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:271: str_Number(balls);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:272: str_Replace(BallText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BallText
	call	_str_Replace
;src/baseball/announcer.c:273: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00107:
;src/baseball/announcer.c:276: __asm__("TRAMPOLINE PutBatterOnFirst");
	TRAMPOLINE	PutBatterOnFirst
;src/baseball/announcer.c:277: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:278: str_Replace(WalkText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalkText
	call	_str_Replace
;src/baseball/announcer.c:279: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:280: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:281: AnnounceRunScored();
	call	_AnnounceRunScored
;src/baseball/announcer.c:282: AnnounceNextBatter();
	jp	_AnnounceNextBatter
.l00112:
;src/baseball/announcer.c:285: }
	ret
;src/baseball/announcer.c:287: void AnnounceWildPitchOrPassedBall(void) {
;	---------------------------------
; Function AnnounceWildPitchOrPassedBall
; ---------------------------------
_AnnounceWildPitchOrPassedBall::
;src/baseball/announcer.c:290: }
.l00101:
	ret
;src/baseball/announcer.c:299: void AnnounceSwingMiss(void) {
;	---------------------------------
; Function AnnounceSwingMiss
; ---------------------------------
_AnnounceSwingMiss::
	dec	sp
;src/baseball/announcer.c:302: char strikes = GetStrikes();
	call	_GetStrikes
	ld	hl, sp+0
;src/baseball/announcer.c:303: if (strikes < 2) {
	ld	[hl], a
	sub	a, $02
	jp	NC, .l00104
;src/baseball/announcer.c:304: SetStrikes(++strikes);
	ld	c, [hl]
	inc	c
	push	bc
	ld	a, c
	call	_SetStrikes
	pop	bc
;src/baseball/announcer.c:305: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:306: str_Number(strikes);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:307: str_Replace(StrikeText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeText
	call	_str_Replace
;src/baseball/announcer.c:308: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	inc	sp
	jp	_RevealTextAndWait
	jp	.l00106
.l00104:
;src/baseball/announcer.c:311: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:312: str_Replace(StrikeOutSwingingText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeOutSwingingText
	call	_str_Replace
;src/baseball/announcer.c:313: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:314: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:315: if (IncrementOuts() < 3) {
	call	_IncrementOuts
	sub	a, $03
	jr	NC, .l00106
;src/baseball/announcer.c:316: AnnounceNextBatter();
	inc	sp
	jp	_AnnounceNextBatter
.l00106:
;src/baseball/announcer.c:319: }
	inc	sp
	ret
;src/baseball/announcer.c:322: void _AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function _AnnounceSwingContact
; ---------------------------------
__AnnounceSwingContact::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:325: ball_state = BALL_STATE_IN_PLAY;
	ld	hl, _ball_state
	ld	[hl], $10
;src/baseball/announcer.c:327: if (spray > -45 && spray < 45) {
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
;src/baseball/announcer.c:328: ball_state |= BALL_STATE_FAIR; 
	ld	[hl], $30
.l00102:
;src/baseball/announcer.c:331: if (launch > 0) {
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
;src/baseball/announcer.c:332: AnnounceHitInAir(speed, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	ld	e, b
	ld	a, c
	call	_AnnounceHitInAir
	jr	.l00107
.l00105:
;src/baseball/announcer.c:335: ball_state |= BALL_STATE_LANDED;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $40
	ld	[hl], a
;src/baseball/announcer.c:336: AnnounceHitOnGround(speed, spray);
	ld	e, b
	ld	a, c
	call	_AnnounceHitOnGround
.l00107:
;src/baseball/announcer.c:338: }
	pop	hl
	inc	sp
	jp	hl
;src/baseball/announcer.c:340: void AnnounceHitOnGround(char speed, char spray) {
;	---------------------------------
; Function AnnounceHitOnGround
; ---------------------------------
_AnnounceHitOnGround::
;src/baseball/announcer.c:342: }
.l00101:
	ret
;src/baseball/announcer.c:344: void AnnounceHitInAir(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceHitInAir
; ---------------------------------
_AnnounceHitInAir::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:345: unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	ld	a, c
	call	_DistanceFromSpeedLaunchAngle
	pop	bc
;src/baseball/announcer.c:346: if (distance < 100) {//infield
	ld	e, a
	sub	a, $64
	jr	NC, .l00102
;src/baseball/announcer.c:347: AnnounceHitInAirToInfield(speed, distance, spray, launch);
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
;src/baseball/announcer.c:350: AnnounceHitInAirToOutfield(speed, distance, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, c
	call	_AnnounceHitInAirToOutfield
.l00104:
;src/baseball/announcer.c:352: }
	pop	hl
	inc	sp
	jp	hl
;src/baseball/announcer.c:354: void AnnounceHitInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {   
;	---------------------------------
; Function AnnounceHitInAirToOutfield
; ---------------------------------
_AnnounceHitInAirToOutfield::
	dec	sp
	dec	sp
	ld	hl, sp+1
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:357: if (distance > 240) { //out of play
	ld	a, $F0
	sub	a, [hl]
	jp	NC, .l00104
;src/baseball/announcer.c:358: if (ball_state & BALL_STATE_FAIR != 0) { //home run
	push	hl
	ld	hl, _ball_state
	bit	0, [hl]
	pop	hl
	jp	Z,.l00102
.l00147:
;src/baseball/announcer.c:359: unsigned char order = CurrentOrderInLineup();
	call	_CurrentOrderInLineup
;src/baseball/announcer.c:360: unsigned char runs_scored = AdvanceRunners(4, ++order);//current batter is 0 to 8, needs to be 1 to 9
	ld	e, a
	inc	e
	ld	a, $04
	call	_AdvanceRunners
;src/baseball/announcer.c:361: const char* home_run_text = (runs_scored == 4) ? HitGrandSlamText : HitHomeRunText;
	sub	a, $04
	jr	Z, .l00149
.l00148:
	jr	.l00115
.l00149:
	ld	de, _HitGrandSlamText+0
	jr	.l00116
.l00115:
	ld	de, _HitHomeRunText+0
.l00116:
;src/baseball/announcer.c:362: RevealTextAndWait(home_run_text);
	call	_RevealTextAndWait
;src/baseball/announcer.c:363: __asm__("TRAMPOLINE DrawScore");
	TRAMPOLINE	DrawScore
;src/baseball/announcer.c:364: AnnounceNextBatter();
	call	_AnnounceNextBatter
;src/baseball/announcer.c:365: return;
	jr	.l00113
.l00102:
;src/baseball/announcer.c:369: AnnounceFoulBall();
	call	_AnnounceFoulBall
;src/baseball/announcer.c:370: return;
	jr	.l00113
.l00104:
;src/baseball/announcer.c:373: const char* hit_text = HitPopFlyText;
	ld	de, _HitPopFlyText+0
;src/baseball/announcer.c:374: if (distance > 220) {
	ld	a, $DC
	ld	hl, sp+0
	sub	a, [hl]
	jr	NC, .l00111
;src/baseball/announcer.c:375: hit_text = HitDeepFlyBallText;
	ld	de, _HitDeepFlyBallText
	jr	.l00112
.l00111:
;src/baseball/announcer.c:377: else if (distance > 180) {
	ld	a, $B4
	ld	hl, sp+0
	sub	a, [hl]
	jr	NC, .l00108
;src/baseball/announcer.c:378: hit_text = HitFlyBallText;
	ld	de, _HitFlyBallText
	jr	.l00112
.l00108:
;src/baseball/announcer.c:380: else if (distance > 140) {
	ld	a, $8C
	ld	hl, sp+0
	sub	a, [hl]
	jr	NC, .l00112
;src/baseball/announcer.c:381: hit_text = HitShallowFlyBallText;
	ld	de, _HitShallowFlyBallText
.l00112:
;src/baseball/announcer.c:383: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:384: AppendOutfieldLocationTextByAngle(spray);
	ld	hl, sp+4
	ld	a, [hl]
	call	_AppendOutfieldLocationTextByAngle
;src/baseball/announcer.c:385: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:387: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+4
	ld	e, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:390: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
;src/baseball/announcer.c:391: unsigned char fielder_position = (char)((position_and_distance_from_ball >> 8) & BALL_STATE_FIELDER);//position in first 4 bits of upper nibble
	ld	a, b
	and	a, $0F
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/baseball/announcer.c:392: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball & 255);//distance in lower nibble
;src/baseball/announcer.c:393: ball_state |= fielder_position;
	push	hl
	ld	hl, _ball_state
	ld	a, [hl]
	pop	hl
	or	a, l
	ld	[_ball_state], a
;src/baseball/announcer.c:395: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
	push	hl
	push	bc
	push	hl
	ld	hl, sp+11
	ld	e, [hl]
	ld	hl, sp+7
	ld	a, [hl]
	pop	hl
	call	_HangTimeFromSpeedLaunchAngle
	pop	bc
	pop	hl
;src/baseball/announcer.c:396: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
	push	af
	inc	sp
	ld	e, c
	ld	a, l
	call	_AnnounceFieldingText
.l00113:
;src/baseball/announcer.c:397: }
	inc	sp
	inc	sp
	pop	hl
	pop	af
	jp	hl
;src/baseball/announcer.c:399: void AppendOutfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
;	---------------------------------
; Function AppendOutfieldLocationTextByAngle
; ---------------------------------
_AppendOutfieldLocationTextByAngle::
	dec	sp
	dec	sp
	ld	c, a
;src/baseball/announcer.c:400: const char* location_text = InFoulTerritoryText;
	ld	hl, sp+0
	inc	hl
	ld	a, LOW(_InFoulTerritoryText)
	ld	[hl], a
	ld	a, HIGH(_InFoulTerritoryText)
	ld	[hl], a
;src/baseball/announcer.c:401: if (spray <= -45 && spray >= 45) { //fair ball
	ld	e, c
	ld	a, $D3
	ld	d, a
	ld	a, $D3
	sub	a, c
	bit	7, e
	jr	Z, .l00116
	bit	7, d
	jr	NZ, .l00117
	cp	a, a
	jr	.l00117
.l00116:
	bit	7, d
	jr	Z, .l00117
	scf
.l00117:
	jr	C, .l00102
	ld	a, c
	xor	a, $80
	sub	a, $AD
	jr	C, .l00102
;src/baseball/announcer.c:402: spray += 46;
	ld	a, c
	add	a, $2E
;src/baseball/announcer.c:403: unsigned int index = (unsigned int)math_Divide(spray, 15);
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	e, a
	ld	d, a
	ld	a, $0F
	push	af
	inc	sp
	call	_math_Divide
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:404: location_text = str_FromArray(index, OutfieldLocationTexts);
	ld	bc, _OutfieldLocationTexts
	call	_str_FromArray
	pop	de
	push	bc
.l00102:
;src/baseball/announcer.c:406: str_Append(location_text, str_buffer);
	ld	bc, _str_buffer
	pop	de
	jp	_str_Append
.l00104:
;src/baseball/announcer.c:407: }
	inc	sp
	inc	sp
	ret
;src/baseball/announcer.c:409: void AnnounceHitInAirToInfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {  
;	---------------------------------
; Function AnnounceHitInAirToInfield
; ---------------------------------
_AnnounceHitInAirToInfield::
	add	sp, -6
	ld	hl, sp+5
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:410: const char* hit_text = HitPopUpText;
	ld	de, _HitPopUpText+0
;src/baseball/announcer.c:411: if (distance > 200) {
	ld	a, $C8
	sub	a, [hl]
	jr	NC, .l00107
;src/baseball/announcer.c:412: hit_text = HitLineDriveText;
	ld	de, _HitLineDriveText
	jr	.l00108
.l00107:
;src/baseball/announcer.c:414: else if (distance > 140) {
	ld	a, $8C
	ld	hl, sp+4
	sub	a, [hl]
	jr	NC, .l00104
;src/baseball/announcer.c:415: hit_text = HitGroundBallText;
	ld	de, _HitGroundBallText
	jr	.l00108
.l00104:
;src/baseball/announcer.c:417: else if (distance > 100) {
	ld	a, $64
	ld	hl, sp+4
	sub	a, [hl]
	jr	NC, .l00108
;src/baseball/announcer.c:418: hit_text = HitChopperText;
	ld	de, _HitChopperText
.l00108:
;src/baseball/announcer.c:420: str_Copy(hit_text, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:422: AppendInfieldLocationTextByAngle(spray);
	ld	hl, sp+8
	ld	a, [hl]
	call	_AppendInfieldLocationTextByAngle
;src/baseball/announcer.c:423: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:425: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+8
	ld	e, [hl]
	ld	hl, sp+4
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:428: unsigned int position_and_distance_from_ball = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
	ld	[hl], b
	ld	hl, sp+2
;src/baseball/announcer.c:429: unsigned char fielder_position = (char)((position_and_distance_from_ball >> 8) & BALL_STATE_FIELDER);//position in first 4 bits of upper nibble
	ld	a, [hl]
	and	a, $0F
;src/baseball/announcer.c:430: unsigned char fielder_dist_from_ball = (char)(position_and_distance_from_ball & 255);//distance in lower nibble
;src/baseball/announcer.c:431: ball_state |= fielder_position;
	ld	[hl], a
	ld	hl, sp+2
	or	a, [hl]
	ld	[hl], a
;src/baseball/announcer.c:433: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
	ld	hl, sp+9
	ld	e, [hl]
	ld	hl, sp+5
	ld	a, [hl]
	call	_HangTimeFromSpeedLaunchAngle
;src/baseball/announcer.c:434: AnnounceFieldingText(fielder_position, fielder_dist_from_ball, hang_time);
	push	af
	inc	sp
	ld	hl, sp+4
	dec	hl
	ld	a,[hl]
	ld	e,a
	call	_AnnounceFieldingText
.l00109:
;src/baseball/announcer.c:435: }
	add	sp, 6
	pop	hl
	pop	af
	jp	hl
;src/baseball/announcer.c:437: void AppendInfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
;	---------------------------------
; Function AppendInfieldLocationTextByAngle
; ---------------------------------
_AppendInfieldLocationTextByAngle::
;src/baseball/announcer.c:459: }
.l00101:
	ret
;src/baseball/announcer.c:461: void AnnounceBuntText(char launch, char spray) {
;	---------------------------------
; Function AnnounceBuntText
; ---------------------------------
_AnnounceBuntText::
;src/baseball/announcer.c:486: }
.l00101:
	ret
;src/baseball/announcer.c:488: void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
;	---------------------------------
; Function AnnounceFieldingText
; ---------------------------------
_AnnounceFieldingText::
;src/baseball/announcer.c:559: }
.l00101:
	pop	hl
	inc	sp
	jp	hl
;src/baseball/announcer.c:561: void AnnounceFoulBall(void) {
;	---------------------------------
; Function AnnounceFoulBall
; ---------------------------------
_AnnounceFoulBall::
;src/baseball/announcer.c:569: }
.l00101:
	ret
;src/baseball/announcer.c:571: void AnnounceAdvanceRunners(void) {
;	---------------------------------
; Function AnnounceAdvanceRunners
; ---------------------------------
_AnnounceAdvanceRunners::
;src/baseball/announcer.c:573: }
.l00101:
	ret
;src/baseball/announcer.c:575: void AnnounceRunnersOn(void) {
;	---------------------------------
; Function AnnounceRunnersOn
; ---------------------------------
_AnnounceRunnersOn::
;src/baseball/announcer.c:577: }
.l00101:
	ret
;src/baseball/announcer.c:580: void AnnounceRunScored(void) {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
;	---------------------------------
; Function AnnounceRunScored
; ---------------------------------
_AnnounceRunScored::
;src/baseball/announcer.c:644: }
.l00101:
	ret
;src/baseball/announcer.c:646: void AnnounceEndOfGame(void) {
;	---------------------------------
; Function AnnounceEndOfGame
; ---------------------------------
_AnnounceEndOfGame::
;src/baseball/announcer.c:648: RevealTextAndWait(AndThatsTheBallGameText);
	ld	de, _AndThatsTheBallGameText
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:649: }
	ret
	SECTION FRAGMENT "src/baseball/announcer.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
