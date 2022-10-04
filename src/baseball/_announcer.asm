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
;src/baseball/announcer.c:167: void AnnouncePitcher(void) {
;	---------------------------------
; Function AnnouncePitcher
; ---------------------------------
_AnnouncePitcher::
;src/baseball/announcer.c:171: __endasm;
	TRAMPOLINE	ShowPitcher
	TRAMPOLINE	GetCurrentPitcherName
;src/baseball/announcer.c:172: str_Replace(TakesTheMoundText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _TakesTheMoundText
	call	_str_Replace
;src/baseball/announcer.c:173: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:174: }
	ret
_PositionTexts:
	DB "lanzador"
	DB $00
	DB "receptor"
	DB $00
	DB "initialista"
	DB $00
	DB "intermedista"
	DB $00
	DB "antesalista"
	DB $00
	DB "campocorto"
	DB $00
	DB "jardinero izquierdo"
	DB $00
	DB "jardinero central"
	DB $00
	DB "jardinero derecho"
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
	DB "primero"
	DB $00
	DB "segundo"
	DB $00
	DB "tercera"
	DB $00
	DB "el home"
	DB $00
_TakesTheMoundText:
	DB "%s en el"
	DB $80
	DB "mont[culo"
	DB $00
_WalksToThePlateText:
	DB "%s se acerca"
	DB $80
	DB "al plato."
	DB $00
_BatterStepsIntoTheBoxText:
	DB "%s pasos"
	DB $80
	DB "into la caja."
	DB $00
_PitcherSetsText:
	DB "%s conjuntos."
	DB $00
_AndThePitchText:
	DB "Y el tono."
	DB $00
_ThrewAPitchText:
	DB $80
	DB "Un %s."
	DB $00
_EarlySwingText:
	DB "Swing temprano."
	DB $00
_LateSwingText:
	DB "Swing tard[o."
	DB $00
_SwingAndMissText:
	DB "Swing y una se~orita."
	DB $00
_HitBarrelText:
	DB "Realmente tengo el"
	DB $80
	DB "barrel en ese."
	DB $00
_HitDeepFlyBallText:
	DB "Bola de mosca profunda"
	DB $00
_HitFlyBallText:
	DB "Pelota voladora"
	DB $00
_HitShallowFlyBallText:
	DB "Mosca poco profunda"
	DB $00
_HitPopFlyText:
	DB "Mosca"
	DB $00
_OutfieldLocationTexts:
	DB "Abajo"
	DB $80
	DB "the <LF> <LF> l[nea."
	DB $00
	DB "a"
	DB $80
	DB "jard[n izquierdo."
	DB $00
	DB "a"
	DB $80
	DB "centro izquierda."
	DB $00
	DB "a"
	DB $80
	DB "jardin centro."
	DB $00
	DB "a"
	DB $80
	DB "centro derecho"
	DB $00
	DB "a"
	DB $80
	DB "jard[n derecho."
	DB $00
	DB "Abajo"
	DB $80
	DB "the <RF> l[nea."
	DB $00
_HitLineDriveText:
	DB "L[nea de l[nea"
	DB $00
_HitGroundBallText:
	DB "Bola de tierra"
	DB $00
_HitChopperText:
	DB "Un helic_ptero"
	DB $00
_HitPopUpText:
	DB "Aparecido"
	DB $00
_HitBuntText:
	DB "Buntado"
	DB $00
_InfieldLocationTexts:
	DB "abajo"
	DB $80
	DB "el<3B> l[nea"
	DB $00
	DB "nto tercero."
	DB $00
	DB "Nin el hoyo <SS> -<3B>."
	DB $00
	DB "nto corto."
	DB $00
	DB "nup the Middle."
	DB $00
	DB "nto segundo."
	DB $00
	DB "Nin el hoyo  <1B>-<2B>."
	DB $00
	DB "nto primero."
	DB $00
	DB "abajo"
	DB $80
	DB "el <1B> l[nea"
	DB $00
_ToThePositionText:
	DB "al"
	DB $80
	DB "%s."
	DB $00
_CaughtByText:
	DB "%s hace la captura."
	DB $00
_LeapingCatchByText:
	DB "%s salta"
	DB $80
	DB " y lo engancha."
	DB $00
_DivingCatchByText:
	DB "%s con"
	DB $80
	DB "the Diving Grab."
	DB $00
_FieldedByText:
	DB "Filentado por"
	DB $80
	DB "%s."
	DB $00
_OffTheGloveOfText:
	DB "Fuera del guante de"
	DB $80
	DB "%s."
	DB $00
_BobbledByText:
	DB "Bobado por"
	DB $80
	DB "%s."
	DB $00
_BadThrowByText:
	DB "Un mal lanzamiento"
	DB $80
	DB "from %s."
	DB $00
_ThrowsToText:
	DB "Lanza a %s."
	DB $00
_PlacesTheTagText:
	DB "%s"
	DB $80
	DB "places la etiqueta."
	DB $00
_DeadBallText:
	DB "{Pelota muerta!"
	DB $00
_StrikeText:
	DB "{Huelgas!"
	DB $00
_StrikeOutLookingText:
	DB "%s huelga"
	DB $80
	DB "out mirando!"
	DB $00
_StrikeOutSwingingText:
	DB "%s huelga"
	DB $80
	DB "out balance`ndose!"
	DB $00
_BallText:
	DB "Bola %s."
	DB $00
_WalkText:
	DB "%s en la base"
	DB $80
	DB " con una caminata."
	DB $00
_PassedBallText:
	DB "{Pasb_l!"
	DB $00
_WildPitchText:
	DB "{Lanzamiento"
	DB $80
	DB "salvaje!"
	DB $00
_HitByPitchText:
	DB "Eso lo golpe_, por lo que"
	DB $80
	DB "%s est` en <1B>."
	DB $00
_BenchesClearText:
	DB "Y los bancos despejados."
	DB $00
_RunnersOnBaseTexts:
	DB "Nadie en la base."
	DB $00
	DB "Runner en primero."
	DB $00
	DB "Corredor en segundo."
	DB $00
	DB "Corredores en el primer segundo."
	DB $00
	DB "Corredor en tercero."
	DB $00
	DB "Corredores en el primer"
	DB $80
	DB "y tercero."
	DB $00
	DB "Corredores en el segundo"
	DB $80
	DB "y tercero."
	DB $00
	DB "Bases cargadas."
	DB $00
_TaggingFromTexts:
	DB "%s etiquetas desde primero."
	DB $00
	DB "%s ser` de segundo."
	DB $00
	DB "Etiquetado de tercero"
	DB $80
	DB "is %s."
	DB $00
_SafeText:
	DB "{Seguro!"
	DB $00
_OutText:
	DB "{Afuera!"
	DB $00
_DoublePlayText:
	DB "{Doble jugada!"
	DB $00
_TriplePlayText:
	DB "{Juego triple!"
	DB $00
_HitFoulTipText:
	DB "Consejo sucio."
	DB $00
_HitFoulBackText:
	DB "Flolled de regreso."
	DB $00
_HitFoulBallText:
	DB "{Bola de falta!"
	DB $00
_InFoulTerritoryText:
	DB "en el territorio de"
	DB $80
	DB "foul."
	DB $00
_HitBaseHitText:
	DB "{Indiscutible!"
	DB $00
_HitDoubleText:
	DB "{Doble!"
	DB $00
_HitTripleText:
	DB "{Triple!"
	DB $00
_HitHomeRunText:
	DB "{Jonr_n!"
	DB $00
_HitGrandSlamText:
	DB "GRAND SLAM!"
	DB $00
_CriticalHitText:
	DB "{Impacto cr[tico!"
	DB $00
_PlayerScoresText:
	DB " puntuaciones."
	DB $00
_TwoPlayersScoreText:
	DB " y puntaje"
	DB $80
	DB "%s."
	DB $00
_BasesClearedScoreText:
	DB "Y eso borra las bases."
	DB $00
_BottomOfTheText:
	DB "Inferior de"
	DB $80
	DB "t %s."
	DB $00
_TopOfTheText:
	DB "Superior de"
	DB $80
	DB "the %s."
	DB $00
_AndThatsTheBallGameText:
	DB "Y ese es el juego"
	DB $80
	DB "ball."
	DB $00
;src/baseball/announcer.c:176: void AnnounceBatter(void) {
;	---------------------------------
; Function AnnounceBatter
; ---------------------------------
_AnnounceBatter::
;src/baseball/announcer.c:181: __endasm;
	TRAMPOLINE	DrawCountOutsInning
	TRAMPOLINE	ShowBatter
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:182: str_Replace(WalksToThePlateText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalksToThePlateText
	call	_str_Replace
;src/baseball/announcer.c:183: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:184: }
	ret
;src/baseball/announcer.c:193: void AnnounceBeginningOfFrame(void) {
;	---------------------------------
; Function AnnounceBeginningOfFrame
; ---------------------------------
_AnnounceBeginningOfFrame::
;src/baseball/announcer.c:194: char* inningText = str_FromArray(frame>>1, InningTexts);
	ld	bc, _InningTexts+0
	ld	hl, _frame
	ld	e, [hl]
	srl	e
	ld	d, $00
	call	_str_FromArray
	ld	e, c
	ld	d, b
;src/baseball/announcer.c:195: str_Copy(inningText, name_buffer);
	ld	bc, _name_buffer
	call	_str_Copy
;src/baseball/announcer.c:196: const char* topBottomText = (frame % 2 == 0) ? TopOfTheText : BottomOfTheText;
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
;src/baseball/announcer.c:197: str_Replace(topBottomText, str_buffer, name_buffer);
	ld	bc, _name_buffer
	push	bc
	ld	bc, _str_buffer
	call	_str_Replace
;src/baseball/announcer.c:198: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:199: AnnouncePitcher();
	call	_AnnouncePitcher
;src/baseball/announcer.c:200: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:201: }
	ret
;src/baseball/announcer.c:203: void AnnouncePitcherSets(void) {
;	---------------------------------
; Function AnnouncePitcherSets
; ---------------------------------
_AnnouncePitcherSets::
;src/baseball/announcer.c:206: __endasm;
	TRAMPOLINE	GetCurrentPitcherName
;src/baseball/announcer.c:207: str_Replace(PitcherSetsText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _PitcherSetsText
	call	_str_Replace
;src/baseball/announcer.c:208: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:209: }
	ret
;src/baseball/announcer.c:211: void AnnounceAndThePitch(void) {
;	---------------------------------
; Function AnnounceAndThePitch
; ---------------------------------
_AnnounceAndThePitch::
;src/baseball/announcer.c:212: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, AndThePitchText);
	ld	de, _AndThePitchText
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:213: }
	ret
;src/baseball/announcer.c:215: void AnnouncePitchName(void) {
;	---------------------------------
; Function AnnouncePitchName
; ---------------------------------
_AnnouncePitchName::
;src/baseball/announcer.c:216: GetMoveName(pitch_move_id);//"PITCH_NAME" in name_buffer
	ld	hl, _pitch_move_id
	ld	a, [hl]
	call	_GetMoveName
;src/baseball/announcer.c:217: str_Copy(AndThePitchText, str_buffer);//"And the pitch.""
	ld	bc, _str_buffer
	ld	de, _AndThePitchText
	call	_str_Copy
;src/baseball/announcer.c:218: str_Replace(ThrewAPitchText, tile_buffer, name_buffer);//"\nA PITCH_NAME."
	ld	de, _name_buffer
	push	de
	ld	bc, _tile_buffer
	ld	de, _ThrewAPitchText
	call	_str_Replace
;src/baseball/announcer.c:219: str_Append(tile_buffer, str_buffer);//"And the pitch.\nA PITCH_NAME."
	ld	bc, _str_buffer
	ld	de, _tile_buffer
	call	_str_Append
;src/baseball/announcer.c:220: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:221: }
	ret
;src/baseball/announcer.c:223: void AnnounceNextBatter(void) {
;	---------------------------------
; Function AnnounceNextBatter
; ---------------------------------
_AnnounceNextBatter::
;src/baseball/announcer.c:224: SetBalls(0);
	xor	a, a
	call	_SetBalls
;src/baseball/announcer.c:225: SetStrikes(0);
	xor	a, a
	call	_SetStrikes
;src/baseball/announcer.c:226: __asm__("TRAMPOLINE NextBatter");
	TRAMPOLINE	NextBatter
;src/baseball/announcer.c:227: AnnounceBatter();
	jp	_AnnounceBatter
.l00101:
;src/baseball/announcer.c:228: }
	ret
;src/baseball/announcer.c:230: void AnnounceBatterStepsIntoBox(void) {
;	---------------------------------
; Function AnnounceBatterStepsIntoBox
; ---------------------------------
_AnnounceBatterStepsIntoBox::
;src/baseball/announcer.c:231: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:232: str_Replace(BatterStepsIntoTheBoxText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BatterStepsIntoTheBoxText
	call	_str_Replace
;src/baseball/announcer.c:233: DisplayText(DRAW_FLAGS_WIN | DRAW_FLAGS_PAD_TOP, str_buffer);
	ld	de, _str_buffer
	ld	a, $03
	jp	_DisplayText
.l00101:
;src/baseball/announcer.c:234: }
	ret
;src/baseball/announcer.c:243: void AnnounceNoSwing(void) {
;	---------------------------------
; Function AnnounceNoSwing
; ---------------------------------
_AnnounceNoSwing::
;src/baseball/announcer.c:245: if (CheckStrike()) { //strike
	call	_CheckStrike
	ld	c, a
	or	a, a
	jp	Z, .l00110
;src/baseball/announcer.c:246: unsigned char strikes = GetStrikes();
	call	_GetStrikes
;src/baseball/announcer.c:247: if (strikes < 2) {
	cp	a, $02
	jp	NC, .l00104
;src/baseball/announcer.c:248: SetStrikes(++strikes);
	ld	c, a
	inc	c
	push	bc
	ld	a, c
	call	_SetStrikes
	pop	bc
;src/baseball/announcer.c:249: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:250: str_Number(strikes);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:251: str_Replace(StrikeText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeText
	call	_str_Replace
;src/baseball/announcer.c:252: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00104:
;src/baseball/announcer.c:255: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:256: str_Replace(StrikeOutLookingText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeOutLookingText
	call	_str_Replace
;src/baseball/announcer.c:257: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:258: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:259: if (IncrementOuts() < 3) {
	call	_IncrementOuts
	sub	a, $03
	jp	NC, .l00112
;src/baseball/announcer.c:260: AnnounceNextBatter();
	jp	_AnnounceNextBatter
	jp	.l00112
.l00110:
;src/baseball/announcer.c:265: unsigned char balls = GetBalls();
	call	_GetBalls
;src/baseball/announcer.c:266: if (balls < 3) {
	cp	a, $03
	jp	NC, .l00107
;src/baseball/announcer.c:267: SetBalls(++balls);
	ld	c, a
	inc	c
	push	bc
	ld	a, c
	call	_SetBalls
	pop	bc
;src/baseball/announcer.c:268: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:269: str_Number(balls);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:270: str_Replace(BallText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _BallText
	call	_str_Replace
;src/baseball/announcer.c:271: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	jp	_RevealTextAndWait
.l00107:
;src/baseball/announcer.c:274: __asm__("TRAMPOLINE PutBatterOnFirst");
	TRAMPOLINE	PutBatterOnFirst
;src/baseball/announcer.c:275: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:276: str_Replace(WalkText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _WalkText
	call	_str_Replace
;src/baseball/announcer.c:277: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:278: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:279: AnnounceRunScored();
	call	_AnnounceRunScored
;src/baseball/announcer.c:280: AnnounceNextBatter();
	jp	_AnnounceNextBatter
.l00112:
;src/baseball/announcer.c:283: }
	ret
;src/baseball/announcer.c:285: void AnnounceWildPitchOrPassedBall(void) {
;	---------------------------------
; Function AnnounceWildPitchOrPassedBall
; ---------------------------------
_AnnounceWildPitchOrPassedBall::
;src/baseball/announcer.c:288: }
.l00101:
	ret
;src/baseball/announcer.c:297: void AnnounceSwingMiss(void) {
;	---------------------------------
; Function AnnounceSwingMiss
; ---------------------------------
_AnnounceSwingMiss::
	dec	sp
;src/baseball/announcer.c:300: char strikes = GetStrikes();
	call	_GetStrikes
	ld	hl, sp+0
;src/baseball/announcer.c:301: if (strikes < 2) {
	ld	[hl], a
	sub	a, $02
	jp	NC, .l00104
;src/baseball/announcer.c:302: SetStrikes(++strikes);
	ld	c, [hl]
	inc	c
	push	bc
	ld	a, c
	call	_SetStrikes
	pop	bc
;src/baseball/announcer.c:303: __asm__("TRAMPOLINE DrawCountOutsInning");
	TRAMPOLINE	DrawCountOutsInning
;src/baseball/announcer.c:304: str_Number(strikes);
	ld	b, $00
	ld	de, $0000
	call	_str_Number
;src/baseball/announcer.c:305: str_Replace(StrikeText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeText
	call	_str_Replace
;src/baseball/announcer.c:306: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	inc	sp
	jp	_RevealTextAndWait
	jp	.l00106
.l00104:
;src/baseball/announcer.c:309: __asm__("TRAMPOLINE GetCurrentBatterName");
	TRAMPOLINE	GetCurrentBatterName
;src/baseball/announcer.c:310: str_Replace(StrikeOutSwingingText, str_buffer, name_buffer);
	ld	de, _name_buffer
	push	de
	ld	bc, _str_buffer
	ld	de, _StrikeOutSwingingText
	call	_str_Replace
;src/baseball/announcer.c:311: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:312: __asm__("TRAMPOLINE HideBatter");
	TRAMPOLINE	HideBatter
;src/baseball/announcer.c:313: if (IncrementOuts() < 3) {
	call	_IncrementOuts
	sub	a, $03
	jr	NC, .l00106
;src/baseball/announcer.c:314: AnnounceNextBatter();
	inc	sp
	jp	_AnnounceNextBatter
.l00106:
;src/baseball/announcer.c:317: }
	inc	sp
	ret
;src/baseball/announcer.c:320: void _AnnounceSwingContact(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function _AnnounceSwingContact
; ---------------------------------
__AnnounceSwingContact::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:323: ball_state = BALL_STATE_IN_PLAY;
	ld	hl, _ball_state
	ld	[hl], $10
;src/baseball/announcer.c:325: if (spray > -45 && spray < 45) {
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
;src/baseball/announcer.c:326: ball_state |= BALL_STATE_FAIR; 
	ld	[hl], $30
.l00102:
;src/baseball/announcer.c:329: if (launch > 0) {
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
;src/baseball/announcer.c:330: AnnounceHitInAir(speed, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	ld	e, b
	ld	a, c
	call	_AnnounceHitInAir
	jr	.l00107
.l00105:
;src/baseball/announcer.c:333: ball_state |= BALL_STATE_LANDED;
	ld	hl, _ball_state
	ld	a, [hl]
	or	a, $40
	ld	[hl], a
;src/baseball/announcer.c:334: AnnounceHitOnGround(speed, spray);
	ld	e, b
	ld	a, c
	call	_AnnounceHitOnGround
.l00107:
;src/baseball/announcer.c:336: }
	pop	hl
	inc	sp
	jp	hl
;src/baseball/announcer.c:338: void AnnounceHitOnGround(char speed, char spray) {
;	---------------------------------
; Function AnnounceHitOnGround
; ---------------------------------
_AnnounceHitOnGround::
;src/baseball/announcer.c:340: }
.l00101:
	ret
;src/baseball/announcer.c:342: void AnnounceHitInAir(unsigned char speed, signed char spray, signed char launch) {
;	---------------------------------
; Function AnnounceHitInAir
; ---------------------------------
_AnnounceHitInAir::
	ld	c, a
	ld	b, e
;src/baseball/announcer.c:343: unsigned char distance = DistanceFromSpeedLaunchAngle(speed, launch);
	push	bc
	ld	hl, sp+4
	ld	e, [hl]
	ld	a, c
	call	_DistanceFromSpeedLaunchAngle
	pop	bc
;src/baseball/announcer.c:344: if (distance < 100) {//infield
	ld	d, a
	sub	a, $64
	jr	NC, .l00102
;src/baseball/announcer.c:345: AnnounceHitInAirToInfield(distance, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	ld	e, b
	ld	a, d
	call	_AnnounceHitInAirToInfield
	jr	.l00104
.l00102:
;src/baseball/announcer.c:348: AnnounceHitInAirToOutfield(speed, distance, spray, launch);
	ld	hl, sp+2
	ld	a, [hl]
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	e, d
	ld	a, c
	call	_AnnounceHitInAirToOutfield
.l00104:
;src/baseball/announcer.c:350: }
	pop	hl
	inc	sp
	jp	hl
;src/baseball/announcer.c:352: void AnnounceHitInAirToOutfield(unsigned char speed, unsigned char distance, signed char spray, signed char launch) {   
;	---------------------------------
; Function AnnounceHitInAirToOutfield
; ---------------------------------
_AnnounceHitInAirToOutfield::
	dec	sp
	dec	sp
	ld	hl, sp+1
	dec	hl
	ld	[hl], e
;src/baseball/announcer.c:355: if (distance > 240) { //out of play
	ld	a, $F0
	sub	a, [hl]
	jp	NC, .l00104
;src/baseball/announcer.c:356: if (ball_state & BALL_STATE_FAIR != 0) { //home run
	push	hl
	ld	hl, _ball_state
	bit	0, [hl]
	pop	hl
	jp	Z,.l00102
.l00147:
;src/baseball/announcer.c:357: unsigned char order = CurrentOrderInLineup();
	call	_CurrentOrderInLineup
;src/baseball/announcer.c:358: unsigned char runs_scored = AdvanceRunners(4, ++order);//current batter is 0 to 8, needs to be 1 to 9
	ld	e, a
	inc	e
	ld	a, $04
	call	_AdvanceRunners
;src/baseball/announcer.c:359: const char* home_run_text = (runs_scored == 4) ? HitGrandSlamText : HitHomeRunText;
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
;src/baseball/announcer.c:360: RevealTextAndWait(home_run_text);
	call	_RevealTextAndWait
;src/baseball/announcer.c:361: __asm__("TRAMPOLINE DrawScore");
	TRAMPOLINE	DrawScore
;src/baseball/announcer.c:362: AnnounceNextBatter();
	call	_AnnounceNextBatter
;src/baseball/announcer.c:363: return;
	jr	.l00113
.l00102:
;src/baseball/announcer.c:367: AnnounceFoulBall();
	call	_AnnounceFoulBall
;src/baseball/announcer.c:368: return;
	jr	.l00113
.l00104:
;src/baseball/announcer.c:371: const char* hitText = HitPopFlyText;
	ld	de, _HitPopFlyText+0
;src/baseball/announcer.c:372: if (distance > 220) {
	ld	a, $DC
	ld	hl, sp+0
	sub	a, [hl]
	jr	NC, .l00111
;src/baseball/announcer.c:373: hitText = HitDeepFlyBallText;
	ld	de, _HitDeepFlyBallText
	jr	.l00112
.l00111:
;src/baseball/announcer.c:375: else if (distance > 180) {
	ld	a, $B4
	ld	hl, sp+0
	sub	a, [hl]
	jr	NC, .l00108
;src/baseball/announcer.c:376: hitText = HitFlyBallText;
	ld	de, _HitFlyBallText
	jr	.l00112
.l00108:
;src/baseball/announcer.c:378: else if (distance > 140) {
	ld	a, $8C
	ld	hl, sp+0
	sub	a, [hl]
	jr	NC, .l00112
;src/baseball/announcer.c:379: hitText = HitShallowFlyBallText;
	ld	de, _HitShallowFlyBallText
.l00112:
;src/baseball/announcer.c:381: str_Copy(hitText, str_buffer);
	ld	bc, _str_buffer
	call	_str_Copy
;src/baseball/announcer.c:382: AppendOutfieldLocationTextByAngle(spray);
	ld	hl, sp+4
	ld	a, [hl]
	call	_AppendOutfieldLocationTextByAngle
;src/baseball/announcer.c:383: RevealTextAndWait(str_buffer);
	ld	de, _str_buffer
	call	_RevealTextAndWait
;src/baseball/announcer.c:385: unsigned int xy = LocationFromDistSprayAngle(distance, spray);
	ld	hl, sp+4
	ld	e, [hl]
	ld	hl, sp+0
	ld	a, [hl]
	call	_LocationFromDistSprayAngle
;src/baseball/announcer.c:388: unsigned int posDist = GetClosestFielderByLocation(xy);
	ld	e, c
	ld	d, b
	call	_GetClosestFielderByLocation
;src/baseball/announcer.c:389: unsigned char pos = (char)((posDist >> 8) & BALL_STATE_FIELDER);//position in first 4 bits of upper nibble
	ld	a, b
	and	a, $0F
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;src/baseball/announcer.c:390: unsigned char dist = (char)(posDist & 255);//distance in lower nibble
;src/baseball/announcer.c:391: ball_state |= pos;
	push	hl
	ld	hl, _ball_state
	ld	a, [hl]
	pop	hl
	or	a, l
	ld	[_ball_state], a
;src/baseball/announcer.c:393: unsigned char hang_time = HangTimeFromSpeedLaunchAngle(speed, launch);
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
;src/baseball/announcer.c:394: AnnounceFieldingText(pos, dist, hang_time);
	push	af
	inc	sp
	ld	e, c
	ld	a, l
	call	_AnnounceFieldingText
.l00113:
;src/baseball/announcer.c:395: }
	inc	sp
	inc	sp
	pop	hl
	pop	af
	jp	hl
;src/baseball/announcer.c:397: void AppendOutfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
;	---------------------------------
; Function AppendOutfieldLocationTextByAngle
; ---------------------------------
_AppendOutfieldLocationTextByAngle::
;src/baseball/announcer.c:419: }
.l00101:
	ret
;src/baseball/announcer.c:421: void AnnounceHitInAirToInfield(unsigned char distance, signed char spray, signed char launch) {  
;	---------------------------------
; Function AnnounceHitInAirToInfield
; ---------------------------------
_AnnounceHitInAirToInfield::
;src/baseball/announcer.c:454: }
.l00101:
	pop	hl
	inc	sp
	jp	hl
;src/baseball/announcer.c:456: void AppendInfieldLocationTextByAngle(signed char spray) {// appends text to str_buffer
;	---------------------------------
; Function AppendInfieldLocationTextByAngle
; ---------------------------------
_AppendInfieldLocationTextByAngle::
;src/baseball/announcer.c:478: }
.l00101:
	ret
;src/baseball/announcer.c:480: void AnnounceBuntText(char launch, char spray) {
;	---------------------------------
; Function AnnounceBuntText
; ---------------------------------
_AnnounceBuntText::
;src/baseball/announcer.c:505: }
.l00101:
	ret
;src/baseball/announcer.c:507: void AnnounceFieldingText(unsigned char position, unsigned char distance, unsigned char hang_time){
;	---------------------------------
; Function AnnounceFieldingText
; ---------------------------------
_AnnounceFieldingText::
;src/baseball/announcer.c:578: }
.l00101:
	pop	hl
	inc	sp
	jp	hl
;src/baseball/announcer.c:580: void AnnounceFoulBall(void) {
;	---------------------------------
; Function AnnounceFoulBall
; ---------------------------------
_AnnounceFoulBall::
;src/baseball/announcer.c:588: }
.l00101:
	ret
;src/baseball/announcer.c:590: void AnnounceAdvanceRunners(void) {
;	---------------------------------
; Function AnnounceAdvanceRunners
; ---------------------------------
_AnnounceAdvanceRunners::
;src/baseball/announcer.c:592: }
.l00101:
	ret
;src/baseball/announcer.c:594: void AnnounceRunnersOn(void) {
;	---------------------------------
; Function AnnounceRunnersOn
; ---------------------------------
_AnnounceRunnersOn::
;src/baseball/announcer.c:596: }
.l00101:
	ret
;src/baseball/announcer.c:599: void AnnounceRunScored(void) {//if upper nibble of [runners_on_base] non-zero, announces runner who scored
;	---------------------------------
; Function AnnounceRunScored
; ---------------------------------
_AnnounceRunScored::
;src/baseball/announcer.c:663: }
.l00101:
	ret
;src/baseball/announcer.c:665: void AnnounceEndOfGame(void) {
;	---------------------------------
; Function AnnounceEndOfGame
; ---------------------------------
_AnnounceEndOfGame::
;src/baseball/announcer.c:667: RevealTextAndWait(AndThatsTheBallGameText);
	ld	de, _AndThatsTheBallGameText
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:668: }
	ret
	SECTION FRAGMENT "src/baseball/announcer.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
