\ Forth words directly corresponding to the EFW SDK
need ForthBase 
need ForthVT100
                                            
LIBRARY: EFW_filter.dll  

Extern: int "C" EFWCalibrate( int WheelID );
Extern: int "C" EFWClose( int WheelID );
Extern: int "C" EFWGetDirection( int ID, int * bUnidirectional );
Extern: int "C" EFWGetFirmwareVersion( int WheelID, unsigned char * major, unsigned char * minor, unsigned char * build );
Extern: int "C" EFWGetHWErrorCode( int WheelID, int * pErrCode );
Extern: int "C" EFWGetID( int index, int * WheelID );
Extern: int "C" EFWGetNum( );
Extern: int "C" EFWGetPosition( int WheelID, int * pPosition );
Extern: int "C" EFWGetProductIDs( int * pPIDs );
Extern: int "C" EFWGetProperty( int WheelID, int * EFW_WHEEL_INFO );
Extern: char * "C" EFWGetSDKVersion( );
Extern: int "C" EFWGetSerialNumber( int WheelID, long * EFWSN );
Extern: int "C" EFWOpen( int WheelID );
Extern: int "C" EFWSetDirection( int WheelID, int bUnidirectional );
Extern: int "C" EFWSetID( int WheelID, long EFWID );
Extern: int "C" EFWSetPosition( int WheelID, int Position );

BEGIN-ENUMS EFW.Error ( n -- caddr u)
\ return the EFW text error message
	 +" FILTER WHEEL SUCCESS" 
	 +" FILTER WHEEL INVALID_INDEX" 
	 +" FILTER WHEEL INVALID_ID" 
	 +" FILTER WHEEL INVALID_VALUE" 
	 +" FILTER WHEEL REMOVED" 	
	 +" FILTER WHEEL MOVING" 	
	 +" FILTER WHEEL ERROR_STATE" 
	 +" FILTER WHEEL GENERAL_ERROR" 
	 +" FILTER WHEEL NOT_SUPPORTED" 
	 +" FILTER WHEEL CLOSED" 
END-ENUMS

BEGIN-STRUCTURE EFW_WHEEL_INFO
 4 +FIELD EFW_WHEEL_ID
64 +FIELD EFW_WHEEL_NAME
 4 +FIELD EFW_SLOT_COUNT
END-STRUCTURE

BEGIN-STRUCTURE EFW_ID				\ 8 bytes
  8 +FIELD EFW_ID_ID
END-STRUCTURE

\ pass by reference to ASI library functions
variable EFWWheelID
EFW_WHEEL_INFO		BUFFER: EFWWheelInfo
EFW_ID				BUFFER: EFWSN

\ do-or-die error handler
: EFW.?abort ( n --)
	flushKeys	
	dup 
	IF 
		EFW.Error cr .>E cr
		abort 
	ELSE
		drop	
	THEN
;
