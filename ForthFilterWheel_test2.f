\ test for EFW_SDK.f

include C:\MPE\VfxForth\Lib\Win32\Genio\SocketIo.fth
include "%idir%\..\ForthBase\ForthBase.f"
include "%idir%\EFW_SDK.f"
include "%idir%\EFW_SDK_extend.f"
include "%idir%\ForthFilterWheel.f"
include "%idir%\..\ForthBase\serial\VFX32serial.f"
include "%idir%\..\ForthKMTronic\KMTronic_Bidmead.f"
include "%idir%\..\ForthKMTronic\KMTronic.f"

-1 constant power-is-relay-switched
CR

power-is-relay-switched [IF] 
\ Switch on the camera relay

	6 constant COM-KMTronic
	COM-KMTronic add-relays
	1 relay-on
	3000 ms
	." Relay power on" CR
[THEN]

scan-wheels
0 add-wheel
0 use-wheel

what-wheel?

." wheel position is " wheel_position . CR

: position-test
	wheel_slots 0 do
		CR ." try position " i . tab
		i ->wheel_position
		CR ." wheel position is " wheel_position .
	loop
;

position-test

\ CR ." calibrate wheel" calibrate-wheel CR
 
\ ." wheel position is " wheel_position . CR

0 remove-wheel

power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	CR ." Relay power off" CR

	remove-relays
	
[THEN]