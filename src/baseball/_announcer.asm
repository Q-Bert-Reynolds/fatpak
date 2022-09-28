;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.2.8 #13684 (MINGW64)
;--------------------------------------------------------
	; MODULE announcer
	; Generated using the rgbds tokens.

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	EXPORT _announceSomething
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
;src/baseball/announcer.c:6: void announceSomething() {
;	---------------------------------
; Function announceSomething
; ---------------------------------
_announceSomething::
;src/baseball/announcer.c:7: RevealTextAndWait(1, BallText);
	ld	de, _BallText
	ld	a, $01
	jp	_RevealTextAndWait
.l00101:
;src/baseball/announcer.c:8: }
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
	DB "mont"
	DB $C3
	DB $AD
	DB "culo"
	DB $00
_WalksToThePlateText:
	DB "%s se acerca"
	DB $0A
	DB "l plato."
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
	DB "Swing tard"
	DB $C3
	DB $AD
	DB "o."
	DB $00
_SwingAndMissText:
	DB "Swing y una se"
	DB $C3
	DB $B1
	DB "orita."
	DB $00
_HitBarrelText:
	DB "Realmente tengo el"
	DB $BA
	DB "rrel en ese."
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
	DB "the <LF> <LF> l"
	DB $C3
	DB $AD
	DB "nea."
	DB $00
	DB "a"
	DB $80
	DB "jard"
	DB $C3
	DB $AD
	DB "n izquierdo."
	DB $00
	DB "a"
	DB $CE
	DB "ntro izquierda."
	DB $00
	DB "a"
	DB $80
	DB "jardin centro."
	DB $00
	DB "a"
	DB $CE
	DB "ntro derecho"
	DB $00
	DB "a"
	DB $80
	DB "jard"
	DB $C3
	DB $AD
	DB "n derecho."
	DB $00
	DB "Abajo"
	DB $80
	DB "the <RF> l"
	DB $C3
	DB $AD
	DB "nea."
	DB $00
_HitLineDriveText:
	DB "L"
	DB $C3
	DB $AD
	DB "nea de l"
	DB $C3
	DB $AD
	DB "nea"
	DB $00
_HitGroundBallText:
	DB "Bola de tierra"
	DB $00
_HitChopperText:
	DB "Un helic"
	DB $C3
	DB $B3
	DB "ptero"
	DB $00
_HitPopUpText:
	DB "Aparecido"
	DB $00
_HitBuntText:
	DB "Buntado"
	DB $00
_InfieldLocationTexts:
	DB "abajo"
	DB $0E
	DB "l<3B> l"
	DB $C3
	DB $AD
	DB "nea"
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
	DB $0E
	DB "l <1B> l"
	DB $C3
	DB $AD
	DB "nea"
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
	DB $0F
	DB "rom %s."
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
	DB $C2
	DB $A1
	DB "Pelota muerta!"
	DB $00
_StrikeText:
	DB $C2
	DB $A1
	DB "Huelgas!"
	DB $00
_StrikeOutLookingText:
	DB "%s huelga"
	DB $80
	DB "out mirando!"
	DB $00
_StrikeOutSwingingText:
	DB "%s huelga"
	DB $80
	DB "out balance"
	DB $C3
	DB $A1
	DB "ndose!"
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
	DB $C2
	DB $A1
	DB "Pasb"
	DB $C3
	DB $B3
	DB "l!"
	DB $00
_WildPitchText:
	DB $C2
	DB $A1
	DB "Lanzamiento"
	DB $80
	DB "salvaje!"
	DB $00
_HitByPitchText:
	DB "Eso lo golpe"
	DB $C3
	DB $B3
	DB ", por lo que"
	DB $80
	DB "%s est"
	DB $C3
	DB $A1
	DB " en <1B>."
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
	DB "%s ser"
	DB $C3
	DB $A1
	DB " de segundo."
	DB $00
	DB "Etiquetado de tercero"
	DB $80
	DB "is %s."
	DB $00
_SafeText:
	DB $C2
	DB $A1
	DB "Seguro!"
	DB $00
_OutText:
	DB $C2
	DB $A1
	DB "Afuera!"
	DB $00
_DoublePlayText:
	DB $C2
	DB $A1
	DB "Doble jugada!"
	DB $00
_TriplePlayText:
	DB $C2
	DB $A1
	DB "Juego triple!"
	DB $00
_HitFoulTipText:
	DB "Consejo sucio."
	DB $00
_HitFoulBackText:
	DB "Flolled de regreso."
	DB $00
_HitFoulBallText:
	DB $C2
	DB $A1
	DB "Bola de falta!"
	DB $00
_InFoulTerritoryText:
	DB "en el territorio de"
	DB $0F
	DB "oul."
	DB $00
_HitBaseHitText:
	DB $C2
	DB $A1
	DB "Indiscutible!"
	DB $00
_HitDoubleText:
	DB $C2
	DB $A1
	DB "Doble!"
	DB $00
_HitTripleText:
	DB $C2
	DB $A1
	DB "Triple!"
	DB $00
_HitHomeRunText:
	DB $C2
	DB $A1
	DB "Jonr"
	DB $C3
	DB $B3
	DB "n!"
	DB $00
_HitGrandSlamText:
	DB "GRAND SLAM!"
	DB $00
_CriticalHitText:
	DB $C2
	DB $A1
	DB "Impacto cr"
	DB $C3
	DB $AD
	DB "tico!"
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
	DB $BA
	DB "ll."
	DB $00
	SECTION FRAGMENT "src/baseball/announcer.c_CODE",ROMX
	SECTION FRAGMENT "_INITIALIZER",ROM0
	SECTION FRAGMENT "_CABS (ABS)",ROM0
