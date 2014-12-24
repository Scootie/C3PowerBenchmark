#include <date.au3>

;===============================================================================
;
; Description:    Sets a wakeup time to wake it up if the system / computer is hibernating or standby
; Parameter(s):  $Hour  - Hour Values   : 0-23
;                   $Minute - Minutes Values: 0-59
;                   $Day    - Days Values   : 1-31  (optional)
;                  $Month   - Month Values  : 1-12  (optional)
;                  $Year    - Year Values   : > 0   (optional)
;
; Requirement(s):   DllCall
; Return Value(s):  On Success - 1
;                  On Failure - 0 sets @ERROR = 1 and @EXTENDED (Windows API error code)
;
; Error code(s):    [url=http://msdn.microsoft.com/library/default.asp?url=/library/en-us/debug/base/system_error_codes.asp]http://msdn.microsoft.com/library/default....error_codes.asp[/url]
;
; Author(s):        Bastel123 aka Sebastian
; Note(s):        -
;
;===============================================================================
func SetWakeUpTime($Hour,$Minute,$Day=@mday,$Month=@mon,$Year=@YEAR)

local $SYSTEMTIME = DllStructCreate("ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort")
local $lpSYSTEMTIME = DllStructGetPtr($SYSTEMTIME)
local $LOCALFILETIME=DllStructCreate("dword;dword")
local $lpLOCALFILETIME = DllStructGetPtr($LOCALFILETIME)
local $DueTime=DllStructCreate("dword;dword")
local $lpDueTime=DllStructGetPtr($DueTime)

DllStructSetData($SYSTEMTIME, 1, $Year)
DllStructSetData($SYSTEMTIME, 2, $Month)
DllStructSetData($SYSTEMTIME, 3, _DateToDayOfWeek($Year,$Month,$Day)-1)
DllStructSetData($SYSTEMTIME, 4, $Day)
DllStructSetData($SYSTEMTIME, 5, $Hour)
DllStructSetData($SYSTEMTIME, 6, $Minute)
DllStructSetData($SYSTEMTIME, 7, 0)
DllStructSetData($SYSTEMTIME, 8, 0)

local $result = DllCall("kernel32.dll", "long", "SystemTimeToFileTime", "ptr", $lpSystemTime, "ptr", $lpLocalFileTime)
If $result[0] = 0 Then
    Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
    SetExtended($lastError[0])
    SetError(1)
    Return 0
EndIf
$result = DllCall("kernel32.dll", "long", "LocalFileTimeToFileTime", "ptr", $lpLocalFileTime, "ptr", $lpLocalFileTime)
If $result[0] = 0 Then
    Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
    SetExtended($lastError[0])
    SetError(1)
    Return 0
EndIf
$result = DllCall("kernel32.dll", "long", "CreateWaitableTimer", "long", 0, "long", True, "str", "")
If $result[0] = 0 Then
    Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
    SetExtended($lastError[0])
    SetError(1)
    Return 0
EndIf
;	DllCall("kernel32.dll", "none", "CancelWaitableTimer", "long",$result[0])

DllStructSetData($DueTime, 1, DllStructGetData($LocalFILETIME, 1))
DllStructSetData($DueTime, 2, DllStructGetData($LocalFILETIME, 2))

$result = DllCall("kernel32.dll", "long", "SetWaitableTimer", "long",$result[0], "ptr", $lpDueTime, "long", 0, "long", 0, "long", 0, "long", true)
If $result[0] = 0 Then
    Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
    SetExtended($lastError[0])
    SetError(1)
    Return 0
EndIf
return 1
EndFunc



;===============================================================================
;
; Description:    Set the computer in Hibernate or Standby Status
; Parameter(s):  $Mode  - Suspend mode  : True=Hibernate, False=Suspend
;                   $Force  - Force-Mode    : True=the system suspends operation immediately
;                                             False=FALSE, the system broadcasts a PBT_APMQUERYSUSPEND event to each application to request permission to suspend operation
;
; Requirement(s):   DllCall
;
; Author(s):        Bastel123 aka Sebastian
; Note(s):        If the system does not support hibernate use the standby mode       -
;
;===============================================================================
Func SetSuspend($mode,$force)
    local $result = DllCall("PowrProf.dll", "long", "SetSuspendState", "long",$mode, "long",$force, "long", false)


EndFunc
