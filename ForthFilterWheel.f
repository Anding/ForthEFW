\ Forth lexicon for controlling a filter wheel
\ 	ZWO EFW version
\ 	ordinary errors report and return to the caller

\ requires EFW_SDK.f
\ requires EFW_SDK_extend.f
\ requires forthbase.f

\ Lexicon conventions
\ 	wheel.word or cam.ID is a word within the encapsulation
\ 	dash is used as a verb-noun seperator
\ 	underscore is used as a whitespace in a noun (including structure field names and hardware properties)
\ 	camelCase is used as whitespace in a verb (including values and variables)
\ 	word? reports text to the user
\ 	->property ( x --) sets a hardware property
\ 	property ( -- x) returns a hardware property

\ Operational notes
\ 	values over variables
\ 	actions to the presently-selected-camera

s" " $value efw.str1

: wheel_name ( -- caddr u)
\ return the name of the camera
	EFWWheelInfo EFW_WHEEL_NAME zcount
;

: wheel_SN   ( -- caddr u)
\ return the S/N of the wheel as a hex string
	base @ >R hex
	EFWSN dup @ ( n) swap 4 + @ ( n) swap	\ S/N is stored in big-endian format
	<# # # # # # # # # # # # # # # # # #> 	\ VFX has no word (ud.)
	R> base !
;

: wheel-motion? { | pos -- moving? valid? }
\ report whether the wheel is moving
	0 -> pos
	wheel.ID ADDR pos EFWGetPosition
	dup 5 = if drop -1 -1 exit then
	?dup if EFW.?abort 0 0 exit then
	pos -1 = -1 \ An SDK position of -1 also means moving.
;

: wheel_moving ( -- bool )
	wheel-motion? drop
;

: (wait-wheel) ( -- ready? )
\ synchronous hold until the wheel stops moving
	begin
	    100 ms
		wheel-motion? 0= if drop 0 exit then
	0= until
	-1
;

: wait-wheel ( --)
	(wait-wheel) drop
;

: wheel_position { | pos } ( -- pos) \ VFX locals for pass-by-reference 
	0 -> pos
	(wait-wheel) 0= if 0 exit then
	wheel.ID ADDR pos EFWGetPosition ?dup if EFW.?abort 0 exit then
	pos
;

: ->wheel_position ( pos --)
	(wait-wheel) 0= if drop exit then
	wheel.ID swap EFWSetPosition EFW.?abort
; 

: calibrate-wheel
	(wait-wheel) 0= if exit then
	wheel.ID EFWCalibrate EFW.?abort
;

: wheel_slots ( -- n)
\ count of filter apertures in the wheel
	EFWWheelInfo EFW_SLOT_COUNT @ 
;

: add-wheel ( WheelID --)
\ make a wheel available for application use
\ 	connect the wheel and read its properties
    EFWGetNum 0= if drop s" no connected filter wheels" .E> exit then
	dup EFWOpen ?dup if EFW.?abort drop exit then
	500 ms
	dup EFWWheelInfo EFWGetProperty ?dup if
		EFW.?abort EFWClose EFW.?abort exit
	then
	drop
;

: use-wheel ( WheelID --)
\ choose the wheel to be selected for operations - must be added first
	-> wheel.ID
	wheel.ID EFWWheelInfo EFWGetProperty ?dup if EFW.?abort exit then
	wheel.ID EFWSN EFWGetSerialNumber ?dup if EFW.?abort exit then
	wheel_name $-> efw.str1 s"  at slot " $+> efw.str1
	wheel_position (.) $+> efw.str1
	efw.str1 .>
;

: remove-wheel ( WheelID --)
\ disconnect the wheel, it becomes unavailable to the application
    (wait-wheel) drop
	EFWClose EFW.?abort
;

: scan-wheels ( -- )
\ scan the plugged-in filter wheels
\ create a CONSTANT (out of the name and S/N) for each WheelID
	EFWGetNum ( -- n)
	?dup
	IF
		\ loop over each connected wheel
		CR ." ID" tab  ." Handle" tab tab ." Wheel" CR
		0 do
			0 EFWWheelID !
			i EFWWheelID EFWGetID ?dup if EFW.?abort unloop exit then
			EFWWheelID @										( ID)
			dup -> wheel.ID .
			wheel.ID EFWOpen ?dup if EFW.?abort unloop exit then
			wheel.ID EFWWheelInfo EFWGetProperty ?dup if
				EFW.?abort wheel.ID EFWClose EFW.?abort unloop exit
			then
			wheel.ID EFWSN EFWGetSerialNumber ?dup if
				EFW.?abort wheel.ID EFWClose EFW.?abort unloop exit
			then
			wheel.ID EFW.make-handle 2dup tab type 	( ID c-addr u)			
			($constant)											( --)			
			wheel_name tab type CR	
			wheel.ID EFWClose EFW.?ABORT	
		loop
	ELSE
		CR ." No connected filter wheels" CR
	THEN
;

\ user lexicon

DEFER filterBand ( n -- caddr u)
DEFER filterSpec ( n -- caddr u)

BEGIN-ENUMS default_filterBand
( n -- caddr u)
	+" LUM"
	+" RED"
	+" GREEN"
	+" BLUE"
	+" H-ALPHA"
	+" SII"
	+" OIII"
END-ENUMS

ASSIGN default_filterBand TO-DO filterBand
	
BEGIN-ENUMS default_filterSpec
( n -- caddr u)
	+" Astronomik UV-IR-BLOCK L-2"
	+" Astronomik Deep-Sky Red"
	+" Astronomik Deep-Sky Green"
	+" Astronomik Deep-Sky Blue"
	+" Astronomik MaxFR 6nm H-alpha"
	+" Astronomik MaxFR 6nm SII"
	+" Astronomik MaxFR 6nm OIII"
END-ENUMS

ASSIGN default_filterSpec TO-DO filterSpec

: filter ( pos --)
	(wait-wheel) 0= if drop exit then
	wheel.ID swap EFWSetPosition ?dup if EFW.?abort exit then
	(wait-wheel) 0= if exit then
	wheel_position filterSpec .>
;

: filter? ( --)
	wheel_position filterBand cr type cr
;

: check-wheel ( --)
\ report the current filter wheel state to the user
	wheel.ID EFWWheelInfo EFWGetProperty ?dup if EFW.?abort exit then
	s" Filter wheel" panel{
	s" ID" wheel.ID (.) .field
	s" Name" wheel_name .field
	s" Position" wheel_position (.) .field
	s" Moving" wheel_moving (.) .field
	}panel
;


		
