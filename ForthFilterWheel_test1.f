\ test for EFW_SDK.f

include "%idir%\..\ForthBase\libraries\libraries.f"
NEED forthbase
NEED simple-tester

include "%idir%\EFW_SDK.f"
: EFWGetPosition ( id position -- ior ) 2drop 1 ;
0 value test.moves
: EFWSetPosition ( id position -- ior ) 2drop 1 +to test.moves 0 ;
include "%idir%\EFW_SDK_extend.f"
include "%idir%\ForthFilterWheel.f"

Tstart
T{ 123 1 EFW.?abort wheel_position }T 123 0 ==
T{ 123 2 ->wheel_position test.moves }T 123 0 ==
Tend