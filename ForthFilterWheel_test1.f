\ test for EFW_SDK.f

include "%idir%\..\ForthBase\libraries\libraries.f"
NEED forthbase
NEED network

include "%idir%\EFW_SDK.f"
include "%idir%\EFW_SDK_extend.f"
include "%idir%\ForthFilterWheel.f"

CR	
\ check DLL and extern status
." EFW_filter.dll load address " EFW_filter.dll u. CR
.BadExterns CR