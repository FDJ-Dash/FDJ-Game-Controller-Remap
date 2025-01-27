; ------------ Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
; Gamer Alias: Mean Little, Grey Dash, Dash.
; ------------ App Details ------------
; App Full Name: Mean Little's Game Controller Remap.
; Description: This is an app aimed towards game controller devices not recognized by some games
; but still recognized by the Operating System. 
; --------------------------------
#Requires Autohotkey v2
#SingleInstance
SetWorkingDir(A_ScriptDir)
Global IconLib := A_ScriptDir . "\Icons"
, ImageLib := A_ScriptDir . "\Images"
, Guide := "https://mean-littles-app.gitbook.io/mean-littles-software"
, IniFile := A_ScriptDir . "\ML_GameControllerRemap.ini"
, LicenseFile := A_ScriptDir . "\LicenseKey.ini"
, DataFile := A_Temp . "\MLGCR_Data.ini"
, TempCleanFileMLGCR := A_Temp . "\MLGCR_CleanFile.ini"
, AppName := "ML Game Controller Remap"
, CurrentVersion := "v1.3"
, MLSoftwareIcon := "\Logo-FDJ-Dash.png"
, DefaultMsgBackgroundImage := "\Smoke2.jpg"
;----------------------------------------------------
; Read Ini Properties
if !FileExist(IniFile) {
	CreateNewIniFile()
}
;----------------------------------------------------
; Read ini Font types
MainFontType := IniRead(IniFile, "FontType", "MainFontType")
MessageAppNameFontType := IniRead(IniFile, "FontType", "MessageAppNameFontType")
LicenseKeyFontType := IniRead(IniFile, "FontType", "LicenseKeyFontType")
MessageMainMsgFontType := IniRead(IniFile, "FontType", "MessageMainMsgFontType")
MessageFontType := IniRead(IniFile, "FontType", "MessageFontType")
;----------------------------------------------------
; Read ini Font Colors
MainFontColor := "c"
MainFontColor .= IniRead(IniFile, "FontColors", "MainFontColor")
;-------------------------------
MessageAppNameFontColor := "c"
MessageAppNameFontColor .= IniRead(IniFile, "FontColors", "MessageAppNameFontColor")
;-------------------------------
MessageMainMsgFontColor := "c"
MessageMainMsgFontColor .= IniRead(IniFile, "FontColors", "MessageMainMsgFontColor")
;-------------------------------
MessageFontColor := "c"
MessageFontColor .= IniRead(IniFile, "FontColors", "MessageFontColor")
;-------------------------------
LicenseKeyFontColor := "c0x"
LicenseKeyFontColor .= IniRead(IniFile, "FontColors", "LicenseKeyFontColor")
;----------------------------------------------------
; Read ini Background
BackgroundMainColor := "Background"
BackgroundColor := IniRead(IniFile, "Background", "BackgroundColor")
BackgroundMainColor .= BackgroundColor
;-------------------------------
BackgroundPicture := IniRead(IniFile, "Background", "BackgroundPicture")
MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
;----------------------------------------------------
; Read ini Properties
ExitMessageTimeWait := IniRead(IniFile, "Properties", "ExitMessageTimeWait")
GuiPriorityAlwaysOnTop := IniRead(IniFile, "Properties", "GuiPriorityAlwaysOnTop")
if GuiPriorityAlwaysOnTop < 0 or GuiPriorityAlwaysOnTop > 1 {
	GuiPriorityAlwaysOnTop := 0
	IniWrite GuiPriorityAlwaysOnTop, IniFile, "Properties", "GuiPriorityAlwaysOnTop"
}
;-------------------------------
ControllerLoopInterval := IniRead(IniFile, "Properties", "ControllerLoopInterval")
if ControllerLoopInterval < 0  {
	ControllerLoopInterval := 0
	IniWrite ControllerLoopInterval, IniFile, "Properties", "ControllerLoopInterval"
}
PositionX := IniRead(IniFile, "Properties", "PositionX")
PositionY := IniRead(IniFile, "Properties", "PositionY")
if isInteger(PositionX) != true or PositionX == ""{
	PositionX := A_ScreenWidth / 2 - 200
}
if isInteger(PositionY) != true or PositionY == ""{
	PositionY := 150
}
ExitGameControllerRemap := IniRead(IniFile, "Properties", "ExitGameControllerRemap")
;-------------------------------
; Read ini Settings
CheckforUpdatesDaily := IniRead(IniFile, "Settings", "CheckforUpdatesDaily")
CheckforupdatesWeekly := IniRead(IniFile, "Settings", "CheckforupdatesWeekly")
NeverCheckForUpdates := IniRead(IniFile, "Settings", "NeverCheckForUpdates")
LastUpdateCheckTimeStamp := IniRead(IniFile, "Settings", "LastUpdateCheckTimeStamp")
NeedUpdate := IniRead(IniFile, "Settings", "NeedUpdate")
switch true {
case CheckforUpdatesDaily == true:
	CheckforupdatesWeekly := false
	NeverCheckForUpdates := false
case CheckforupdatesWeekly == true:
	CheckforUpdatesDaily := false
	NeverCheckForUpdates := false
case NeverCheckForUpdates == true:
	CheckforUpdatesDaily := false
	CheckforupdatesWeekly := false
}
;----------------------------------------------------
; Read ini Cursor Movement
CursorSensRight := IniRead(IniFile, "ControllerCursorMovement", "CursorSensRight")
CursorSensDown := IniRead(IniFile, "ControllerCursorMovement", "CursorSensDown")
CursorSensLeft := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
CursorSensUp := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
CursorSpeed := IniRead(IniFile, "ControllerCursorMovement", "CursorSpeed")
;----------------------------------------------------
; Read ini Controller Camera Rotation
ShiftDownRotation := IniRead(IniFile, "ControllerCameraRotation", "ShiftDownRotation")
CtrlDownRotation := IniRead(IniFile, "ControllerCameraRotation", "CtrlDownRotation")
RotateLeft := IniRead(IniFile, "ControllerCameraRotation", "RotateLeft")
RotateRight := IniRead(IniFile, "ControllerCameraRotation", "RotateRight")
RotateUp := IniRead(IniFile, "ControllerCameraRotation", "RotateUp")
RotateDown := IniRead(IniFile, "ControllerCameraRotation", "RotateDown")
;----------------------------------------------------
; Read ini Controller Normal Mode Remap
ButtonA := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonA")
ButtonB := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonB")
ButtonX := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonX")
ButtonY := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonY")
SprintLB := IniRead(IniFile, "ControllerNormalModeRemap", "SprintLB")
ScannerRB := IniRead(IniFile, "ControllerNormalModeRemap", "ScannerRB")
ButtonLT := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonLT")
ButtonRT := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonRT")
ButtonBack := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonBack")
ButtonStart := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonStart")
;----------------------------------------------------
; Read ini Controller Race Mode Remap
AfterBurnerButtonA := IniRead(IniFile, "ControllerRaceModeRemap", "AfterBurnerButtonA")
ButtonLB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonLB")
ButtonRB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonRB")
RespawnY := IniRead(IniFile, "ControllerRaceModeRemap", "RespawnY")
AcelerateButtonRT := IniRead(IniFile, "ControllerRaceModeRemap", "AcelerateButtonRT")
ReverseButtonLT := IniRead(IniFile, "ControllerRaceModeRemap", "ReverseButtonLT")
;----------------------------------------------------
; Read ini Controller Axis Remap
TurnLeft := IniRead(IniFile, "ControllerAxisRemap", "TurnLeft")
TurnRight := IniRead(IniFile, "ControllerAxisRemap", "TurnRight")
MoveForward := IniRead(IniFile, "ControllerAxisRemap", "MoveForward")
MoveBackward := IniRead(IniFile, "ControllerAxisRemap", "MoveBackward")
LeftPOV := IniRead(IniFile, "ControllerAxisRemap", "LeftPOV")
RightPOV := IniRead(IniFile, "ControllerAxisRemap", "RightPOV")
ForwadPOV := IniRead(IniFile, "ControllerAxisRemap", "ForwadPOV")
BackwardPOV := IniRead(IniFile, "ControllerAxisRemap", "BackwardPOV")
;----------------------------------------------------
; GUI Properties
if GuiPriorityAlwaysOnTop == true {
	ControllerRemapGui := Gui("+AlwaysOnTop")
} else {
	ControllerRemapGui := Gui()
}
ControllerRemapGui.Opt("+MinimizeBox +OwnDialogs -Theme")
ControllerRemapGui.SetFont("Bold " . MainFontColor, MainFontType)
ControllerRemapGui.BackColor := "0x" . BackgroundColor

if BackgroundPicture == "" {
	try {
		ControllerRemapGui.Add("Picture", "x0 y0 w250 h422", ImageLib . "\Smoke1.jpg")
	}
	catch {
	}
} else {
	try {
		ControllerRemapGui.Add("Picture", "x0 y0 w250 h422", BackgroundPicture)
	}
	catch {
		BackgroundPicture := ""
		IniWrite BackgroundPicture, IniFile, "Background", "BackgroundPicture"
		Reload
	}
}
;----------------------------------------------------
; Setup Menu
MenuBar_Storage := MenuBar()
;-------------------------------
FileMenu := Menu()
MenuBar_Storage.Add("&File", FileMenu)
FileMenu.Add("&Exit`t" . ExitGameControllerRemap,MenuHandlerExit)
try {
	FileMenu.SetIcon("&Exit`t" . ExitGameControllerRemap,IconLib . "\exit.ico")
}
catch {
}
;-------------------------------
OptionsMenu := Menu()
MenuBar_Storage.Add("&Options", OptionsMenu)
OptionsMenu.Add("Edit &Ini File", EditIniFileHandler)
OptionsMenu.Insert()
OptionsMenu.Add("Change Background &Image", ChangeBackgroundHandler)
OptionsMenu.Add("Change M&essage Background Image", ChangeMessageBackgroundHandler)
OptionsMenu.Insert()
OptionsMenu.Add("&Always On Top: ON/OFF", GuiPriorityAlwaysOnTopHandler)

try {
	OptionsMenu.SetIcon("Edit &Ini File", IconLib . "\File.ico")
	OptionsMenu.SetIcon("Change Background &Image", IconLib . "\ChangeBackground.png")
	OptionsMenu.SetIcon("Change M&essage Background Image", IconLib . "\ChangeBackground.png")
	OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch2.ico")
}
catch {
}
;-------------------------------
SettingsMenu := Menu()
MenuBar_Storage.Add("&Settings", SettingsMenu)
SettingsMenu.Add("Check for updates &daily", MenuHandlerCheckUptDaily)
SettingsMenu.Add("Check for updates &weekly", MenuHandlerCheckUptWeekly)
SettingsMenu.Add("&Never check for updates", MenuHandlerNeverCheckUpt)

try {
	SettingsMenu.SetIcon("Check for updates &daily", IconLib . "\CheckDaily.png")
	SettingsMenu.SetIcon("Check for updates &weekly", IconLib . "\CheckWeekly.png")
	SettingsMenu.SetIcon("&Never check for updates", IconLib . "\stop.ico")
}
catch {
}
;-------------------------------
HelpMenu := Menu()
MenuBar_Storage.Add("&Help", HelpMenu)
HelpMenu.Add("Guide", MenuHandlerGuide)
HelpMenu.Add("Quick Fix", MenuHandlerQuickFix)
HelpMenu.Insert()
HelpMenu.Add("Update", MenuHandlerUpdate)
HelpMenu.Insert()
HelpMenu.Add("About", MenuHandlerAbout)

try {
	HelpMenu.SetIcon("Guide", IconLib . "\Logo-MLGCR.ico")
	HelpMenu.SetIcon("Quick Fix", IconLib . "\Fix.ico")
	HelpMenu.SetIcon("Update", IconLib . "\Update.png")
	HelpMenu.SetIcon("About", IconLib . "\info.ico")
}
catch {
}
;-------------------------------
ControllerRemapGui.MenuBar := MenuBar_Storage
;----------------------------------------------------
if GuiPriorityAlwaysOnTop == true {
	OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch1.ico")
} else {
	OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch2.ico")
}
;----------------------------------------------------
; Controller
ControllerRemapGui.Add("Text","x10 y10 w68 h20 +0x200", " Controller:")
TextOnOffController := ControllerRemapGui.Add("Text","x85 y10 w155 h20 +0x200", " Controller Not Found.")
ControllerName := ControllerRemapGui.Add("Text","x10 y35 w230 h20 +0x200", " - - - - - - - - - -")
;----------------------------------------------------
ControllerRemapGui.Add("Text", "x1 y59 w250 h2 +0x10") ; Separator
;----------------------------------------------------
ControllerRemapGui.Add("Text","x20 y65 w212 h20 +0x200", " Game Doesn't Detect Controller Device?")
ControllerRemapGui.Add("Text","x20 y90 w98 h20 +0x200", " Controller Remap:")
RadioCtrlRemapYes := ControllerRemapGui.Add("Radio", "x140 y90 w30 h20 +Checked", "Y")
RadioCtrlRemapNo := ControllerRemapGui.Add("Radio", "x200 y90 w31 h20", "N")
;----------------------------------------------------
; Controller Status
TextAxisInfo := ControllerRemapGui.Add("Text","x20 y115 w212 h20 +0x200", " " )

ButtonAOnOff := ControllerRemapGui.Add("Text","x20 y140 w20 h20 +0x200", " - ")
ButtonBOnOff := ControllerRemapGui.Add("Text","x40 y140 w20 h20 +0x200", " - ")
ButtonXOnOff := ControllerRemapGui.Add("Text","x60 y140 w20 h20 +0x200", " - ")
ButtonYOnOff := ControllerRemapGui.Add("Text","x80 y140 w20 h20 +0x200", " - ")
ButtonLBOnOff := ControllerRemapGui.Add("Text","x100 y140 w20 h20 +0x200", " - ")
ButtonRBOnOff := ControllerRemapGui.Add("Text","x120 y140 w20 h20 +0x200", " - ")
ButtonBackOnOff := ControllerRemapGui.Add("Text","x140 y140 w45 h20 +0x200", " -   -")
ButtonStartOnOff := ControllerRemapGui.Add("Text","x185 y140 w47 h20 +0x200", "-   -")

NormalMode := ControllerRemapGui.Add("Radio", "x20 y165 w95 h20 +Checked", " Normal Mode")
RaceMode := ControllerRemapGui.Add("Radio", "x150 y165 w82 h20 ", " Race Mode")
;----------------------------------------------------
ControllerRemapGui.Add("Text", "x1 y188 w250 h2 +0x10") ; Separator
ControllerRemapGui.Add("Text","x80 y195 w90 h20 +0x200", " Camera Rotation")
CursorMovement := ControllerRemapGui.Add("Radio", "x20 y220 h20 +Checked", " Cursor Movement")
RotateCamera := ControllerRemapGui.Add("Radio", "x20 y245 h20", " Rotate with arrow keys")
RotateCameraCtrldown := ControllerRemapGui.Add("Radio", "x20 y270 h20", " Rotate Ctrl Down + arrow keys")
RotateCameraShiftdown := ControllerRemapGui.Add("Radio", "x20 y295 h20", " Rotate Shift Down + arrow keys")
ControllerRemapGui.Add("Text", "x1 y318 w250 h2 +0x10") ; Separator
ControllerRemapGui.Add("Text","x10 y323 h20 +0x200", " ADVICE: Minimize the app once you check")
ControllerRemapGui.Add("Text","x10 y348 h20 +0x200", " any rotation to avoid switching selectors.")
;----------------------------------------------------
; Check for updates
; A_Now - The current local time in YYYYMMDDHH24MISS format.
;-------------------------------
ControllerRemapGui.Add("Text", "x1 y371 w250 h2 +0x10") ; Separator
FlagCheckTime := false
GreenIcon := ""
YellowIcon := ""
BlueIcon := ""
RedIcon := ""
if CheckforUpdatesDaily == true and 
	(LastUpdateCheckTimeStamp == "" or DateDiff(A_Now, LastUpdateCheckTimeStamp, "Days") > 0) {
	FlagCheckTime := true
} 
;-------------------------------
if CheckforupdatesWeekly == true and 
	(LastUpdateCheckTimeStamp == "" or DateDiff(A_Now, LastUpdateCheckTimeStamp, "Days") > 6) {
	FlagCheckTime := true
}

switch true {
case NeverCheckForUpdates == true:
	ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
	ControllerRemapGui.SetFont("s8 Bold c00A8F3", LicenseKeyFontType)
	ControllerRemapGui.Add("Text","x97 y376 w126 h20 +0x200", " Update check disabled ")
	try {
		ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\UpdateCheckDisabled.png")
	}
	catch {
	}
case NeedUpdate == true:
	ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
	ControllerRemapGui.SetFont("s8 Bold cYellow", LicenseKeyFontType)
	ControllerRemapGui.Add("Text","x97 y376 w126 h20 +0x200", " New version available ")
	try {
		ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\NewVersionAvailable.png")
	}
	catch {
	}
case FlagCheckTime == false and NeedUpdate == false:
	ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
	ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
	ControllerRemapGui.Add("Text","x97 y376 w126 h20 +0x200", " Version up to date ")
	try {
		ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\UpToDate.png")
	}
	catch {
	}
}
;-------------------------------
if FlagCheckTime == true {
	Connected := CheckConnection()
	if Connected != true {
		ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
		ControllerRemapGui.SetFont("s8 Bold cRed", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x97 y376 h20 +0x200", " No internet connection ")
		try {
			ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\NoInternetConnection.png")
		}
		catch {
		}
	} else {
		if !FileExist(DataFile) {
			ParseRequest()
		}
		MLGCRLatestReleaseVersion := IniRead(DataFile, "GeneralData", "MLGCRLatestReleaseVersion")
		if MLGCRLatestReleaseVersion == "" {
			ParseRequest()
		}
		DownloadUrl := IniRead(DataFile, "EncriptedData", "MLGCRDownload")
		MLGCRLatestReleaseVersion := IniRead(DataFile, "GeneralData", "MLGCRLatestReleaseVersion")
		if MLGCRLatestReleaseVersion != CurrentVersion {
			if DownloadUrl != "" {
				ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
				ControllerRemapGui.SetFont("s8 Bold cYellow", LicenseKeyFontType)
				ControllerRemapGui.Add("Text","x101 y376 h20 +0x200", " New version available ")
				try {
					ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\NewVersionAvailable.png")
				}
				catch {
				}
				NeedUpdate := true
				IniWrite NeedUpdate, IniFile, "Settings", "NeedUpdate"
			}
		}
		if MLGCRLatestReleaseVersion == CurrentVersion {
			ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
			ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
			ControllerRemapGui.Add("Text","x128 y376 h20 +0x200", " Up to date ")
			try {
				ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\UpToDate.png")
			}
			catch {
			}
		}
		IniWrite A_Now, IniFile, "Settings", "LastUpdateCheckTimeStamp"
	}
}
;----------------------------------------------------
SB := ControllerRemapGui.Add("StatusBar", , "Ready.")
;----------------------------------------------------
ControllerRemapGui.OnEvent('Close', (*) => ExitApp())
ControllerRemapGui.Title := AppName
ControllerRemapGui.Show("x" . PositionX . " y" . PositionY . " w250 h422")
Saved := ControllerRemapGui.Submit(false)

;----------------------------------------------------
OnExit ExitMenu
ExitMenu(ExitReason,ExitCode)
{
	SB.SetText("Quiting..")
	ControllerRemapGui.GetPos(&PosX, &PosY)
	if PosX != -32000 {
		IniWrite PosX, IniFile, "Properties", "PositionX"
	}
	if PosY != -32000 {
		IniWrite PosY, IniFile, "Properties", "PositionY"
	}
	If ExitReason == "Reload" {
		return 0
	}
	try {
		FileDelete DataFile
		FileDelete TempCleanFileMLGCR
	}
	catch {
	}
	If ExitCode == 2 {
		InvalidLicenseMsg
		sleep ExitMessageTimeWait
		return 0
	}
	If ExitCode == 3 {
		LicenseFileMissingMsg
		sleep ExitMessageTimeWait
		return 0
	}
	Send("{w up}")
	Send("{shift up}")
	Send("{Ctrl up}")
	ExitMsg
	sleep ExitMessageTimeWait
	return 0
}
;----------------------------------------------------
; Auto-detect the controller number if called for:
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

TempFile := A_Temp . "\AuxData2.ini"
if !FileExist(TempFile) {
	RunWait(A_ComSpec " /c getmac /NH > " TempFile, , "Hide") ; ipconfig (slow)
	FileAppend "[AuxData]" , TempFile
}
Count := 0
FlagError := 0
Loop Read, TempFile
{
	; Check if the current line is empty
	if !A_LoopReadLine {
		Count++
		continue
	}

	; Process the non-empty line here
	Match := RegExMatch(A_LoopReadLine, ".*?([0-9A-F])(?!\\Device)", &mac)
	Match2 := RegExMatch(A_LoopReadLine, ".*?([0-9A-Z])(?!\\w\\Device)", &mac)
	Switch true {
	case Match == true:
		MacAddress := StrSplit( A_LoopReadLine, A_Space)
	case Match2 == true:
		MacAddress := StrSplit( A_LoopReadLine, A_Space)
	Default:
		MacAddress := "An Error Ocurred"
		FlagError := 1
	}
	break
}

MixedPattern := "Az0By9Cx7Da8Eb2Fc4Gw3Hv5Ij6Js1KlLhMpNeOtPgQnRrSiTqUoVkWmXdYfZu"
PunctuationPattern := "!#$%&'()*+,-./:;<=>?@[\]^_`{|}~ "
if FlagError == 0 {
	StringMacAddress := MacAddress[Count]
} else {
	StringMacAddress := MacAddress
}

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

try {
	FileDelete TempFile
}
catch {

}
;----------------------------------------------------
InvalidLicenseMsg(*){
	ShowLicense:
		if GuiPriorityAlwaysOnTop == true {
			InvLicMsg := Gui("+AlwaysOnTop")
		} else {
			InvLicMsg := Gui()
		}
		InvLicMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				InvLicMsg.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				InvLicMsg.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			InvLicMsg.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		InvLicMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
        InvLicMsg.Add("Text", "x80 y8", AppName)
		InvLicMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		InvLicMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		InvLicMsg.Add("Text", "x80 y65", "License key: ")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s8 Bold cRed", LicenseKeyFontType)
		InvLicMsg.Add("Text", "x160 y65", "???")
		InvLicMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s12 cRed", MessageMainMsgFontType)
		InvLicMsg.Add("Text", "x167 y110", "Invalid License Key")
        InvLicMsg.Add("Text", "x45 y140", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		InvLicMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		InvLicMsg.Add("Text", "x100 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		InvLicMsg.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        InvLicMsg.Title := "Invalid License Key!"
		ControllerRemapGui.GetPos(&PosX, &PosY)
        InvLicMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        InvLicMsg.Opt("+LastFound")
    Return
}
;----------------------------------------------------
LicenseFileMissingMsg(*){
	ShowMissingLicFile:
		if GuiPriorityAlwaysOnTop == true {
			NoLicFileMsg := Gui("+AlwaysOnTop")
		} else {
			NoLicFileMsg := Gui()
		}
		NoLicFileMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				NoLicFileMsg.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				NoLicFileMsg.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			NoLicFileMsg.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		NoLicFileMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
        NoLicFileMsg.Add("Text", "x80 y8", AppName)
		NoLicFileMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NoLicFileMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		NoLicFileMsg.Add("Text", "x80 y65", "License key: ")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s8 Bold cRed", LicenseKeyFontType)
		NoLicFileMsg.Add("Text", "x160 y65", "???")
		NoLicFileMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s12 cRed", MessageMainMsgFontType)
		NoLicFileMsg.Add("Text", "x160 y110", "License file not found")
        NoLicFileMsg.Add("Text", "x45 y140", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NoLicFileMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		NoLicFileMsg.Add("Text", "x100 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		NoLicFileMsg.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        NoLicFileMsg.Title := "Invalid License Key!"
		ControllerRemapGui.GetPos(&PosX, &PosY)
        NoLicFileMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        NoLicFileMsg.Opt("+LastFound")
    Return
}
;----------------------------------------------------
ConnectionMessage(*) {
	ShowConnection:
		if GuiPriorityAlwaysOnTop == true {
			ConnectionMsg := Gui("+AlwaysOnTop")
		} else {
			ConnectionMsg := Gui()
		}
		ConnectionMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				ConnectionMsg.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				ConnectionMsg.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			ConnectionMsg.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		ConnectionMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		ConnectionMsg.Add("Text", "x80 y8", AppName)
		ConnectionMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ConnectionMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		ConnectionMsg.Add("Text", "x80 y65", "License key: ")
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		ConnectionMsg.Add("Text", "x160 y65", LicenseKey)
		ConnectionMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s12 cRed", MessageMainMsgFontType)
		ConnectionMsg.Add("Text", "x125 y110", "Unable to check for new updates.")
		ConnectionMsg.Add("Text", "x135 y140", "Please verify your connection")		
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ConnectionMsg.Add("Text", "x0 y180 w470 h1 +0x5")
        ConnectionMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		ConnectionMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := ConnectionMsg.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        ConnectionMsg.Title := "Connection Failed!"
		ControllerRemapGui.GetPos(&PosX, &PosY)
        ConnectionMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        ControlFocus("Button1", "Connection Failed!")
        ConnectionMsg.Opt("+LastFound")
	Return
	Destroy(*){
		ConnectionMsg.Destroy()
	}
}
;----------------------------------------------------
UpToDateMessage(*) {
	ShowUpToDate:
		if GuiPriorityAlwaysOnTop == true {
			UpToDateMsg := Gui("+AlwaysOnTop")
		} else {
			UpToDateMsg := Gui()
		}
		UpToDateMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				UpToDateMsg.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				UpToDateMsg.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			UpToDateMsg.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		UpToDateMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		UpToDateMsg.Add("Text", "x80 y8", AppName)
		UpToDateMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		UpToDateMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		UpToDateMsg.Add("Text", "x80 y65", "License key: ")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		UpToDateMsg.Add("Text", "x160 y65", LicenseKey)
		UpToDateMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		UpToDateMsg.Add("Text", "x135 y123", "Current version is up to date!")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		UpToDateMsg.Add("Text", "x0 y180 w470 h1 +0x5")
        UpToDateMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		UpToDateMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := UpToDateMsg.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        UpToDateMsg.Title := "Up To Date!"
		ControllerRemapGui.GetPos(&PosX, &PosY)
        UpToDateMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        ControlFocus("Button1", "Up To Date!")
        UpToDateMsg.Opt("+LastFound")
	Return
	Destroy(*){
		UpToDateMsg.Destroy()
	}
}
;----------------------------------------------------
NewVersionAvailableMessage(ReleaseVersion, *) {
	ShowNewVerMsg:
		if GuiPriorityAlwaysOnTop == true {
			NewVerMsg := Gui("+AlwaysOnTop")
		} else {
			NewVerMsg := Gui()
		}
		NewVerMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				NewVerMsg.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				NewVerMsg.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			NewVerMsg.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		NewVerMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		NewVerMsg.Add("Text", "x80 y8", AppName)
		NewVerMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NewVerMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		NewVerMsg.Add("Text", "x80 y65", "License key: ")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		NewVerMsg.Add("Text", "x160 y65", LicenseKey)
		NewVerMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		NewVerMsg.Add("Text", "x100 y115", "New release version " . ReleaseVersion . " is available")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ogcButtonUpdate := NewVerMsg.Add("Button", "x190 y145 w80 h24", "Download")
		ogcButtonUpdate.OnEvent("Click", UpdateDownload)
		NewVerMsg.Add("Text", "x0 y180 w470 h1 +0x5")
        NewVerMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		NewVerMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := NewVerMsg.Add("Button", "x370 y200 w80 h24", "Close")
		ogcButtonOK.OnEvent("Click", Destroy)
        NewVerMsg.Title := "New Version Available!"
		ControllerRemapGui.GetPos(&PosX, &PosY)
        NewVerMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        ControlFocus("Button1", "New Version Available!")
        NewVerMsg.Opt("+LastFound")
		NewVerMsg.OnEvent("Close", NewVerMsg_Close)
	Return
	Destroy(*){
		NewVerMsg.Destroy()
	}
	UpdateDownload(*){
		MLGCRName := IniRead(DataFile, "GeneralData", "MLGCRName")
		; Scaped character included: ``
		MLGCRDownloadPart1 := "NJdlcj]YIG27Q]LFCM\dIG27?HLFR\./FMNJLTY``ea86FK19Y``a]FNelNJ19]dmiZbah:4qm7?]dc_NVCMRYeaT\[bHD^fDBFK82FRWaDB*3szeaHPipkgV^7>HDNVelqmRZ5:LF]dqm\d[bieWaPXeleaHPszKGCAJR@Gea@EDAEP./COHQ45_kFT*3)&T\OVFG:FBM``iPQuq@Ldl=DT]F@CQRS]ikgBK\d:;IUNWLSa](0XY_kZcRYEA(0\]ah4@;89Da]NWFNIW]dWSCKFM,)B>TUHP]iahEA<E@H@AEPmt4@4B9B:;O[;8<G9B@NLM4@dmNJV^jk_fR\"
		MLGCRDownloadPart1 := DecriptMsg(MLGCRDownloadPart1)
		;------------------------
		MLGCRDownloadPart2 := IniRead(DataFile, "EncriptedData", "MLGCRDownload")
		MLGCRDownloadPart2 := DecriptMsg(MLGCRDownloadPart2)
		;------------------------
		MLGCRDownloadPart3 := "53qm"
		MLGCRDownloadPart3 := DecriptMsg(MLGCRDownloadPart3)
		;------------------------
		MLGCRDownloadPart4 := FileSelect("S16", A_MyDocuments . "\" . MLGCRName , "Save File", "Executable files (*.exe)")
		FullPathDownLoad := MLGCRDownloadPart1 . " " . MLGCRDownloadPart2 . " " . MLGCRDownloadPart3 . " " . MLGCRDownloadPart4
		if MLGCRDownloadPart4 != "" {
			RunWait(A_ComSpec " /c " . FullPathDownLoad . " > " TempCleanFileMLGCR, , "Hide")
		}
		NewVerMsg.Destroy()
	}
	NewVerMsg_Close(*){
		try {
			FileDelete TempCleanFileMLGCR
		}
		catch {
		}
	}
}
;----------------------------------------------------
MenuHandlerAbout(*) {
	ShowAbout:
		if GuiPriorityAlwaysOnTop == true {
			About := Gui("+AlwaysOnTop")
		} else {
			About := Gui()
		}
		About.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				About.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				About.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			About.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		About.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		About.Add("Text", "x80 y8", AppName)
		About.SetFont("s9 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		About.Add("Text", "x80 y65", "License key: ")
		About.SetFont()
		About.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		About.Add("Text", "x160 y65", LicenseKey)
		About.Add("Text", "x0 y90 w470 h1 +0x5")
		About.SetFont()
		About.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		About.Add("Text", "x80 y115", "Programmed and designed by:")
		About.Add("Link", "x310 y115", "<a href=`"https://github.com/FDJ-Dash`">FDJ-Dash</a>")
		About.SetFont()
		About.SetFont("s9 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x105 y155", "Support mail: mean.little.software@gmail.com")
		About.Add("Text", "x0 y180 w470 h1 +0x5")
        About.Add("Text", "x25 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		About.SetFont()
		About.SetFont("s8 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := About.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        About.Title := "About"
		ControllerRemapGui.GetPos(&PosX, &PosY)
        About.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        ControlFocus("Button1", "About")
        About.Opt("+LastFound")
	Return
	Destroy(*){
		About.Destroy()
	}
}
;----------------------------------------------------
ExitMsg(*){
	ShowExit:
		if GuiPriorityAlwaysOnTop == true {
			Exitmsg := Gui("+AlwaysOnTop")
		} else {
			Exitmsg := Gui()
		}
		Exitmsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				Exitmsg.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				Exitmsg.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			Exitmsg.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		Exitmsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		Exitmsg.Add("Text", "x80 y8", AppName)
		Exitmsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		Exitmsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		Exitmsg.Add("Text", "x80 y65", "License key: ")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		Exitmsg.Add("Text", "x160 y65", LicenseKey)
		Exitmsg.Add("Text", "x0 y90 w470 h1 +0x5")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		Exitmsg.Add("Text", "x45 y110", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
        Exitmsg.Add("Text", "x175 y140", "Have a nice day!")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		Exitmsg.Add("Text", "x0 y180 w470 h1 +0x5")
		Exitmsg.Add("Text", "x107 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		Exitmsg.Add("Text", "x116 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        Exitmsg.Title := "Goodbye!"
		ControllerRemapGui.GetPos(&PosX, &PosY)
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        Exitmsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        Exitmsg.Opt("+LastFound")
	Return
}
;----------------------------------------------------
MenuHandlerExit(*){
	ExitApp()
}
;----------------------------------------------------
MenuHandlerGuide(*) {
	ShowGuide:
		if GuiPriorityAlwaysOnTop == true {
			GuideMsg := Gui("+AlwaysOnTop")
		} else {
			GuideMsg := Gui()
		}
		GuideMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				GuideMsg.Add("Picture", "x0 y0 w470 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				GuideMsg.Add("Picture", "x0 y0 w470 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				Reload
			}
		}
		try {
			GuideMsg.Add("Picture", "x9 y14 w64 h64 +border", IconLib . MLSoftwareIcon)
		}
		catch {
		}
		GuideMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		GuideMsg.Add("Text", "x80 y8", AppName)
		GuideMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		GuideMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap " CurrentVersion)
		GuideMsg.Add("Text", "x80 y65", "License key: ")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		GuideMsg.Add("Text", "x160 y65", LicenseKey)
		GuideMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		GuideMsg.Add("Text", "x100 y110", "The guide will open in your browser.")
        GuideMsg.Add("Text", "x137 y140", "You can close this message.")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		GuideMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		GuideMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		GuideMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        ogcButtonOK := GuideMsg.Add("Button", "x370 y200 w80 h24 Default", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        GuideMsg.Title := "Guide"
		ControllerRemapGui.GetPos(&PosX, &PosY)
        GuideMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
        ControlFocus("Button1", "Guide")
        GuideMsg.Opt("+LastFound")
		run Guide
	Return

	Destroy(*){
		GuideMsg.Destroy()
	}
}
;----------------------------------------------------
EncriptMsg(OriginalMsg, *){
	MixedPattern := "Az0By9Cx7Da8Eb2Fc4Gw3Hv5Ij6Js1KlLhMpNeOtPgQnRrSiTqUoVkWmXdYfZu"
	PunctuationPattern := "!#$%&'()*+,-./:;<=>?@[\]^_`"{|}~ "
	
	EncriptedMsg := ""
	FlagSignCount := 0
	FlagNmCount := 0
	Flag_az_Count := 0
	Flag_AZ_Count2 := 0
	Loop Parse OriginalMsg {
		switch true {
		case ord(A_LoopField) > 31 and ord(A_LoopField) < 48:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 47 and ord(A_LoopField) < 58:
			; (0,9)
			EncriptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case FlagNmCount == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 1)
						FlagNmCount++
						break
					}
				case FlagNmCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 5)
						EncriptedMsg .= chr(index + 34 + 16)
						FlagNmCount++
						break
					}
				case FlagNmCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 9)
						EncriptedMsg .= chr(index + 34 + 23)
						FlagNmCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 57 and ord(A_LoopField) < 65:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 64 and ord(A_LoopField) < 91:
			; (A-Z)
			EncriptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case Flag_AZ_Count2 == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 14)
						EncriptedMsg .= chr(index + 34 + 26)
						Flag_AZ_Count2++
						break
					}
				case Flag_AZ_Count2 == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 16)
						Flag_AZ_Count2++
						break
					}
				case Flag_AZ_Count2 == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 11)
						EncriptedMsg .= chr(index + 34 + 12)
						Flag_AZ_Count2 := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 90 and ord(A_LoopField) < 97:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 96 and ord(A_LoopField) < 123:
			; (a-z)
			EncriptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case Flag_az_Count == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 27)
						EncriptedMsg .= chr(index + 34 + 23)
						Flag_az_Count++
						break
					}
				case Flag_az_Count == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 12)
						Flag_az_Count++
						break
					}
				case Flag_az_Count == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 19)
						EncriptedMsg .= chr(index + 34 + 26)
						Flag_az_Count := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 122 and ord(A_LoopField) < 127:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		}
	}
	return EncriptedMsg
}
;----------------------------------------------------
DecriptMsg(EncriptedMsgMLGCR, *) {
	MixedPattern := "Az0By9Cx7Da8Eb2Fc4Gw3Hv5Ij6Js1KlLhMpNeOtPgQnRrSiTqUoVkWmXdYfZu"
	PunctuationPattern := "!#$%&'()*+,-./:;<=>?@[\]^_`"{|}~ "
	DecriptedMsg := ""

	count := 1
	DiffValue := 0
	IndexKey := 0
	Loop Parse EncriptedMsgMLGCR {
		if Mod(count, 2) == 1 {
			RealKey := ord(A_LoopField)
		}
		
		if Mod(count, 2) == 0 {
			AddedKey1 := ord(A_LoopField)
			DiffValue := Abs(RealKey - AddedKey1)
			flagLetterFound := 0
			switch true {
			case DiffValue == 1:
				IndexKey := RealKey - 34 - 11
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 2:
				IndexKey := RealKey - 34 - 7
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 3:
				IndexKey := RealKey - 34 - 4
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 4:
				IndexKey := RealKey - 34 - 27
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 5:
				IndexKey := RealKey - 34 - 4
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 6:
				IndexKey := RealKey - 34 - 10
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 7:
				IndexKey := RealKey - 34 - 19
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 8:
				IndexKey := RealKey - 34 - 4
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 9:
				IndexKey := RealKey - 34 - 7
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 10:
				IndexKey := RealKey - 34 - 21
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 11:
				IndexKey := RealKey - 34 - 5
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 12:
				IndexKey := RealKey - 34 - 14
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			case DiffValue == 14:
				IndexKey := RealKey - 34 - 9
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecriptedMsg .= letter
						break
					}
				}
			}
		}
		count++
	}
	return DecriptedMsg
}
;----------------------------------------------------
ParseRequest(*){
	TempFileMLGCR := A_Temp . "\MLGCR_UpdateData.ini"
	EncCurl := "NJdlcj]YIG27\dLFCMFRIGAF*3szeaHPipkgV^7>HDNVelqmRZ;5Wa]dqm\d[bieIGPXeleaHPszKG@EJR@GeaF@DAEP./COHQ45_kFT*3)&T\OVFG:FBM``iPQuq@Ldl=DT]Q[CQRS]ikgBK\d:;IUNWLSa](0XY_kZcRYEA(0\]ah4@;89Da]NWFNIW]dWSCKFM,)B>TUHP]iahEA<E@H@AEPmt4@4B9B:;O[;8<G9B@NLM4@dmNJV^jk_fDBFK_[NV]da]CK;5EO75@Ga]V^38_fmiNVW^{w4<93FMqm^fEOcjc_JRipZV75@L3<IJ27:F19RY_[:4LUNOCMCO19mtc_5309ZbaheaT\ip]YFN[bkg27Z[LTmtHDJR:4cjc_FN[bHDCK[bZVEOFN@GeaLTRYea"
	RunWait(A_ComSpec " /c " . DecriptMsg(EncCurl) . " > " TempFileMLGCR, , "Hide")
	
	Count := 0
	Loop Read, TempFileMLGCR
	{
		; Check if the current line is empty
		if !A_LoopReadLine {
			Count++
			continue
		}
		
		; Process the non-empty line here
		Flag1stLetter := 0
		CountOrd34 := 0
		FlagAddedSpace := 0
		CleanLine := ""
		Loop parse A_LoopReadLine {
			if ord(A_LoopField) == 34 {
				CountOrd34++
				if CountOrd34 == 4 {
					break
				}
			}
			if Flag1stLetter == 1 {
				Switch true {
				case ord(A_LoopField) == 32 and FlagAddedSpace == 0:
					CleanLine .= A_LoopField
					FlagAddedSpace := 1
				case ord(A_LoopField) == 34 and FlagAddedSpace == 0:
					CleanLine .= " "
					FlagAddedSpace := 1
				case ord(A_LoopField) == 44:
					break
				case ord(A_LoopField) != 34:
					CleanLine .= A_LoopField
					FlagAddedSpace := 0
				}	
			} 
			if ord(A_LoopField) != 32 and Flag1stLetter == 0 {
				Flag1stLetter := 1
				if ord(A_LoopField) != 34 {
					break
				}
			}
		}
		FileAppend CleanLine . "`n", TempCleanFileMLGCR
		Match := RegExMatch(CleanLine, "tag_name : v\d+\.\d+", &tag_name)
		Match2 := RegExMatch(CleanLine, "url : https://api.github.com/repos/FDJ-Dash/ML-Game-Controller-Remap/releases/assets/\d+", &download_url)
		Match3 := RegExMatch(CleanLine, "name : \w+-\w+-\w+-\w+-\w+-v\d+\.\d+\.\w+", &name)
		Switch true {
		case Match == true:
			for index, word in StrSplit(tag_name[0], A_Space) {
				if index == 3 {
					MLGCRLatestReleaseVersion := word
					IniWrite MLGCRLatestReleaseVersion, DataFile, "GeneralData", "MLGCRLatestReleaseVersion"
				}
			}
		case Match2 == true:
			for index, word in StrSplit(download_url[0], A_Space) {
				if index == 3 {
					DownloadUrl := word
					DownloadUrl := EncriptMsg(DownloadUrl)
					IniWrite DownloadUrl, DataFile, "EncriptedData", "MLGCRDownload"
				}
			}
		case Match3 == true:
			for index, word in StrSplit(name[0], A_Space) {
				if index == 3 {
					Name := word
					IniWrite Name, DataFile, "GeneralData", "MLGCRName"
				}
			}
		}
	}
	
	try {
		FileDelete TempFileMLGCR
	}
	catch {

	}
}
;----------------------------------------------------
CheckConnection(*){
	TempFileConnectionMLGCR := A_Temp . "\MLGCR_Connection.log"
	RunWait(A_ComSpec " /c curl -k -L https://www.google.com > " TempFileConnectionMLGCR, , "Hide")
	Match := false
	Count := 0
	Loop Read, TempFileConnectionMLGCR
	{
		; Check if the current line is empty
		if !A_LoopReadLine {
			Count++
			continue
		}
		if Count > 0 {
			Match := true
			break
		}
		Count++
	}
	
	try {
		FileDelete TempFileConnectionMLGCR
	}
	catch {

	}
	return Match
}
;----------------------------------------------------
MenuHandlerQuickFix(*) {
	Send("{w up}")
	Send("{shift up}")
	Send("{Ctrl up}")
	Reload
}
;----------------------------------------------------
MenuHandlerUpdate(*){
	SB.SetText("Checking for updates..")
	Connection := CheckConnection()
	if Connection != true {
		ConnectionMessage()
		return
	}
	ParseRequest()
	DownloadUrl := IniRead(DataFile, "EncriptedData", "MLGCRDownload")
	MLGCRLatestReleaseVersion := IniRead(DataFile, "GeneralData", "MLGCRLatestReleaseVersion")
	IniWrite A_Now, IniFile, "Settings", "LastUpdateCheckTimeStamp"
	if MLGCRLatestReleaseVersion != CurrentVersion {
		if DownloadUrl != "" {
			IniWrite true, IniFile, "Settings", "NeedUpdate"
			NewVersionAvailableMessage(MLGCRLatestReleaseVersion)
		}
	}
	If MLGCRLatestReleaseVersion == CurrentVersion {
		UpToDateMessage
	}
}
;----------------------------------------------------
MenuHandlerCheckUptDaily(*){
	CheckforUpdatesDaily := true
	CheckforupdatesWeekly := false
	NeverCheckForUpdates := false
	IniWrite CheckforUpdatesDaily, IniFile, "Settings", "CheckforUpdatesDaily"
	IniWrite CheckforupdatesWeekly, IniFile, "Settings", "CheckforupdatesWeekly"
	IniWrite NeverCheckForUpdates, IniFile, "Settings", "NeverCheckForUpdates"
	Reload
}
;----------------------------------------------------
MenuHandlerCheckUptWeekly(*){
	CheckforUpdatesDaily := false
	CheckforupdatesWeekly := true
	NeverCheckForUpdates := false
	IniWrite CheckforUpdatesDaily, IniFile, "Settings", "CheckforUpdatesDaily"
	IniWrite CheckforupdatesWeekly, IniFile, "Settings", "CheckforupdatesWeekly"
	IniWrite NeverCheckForUpdates, IniFile, "Settings", "NeverCheckForUpdates"
	Reload
}
;----------------------------------------------------
MenuHandlerNeverCheckUpt(*){
	CheckforUpdatesDaily := false
	CheckforupdatesWeekly := false
	NeverCheckForUpdates := true
	IniWrite CheckforUpdatesDaily, IniFile, "Settings", "CheckforUpdatesDaily"
	IniWrite CheckforupdatesWeekly, IniFile, "Settings", "CheckforupdatesWeekly"
	IniWrite NeverCheckForUpdates, IniFile, "Settings", "NeverCheckForUpdates"
	Reload
}
;----------------------------------------------------
EditIniFileHandler(*) {
	run IniFile
}
;----------------------------------------------------
ChangeBackgroundHandler(*){
	SelectedFile := FileSelect("3", "A_MyDocuments", "Open a file", "Text Documents (*.ico; *.png; *.jpg)")
	IniWrite SelectedFile, IniFile, "Background", "BackgroundPicture"
	Reload
}
;----------------------------------------------------
ChangeMessageBackgroundHandler(*){
	SelectedFile := FileSelect("3", "A_MyDocuments", "Open a file", "Text Documents (*.ico; *.png; *.jpg)")
	IniWrite SelectedFile, IniFile, "Background", "MessageBackgroundPicture"
	Reload
}
;----------------------------------------------------
GuiPriorityAlwaysOnTopHandler(*){
	GuiPriorityAlwaysOnTop := IniRead(IniFile, "Properties", "GuiPriorityAlwaysOnTop")
	GuiPriorityAlwaysOnTop := !GuiPriorityAlwaysOnTop
	IniWrite GuiPriorityAlwaysOnTop, IniFile, "Properties", "GuiPriorityAlwaysOnTop"
	Reload
}
;----------------------------------------------------
if ControllerAvailable == true {
	TextOnOffController.Value := " Controller Found"
	ControllerName.Value := GetKeyState(ControllerNumber "JoyName")
	cont_info := GetKeyState(ControllerNumber "JoyInfo")
	axis_info := " -   -   -   -   -   -   -   -   -   -"
	CoordMode "Mouse", "Screen"

	; Controller AutoRun Loop
	Loop {
		if GetKeyState(ExitGameControllerRemap){
			ExitApp()
		}
		if RadioCtrlRemapYes.Value == true {
			RadioCtrlRemapNo.Value := false
			if GetKeyState(ExitGameControllerRemap){
				ExitApp()
			}
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
	} ; End Controller loop
} ; End Controller Available
;----------------------------------------------------
CreateNewIniFile(*) {
	FileAppend "; ------------ Credits ------------`n" , IniFile
	FileAppend "; Creator: Fernando Daniel Jaime.`n" , IniFile
	FileAppend "; Programmer Alias: FDJ-Dash.`n" , IniFile
	FileAppend "; Gamer Alias: Mean Little, Grey Dash, Dash.`n" , IniFile
	FileAppend "; ------------ App Details ------------`n" , IniFile
	FileAppend "; App Full Name: Mean Little's Game Controller Remap.`n" , IniFile
	FileAppend "; Description: This is an app aimed towards game controller devices not recognized by some games`n" , IniFile
	FileAppend "; but still recognized by the Operating System.`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "; HINT: If you delete this file or move it away from its forder,`n" , IniFile
	FileAppend "; Game Controller Remap will generate a new file on the spot.`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "; Find the list of key names here: https://www.autohotkey.com/docs/v2/KeyList.htm`n" , IniFile
	FileAppend ";-------------------------------`n" , IniFile
	FileAppend "; See the list of recommended fonts here: https://www.autohotkey.com/docs/v2/misc/FontsStandard.htm`n" , IniFile
	FileAppend ";-------------------------------`n" , IniFile
	FileAppend "; See the list of color names and RGB values here: https://www.autohotkey.com/docs/v2/misc/Colors.htm`n" , IniFile
	FileAppend "; Black Silver Gray White Maroon Red Purple Fuchsia Green Lime Olive Yellow Navy Blue Teal Aqua`n" , IniFile
	FileAppend "; If the color name you need is not listed you can still write its RGB value`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Properties]`n" , IniFile
	FileAppend "ExitMessageTimeWait=3000`n" , IniFile
	FileAppend "GuiPriorityAlwaysOnTop=1`n" , IniFile
	FileAppend "ControllerLoopInterval=100`n" , IniFile
	FileAppend ";-------------------------------`n" , IniFile
	FileAppend "PositionX=605`n" , IniFile
	FileAppend "PositionY=324`n" , IniFile
	FileAppend ";-------------------------------`n" , IniFile
	FileAppend "ExitGameControllerRemap=Esc`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Settings]`n" , IniFile
	FileAppend "CheckforUpdatesDaily=1`n" , IniFile
	FileAppend "CheckforupdatesWeekly=0`n" , IniFile
	FileAppend "NeverCheckForUpdates=0`n" , IniFile
	FileAppend "NeedUpdate=0`n" , IniFile
	FileAppend ";-------------------------------`n" , IniFile
	FileAppend "LastUpdateCheckTimeStamp=`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerCursorMovement]`n" , IniFile
	FileAppend "CursorSensRight=100`n" , IniFile
	FileAppend "CursorSensDown=100`n" , IniFile
	FileAppend "CursorSensLeft=-100`n" , IniFile
	FileAppend "CursorSensUp=-100`n" , IniFile
	FileAppend "CursorSpeed=0`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerCameraRotation]`n" , IniFile
	FileAppend "ShiftDownRotation=Shift`n" , IniFile
	FileAppend "CtrlDownRotation=Ctrl`n" , IniFile
	FileAppend "RotateLeft=Left`n" , IniFile
	FileAppend "RotateRight=Right`n" , IniFile
	FileAppend "RotateUp=Up`n" , IniFile
	FileAppend "RotateDown=Down`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerNormalModeRemap]`n" , IniFile
	FileAppend "ButtonA=Space`n" , IniFile
	FileAppend "ButtonB=RButton`n" , IniFile
	FileAppend "ButtonX=esc`n" , IniFile
	FileAppend "ButtonY=f`n" , IniFile
	FileAppend "SprintLB=Shift`n" , IniFile
	FileAppend "ScannerRB=n`n" , IniFile
	FileAppend "ButtonRT=w`n" , IniFile
	FileAppend "ButtonLT=s`n" , IniFile
	FileAppend "ButtonStart=tab`n" , IniFile
	FileAppend "ButtonBack=i`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerAxisRemap]`n" , IniFile
	FileAppend "TurnLeft=a`n" , IniFile
	FileAppend "TurnRight=d`n" , IniFile
	FileAppend "MoveForward=w`n" , IniFile
	FileAppend "MoveBackward=s`n" , IniFile
	FileAppend "LeftPOV=a`n" , IniFile
	FileAppend "RightPOV=d`n" , IniFile
	FileAppend "ForwadPOV=w`n" , IniFile
	FileAppend "BackwardPOV=s`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerRaceModeRemap]`n" , IniFile
	FileAppend "AfterBurnerButtonA=Shift`n" , IniFile
	FileAppend "ButtonLB=a`n" , IniFile
	FileAppend "ButtonRB=d`n" , IniFile
	FileAppend "RespawnY=r`n" , IniFile
	FileAppend "AcelerateButtonRT=w`n" , IniFile
	FileAppend "ReverseButtonLT=s`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[FontType]`n" , IniFile
	FileAppend "MainFontType=Comic Sans MS`n" , IniFile
	FileAppend "MessageAppNameFontType=Georgia`n" , IniFile
	FileAppend "LicenseKeyFontType=Comic Sans MS`n" , IniFile
	FileAppend "MessageMainMsgFontType=Georgia`n" , IniFile
	FileAppend "MessageFontType=Georgia`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[FontColors]`n" , IniFile
	FileAppend "MainFontColor=FF9933`n" , IniFile
	FileAppend "MessageAppNameFontColor=FF9933`n" , IniFile
	FileAppend "LicenseKeyFontColor=70A0FA`n" , IniFile
	FileAppend "MessageMainMsgFontColor=FF9933`n" , IniFile
	FileAppend "MessageFontColor=FF9933`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Background]`n" , IniFile
	FileAppend "BackgroundColor=2F2F2F`n" , IniFile
	FileAppend "BackgroundPicture=`n" , IniFile
	FileAppend "MessageBackgroundPicture=`n" , IniFile
}