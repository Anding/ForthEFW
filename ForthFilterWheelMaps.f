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

: add-wheelFITS ( map --)
\ add key value pairs for FITS wheel parameters
	>R
	s"  "                           R@ =>" #FILTERWH"						\ a header to indicate the source of these FITS values
	wheel_position filterBand       R@ =>" FILTER"
	wheel_position filterSpec       R@ =>" FILTERSP"	
	wheel_position (.)              R@ =>" WHEELPOS"	
	wheel_name                      R@ =>" WHEEL"
	wheel_SN                        R@ =>" WHEELSN"
	R> drop
;	



