\ test for EFW_SDK.f

include "%idir%\EFW_SDK.f"
CR	
\ check DLL and extern status
." EFW_filter.dll load address " EFW_filter.dll u. CR
.BadExterns CR