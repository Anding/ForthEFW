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

: scan-wheels ( -- )
\ scan the plugged-in cameras
\ create a CONSTANT (out of the name and S/N) for each CameraID
\ report the cameras and 
	base @ >R hex									\ report the s/n in hex
	EFWGetNum ( -- n)
	?dup
	IF
		\ loop over each connected camera
		CR ." ID" tab ." Wheel" tab tab ." S/N" tab tab ." Handle" CR
		0 do
			i EFWWheelID ( index buffer) EFWGetID  EFW.?abort
			EFWWheelID @										( ID)
			dup .
			dup EFWOpen EFW.?abort
			dup EFWWheelInfo ( ID buffer) EFWGetProperty EFW.?abort
			EFWWheelInfo EFW_WHEEL_NAME zcount tab type			
			dup EFWSN EFWGetSerialNumber EFW.?ABORT 	( ID)
			dup EFWClose EFW.?abort							( ID)
			EFWSN @ tab tab u. 								\ last 8 hex digits only				
			EFW.make-handle									( ID c-addr u)
			2dup tab type CR									( ID c-addr u)
			($constant)											( --)
		loop
	ELSE
		CR ." No connected filter wheels" CR
	THEN
	R> base !
;

: add-wheel ( WheelD --)
\ make a wheel available for application use
\ 	connect the wheel and calibrate it
	dup EFWOpen EFW.?abort
	500 ms
\	dup EFWCalibrate EFW.?abort
	EFWWheelInfo ( ID buffer) EFWGetProperty EFW.?abort
;

: remove-wheel ( WeelID --)
\ disconnect the wheel, it becomes unavailable to the application
	EFWClose EFW.?abort
;

: use-wheel ( CameraID --)
\ choose the camera to be selected for operations
	-> wheel.ID
;

: wheel_slots ( -- n)
\ count of filter apertures in the wheel
	EFWWheelInfo EFW_SLOT_COUNT @ 
;

: what-wheel? ( --)
\ report the current camera to the user
\ WheelID Name SerialNo Slots
	CR ." ID" tab ." Wheel" tab tab ." S/N" tab tab ." Slots" tab CR	
	wheel.ID .	
	wheel.ID EFWWheelInfo ( ID buffer) EFWGetProperty EFW.?abort
	wheel.ID EFWSN EFWGetSerialNumber EFW.?ABORT 
	EFWWheelInfo EFW_WHEEL_NAME zcount tab type
	base @ hex									\ report the s/n in hex
	EFWSN @ tab tab u.
	base !
	wheel_slots tab . CR
;

: wheel_moving { | pos } ( -- bool) \ VFX locals for pass-by-reference 
\ report whether the wheel is moving
	wheel.ID ADDR pos EFWGetPosition ( -- errorno)
	case
		0 of 0 endof
		5 of -1 endof
		EFW.?ABORT		\ no need to restore the selector for ENDCASE provided 0 is a case
	ENDCASE
;

: wheel_position { | pos } ( -- pos) \ VFX locals for pass-by-reference 
	wheel.ID ADDR pos EFWGetPosition EFW.?abort
	pos
;

: ->wheel_position ( pos --)
	wheel.ID swap EFWSetPosition EFW.?abort
; 
