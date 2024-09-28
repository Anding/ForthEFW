\ Add FITS and XISF keywords to a map
\ 	ASI version

\ requires forthbase.f
\ requires EFW_SDK.f
\ requires EFW_SDK_extend.f
\ requires maps.fs
\ requires map-tools.fs

\ FITS keywords supported by MaxImDL
\ ==================================
\ FILTER		- filter name

\ FITS keywords defined here for the ZWO wheel
\ =============================================
\ WHEEL		- name of the filter wheel
\ WHEELPOS	- position of the filter wheel
\ WHEELSN 	- wheel serial number
\ FILTERSP	- filter specification

begin-enum
	+enum LUM
	+enum RED
	+enum GREEN
	+enum BLUE
	+enum H_alpha
	+enum SII
	+enum OIII
end-enum

: FITSfilterBand ( n -- caddr u)
	case
	LUM 		of s" Luminescence" endof
	RED 		of s" RED" endof
	GREEN 	of s" GREEN" endof
	BLUE 		of s" BLUE" endof
	SII 		of s" H_alpha" endof
	H_alpha 	of s" SII" endof
	OIII 		of s" OIII" endof
	." " rot endcase
;

: FITSfilterSpec ( n -- caddr u)
	case
	LUM 		of s" Astronomik Deep Sky II" endof
	RED 		of s" Astronomik Deep Sky II" endof
	GREEN 	of s" Astronomik Deep Sky II" endof
	BLUE 		of s" Astronomik Deep Sky II" endof
	SII 		of s" Astronomik 3nm" endof
	H_alpha 	of s" Astronomik 3nm" endof
	OIII 		of s" Astronomik 3nm" endof
	." " rot endcase
;

: add-wheelFITS ( map --)
\ add key value pairs for FITS wheel parameters
	>R
	s"  " 					R@ =>" #FILTERWH"		\ a header to indicate the source of these FITS values
	wheel_position FITSfilterBand 	R@ =>" FILTER"
	wheel_position FITSfilterSpec 	R@ =>" FILTERSP"	
	wheel_name				R@ =>" WHEEL"
	wheel_position (.) 	R@ =>" WHEELPOS"
	wheel_SN					R@ =>" WHEELSN"
	R> drop
;	

	

