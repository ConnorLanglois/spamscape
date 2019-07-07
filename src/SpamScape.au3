#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>

Global $bIsSpamming = False

_Main()

Func _Main()
	_Init()
	_Run()
EndFunc

Func _Init()
	HotKeySet('{END}', '_Exit')
	AutoItSetOption('SendKeyDelay', 20)
EndFunc

Func _Run()
	Local $iWidth = 500
	Local $iHeight = 170

	Local $temp

	Local $hWnd = GUICreate('SpamScape', $iWidth, $iHeight)
	Local $idLabelTitle = GUICtrlCreateLabel('SpamScape', 0, 10)

	GUICtrlSetPos($idLabelTitle, $iWidth / 2 - ControlGetPos($hWnd, '', $idLabelTitle)[2] / 2)
	; GUICtrlSetFont($idTitle, 12)

	Local $idLabelText = GUICtrlCreateLabel('Text:', 10, 50)
	$temp = ControlGetPos($hWnd, '', $idLabelText)[2]
	Local $idInputText = GUICtrlCreateInput('', $temp + 10, 50, $iWidth - 20 - $temp)

	Local $idLabelTime = GUICtrlCreateLabel('Time Interval (ms):', 10, 85)
	$temp = ControlGetPos($hWnd, '', $idLabelTime)[2]
	Local $idInputTime = GUICtrlCreateInput('', $temp + 10, 85, $iWidth - 20 - $temp)

	Local $idButtonStart = GUICtrlCreateButton('Spam!', 25, $iHeight - 38, $iWidth / 2 - 50)
	Local $idButtonStop = GUICtrlCreateButton('Stop!', $iWidth / 2 + 25, $iHeight - 38, $iWidth / 2 - 50)

	GUICtrlSetState($idButtonStop, $GUI_DISABLE)
	GuiSetState(@SW_SHOW)

	Local $iTime
	Local $hTimer

	While True
		Switch GuiGetMsg()
			Case $GUI_EVENT_CLOSE
				_Exit()
			Case $idButtonStart
				$sText = GUICtrlRead($idInputText)
				$iTime = GUICtrlRead($idInputTime)

				If StringIsDigit($iTime) Then
					GUICtrlSetState($idButtonStart, $GUI_DISABLE)
					GUICtrlSetState($idButtonStop, $GUI_ENABLE)

					$hTimer = TimerInit()
					$bIsSpamming = True
				EndIf
			Case $idButtonStop
				GUICtrlSetState($idButtonStart, $GUI_ENABLE)
				GUICtrlSetState($idButtonStop, $GUI_DISABLE)

				$bIsSpamming = False
		EndSwitch

		If $bIsSpamming And TimerDiff($hTimer) > $iTime Then
			Window_Display('Old School RuneScape')
			Send($sText, $SEND_RAW)
			Send('{ENTER}{RIGHT}')

			$hTimer = TimerInit()
		EndIf
	WEnd
EndFunc

Func Window_Display($title)
	Local $hWnd = WinWait($title, '',  10)

	WinActivate($hWnd)

	If $hWnd = 0 Or WinWaitActive($hWnd, '', 5) = 0 Then
		MsgBox(0, 'ERROR', 'Could not open game window', 10)

		$bIsSpamming = False
	EndIf

	Sleep(1000)
EndFunc

Func _Exit()
	Exit
EndFunc
