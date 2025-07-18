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
ListLines False
#NoTrayIcon
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
, CurrentVersion := "v2.0"
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
#Include "*i %A_ScriptDir%\Include\Submit_Handlers.ahk"
#Include "*i %A_ScriptDir%\Include\Image_File_Select.ahk"
#Include "*i %A_ScriptDir%\Include\General_Functions.ahk"
#Include "*i %A_ScriptDir%\Include\ClassDefinitions.ahk"
;----------------------------------------------------
; Database Libraries
;----------------------------------------------------
#Include "*i %A_ScriptDir%\Include\Forms_Handler.ahk"
#Include "*i %A_ScriptDir%\Include\DatabaseMsgHandler.ahk"
#Include "*i %A_ScriptDir%\MySQLAPI-v1.1.ahk"
#Include "*i %A_ScriptDir%\DB_Interactions.ahk"
;----------------------------------------------------
; Mail Variables
;----------------------------------------------------
MailPswd := MailPswdGen()
;----------------------------------------------------
; DynamicReload variables
;----------------------------------------------------
DynamicReload := true
GuiCount := 1
GuiName := ""
ControllerAvailable := true
IniWrite DynamicReload, TempSystemFile, "GeneralData", "DynamicReload"
IniWrite GuiCount, TempSystemFile, "GeneralData", "GuiCount"
IniWrite GuiName, TempSystemFile, "GeneralData", "GuiName"
;----------------------------------------------------
; Get Device License Data
;----------------------------------------------------
StringMacAddress := GetMacAddress()
LicenseKey := EncryptMsg(StringMacAddress)
;----------------------------------------------------
; Check connection every minute
;----------------------------------------------------
totalTime := 60000
remainingTime := totalTime
elapsed := 0
KeepChecking := false
;----------------------------------------------------
; General Loop Start
;----------------------------------------------------
Loop {
	DynamicReload := IniRead(TempSystemFile, "GeneralData", "DynamicReload")
	;----------------------------------------------------
	; Read License Data
	;----------------------------------------------------
	try {
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		UserName := IniRead(LicenseFile, "Data", "UserName")
		DeviceNumber := IniRead(LicenseFile, "Data", "DeviceNumber")
	}
	catch as e {
		; License file is missing. Exitapp once all is loaded 
		LicenseKeyInFile := ""
	}
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
			if ControllerAvailable == false {
				ControllerAvailable := true
				reload
			}
			ControllerAvailable := true
		}
	}
	if DynamicReload == true {
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
					   &CtrlRemapYesNo,
					   &NormalMode,
					   &RaceMode,
					   &CursorMovement,
					   &RotateCamera,
					   &RotateCameraCtrldown,
					   &RotateCameraShiftdown,
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
			; GUI 1 instance - Inside DynamicReload
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
					   &CtrlRemapYesNo,
					   &ControllerAvailable,
					   &LicenseKeyInFile,
					   &LicenseKey)
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
							 &RotateCameraShiftdown,
							 &LicenseKeyInFile,
							 &LicenseKey)
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
			switch true {
			case LicenseKeyInFile != LicenseKey:
				SB := ControllerRemapGui1.Add("StatusBar", , "Awaiting login or registration..")
			case ControllerAvailable == false:
				SB := ControllerRemapGui1.Add("StatusBar", , "Controller Not Found")
			default:
				SB := ControllerRemapGui1.Add("StatusBar", , "Ready.")
			}
			;----------------------------------------------------
			ControllerRemapGui1.OnEvent('Close', (*) => ExitApp())
			ControllerRemapGui1.Title := AppName
			ControllerRemapGui1.Show("x" . PositionX . " y" . PositionY . " w250 h375")
			Saved := ControllerRemapGui1.Submit(false)
		} else {
			;----------------------------------------------------
			; GUI 2 instance - Inside DynamicReload
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
					   &CtrlRemapYesNo,
					   &ControllerAvailable,
					   &LicenseKeyInFile,
					   &LicenseKey)
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
							 &RotateCameraShiftdown,
							 &LicenseKeyInFile,
							 &LicenseKey)
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
			switch true {
			case LicenseKeyInFile != LicenseKey:
				SB := ControllerRemapGui2.Add("StatusBar", , "Awaiting login or registration..")
			case ControllerAvailable == false:
				SB := ControllerRemapGui2.Add("StatusBar", , "Controller Not Found")
			default:
				SB := ControllerRemapGui2.Add("StatusBar", , "Ready.")
			}
			;----------------------------------------------------
			ControllerRemapGui2.OnEvent('Close', (*) => ExitApp())
			ControllerRemapGui2.Title := AppName
			ControllerRemapGui2.Show("x" . PositionX . " y" . PositionY . " w250 h375")
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
		; Validate Connection
		;----------------------------------------------------
		Connected := CheckConnection()
		;----------------------------------------------------
		; Validate license key and Device Number
		;----------------------------------------------------
		try {
			LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
			DeviceNumber := IniRead(LicenseFile, "Data", "DeviceNumber")
			LicenceAmount := IniRead(LicenseFile, "Data", "LicenceAmount")
			UserName := IniRead(LicenseFile, "Data", "UserName")
		}
		catch as e {
			; License file is missing
			ExitApp(3)
		}
		;----------------------------------------------------
		; Validate Session
		;----------------------------------------------------
		try {
		SessionKey := CurrentSessionKey()
		}
		catch {
		    ; No Session Generated
			SessionKey := ""
		}
		NewSessionKey := SessionGenerationKey()
		if SessionKey != NewSessionKey {
			;------------------------
			CustomerId := ""
			switch true {
			case Connected != true:
				KeepChecking := true
			case LicenseKeyInFile != LicenseKey:
			    SB.SetText("Authenticating..")
				VerifyingPortAccess()
				MySqlInst := DatabaseConnetion()
				;------------------------
				QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Mac_Address='" StringMacAddress "'" )
				if QueryResult == 0 {
					KeepChecking := false
					ResultSet := MySqlInst.GetResult()
					Device := 0
					for k, v in ResultSet.Rows {
						; Process each row (Could be more than 1 row)
						if StringMacAddress == v["Mac_Address"] {
							Device := v["Device_Number"]
							CustomerId := v["Customer_Id"]
							; Add missing device number silently
							DeviceNumber := Device
							IniWrite Device, LicenseFile, "Data", "DeviceNumber"
						}
					}
					if DeviceNumber != Device {
						; Device not found
						LoginOrRegister()
					}
				} else {
					; Unable to connect to server - Using VPN
					if Connected == true {
						; Port 3306 is blocked.
						Port3306Blocked()
					} else {
						LoginOrRegister()
						CheckConnectionMsg()
					}
				}
				LoginOrRegister()
			case UserName == "" or LicenceAmount == "":
			    SB.SetText("Authenticating..")
				VerifyingPortAccess()
				FlagSession := False
				MySqlInst := DatabaseConnetion()
				;------------------------
				QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Mac_Address='" StringMacAddress "'" )
				if QueryResult == 0 {
					KeepChecking := false
					ResultSet := MySqlInst.GetResult()
					Device := 0
					DeviceNumber := ""
					CountDevice := 0
					for k, v in ResultSet.Rows {
						; Process each row (Could be more than 1 row)
						if StringMacAddress == v["Mac_Address"] {
							Device := v["Device_Number"]
							CustomerId := v["Customer_Id"]
							; Add missing device number silently
							DeviceNumber := Device
							IniWrite Device, LicenseFile, "Data", "DeviceNumber"
							FlagSession := true
						}
					}
					if DeviceNumber != Device {
						; Device not found
						LoginOrRegister()
					}
				} else {
					; Unable to connect to server - Using VPN
					if Connected == true {
						; Port 3306 is blocked.
						Port3306Blocked()
					} else {
						LoginOrRegister()
						CheckConnectionMsg()
					}
				}
				;------------------------
				if CustomerId != "" {
					QueryResult := MySqlInst.Query("SELECT * FROM billing_gcr WHERE Customer_Id='" CustomerId "'" )
					if QueryResult == 0 {
						ResultSet := MySqlInst.GetResult()
						for k, v in ResultSet.Rows {
							; Process each row (Will always be a unique row for billing_gcr table)
							LicAmountGCR := v["Lic_Amount_GCR"]
							IniWrite LicAmountGCR, LicenseFile, "Data", "LicenceAmount"
						}
					}
					if UserName == "" {
						QueryResult := MySqlInst.Query("SELECT * FROM customers WHERE Customer_Id='" CustomerId "'")
						if QueryResult == 0 {
							ResultSet := MySqlInst.GetResult()
							for k, v in ResultSet.Rows {
								; Process each row (Will always be a unique row for customers table)
								UserName := v["User_Name"]
								IniWrite UserName, LicenseFile, "Data", "UserName"
							}
						}
					}
				}
				if FlagSession == true {
				    SetSessionKey(NewSessionKey)
				}
			default:
				SB.SetText("Authenticating..")
				VerifyingPortAccess()
				FlagSession := False
				MySqlInst := DatabaseConnetion()
				;------------------------
				QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Mac_Address='" StringMacAddress "'" )
				if QueryResult == 0 {
					KeepChecking := false
					ResultSet := MySqlInst.GetResult()
					Device := 0
					DeviceNumber := ""
					for k, v in ResultSet.Rows {
						; Process each row (Could be more than 1 row)
						if StringMacAddress == v["Mac_Address"] {
							Device := v["Device_Number"]
							CustomerId := v["Customer_Id"]
							; Add missing device number silently
							DeviceNumber := Device
							IniWrite Device, LicenseFile, "Data", "DeviceNumber"
							FlagSession := true
							SB.SetText("Ready.")
						}
					}
					if DeviceNumber != Device {
						; Device not found
						LoginOrRegister()
					}
				} else {
					; Unable to connect to server - Using VPN
					if Connected == true {
						; Port 3306 is blocked.
						Port3306Blocked()
					} else {
						LoginOrRegister()
						CheckConnectionMsg()
					}
				}
				if FlagSession == true {
				    SetSessionKey(NewSessionKey)
				}
			} ; End switch
		}
		
		;----------------------------------------------------
		; Set DynamicReload to false again
		;----------------------------------------------------
		DynamicReload := false
		IniWrite DynamicReload, TempSystemFile, "GeneralData", "DynamicReload"
		;----------------------------------------------------
	} ; End DimamicReload / GUI Static code
	;----------------------------------------------------
	; Dynamic code starts here
	;----------------------------------------------------
	if KeepChecking == true {
		elapsed += ControllerLoopInterval 
		remainingTime := round((totalTime - elapsed) / 1000)
		if (remainingTime <= 0) {
			remainingTime := 0
		}
	}
	if remainingTime == 0 {
		remainingTime := totalTime
		elapsed := 0
	    ; Check connection again
		Connected := CheckConnection()
		if Connected == true {
		    IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
		}
	}
	
    if ControllerAvailable == true {
		TextOnOffController.Value := " Controller Found"
		ControllerName.Value := GetKeyState(ControllerNumber "JoyName")
		cont_info := GetKeyState(ControllerNumber "JoyInfo")
		axis_info := " -   -   -   -   -   -   -   -   -   -"
		CoordMode "Mouse", "Screen"
		if GetKeyState(ExitGameControllerRemap, "P") == true {
			ExitApp()
		}
		if CtrlRemapYesNo == true {
			MouseGetPos(&x, &y)
			SB.SetText("Ready.                          X:" . x . " Y:" . y )
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
				ControllerAvailable := false
				reload
			}
			axis_info .= "  Y" Round(GetKeyState(ControllerNumber "JoyY"))
			;----------------------------------------------------
			; Jump Key - A
			if GetKeyState(ControllerNumber "Joy1", "P") {
				ButtonAOnOff.Value := " A"
				if NormalMode == true {
					RaceMode := false

					Send("{" . ButtonA . " down}")
				} else {
					RaceMode := true
					Send("{" . AfterBurnerButtonA . " down}")
				}
			} else {
				if ButtonAOnOff.Value == " A" {
					if NormalMode == true {
						RaceMode := false
						Send("{" . ButtonA . " up}")
					} else {
						RaceMode := true
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
				if NormalMode == true {
					RaceMode := false
					Send("{" . ButtonY . " down}")
				} else {
					RaceMode := true
					Send("{" . RespawnY . " down}")
				}
			} else {
				if ButtonYOnOff.Value == " Y" {
					if NormalMode == true {
						RaceMode := false
						Send("{" . ButtonY . " up}")
					} else {
						RaceMode := true
						Send("{" . RespawnY . " up}")
					}
					ButtonYOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			;  Key - LB
			if GetKeyState(ControllerNumber "Joy5", "P") {
				ButtonLBOnOff.Value := "LB"
				if NormalMode == true {
					RaceMode := false
					Send("{" . SprintLB . " down}")
				} else {
					RaceMode := true
					Send("{" . ButtonLB . " down}")
				}
			} else {
				if ButtonLBOnOff.Value == "LB" {
					if NormalMode == true {
						RaceMode := false
						Send("{" . SprintLB . " up}")
					} else {
						RaceMode := true
						Send("{" . ButtonLB . " up}")
					}
					ButtonLBOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Scanner Key - RB
			if GetKeyState(ControllerNumber "Joy6", "P") {
				ButtonRBOnOff.Value := "RB"
				if NormalMode == true {
					RaceMode := false
					Send("{" . ScannerRB . " down}")
				} else {
					RaceMode := true
					Send("{" . ButtonRB . " down}")
				}
			} else {
				if ButtonRBOnOff.Value == "RB" {
					if NormalMode == true {
						RaceMode := false
						Send("{" . ScannerRB . " up}")
					} else {
						RaceMode := true
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
				try {
					axis_info_Z := Round(GetKeyState(ControllerNumber "JoyZ"))
				}
				catch as e {
					; the controller was disconnected
					TextOnOffController.Value := " Controller Not Found."
					ControllerName.Value := " "
					axis_info := " -   -   -   -   -   -   -   -   -   -"
					TextAxisInfo.Value := axis_info
					ControllerAvailable := false
					reload
				}
				axis_info .= "  Z" Round(GetKeyState(ControllerNumber "JoyZ"))
				if NormalMode == true {
					RaceMode := false
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
					RaceMode := true
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
				try {
					axis_info_R := Round(GetKeyState(ControllerNumber "JoyR"))
				}
				catch as e {
					; the controller was disconnected
					TextOnOffController.Value := " Controller Not Found."
					ControllerName.Value := " "
					axis_info := " -   -   -   -   -   -   -   -   -   -"
					TextAxisInfo.Value := axis_info
					ControllerAvailable := false
					reload
				}
				axis_info .= "  R" Round(GetKeyState(ControllerNumber "JoyR"))
				if axis_info_R >= 45 and axis_info_R <= 55 {
					Switch true {
					case CursorMovement:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCamera:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraCtrldown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraShiftdown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					}
				}
				; Look Up
				if axis_info_R < 45 {
					Switch true {
					case CursorMovement:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x, "int", y + CursorSensUp)
					case RotateCamera:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " down}")
					case RotateCameraCtrldown:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateUp . " down}")
					case RotateCameraShiftdown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateUp . " down}")
					}
				}
				; Look Down
				if axis_info_R > 55 {
					Switch true {
					case CursorMovement:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x, "int", y + CursorSensDown)
					case RotateCamera:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateDown . " down}")
					case RotateCameraCtrldown:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateDown . " down}")	
					case RotateCameraShiftdown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateDown . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "U") {
				try {
					axis_info_U := Round(GetKeyState(ControllerNumber "JoyU"))
				}
				catch as e {
					; the controller was disconnected
					TextOnOffController.Value := " Controller Not Found."
					ControllerName.Value := " "
					axis_info := " -   -   -   -   -   -   -   -   -   -"
					TextAxisInfo.Value := axis_info
					ControllerAvailable := false
					reload
				}
				axis_info .= "  U" Round(GetKeyState(ControllerNumber "JoyU"))
				if axis_info_U >= 45 and axis_info_U <= 55 {
					Switch true {
					case CursorMovement:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					case RotateCamera:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraCtrldown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					case RotateCameraShiftdown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					}
				}
				; Look Left
				if axis_info_U < 45 {
					Switch true {
					case CursorMovement:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x + CursorSensLeft, "int", y)
					case RotateCamera:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " down}")
					case RotateCameraCtrldown:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateLeft . " down}")
					case RotateCameraShiftdown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateLeft . " down}")
					}
				}
				; Look Right
				if axis_info_U > 55 {
					Switch true {
					case CursorMovement:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x + CursorSensRight, "int", y)
					case RotateCamera:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateRight . " down}")
					case RotateCameraCtrldown:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateRight . " down}")
					case RotateCameraShiftdown:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateRight . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "V") {
				try {
					axis_info_V :=  Round(GetKeyState(ControllerNumber "JoyV"))
				}
				catch as e {
					; the controller was disconnected
					TextOnOffController.Value := " Controller Not Found."
					ControllerName.Value := " "
					axis_info := " -   -   -   -   -   -   -   -   -   -"
					TextAxisInfo.Value := axis_info
					ControllerAvailable := false
					reload
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "P") {
				try {
					axis_info_POV := Round(GetKeyState(ControllerNumber "JoyPOV"))
				}
				catch as e {
					; the controller was disconnected
					TextOnOffController.Value := " Controller Not Found."
					ControllerName.Value := " "
					axis_info := " -   -   -   -   -   -   -   -   -   -"
					TextAxisInfo.Value := axis_info
					ControllerAvailable := false
					reload
				}
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
	} ; End Controller Available
	else {
	    SB.SetText("No Controller Found.")
	}
	Sleep ControllerLoopInterval
} ; End General loop
