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
#Include <Battery.au3>
#include <GUIConstants.au3>


Opt('MustDeclareVars', 1)
;///// Array information key////

;Power state: ' & $aData[0]
;Capacity:    ' & $aData[1]
;Voltage:     ' & $aData[2]
;Rate:        ' & $aData[3]

;_BatteryQuery key
;       $array[0]   = ACPower(0=offline, 1=online, 255=unknown)
;       $array[1]   = BatteryFlag(1=High, 2=Low, 4=Critical,
;                     8=Charging 128=No Battery, 255=Unknown
;                     Use BitAnd to test, ie BitAnd($array[1],128)
;       $array[2]   = BatteryLife %(0-100, 255=unknown)
;       $array[3]   = Seconds left of charge, estimate(4294967295=unknown)
;//////////////////////////////

Global $aData, $iTag, $sDevicePath = _Battery_GetDevicePath()
Global $syspower
Global $string_info
Global $string_key = ("Power State,Capacity,Voltage,Rate,AC Power,Battery Flag,%Battery Life,Remaining Charge (s),Cooling Mode")
Global $coolingdata

Func _getlogging_key()
	Return $string_key
EndFunc




Func _getbattstatus()

$iTag = _Battery_GetTag($sDevicePath)
If $iTag Then
    $aData = _Battery_QueryStatus($sDevicePath, $iTag)
	$syspower = _SystemPowerStatus()
	$coolingdata = _GetSystemPowerInformation()

    If IsArray($aData) AND IsArray($syspower) AND IsArray($coolingdata) Then
			$string_info = ""
		For $i=0 to 3 step 1
			$string_info = String($string_info & $aData[$i] & ",")

		Next

		For $i=0 to 3 step 1
			$string_info = String($string_info & $syspower[$i] & ",")
		Next

		$string_info = String($string_info) & $coolingdata[3]

    Else
        Switch @error
			Case 1
				$string_info = String( 'Unable to open the battery device.' & @CR)

            Case 2
				$string_info = String( 'The specified tag does not match that of the current battery tag.' & @CR)
        EndSwitch
    EndIf
Else
	$string_info = String( 'Battery not found.' & @CR)
EndIf
Return $string_info

EndFunc


Func _getbattonly()

$iTag = _Battery_GetTag($sDevicePath)
If $iTag Then
    $aData = _Battery_QueryStatus($sDevicePath, $iTag)


    If IsArray($aData) Then

		For $i=0 to 3 step 1
			$string_info = String($string_info & $aData[$i] & ",")

		Next

    Else
        Switch @error
			Case 1
				$string_info = String( 'Unable to open the battery device.' & @CR)

            Case 2
				$string_info = String( 'The specified tag does not match that of the current battery tag.' & @CR)
        EndSwitch
    EndIf
Else
	$string_info = String( 'Battery not found.' & @CR)
EndIf
Return $string_info

EndFunc

