#Requires Autohotkey v2
#SingleInstance
SetWorkingDir(A_ScriptDir)
Global IconLib := A_ScriptDir . "\Icons"
, ImageLib := A_ScriptDir . "\Images"
, DonationsLib:= A_ScriptDir . "\Donations"
, Guide := "https://mean-littles-app.gitbook.io/mean-littles-app-docs"
, BuyMeACoffee := "https://buymeacoffee.com/fdjdash"
, IniFile := A_ScriptDir . "\ML_GameControllerRemap.ini"
, LicenseFile := A_ScriptDir . "\LicenseKey.ini"
, AppName := "ML Task Automator"
, CurrentVersion := "1.0"
, BlueFont := "c0x70A0FA"
, BackgroundDarkGrey := "Background2F2F2F"
;----------------------------------------------------
; GUI Properties
ControllerRemapGui := Gui("+AlwaysOnTop")
ControllerRemapGui.Opt("+MinimizeBox +OwnDialogs -Theme")
ControllerRemapGui.SetFont("Bold cLime", "Comic Sans MS")
ControllerRemapGui.BackColor := "0x2F2F2F"
try {
	ControllerRemapGui.Add("Picture", "x-16 y0 w304 h712", ImageLib . "\MLCRBackground.png")
}
catch {
}
;----------------------------------------------------
; Read Ini Properties
if !FileExist(IniFile) {
	CreateNewIniFile
}
ExitMessageTimeWait := IniRead(IniFile, "Properties", "ExitMessageTimeWait")
SuspendHotkeys := IniRead(IniFile, "Properties", "SuspendHotkeys")
if SuspendHotkeys > 1 or SuspendHotkeys < 0 {
	SuspendHotkeys := 0
	IniWrite SuspendHotkeys, IniFile, "Properties", "SuspendHotkeys"
}
;----------------------------------------------------
; Read ini Controller
ControllerLoop := IniRead(IniFile, "Controller", "ControllerLoop")
if ControllerLoop < 0  {
	ControllerLoop := 0
	IniWrite ControllerLoop, IniFile, "Controller", "ControllerLoop"
}
;----------------------------------------------------
; Read ini Cursor Movement
CursorSensRight := IniRead(IniFile, "ControllerCursorMovement", "CursorSensRight")
CursorSensDown := IniRead(IniFile, "ControllerCursorMovement", "CursorSensDown")
CursorSensLeft := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
CursorSensUp := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
CursorSpeed := IniRead(IniFile, "ControllerCursorMovement", "CursorSpeed")
;----------------------------------------------------
; Controller Camera Rotation
ShiftDownRotation := IniRead(IniFile, "ControllerCameraRotation", "ShiftDownRotation")
CtrlDownRotation := IniRead(IniFile, "ControllerCameraRotation", "CtrlDownRotation")
RotateLeft := IniRead(IniFile, "ControllerCameraRotation", "RotateLeft")
RotateRight := IniRead(IniFile, "ControllerCameraRotation", "RotateRight")
RotateUp := IniRead(IniFile, "ControllerCameraRotation", "RotateUp")
RotateDown := IniRead(IniFile, "ControllerCameraRotation", "RotateDown")
;----------------------------------------------------
; Controller Normal Mode Remap
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
; Controller Race Mode Remap
AfterBurnerButtonA := IniRead(IniFile, "ControllerRaceModeRemap", "AfterBurnerButtonA")
ButtonLB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonLB")
ButtonRB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonRB")
RespawnY := IniRead(IniFile, "ControllerRaceModeRemap", "RespawnY")
AcelerateButtonRT := IniRead(IniFile, "ControllerRaceModeRemap", "AcelerateButtonRT")
ReverseButtonLT := IniRead(IniFile, "ControllerRaceModeRemap", "ReverseButtonLT")
;----------------------------------------------------
; Controller Axis Remap
TurnLeft := IniRead(IniFile, "ControllerAxisRemap", "TurnLeft")
TurnRight := IniRead(IniFile, "ControllerAxisRemap", "TurnRight")
MoveForward := IniRead(IniFile, "ControllerAxisRemap", "MoveForward")
MoveBackward := IniRead(IniFile, "ControllerAxisRemap", "MoveBackward")
LeftPOV := IniRead(IniFile, "ControllerAxisRemap", "LeftPOV")
RightPOV := IniRead(IniFile, "ControllerAxisRemap", "RightPOV")
ForwadPOV := IniRead(IniFile, "ControllerAxisRemap", "ForwadPOV")
BackwardPOV := IniRead(IniFile, "ControllerAxisRemap", "BackwardPOV")
;----------------------------------------------------
; Setup Menu
FileMenu := Menu()
MenuBar_Storage := MenuBar()
MenuBar_Storage.Add("&File", FileMenu)
FileMenu.Add("&Exit`tCtrl+K",MenuHandlerExit)
FileMenu.Add("S&uspend Hotkeys`tCtrl+U",SuspendMenuHandler)
FileMenu.Insert()
try {
	FileMenu.SetIcon("S&uspend Hotkeys`tCtrl+U",IconLib . "\stop.ico")
	FileMenu.SetIcon("&Exit`tCtrl+K",IconLib . "\exit.ico")
}
catch {
}

OptionsMenu := Menu()
MenuBar_Storage.Add("&Options", OptionsMenu)
OptionsMenu.Add("Edit &Ini File", EditIniFileHandler)

try {
	OptionsMenu.SetIcon("Edit &Ini File", IconLib . "\File.ico")
}
catch {
}

DonationsMenu := Menu()
MenuBar_Storage.Add("&Donations", DonationsMenu)
DonationsMenu.Add("Buy me a coffee", DonationsMenuBMACoffeeHandler)
DonationsMenu.Add("ADA Cardano network", DonationsMenuCardanoHandler)
DonationsMenu.Add("EVM-compatible chains", DonationsMenuEVMHandler)
DonationsMenu.Add("BTC - Bitcoin chain", DonationsMenuBTCHandler)

try {
	DonationsMenu.SetIcon("Buy me a coffee", IconLib . "\Buymeacoffee.ico")
	DonationsMenu.SetIcon("ADA Cardano network", IconLib . "\ada_cardano.ico")
	DonationsMenu.SetIcon("EVM-compatible chains", IconLib . "\usdc.ico")
	DonationsMenu.SetIcon("BTC - Bitcoin chain", IconLib . "\bitcoin.ico")
}
catch {
}

HelpMenu := Menu()
MenuBar_Storage.Add("&Help", HelpMenu)
HelpMenu.Add("Guide", MenuHandlerGuide)
HelpMenu.Add("Quick Fix", MenuHandlerQuickFix)
HelpMenu.Insert()
HelpMenu.Add("About", MenuHandlerAbout)

try {
	HelpMenu.SetIcon("Guide", IconLib . "\MLCR.ico")
	HelpMenu.SetIcon("Quick Fix", IconLib . "\Fix.ico")
	HelpMenu.SetIcon("About", IconLib . "\info.ico")
}
catch {
}

ControllerRemapGui.MenuBar := MenuBar_Storage
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
ControllerRemapGui.Add("Text","x10 y320 h20 +0x200", " ADVICE: Minimize the app once you check")
ControllerRemapGui.Add("Text","x10 y345 h20 +0x200", " any rotation to avoid switching selectors.")
;----------------------------------------------------
SB := ControllerRemapGui.Add("StatusBar", , "Ready.")
;----------------------------------------------------
ControllerRemapGui.OnEvent('Close', (*) => ExitApp())
ControllerRemapGui.Title := "ML Game Controller Remap"
ControllerRemapGui.Show("w250 h395")
Saved := ControllerRemapGui.Submit(false)
;----------------------------------------------------
OnExit ExitMenu
ExitMenu(ExitReason,ExitCode)
{
	SB.SetText("Quiting..")
	SuspendHotkeys := IniRead(IniFile, "Properties", "SuspendHotkeys")
	if SuspendHotkeys != 0 {
		SuspendHotkeys := 0
		IniWrite SuspendHotkeys, IniFile, "Properties", "SuspendHotkeys"
	}
	If ExitReason == "Reload" {
		return 0
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
if FlagError == 0 {
	StringMacAddress := MacAddress[Count]
} else {
	StringMacAddress := MacAddress
}
LicenseKey := ""
Count := 0
flag := 0
Loop Parse StringMacAddress {
	; 48 - 57
	if ord(A_LoopField) == 45 {
		if flag == 4 {
			LicenseKey .= "\"
		} else if flag == 3 {
			LicenseKey .= "@"
			flag := 4
		} else if flag == 2 {
			LicenseKey .= "["
			flag := 3
		} else if flag == 1 {
			LicenseKey .= "!"
			flag := 2
		} else {
			LicenseKey .= "."
			flag := 1
		}	
	}
	if ord(A_LoopField) == 46 {
		LicenseKey .= "-"
	}
	if ord(A_LoopField) < 58 {
		; (0,9)
		EncriptedString := A_LoopField
		for index, letter in StrSplit(MixedPattern) {
			if (letter == A_LoopField) {
				LicenseKey .= chr(index + 36)
				LicenseKey .= chr(index + 45)
				LicenseKey .= chr(index + 33)
				break
			}
		}
	}
	
	if ord(A_LoopField) == 58 {
		LicenseKey .= ";"
	}
	if ord(A_LoopField) == 59 {
		LicenseKey .= ":"
	}
	; 65 - 90
	if ord(A_LoopField) > 66 and ord(A_LoopField) < 91 {
		; (0,25) + 10 = (10,35)
		EncriptedString := A_LoopField
		for index, letter in StrSplit(MixedPattern) {
			if (letter == A_LoopField) {
				LicenseKey .= chr(index + 60)
				LicenseKey .= chr(index + 44)
				LicenseKey .= chr(index + 32)
				break
			}
		}
	}
	; 97 - 122
	if ord(A_LoopField) > 96 and ord(A_LoopField) < 123 {
		; (0,26) + 10 + 26 = (36,61)
		EncriptedString := A_LoopField
		for index, letter in StrSplit(MixedPattern) {
			if (letter == A_LoopField) {
				LicenseKey .= chr(index + 40)
				LicenseKey .= chr(index + 26)
				LicenseKey .= chr(index + 31)
				break
			}
		}
	}
}
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
DonationsMenuCardanoHandler(*){
ShowCardano:
		Cardano := Gui("+AlwaysOnTop")
		Cardano.BackColor := "0x2F2F2F"
		try {
			Cardano.Add("Picture", "x-120 y0 w712 h300", DonationsLib . "\CardanoAddress.png")
		}
		catch {
		}
		Cardano.SetFont("s10 cLime", "Comic Sans MS")
		Cardano.Add("Text", "x80 y10", " ADA - Cardano Chain - ADA Handle: $grey.dash")
		Cardano.SetFont()
		Cardano.SetFont("s9 cLime", "Comic Sans MS")
		EditADA := Cardano.Add("Edit", "x20 y245 w430 h40 +Readonly", "addr1qxlvz257exqmlfe9edzxgug3vfz59fajc4f6x3mr0053pqvqlegkyt3v299y5mjuxx0zk7ezpvesgqjp69g8q9whykzqtfz2u4")
		EditADA.Opt("Background2F2F2F")
		Cardano.Title := "Cardano"
		Cardano.Show("w470 h300")
		ControlFocus(" ", "Cardano")
		Cardano.Opt("+LastFound")
	Return
}
;----------------------------------------------------
DonationsMenuEVMHandler(*){
ShowUSDC:
		EVM := Gui("+AlwaysOnTop")
		EVM.BackColor := "0x2F2F2F"
		try {
			EVM.Add("Picture", "x-120 y0 w712 h300", DonationsLib . "\USDCBaseAddress.png")
		}
		catch {
		}
		EVM.SetFont("s10 cLime", "Comic Sans MS")
		EVM.Add("Text", "x43 y10", " Copi, USDC, Ethereum, BNB and any EVM-compatible chain")
		EVM.SetFont()
		EVM.SetFont("s9 cLime", "Comic Sans MS")
		EditEVM := EVM.Add("Edit", "x75 y245 w310 h20 +Readonly", "0xd6F28E0fDacee390Bee8a8E37cdBA458629bf184")
		EditEVM.Opt("Background2F2F2F")
		EVM.Title := "EVM"
		EVM.Show("w470 h300")
		ControlFocus(" ", "EVM")
		EVM.Opt("+LastFound")
	Return
}

DonationsMenuBTCHandler(*){
ShowBTC:
		BTC := Gui("+AlwaysOnTop")
		BTC.BackColor := "0x2F2F2F"
		try {
			BTC.Add("Picture", "x-120 y0 w712 h300", DonationsLib . "\BtcAddress.png")
		}
		catch {
		}
		BTC.SetFont("s10 cLime", "Comic Sans MS")
		BTC.Add("Text", "x167 y10", " BTC - Bitcoin chain")
		BTC.SetFont()
		BTC.SetFont("s9 cLime", "Comic Sans MS")
		EditBTC := BTC.Add("Edit", "x88 y245 w285 h20 +Readonly", "bc1qnh2lw9tmkte2yjq9lujc80qq7ke32ps0wj30ss")
		EditBTC.Opt("Background2F2F2F")
		BTC.Title := "BTC"
		BTC.Show("w470 h300")
		ControlFocus(" ", "BTC")
		BTC.Opt("+LastFound")
	Return
}

DonationsMenuBMACoffeeHandler(*){
ShowBMACoffee:
		BMACoffee := Gui("+AlwaysOnTop")
		BMACoffee.BackColor := "0x2F2F2F"
		try {
			BMACoffee.Add("Picture", "x-120 y0 w712 h300", ImageLib . "\MLCRBackground2.png")
			BMACoffee.Add("Picture", "x9 y14 w64 h64", IconLib . "\MLCR.ico")
		}
		catch {
		}
		BMACoffee.SetFont("s18 W700 Q4 cLime", "Georgia")
		BMACoffee.Add("Text", "x80 y8", AppName)
		BMACoffee.SetFont("s9 cLime", "Comic Sans MS")
		BMACoffee.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		BMACoffee.Add("Text", "x80 y65", "License key: ")
		BMACoffee.SetFont()
		BMACoffee.SetFont("s7 Bold " . BlueFont . "", "Comic Sans MS")
		BMACoffee.Add("Text", "x160 y68", LicenseKey)
		BMACoffee.Add("Text", "x0 y90 w470 h1 +0x5")
		BMACoffee.SetFont()
		BMACoffee.SetFont("s12 cLime", "Comic Sans MS")
		BMACoffee.Add("Text", "x50 y100", "My buy me a coffee page will open in your browser.")
		BMACoffee.Add("Text", "x137 y125", "You can close this message.")
		BMACoffee.Add("Text", "x187 y150", " Thank you! ")
		BMACoffee.Add("Text", "x0 y180 w470 h1 +0x5")
		BMACoffee.SetFont()
		BMACoffee.SetFont("s9 cLime", "Comic Sans MS")
		BMACoffee.Add("Text", "x100 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		BMACoffee.SetFont()
		BMACoffee.SetFont("s8 cLime", "Comic Sans MS")
		BMACoffee.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		BMACoffee.Title := "BMACoffee"
		BMACoffee.Show("w470 h240")
		ControlFocus(" ", "BMACoffee")
		BMACoffee.Opt("+LastFound")
		Run BuyMeACoffee
	Return
}
;----------------------------------------------------
InvalidLicenseMsg(*){
	ShowLicense:
        InvLicMsg := Gui("+AlwaysOnTop")
		InvLicMsg.BackColor := "0x2F2F2F"
		try {
			InvLicMsg.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLCRBackground2.png")
			InvLicMsg.Add("Picture", "x9 y14 w64 h64", IconLib . "\MLCR.ico")
		}
		catch {
		}
		InvLicMsg.SetFont("s20 W700 Q4 cLime", "Georgia")
        InvLicMsg.Add("Text", "x80 y8", AppName)
		InvLicMsg.SetFont("s9 cLime", "Comic Sans MS")
		InvLicMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		InvLicMsg.Add("Text", "x80 y65", "License key: ")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s7 Bold cRed", "Comic Sans MS")
		InvLicMsg.Add("Text", "x160 y68", "???")
		InvLicMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s12 cRed", "Comic Sans MS")
		InvLicMsg.Add("Text", "x167 y110", "Invalid License Key")
        InvLicMsg.Add("Text", "x45 y140", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s9 cLime", "Comic Sans MS")
		InvLicMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		InvLicMsg.Add("Text", "x100 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s8 cLime", "Comic Sans MS")
		InvLicMsg.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        InvLicMsg.Title := "Invalid License Key!"
        InvLicMsg.Show("w470 h240")
        InvLicMsg.Opt("+LastFound")
    Return
}
;----------------------------------------------------
LicenseFileMissingMsg(*){
	ShowMissingLicFile:
        NoLicFileMsg := Gui("+AlwaysOnTop")
		NoLicFileMsg.BackColor := "0x2F2F2F"
		try {
			NoLicFileMsg.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLCRBackground2.png")
			NoLicFileMsg.Add("Picture", "x9 y14 w64 h64", IconLib . "\MLCR.ico")
		}
		catch {
		}
		NoLicFileMsg.SetFont("s20 W700 Q4 cLime", "Georgia")
        NoLicFileMsg.Add("Text", "x80 y8", AppName)
		NoLicFileMsg.SetFont("s9 cLime", "Comic Sans MS")
		NoLicFileMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		NoLicFileMsg.Add("Text", "x80 y65", "License key: ")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s7 Bold cRed", "Comic Sans MS")
		NoLicFileMsg.Add("Text", "x160 y68", "???")
		NoLicFileMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s12 cRed", "Comic Sans MS")
		NoLicFileMsg.Add("Text", "x160 y110", "License file not found")
        NoLicFileMsg.Add("Text", "x45 y140", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s9 cLime", "Comic Sans MS")
		NoLicFileMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		NoLicFileMsg.Add("Text", "x100 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s8 cLime", "Comic Sans MS")
		NoLicFileMsg.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        NoLicFileMsg.Title := "Invalid License Key!"
        NoLicFileMsg.Show("w470 h240")
        NoLicFileMsg.Opt("+LastFound")
    Return
}
;----------------------------------------------------
MenuHandlerAbout(*)
{
	ShowAbout:
		About := Gui("+AlwaysOnTop")
		About.BackColor := "0x2F2F2F"
		try {
			About.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLCRBackground2.png")
			About.Add("Picture", "x9 y14 w64 h64", IconLib . "\MLCR.ico")
		}
		catch {
		}
		About.SetFont("s18 W700 Q4 cLime", "Georgia")
		About.Add("Text", "x80 y8", "ML Game Controller Remap")
		About.SetFont("s9 cLime", "Comic Sans MS")
		About.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		About.Add("Text", "x80 y65", "License key: ")
		About.SetFont()
		About.SetFont("s7 Bold " . BlueFont . "", "Comic Sans MS")
		About.Add("Text", "x160 y68", LicenseKey)
		About.Add("Text", "x0 y90 w470 h1 +0x5")
		About.SetFont()
		About.SetFont("s12 cLime", "Comic Sans MS")
		About.Add("Text", "x80 y115", "Programmed and designed by:")
		About.Add("Link", "x310 y115", "<a href=`"https://github.com/FDJ-Dash`">FDJ-Dash</a>")
		About.SetFont()
		About.SetFont("s9 cLime", "Comic Sans MS")
		About.Add("Text", "x105 y155", "Support mail: mean.little.software@gmail.com")
		About.Add("Text", "x0 y180 w470 h1 +0x5")
        About.Add("Text", "x25 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		About.SetFont()
		About.SetFont("s8 cLime", "Comic Sans MS")
		About.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := About.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        About.Title := "About"
        About.Show("w470 h240")
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
		Exitmsg := Gui("+AlwaysOnTop")
		Exitmsg.BackColor := "0x2F2F2F"
		try {
			Exitmsg.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLCRBackground2.png")
			Exitmsg.Add("Picture", "x9 y14 w64 h64", IconLib . "\MLCR.ico")
		}
		catch {
		}
		Exitmsg.SetFont("s18 W700 Q4 cLime", "Georgia")
		Exitmsg.Add("Text", "x80 y8", AppName)
		Exitmsg.SetFont("s9 cLime", "Comic Sans MS")
		Exitmsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		Exitmsg.Add("Text", "x80 y65", "License key: ")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s7 Bold " . BlueFont . "", "Comic Sans MS")
		Exitmsg.Add("Text", "x160 y68", LicenseKey)
		Exitmsg.Add("Text", "x0 y90 w470 h1 +0x5")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s12 cLime", "Comic Sans MS")
		Exitmsg.Add("Text", "x45 y110", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
        Exitmsg.Add("Text", "x175 y140", "Have a nice day!")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s9 cLime", "Comic Sans MS")
		Exitmsg.Add("Text", "x0 y180 w470 h1 +0x5")
		Exitmsg.Add("Text", "x100 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s8 cLime", "Comic Sans MS")
		Exitmsg.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        Exitmsg.Title := "Goodbye!"
        Exitmsg.Show("w470 h240")
        Exitmsg.Opt("+LastFound")
	Return
}
;----------------------------------------------------
SuspendMenuHandler(*){
	SuspendHotkeys := IniRead(IniFile, "Properties", "SuspendHotkeys")
	SuspendHotkeys := !SuspendHotkeys
	IniWrite SuspendHotkeys, IniFile, "Properties", "SuspendHotkeys"
	if SuspendHotkeys == true {
		FileMenu.ToggleCheck("S&uspend Hotkeys`tCtrl+U")
	} else {
		FileMenu.Uncheck("S&uspend Hotkeys`tCtrl+U")
	}
	Suspend
}
;----------------------------------------------------
MenuHandlerExit(*){
	ExitApp()
}
;----------------------------------------------------
MenuHandlerGuide(*) {
	ShowGuide:
		GuideMsg := Gui("+AlwaysOnTop")
		GuideMsg.BackColor := "0x2F2F2F"
		try {
			GuideMsg.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLCRBackground2.png")
			GuideMsg.Add("Picture", "x9 y14 w64 h64", IconLib . "\MLCR.ico")
		}
		catch {
		}
		GuideMsg.SetFont("s18 W700 Q4 cLime", "Georgia")
		GuideMsg.Add("Text", "x80 y8", AppName)
		GuideMsg.SetFont("s9 cLime", "Comic Sans MS")
		GuideMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		GuideMsg.Add("Text", "x80 y65", "License key: ")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s7 Bold " . BlueFont . "", "Comic Sans MS")
		GuideMsg.Add("Text", "x160 y68", LicenseKey)
		GuideMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s12 cLime", "Comic Sans MS")
		GuideMsg.Add("Text", "x100 y110", "The guide will open in your browser.")
        GuideMsg.Add("Text", "x137 y140", "You can close this message.")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s9 cLime", "Comic Sans MS")
		GuideMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		GuideMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Dash. All Rights Reserved.")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s8 cLime", "Comic Sans MS")
		GuideMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        ogcButtonOK := GuideMsg.Add("Button", "x370 y200 w80 h24 Default", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        GuideMsg.Title := "Guide"
        GuideMsg.Show("w470 h240")
        ControlFocus("Button1", "Guide")
        GuideMsg.Opt("+LastFound")
		run Guide
	Return

	Destroy(*){
		GuideMsg.Destroy()
	}
}
;----------------------------------------------------
MenuHandlerQuickFix(*) {
	Send("{w up}")
	Send("{shift up}")
	Send("{Ctrl up}")
	Reload
}
;----------------------------------------------------
EditIniFileHandler(*) {
	run IniFile
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
		Sleep ControllerLoop
	} ; End Controller loop
} ; End Controller Available
;----------------------------------------------------
CreateNewIniFile(*) {
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "; HINT: If you delete this file or move it away from its forder,`n" , IniFile
	FileAppend "; Task Automator will generate a new file on the spot.`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "; WARNING: Don't set this file as read only!`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Properties]`n" , IniFile
	FileAppend "ExitMessageTimeWait=3000`n" , IniFile
	FileAppend "SuspendHotkeys=0`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Controller]`n" , IniFile
	FileAppend "ControllerLoop=100`n" , IniFile
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
}