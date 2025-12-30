\ Forth lexicon for controlling a filter wheel
\ 	ZWO EFW version
\ 	interactive version - errors will report and abort

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

: wheel_moving { | pos } ( -- bool) \ VFX locals for pass-by-reference 
\ report whether the wheel is moving
	wheel.ID ADDR pos EFWGetPosition ( -- errorno)
	case
		0 of pos -1 = if -1 else 0 then endof			\ pos -1 also indicated moving UNDOCUMENTED
		5 of -1 endof
		EFW.?ABORT												\ no need to restore the selector for ENDCASE provided 0 is a case
	ENDCASE
;

: wait-wheel ( --)
\ synchronous hold until the wheel stops moving
	begin
		wheel_moving
	while
		100 ms
	repeat
;

: wheel_position { | pos } ( -- pos) \ VFX locals for pass-by-reference 
	wait-wheel
	wheel.ID ADDR pos EFWGetPosition EFW.?abort
	pos
;

: ->wheel_position ( pos --)
	wait-wheel
	wheel.ID swap EFWSetPosition EFW.?abort
; 

: calibrate-wheel
	wait-wheel
	wheel.ID EFWCalibrate EFW.?abort
;

: wheel_slots ( -- n)
\ count of filter apertures in the wheel
	EFWWheelInfo EFW_SLOT_COUNT @ 
;

: add-wheel ( WheelID --)
\ make a wheel available for application use
\ 	connect the wheel and calibrate it
	dup EFWOpen EFW.?abort
	500 ms
	EFWWheelInfo ( ID buffer) EFWGetProperty EFW.?abort
;

: use-wheel ( WheelID --)
\ choose the wheel to be selected for operations - must be added first
	-> wheel.ID
	wheel.ID EFWWheelInfo ( ID buffer) EFWGetProperty EFW.?abort
	wheel.ID EFWSN EFWGetSerialNumber EFW.?ABORT 
;

: remove-wheel ( WheelID --)
\ disconnect the wheel, it becomes unavailable to the application
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
			i EFWWheelID ( index buffer) EFWGetID  EFW.?abort
			EFWWheelID @										( ID)
			dup -> wheel.ID .
			wheel.ID EFWOpen EFW.?abort
			wheel.ID EFWWheelInfo ( ID buffer) EFWGetProperty EFW.?ABORT
			wheel.ID EFWSN EFWGetSerialNumber EFW.?ABORT 
			wheel.ID EFW.make-handle 2dup tab type 	( ID c-addr u)			
			($constant)											( --)			
			wheel_name tab type CR	
			wheel.ID EFWClose EFW.?ABORT	
		loop
	ELSE
		CR ." No connected filter wheels" CR
	THEN
;

\ convenience functions

: check-wheel ( --)
\ report the current filter wheel to the user
\ WheelID Name SerialNo Slots
	wheel.ID EFWWheelInfo ( ID buffer) EFWGetProperty EFW.?abort
	CR 
	." Filter wheel ID = " wheel.ID .	
	." ; Name = " wheel_name type
;


		


