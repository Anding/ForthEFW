\ utilities and helper functions to conveniently operate the EFW SDK
\ requires EFW_SDK.f

\ Lexicon conventions
\ 	EFW.word

\ Operational notes
\ 	variables over values

: EFW.make-handle ( -- c-addr u)
\ prepare a handle for the filter wheel based on name and serial number
\ assumes EFWGetProperty and EFWGetSerialNumber have been called
	base @ >R hex	\ s/n in hexadecimal
	EFWSN w@ ( n) 0 
	<# # # # #  	\ first 4 digits only 
	'_' HOLD			\ separator
	EFWWheelInfo EFW_WHEEL_NAME zcount HOLDS
	#> 
	R> base !
;
 
0 value wheel.ID 
\ the EFW WheelID of the presently selected filter wheel
