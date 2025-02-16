; ------------ Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
; ------------ App Details ------------
; App Full Name: Game Controller Remap.
; Description: This is an app aimed towards game controller devices not recognized by some games
; but still recognized by the Operating System. 
; --------------------------------
#Requires Autohotkey v2
#SingleInstance
SetWorkingDir(A_ScriptDir)
Global IconLib := A_ScriptDir . "\Icons"
, ImageLib := A_ScriptDir . "\Images"
, Guide := "https://fdj-software.gitbook.io/apps"
, IniFile := A_ScriptDir . "\GameControllerRemap.ini"
, LicenseFile := A_ScriptDir . "\LicenseKey.ini"
, DataFile := A_Temp . "\GCR_Data.ini"
, TempCleanFileGCR := A_Temp . "\GCR_CleanFile.ini"
, TempSystemFile := A_Temp . "\GCR_SystemFile.ini"
, AppName := "Game Controller Remap"
, CurrentVersion := "v1.4"
, FDJ_SoftwareIcon := "\Logo-FDJ-Dash.png"
, DefaultMsgBackgroundImage := "\Smoke2.jpg"
, Creator := " Fernando Daniel Jaime "

;----------------------------------------------------
; Libraries
;----------------------------------------------------
#Include "*i %A_ScriptDir%\Include\Create_Files.ahk"
#Include "*i %A_ScriptDir%\Include\ReadIniFile.ahk"
#Include "*i %A_ScriptDir%\Include\SetupMenu.ahk"
#Include "*i %A_ScriptDir%\Include\GameControllerRemapGui.ahk"
#Include "*i %A_ScriptDir%\Include\Menu_Handlers.ahk"
#Include "*i %A_ScriptDir%\Include\Message_Handlers.ahk"
#Include "*i %A_ScriptDir%\Include\Image_File_Select.ahk"
#Include "*i %A_ScriptDir%\Include\General_Functions.ahk"
;----------------------------------------------------
; Dinamic Reload variables
;----------------------------------------------------
DinamicReload := true
GuiCount := 1
GuiName := ""

IniWrite DinamicReload, TempSystemFile, "GeneralData", "DinamicReload"
IniWrite GuiCount, TempSystemFile, "GeneralData", "GuiCount"
IniWrite GuiName, TempSystemFile, "GeneralData", "GuiName"
;----------------------------------------------------
; General Loop Start
;----------------------------------------------------
Loop {
	DinamicReload := IniRead(TempSystemFile, "GeneralData", "DinamicReload")
	if DinamicReload == true {
		;----------------------------------------------------
		; Read Ini Properties - Create_Files.ahk
		;----------------------------------------------------
		if !FileExist(IniFile) {
			; CreateNewIniFile is defined in Create_Files.ahk
			CreateNewIniFile()
		}
		;----------------------------------------------------
		; Read ini Font types - ReadIniFile.ahk
		;----------------------------------------------------
		ReadFontTypes(&MainFontType, 
					  &MessageAppNameFontType, 
					  &LicenseKeyFontType, 
					  &MessageMainMsgFontType, 
					  &MessageFontType)
		;----------------------------------------------------
		; Read ini Font Colors - ReadIniFile.ahk
		;----------------------------------------------------
		ReadFontColors(&MainFontColor, 
					   &MessageAppNameFontColor,
					   &MessageMainMsgFontColor,
					   &MessageFontColor, 
					   &LicenseKeyFontColor)
		;----------------------------------------------------
		; Read ini Background - ReadIniFile.ahk
		;----------------------------------------------------
		ReadBackground(&BackgroundMainColor, 
					   &BackgroundColor,
					   &BackgroundPicture,
					   &MessageBackgroundPicture)
		;----------------------------------------------------
		; Read ini Properties - ReadIniFile.ahk
		;----------------------------------------------------
		ReadProperties(&ExitMessageTimeWait, 
					   &GuiPriorityAlwaysOnTop,
					   &ControllerLoopInterval,
					   &PositionX,
					   &PositionY,
					   &ExitGameControllerRemap)
		;----------------------------------------------------
		; Read ini Settings - ReadIniFile.ahk
		;----------------------------------------------------
		ReadSetting(&CheckforUpdatesDaily, 
					&CheckforupdatesWeekly, 
					&NeverCheckForUpdates,
					&LastUpdateCheckTimeStamp,
					&NeedUpdate)
		;----------------------------------------------------
		; Read ini Cursor Movement - ReadIniFile.ahk
		;----------------------------------------------------
		ReadCursorMovement(&CursorSensRight,
						   &CursorSensDown,
						   &CursorSensLeft,
						   &CursorSensUp,
						   &CursorSpeed)
		;----------------------------------------------------
		; Read ini Controller Camera Rotation - ReadIniFile.ahk
		;----------------------------------------------------
		ReadControllerCameraRotation(&ShiftDownRotation,
									 &CtrlDownRotation,
									 &RotateLeft,
									 &RotateRight,
									 &RotateUp,
									 &RotateDown)
		;----------------------------------------------------
		; Read ini Controller Normal Mode Remap - ReadIniFile.ahk
		;----------------------------------------------------
		ReadControllerNormalModeRemap(&ButtonA,
									  &ButtonB,
									  &ButtonX,
									  &ButtonY,
									  &SprintLB,
									  &ScannerRB,
									  &ButtonLT,
									  &ButtonRT,
									  &ButtonBack,
									  &ButtonStart)
		;----------------------------------------------------
		; Read ini Controller Race Mode Remap - ReadIniFile.ahk
		;----------------------------------------------------
		ReadControllerRaceModeRemap(&AfterBurnerButtonA,
									&ButtonLB,
									&ButtonRB,
									&RespawnY,
									&AcelerateButtonRT,
									&ReverseButtonLT)
		;----------------------------------------------------
		; Read ini Controller Axis Remap - ReadIniFile.ahk
		;----------------------------------------------------
		ReadControllerAxisRemap(&TurnLeft,
								&TurnRight,
								&MoveForward,
								&MoveBackward,
								&LeftPOV,
								&RightPOV,
								&ForwadPOV,
								&BackwardPOV)
		;----------------------------------------------------
		; GUI Properties
		;----------------------------------------------------
		if Mod(GuiCount, 2) == 1 {
			;----------------------------------------------------
			; GUI 1 instance - Inside Dinamic Reload
			;----------------------------------------------------
			GuiName := "ControllerRemapGui1"
			IniWrite GuiName, TempSystemFile, "GeneralData", "GuiName"
			
			if GuiPriorityAlwaysOnTop == true {
				ControllerRemapGui1 := Gui("+AlwaysOnTop")
			} else {
				ControllerRemapGui1 := Gui()
			}
			ControllerRemapGui1.Opt("+MinimizeBox +OwnDialogs -Theme")
			ControllerRemapGui1.SetFont("Bold " . MainFontColor, MainFontType)
			ControllerRemapGui1.BackColor := "0x" . BackgroundColor

			if BackgroundPicture == "" {
				try {
					ControllerRemapGui1.Add("Picture", "x0 y0 w250 h422", ImageLib . "\Smoke1.jpg")
				}
				catch {
				}
			} else {
				try {
					ControllerRemapGui1.Add("Picture", "x0 y0 w250 h422", BackgroundPicture)
				}
				catch {
					BackgroundPicture := ""
					IniWrite BackgroundPicture, IniFile, "Background", "BackgroundPicture"
					Reload
				}
			}
			;----------------------------------------------------
			; Setup Menu - SetupMenu.ahk
			;----------------------------------------------------
			SetupMenuBar(&MenuBar_Storage,
						 &FileMenu,
						 &ExitGameControllerRemap,
						 &OptionsMenu,
						 &SettingsMenu,
						 &HelpMenu,
						 ControllerRemapGui1)
			;----------------------------------------------------
			; Always On Top: ON/OFF
			;----------------------------------------------------
			if GuiPriorityAlwaysOnTop == true {
				OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch1.ico")
			} else {
				OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch2.ico")
			}
			;----------------------------------------------------
			; Y-10 / Controller
			;----------------------------------------------------
			Controller(ControllerRemapGui1,
					   &TextOnOffController,
					   &ControllerName,
					   &RadioCtrlRemapYes,
					   &RadioCtrlRemapNo)
			;----------------------------------------------------
			; Y-115 / Controller Status
			;----------------------------------------------------
			ControllerStatus(&TextAxisInfo,
							 &ButtonAOnOff,
							 &ButtonBOnOff,
							 &ButtonXOnOff,
							 &ButtonYOnOff,
							 &ButtonLBOnOff,
							 &ButtonRBOnOff,
							 &ButtonBackOnOff,
							 &ButtonStartOnOff,
							 &NormalMode,
							 &RaceMode,
							 ControllerRemapGui1,
							 &CursorMovement,
							 &RotateCamera,
							 &RotateCameraCtrldown,
							 &RotateCameraShiftdown)
			;----------------------------------------------------
			; Y-371 / Check for updates
			;----------------------------------------------------
			CheckForUpdates(ControllerRemapGui1, 
						    &FlagCheckTime,
						    &LastUpdateCheckTimeStamp,
						    &LicenseKeyFontType,
						    &CheckforUpdatesDaily,
						    &CheckforupdatesWeekly,
						    &NeverCheckForUpdates, 
						    &NeedUpdate,
						    &Connected,
						    &MLGCRLatestReleaseVersion,
						    &DownloadUrl,
						    &CurrentVersion)
			;----------------------------------------------------
			SB := ControllerRemapGui1.Add("StatusBar", , "Ready.")
			;----------------------------------------------------
			ControllerRemapGui1.OnEvent('Close', (*) => ExitApp())
			ControllerRemapGui1.Title := AppName
			ControllerRemapGui1.Show("x" . PositionX . " y" . PositionY . " w250 h422")
			Saved := ControllerRemapGui1.Submit(false)
		} else {
			;----------------------------------------------------
			; GUI 2 instance - Inside Dinamic Reload
			;----------------------------------------------------
			GuiName := "ControllerRemapGui2"
			IniWrite GuiName, TempSystemFile, "GeneralData", "GuiName"
			
			if GuiPriorityAlwaysOnTop == true {
				ControllerRemapGui2 := Gui("+AlwaysOnTop")
			} else {
				ControllerRemapGui2 := Gui()
			}
			ControllerRemapGui2.Opt("+MinimizeBox +OwnDialogs -Theme")
			ControllerRemapGui2.SetFont("Bold " . MainFontColor, MainFontType)
			ControllerRemapGui2.BackColor := "0x" . BackgroundColor

			if BackgroundPicture == "" {
				try {
					ControllerRemapGui2.Add("Picture", "x0 y0 w250 h422", ImageLib . "\Smoke1.jpg")
				}
				catch {
				}
			} else {
				try {
					ControllerRemapGui2.Add("Picture", "x0 y0 w250 h422", BackgroundPicture)
				}
				catch {
					BackgroundPicture := ""
					IniWrite BackgroundPicture, IniFile, "Background", "BackgroundPicture"
					Reload
				}
			}
			;----------------------------------------------------
			; Setup Menu
			;----------------------------------------------------
			SetupMenuBar(&MenuBar_Storage,
						 &FileMenu,
						 &ExitGameControllerRemap,
						 &OptionsMenu,
						 &SettingsMenu,
						 &HelpMenu,
						 ControllerRemapGui2)
			;----------------------------------------------------
			if GuiPriorityAlwaysOnTop == true {
				OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch1.ico")
			} else {
				OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch2.ico")
			}
			;----------------------------------------------------
			; Y-10 / Controller
			;----------------------------------------------------
			Controller(ControllerRemapGui2,
					   &TextOnOffController,
					   &ControllerName,
					   &RadioCtrlRemapYes,
					   &RadioCtrlRemapNo)
			;----------------------------------------------------
			; Y-115 / Controller Status
			;----------------------------------------------------
			ControllerStatus(&TextAxisInfo,
							 &ButtonAOnOff,
							 &ButtonBOnOff,
							 &ButtonXOnOff,
							 &ButtonYOnOff,
							 &ButtonLBOnOff,
							 &ButtonRBOnOff,
							 &ButtonBackOnOff,
							 &ButtonStartOnOff,
							 &NormalMode,
							 &RaceMode,
							 ControllerRemapGui2,
							 &CursorMovement,
							 &RotateCamera,
							 &RotateCameraCtrldown,
							 &RotateCameraShiftdown)
			;----------------------------------------------------
			; Y-371 / Check for updates
			;----------------------------------------------------
			CheckForUpdates(ControllerRemapGui2, 
						    &FlagCheckTime,
						    &LastUpdateCheckTimeStamp,
						    &LicenseKeyFontType,
						    &CheckforUpdatesDaily,
						    &CheckforupdatesWeekly,
						    &NeverCheckForUpdates, 
						    &NeedUpdate,
						    &Connected,
						    &MLGCRLatestReleaseVersion,
						    &DownloadUrl,
						    &CurrentVersion)
			;----------------------------------------------------
			SB := ControllerRemapGui2.Add("StatusBar", , "Ready.")
			;----------------------------------------------------
			ControllerRemapGui2.OnEvent('Close', (*) => ExitApp())
			ControllerRemapGui2.Title := AppName
			ControllerRemapGui2.Show("x" . PositionX . " y" . PositionY . " w250 h422")
			Saved := ControllerRemapGui2.Submit(false)
		}
		;----------------------------------------------------
		; Destroy previous Gui
		;----------------------------------------------------
		if GuiCount != 1 {
			if Mod(GuiCount, 2) == 0 {
				ControllerRemapGui1.Destroy
			} else {
				ControllerRemapGui2.Destroy
			}
		}
		GuiCount++
		IniWrite GuiCount, TempSystemFile, "GeneralData", "GuiCount"
		;----------------------------------------------------
		; OnExit Process - General_Functions.ahk
		;----------------------------------------------------
		OnExit ExitMenu
		;----------------------------------------------------
		; Auto-detect the controller number
		;----------------------------------------------------
		ControllerNumber := 0 ; Auto-detect Controller

		if ControllerNumber <= 0
		{
			Loop 16  ; Query each controller number to find out which ones exist.
			{
				if GetKeyState(A_Index "JoyName")
				{
					ControllerNumber := A_Index
					break
				}
			}
			if ControllerNumber <= 0
			{
				ControllerAvailable := false
			} else {
				ControllerAvailable := true
			}
		}
		;----------------------------------------------------
		; Verify License
		;----------------------------------------------------
		StringMacAddress := GetMacAddress()
		LicenseKey := EncriptMsg(StringMacAddress)

		try {
			LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		}
		catch as e {
			; License file is missing
			ExitApp(3)
		}

		Switch true {
		case LicenseKeyInFile == "":
			IniWrite LicenseKey, LicenseFile, "Data", "LicenseKey"
		case LicenseKeyInFile == LicenseKey:
		case LicenseKeyInFile != LicenseKey:
			; Invalid License
			ExitApp(2)
		}
		;----------------------------------------------------
		; Set DinamicReload to false again
		;----------------------------------------------------
		DinamicReload := false
		IniWrite DinamicReload, TempSystemFile, "GeneralData", "DinamicReload"
		;----------------------------------------------------
	} ; End DimamicReload / GUI Static code
	;----------------------------------------------------
	; Dinamic code starts here
	;----------------------------------------------------
	if ControllerAvailable == true {
		TextOnOffController.Value := " Controller Found"
		ControllerName.Value := GetKeyState(ControllerNumber "JoyName")
		cont_info := GetKeyState(ControllerNumber "JoyInfo")
		axis_info := " -   -   -   -   -   -   -   -   -   -"
		CoordMode "Mouse", "Screen"
		if GetKeyState(ExitGameControllerRemap, "P") == true {
			ExitApp()
		}
		if RadioCtrlRemapYes.Value == true {
			RadioCtrlRemapNo.Value := false
			MouseGetPos(&x, &y)
			SB.SetText("Controller remap active.        X:" . x . " Y:" . y )
			; Status info axis
			try {
					axis_info := " X" Round(GetKeyState(ControllerNumber "JoyX"))
				}
				catch as e {
					; the controller was disconnected
					TextOnOffController.Value := " Controller Not Found."
					ControllerName.Value := " "
					axis_info := " -   -   -   -   -   -   -   -   -   -"
					TextAxisInfo.Value := axis_info
					break
				}
			axis_info .= "  Y" Round(GetKeyState(ControllerNumber "JoyY"))
			;----------------------------------------------------
			; Jump Key - A
			if GetKeyState(ControllerNumber "Joy1", "P") {
				ButtonAOnOff.Value := " A"
				if NormalMode.Value == true {
					RaceMode.Value := false

					Send("{" . ButtonA . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . AfterBurnerButtonA . " down}")
				}
			} else {
				if ButtonAOnOff.Value == " A" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . ButtonA . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . AfterBurnerButtonA . " up}")
					}
					Send("{" . ButtonA . " up}")
					ButtonAOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Exit Key - B
			if GetKeyState(ControllerNumber "Joy2", "P") {
				ButtonBOnOff.Value := " B"
				Send("{" . ButtonB . " down}")
			} else {
				if ButtonBOnOff.Value == " B" {
					Send("{" . ButtonB . " up}")
					ButtonBOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Key - X
			if GetKeyState(ControllerNumber "Joy3", "P") {
				ButtonXOnOff.Value := " X"
				Send("{" . ButtonX . " down}")
			} else {
				if ButtonXOnOff.Value == " X" {
					Send("{" . ButtonX . " up}")
					ButtonXOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Interaction Key - Y
			if GetKeyState(ControllerNumber "Joy4", "P") {
				ButtonYOnOff.Value := " Y"
				if NormalMode.Value == true {
					RaceMode.Value := false
					Send("{" . ButtonY . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . RespawnY . " down}")
				}
			} else {
				if ButtonYOnOff.Value == " Y" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . ButtonY . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . RespawnY . " up}")
					}
					ButtonYOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			;  Key - LB
			if GetKeyState(ControllerNumber "Joy5", "P") {
				ButtonLBOnOff.Value := "LB"
				if NormalMode.Value == true {
					RaceMode.Value := false
					Send("{" . SprintLB . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . ButtonLB . " down}")
				}
			} else {
				if ButtonLBOnOff.Value == "LB" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . SprintLB . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . ButtonLB . " up}")
					}
					ButtonLBOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Scanner Key - RB
			if GetKeyState(ControllerNumber "Joy6", "P") {
				ButtonRBOnOff.Value := "RB"
				if NormalMode.Value == true {
					RaceMode.Value := false
					Send("{" . ScannerRB . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . ButtonRB . " down}")
				}
			} else {
				if ButtonRBOnOff.Value == "RB" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . ScannerRB . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . ButtonRB . " up}")
					}
					ButtonRBOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			;  Key - Back
			if GetKeyState(ControllerNumber "Joy7", "P") {
				ButtonBackOnOff.Value := "BACK"
				Send("{" . ButtonBack . " down}")
			} else {
				if ButtonBackOnOff.Value == "BACK" {
					Send("{" . ButtonBack . " up}")
					ButtonBackOnOff.Value := " -   -"
				}
			}
			;----------------------------------------------------
			;  Key - Start
			if GetKeyState(ControllerNumber "Joy8", "P") {
				ButtonStartOnOff.Value := "START"
				Send("{" . ButtonStart . " down}")
			} else {
				if ButtonStartOnOff.Value == "START" {
					Send("{" . ButtonStart . " up}")
					ButtonStartOnOff.Value := "-   -"
				}
			}
			;----------------------------------------------------
			axis_info_X := Round(GetKeyState(ControllerNumber "JoyX"))
			If axis_info_X >= 45 and axis_info_X <= 55 {
				Send("{" . TurnLeft . " up}")
				Send("{" . TurnRight . " up}")
			}
			; Turn Left
			If axis_info_X < 45 {
				Send("{" . TurnRight . " up}")
				Send("{" . TurnLeft . " down}")
			}
			; Turn Right
			If axis_info_X > 55 {
				Send("{" . TurnLeft . " up}")
				Send("{" . TurnRight . " down}")
			}
			;----------------------------------------------------
			axis_info_Y := Round(GetKeyState(ControllerNumber "JoyY"))
			If axis_info_Y >= 45 and axis_info_Y <= 55 {
				Send("{" . MoveForward . " up}")
				Send("{" . MoveBackward . " up}")
			}
			; Go forward
			If axis_info_Y < 45 {
				Send("{" . MoveBackward . " up}")
				Send("{" . MoveForward . " down}")
			}
			; Go backward
			If axis_info_Y > 55 {
				Send("{" . MoveForward . " up}")
				Send("{" . MoveBackward . " down}")
			}
			;----------------------------------------------------
			; LT and RT
			if InStr(cont_info, "Z") {
				axis_info_Z := Round(GetKeyState(ControllerNumber "JoyZ"))
				axis_info .= "  Z" Round(GetKeyState(ControllerNumber "JoyZ"))
				if NormalMode.Value == true {
					RaceMode.Value := false
					if axis_info_Z >= 45 and axis_info_Z <= 55 {
						Send("{" . ButtonLT . " up}")
						Send("{" . ButtonRT . " up}")
					}
					; Controller RT key
					if axis_info_Z < 45 {
						Send("{" . ButtonLT . " up}")
						Send("{" . ButtonRT . " down}")
					}
					; Controller LT key
					if axis_info_Z > 55 {
						Send("{" . ButtonRT . " up}")
						Send("{" . ButtonLT . " down}")
					}
				} else {
					RaceMode.Value := true
					if axis_info_Z >= 45 and axis_info_Z <= 55 {
						Send("{" . ReverseButtonLT . " up}")
						Send("{" . AcelerateButtonRT . " up}")
					}
					; Controller RT key
					if axis_info_Z < 45 {
						Send("{" . ReverseButtonLT . " up}")
						Send("{" . AcelerateButtonRT . " down}")
					}
					; Controller LT key
					if axis_info_Z > 55 {
						Send("{" . AcelerateButtonRT . " up}")
						Send("{" . ReverseButtonLT . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "R"){
				; MouseMove X, Y , Speed, Relative
				axis_info_R := Round(GetKeyState(ControllerNumber "JoyR"))
				axis_info .= "  R" Round(GetKeyState(ControllerNumber "JoyR"))
				if axis_info_R >= 45 and axis_info_R <= 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraCtrldown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					}
				}
				; Look Up
				if axis_info_R < 45 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x, "int", y + CursorSensUp)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateUp . " down}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateUp . " down}")
					}
				}
				; Look Down
				if axis_info_R > 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x, "int", y + CursorSensDown)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateDown . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateDown . " down}")	
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateDown . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "U") {
				axis_info_U := Round(GetKeyState(ControllerNumber "JoyU"))
				axis_info .= "  U" Round(GetKeyState(ControllerNumber "JoyU"))
				if axis_info_U >= 45 and axis_info_U <= 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraCtrldown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					}
				}
				; Look Left
				if axis_info_U < 45 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x + CursorSensLeft, "int", y)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateLeft . " down}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateLeft . " down}")
					}
				}
				; Look Right
				if axis_info_U > 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x + CursorSensRight, "int", y)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateRight . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateRight . " down}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateRight . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "V") {
				axis_info_V :=  Round(GetKeyState(ControllerNumber "JoyV"))
			}
			;----------------------------------------------------
			if InStr(cont_info, "P") {
				axis_info_POV := Round(GetKeyState(ControllerNumber "JoyPOV"))
				axis_info .= "  POV" Round(GetKeyState(ControllerNumber "JoyPOV"))
				if axis_info_POV == -1 {
					Send("{" . LeftPOV . " up}")
					Send("{" . RightPOV . " up}")
					Send("{" . ForwadPOV . " up}")
					Send("{" . BackwardPOV . " up}")
				}
				; Go Upper Left
				if axis_info_POV  == 31500 {
					Send("{" . RightPOV . " up}")
					Send("{" . BackwardPOV . " up}")
					Send("{" . LeftPOV . " down}")
					Send("{" . ForwadPOV . " down}")
				}
				; Go Upper Right
				if axis_info_POV  == 4500 {
					Send("{" . LeftPOV . " up}")
					Send("{" . BackwardPOV . " up}")
					Send("{" . RightPOV . " down}")
					Send("{" . ForwadPOV . " down}")
				}
				; Go Lower Left
				if axis_info_POV  == 22500 {
					Send("{" . RightPOV . " up}")
					Send("{" . ForwadPOV . " up}")
					Send("{" . LeftPOV . " down}")
					Send("{" . BackwardPOV . " down}")
				}
				; Go Lower Right
				if axis_info_POV  == 13500 {
					Send("{" . LeftPOV . " up}")
					Send("{" . ForwadPOV . " up}")
					Send("{" . RightPOV . " down}")
					Send("{" . BackwardPOV . " down}")
				}
				; Turn Left
				If axis_info_POV  == 27000 {
					Send("{" . RightPOV . " up}")
					Send("{" . LeftPOV . " down}")
				}
				; Turn Right
				If axis_info_POV == 9000 {
					Send("{" . LeftPOV . " up}")
					Send("{" . RightPOV . " down}")
				}
				; Go Forward
				If axis_info_POV == 0 {
					Send("{" . BackwardPOV . " up}")
					Send("{" . ForwadPOV . " down}")
				}
				; Go Backward
				If axis_info_POV == 18000 {
					Send("{" . ForwadPOV . " up}")
					Send("{" . BackwardPOV . " down}")
				}
			}
		} else {
			SB.SetText("Controller Remap Off.")
			axis_info := " -   -   -   -   -   -   -   -   -   -"
		}
		TextAxisInfo.Value := axis_info
		Sleep ControllerLoopInterval
	} ; End Controller Available
} ; End General loop
