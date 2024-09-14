\ Forth words directly corresponding to the EFW SDK
                                            
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

: EFW.Error ( n -- caddr u)
\ return the EFW text error message
	CASE
	 0 OF s" SUCCESS" ENDOF
	 1 OF s" INVALID_INDEX" ENDOF
	 2 OF s" INVALID_ID" ENDOF
	 3 OF s" INVALID_VALUE" ENDOF
	 4 OF s" REMOVED" ENDOF	
	 5 OF s" MOVING" ENDOF	
	 6 OF s" ERROR_STATE" ENDOF
	 7 OF s" GENERAL_ERROR" ENDOF
	 8 OF s" NOT_SUPPORTED" ENDOF
	 9 OF s" CLOSED" ENDOF
	s" OTHER_ERROR" rot 							( caddr u n)  \ ENDCASE consumes the case selector
	ENDCASE 
;

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
		EFW.Error type CR
		abort 
	ELSE
		drop	
	THEN
;
