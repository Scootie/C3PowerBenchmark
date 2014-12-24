#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=C3PowerBenchmark_x86.exe
#AutoIt3Wrapper_Outfile_x64=C3PowerBenchmark_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_LegalCopyright=Caleb Ku
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;Copyright 2009 Caleb Ku
;Licensed under the Apache License, Version 2.0 (the "License");
;you may not use this file except in compliance with the License.
;You may obtain a copy of the License at
;
;http://www.apache.org/licenses/LICENSE-2.0
;
;Unless required by applicable law or agreed to in writing, software
;distributed under the License is distributed on an "AS IS" BASIS,
;WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;See the License for the specific language governing permissions and
;limitations under the License.


#include <SleepWakeup.au3>
#include <Date.au3>
#include <getbattstatus.au3>

Local Const $headerinfo = "C3PowerBenchmark v1.0, @Copyright Caleb Ku"
Local Const $filename = "C3PowerBenchmark.txt"
Local Const $interval = 6
local Const $intervaltype = 'h' ; h for hours n for minutes

;===============================================================================
;
; Description:    Set the computer in Hibernate or Standby Status
; Parameter(s):  $Mode  - Suspend mode  : True=Hibernate, False=Suspend
;                   $Force  - Force-Mode    : True=the system suspends operation immediately
;                                             False=FALSE, the system broadcasts a PBT_APMQUERYSUSPEND event to each application to request permission to suspend operation
;
;===============================================================================

local $answer = MsgBox(292, "C3PowerBenchmark", "Are you sure you wish to test Standby and Hibernation?" & @LF & _
																					"Please do not unplug computer yet!!!" )

If $answer = 7 Then
    MsgBox(0, "C3PowerBenchmark", "Process canceled!!!")
    Exit
ElseIf $answer = 6 Then
Sleep(2000)
		If FileExists($filename) then
			FileDelete($filename)
		EndIf

local $str = InputBox("C3PowerBenchmark","Please Choose which Benchmark to initiate" & @LF & _
																	"Enter 's' for standby or 'h' for hibernation." & @LF & _
																	"Both standby and hibernation have a duration of 12 hours." & @LF & _
																	"Note that the standby cycle self loops 12 times." & @LF & _
																	"Please unplug computer before you hit 'Ok'",""," M1", 350, 250)


		local $log = FileOpen($filename, 1)
		local $mode, $tCur
		local $force=False
		If $str = 's' Then

			local $info1 = _getlogging_key()
			FileWriteLine($log, $headerinfo)
			FileWriteLine($log, "Local Time & Date" & "," & $info1 )
			Sleep(5000)

			$mode=False

			For $i=0 to 6 Step 1


				For $x =0 to 1 Step 1

					$tCur = _Date_Time_GetLocalTime()
					local $info2 = _getbattstatus()

					FileWriteLine($log, _Date_Time_SystemTimeToDateTimeStr($tCur) & "," & $info2)

					Sleep(1000)

				Next

				If $i < 6 Then

					$tCur = _Date_Time_GetLocalTime()
					FileWriteLine($log, _Date_Time_SystemTimeToDateTimeStr($tCur) & "," & "Suspending Start @hour = " & $i*$interval)

					Sleep(2000)
					local $alarminput = _DateAdd($intervaltype, $interval, _Date_Time_SystemTimeToDateTimeStr($tCur,1))
					Local $DatePart[4], $TimePart[4]

					_DateTimeSplit($alarminput, $DatePart, $TimePart)

;					ConsoleWrite($DatePart[3] & @CRLF)
;					ConsoleWrite("HH " & $TimePart[1] & @CRLF)
;					ConsoleWrite("MM " & $TimePart[2] & @CRLF)
;					ConsoleWrite("SS " & $TimePart[3] & @CRLF)

					SetWakeUpTime($TimePart[1],$TimePart[2], $DatePart[3], $DatePart[2], $DatePart[1]); wakeup the system 30 minutes from now
					SetSuspend($mode, $force); go to standby mode



				ElseIf $i = 6 Then

					$tCur = _Date_Time_GetLocalTime()
					FileWriteLine($log, _Date_Time_SystemTimeToDateTimeStr($tCur) & "," & "Suspending End @hour = " & $i*$interval)
				Else

				EndIf
				Sleep(5000)
			Next

		ElseIf $str = 'h' Then

			;$tCur = _Date_Time_GetSystemTime()
			;FileWrite($log, _Date_Time_SystemTimeToDateTimeStr($tCur) & "," & "Hibernating Start" & @CRLF)
			;$mode=True
			;SetWakeUpTime(@HOUR,@min+2); wakeup the system 30 minutes from now
			;SetSuspend($mode, $force); go to hibernate mode
			;$tCur = _Date_Time_GetSystemTime()
			;FileWrite($log, _Date_Time_SystemTimeToDateTimeStr($tCur) & "," & "Hibernating End" & @CRLF)
		Else

		EndIf
FileClose($log)
EndIf
