\ utilities and helper functions to conveniently operate the EFW SDK
\ requires EFW_SDK.f

\ Lexicon conventions
\ 	EFW.word

\ Operational notes
\ 	variables over values

: despace ( c-addr u --)
\ convert spaces to underscore characters
	over + swap do
		i c@ BL = if '_' i c! then	
	loop
;

: EFW.make-handle ( -- c-addr u)
\ prepare a handle for the filter wheel based on name and serial number
\ assumes ASIGetCameraProperty and ASIGetSerialNumber have been called
	base @ >R hex	\ s/n in hexadecimal
	EFWSN @ 0 
	<# # # # #  	\ last 4 digits only 
	'_' HOLD			\ separator
	EFWWheelInfo EFW_WHEEL_NAME zcount HOLDS
	#> 
	R> base !
;
 
0 value wheel.ID 
\ the EFW WheelID of the presently selected camera
