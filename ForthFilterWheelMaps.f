\ Add FITS and XISF keywords to a map
\ 	ASI version

\ requires forthbase.f
\ requires EFW_SDK.f
\ requires EFW_SDK_extend.f
\ requires maps.fs
\ requires forthbase.f, map-tools.fs

\ FITS keywords supported by MaxImDL
\ ==================================
\ FILTER		- filter name

\ FITS keywords defined here for the ZWO wheel
\ =============================================
\ WHEEL		- name of the filter wheel
\ WHEELPOS	- position of the filter wheel
\ WHEELSN 	- wheel serial number
\ FILTERSP	- filter specification

DEFER FITSfilterBand ( n -- caddr u)

DEFER FITSfilterSpec ( n -- caddr u)

: add-wheelFITS ( map --)
\ add key value pairs for FITS wheel parameters
	>R
	s"  " 					R@ =>" #FILTERWH"						\ a header to indicate the source of these FITS values
	wheel_position FITSfilterBand 	R@ =>" FILTER"
	wheel_position FITSfilterSpec 	R@ =>" FILTERSP"	
	wheel_name				R@ =>" WHEEL"
	wheel_position (.) 	R@ =>" WHEELPOS"
	wheel_SN					R@ =>" WHEELSN"
	R> drop
;	

BEGIN-ENUMS default_FITSfilterBand
	+" LUM"
	+" RED"
	+" GREEN"
	+" BLUE"
	+" H-ALPHA"
	+" SII"
	+" OIII"
END-ENUMS

ASSIGN default_FITSfilterBand TO-DO FITSfilterBand
	
BEGIN-ENUMS default_FITSfilterSpec
	+" Astronomik UV-IR-BLOCK L-2"
	+" Astronomik Deep-Sky RGB"
	+" Astronomik Deep-Sky RGB"
	+" Astronomik Deep-Sky RGB"
	+" Astronomik MaxFR 6nm"
	+" Astronomik MaxFR 6nm"
	+" Astronomik MaxFR 6nm"
END-ENUMS

ASSIGN default_FITSfilterBand TO-DO FITSfilterSpec
