\ test for ForthAstroCameraFITS.f

include C:\MPE\VfxForth\Lib\Win32\Genio\SocketIo.fth
include "%idir%\..\ForthBase\ForthBase.f"
include "%idir%\EFW_SDK.f"
include "%idir%\EFW_SDK_extend.f"
include "%idir%\ForthFilterWheel.f"
include "%idir%\..\ForthBase\serial\VFX32serial.f"
include "%idir%\..\KMTronic\KMTronic_Bidmead.f"
include "%idir%\..\KMTronic\KMTronic.f"
include "%idir%\..\forth-map\map.fs"
include "%idir%\..\forth-map\map-tools.fs"
include "%idir%\ForthFilterWheelMaps.f"

-1 constant power-is-relay-switched
CR

power-is-relay-switched [IF] 
\ Switch on the camera relay

	COM-KMT add-relays
	1 relay-on
	3000 ms
	." Relay power on" CR
[THEN]

scan-wheels
0 add-wheel
0 use-wheel
500 ms

	map-strings
	map CONSTANT wheel_FITSmap
	wheel_FITSmap add-wheelFITS
	wheel_FITSmap .map


power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	CR ." Relay power off" CR

	remove-relays
	
[THEN]