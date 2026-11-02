\ test for EFW_SDK.f

include "%idir%\..\ForthBase\libraries\libraries.f"
NEED forthbase
NEED simple-tester

include "%idir%\EFW_SDK.f"
1 value test.position-error
: EFWGetPosition ( id position -- ior )
\ Simulate a settled wheel only when the transport succeeds.
    0 swap ! drop test.position-error ;
0 value test.moves
99 value test.slot
: EFWSetPosition ( id position -- ior )
\ Record requested wheel slots without equipment.
    -> test.slot drop 1 +to test.moves 0 ;
include "%idir%\EFW_SDK_extend.f"
include "%idir%\ForthFilterWheel.f"

Tstart
T{ 123 1 EFW.?abort wheel_position }T 123 0 ==
T{ 123 2 ->wheel_position test.moves }T 123 0 ==
0 -> test.position-error
T{ 123 configure-wheel test.slot test.moves }T 123 0 1 ==
T{ 123 2 filter test.slot test.moves wheel_moving }T 123 2 2 0 ==
Tend