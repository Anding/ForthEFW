\ test for EFW_SDK.f

include "%idir%\..\ForthBase\ForthBase.f"
include "%idir%\EFW_SDK.f"
include "%idir%\EFW_SDK_extend.f"
include "%idir%\ForthFilterWheel.f"
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
500 ms

what-wheel?

." wheel position " wheel_position . CR

: position-test
	wheel_slots 0 do
		." try position " i . tab
		i ->wheel_position
		2000 ms
		." wheel position " wheel_position . CR
	loop
;

position-test

0 remove-wheel

power-is-relay-switched [IF]
\ Switch off the camera relay

	500 ms
	1 relay-off
	." Relay power off" CR

	remove-relays
	
[THEN]