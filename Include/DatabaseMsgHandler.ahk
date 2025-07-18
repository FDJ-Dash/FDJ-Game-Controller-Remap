;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains all database messages handled by Game Controller Remap.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; WelcomeMessage(*)
; MailValidationMessage(*)
; MailAlreadyRegistered(*)
; MailNotRegistered(*)
; InvalidEmailAddress(*)
; FieldsNotValidated(*)
; PasswordTooShort(*)
; PasswordUpdateSuccessful(*)
; CheckInternetConnectEmailPassword(*)
; CheckConnectionMsg(*)
;----------------------------------------------------
WelcomeMessage(*){
	ShowWelcomeMsg:
		if GuiPriorityAlwaysOnTop == true {
			WelcomeMsg := Gui("+AlwaysOnTop")
		} else {
			WelcomeMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		UserName := IniRead(LicenseFile, "Data", "UserName")
		DeviceNumber := IniRead(LicenseFile, "Data", "DeviceNumber")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		WelcomeMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				WelcomeMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				WelcomeMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			WelcomeMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		WelcomeMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		WelcomeMsg.Add("Text", "x50 y16 +Center w400", AppName)
		WelcomeMsg.Add("Text", "x450 y16 +Center w40", "")
		WelcomeMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		WelcomeMsg.Add("Text", "x390 y24 ", CurrentVersion)
		WelcomeMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		WelcomeMsg.SetFont()
		WelcomeMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		WelcomeMsg.Add("Text", "x80 y110 +Center w340", "Welcome " . UserName)
		WelcomeMsg.Add("Text", "x100 y140 +Center w300", "Loading.. ")
		;-----------------
        WelcomeMsg.Title := "Welcome!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        WelcomeMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        WelcomeMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		WelcomeMsg.Destroy()
    }		
}
;----------------------------------------------------
MailValidationMessage(ToUserMail, *) {
	InputValidCode:
		if GuiPriorityAlwaysOnTop == true {
			CodeInput := Gui("+AlwaysOnTop")
		} else {
			CodeInput := Gui()
		}
		CodeInput.MarginX := "5", CodeInput.MarginY := "5"
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		CodeInput.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				CodeInput.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				CodeInput.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			CodeInput.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		CodeInput.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		CodeInput.Add("Text", "x50 y16 +Center w400", AppName)
		CodeInput.Add("Text", "x450 y16 +Center w40", "")
		CodeInput.SetFont("s9 " . MessageFontColor, MessageFontType)
		CodeInput.Add("Text", "x390 y24 ", CurrentVersion)
		CodeInput.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		CodeInput.SetFont()
		CodeInput.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		CodeInput.Add("Text", "x80 y110 +Center w340", "Mail validation code sent to: ")
		CodeInput.Add("Text", "x10 y140 +Center w480", ToUserMail)
		;-----------------
        CodeInput.Title := "Mail Validation Code"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        CodeInput.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        CodeInput.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		CodeInput.Destroy()
	}
}
;----------------------------------------------------
MailAlreadyRegistered(*) {
	ShowMailAlreadyRegisteredMsg:
		if GuiPriorityAlwaysOnTop == true {
			AlrdRegisteredMsg := Gui("+AlwaysOnTop")
		} else {
			AlrdRegisteredMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		AlrdRegisteredMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				AlrdRegisteredMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				AlrdRegisteredMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			AlrdRegisteredMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		AlrdRegisteredMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		AlrdRegisteredMsg.Add("Text", "x50 y16 +Center w400", AppName)
		AlrdRegisteredMsg.Add("Text", "x450 y16 +Center w40", "")
		AlrdRegisteredMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		AlrdRegisteredMsg.Add("Text", "x390 y24 ", CurrentVersion)
		AlrdRegisteredMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		AlrdRegisteredMsg.SetFont()
		AlrdRegisteredMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		AlrdRegisteredMsg.Add("Text", "x80 y110 +Center w340", "Your mail is already registered.")
		AlrdRegisteredMsg.Add("Text", "x90 y140 +Center w320", "Login to validate your new device.")
		;-----------------
        AlrdRegisteredMsg.Title := "Mail already registered!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        AlrdRegisteredMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        AlrdRegisteredMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		AlrdRegisteredMsg.Destroy()
    }		
}
;----------------------------------------------------
MailNotRegistered(*) {
	ShowMailNotRegisteredMsg:
		if GuiPriorityAlwaysOnTop == true {
			NotRegisteredMsg := Gui("+AlwaysOnTop")
		} else {
			NotRegisteredMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		NotRegisteredMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				NotRegisteredMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				NotRegisteredMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			NotRegisteredMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		NotRegisteredMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		NotRegisteredMsg.Add("Text", "x50 y16 +Center w400", AppName)
		NotRegisteredMsg.Add("Text", "x450 y16 +Center w40", "")
		NotRegisteredMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NotRegisteredMsg.Add("Text", "x390 y24 ", CurrentVersion)
		NotRegisteredMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		NotRegisteredMsg.SetFont()
		NotRegisteredMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		NotRegisteredMsg.Add("Text", "x80 y130 +Center w340 +0x200", "Entered mail is not registered.")
		;-----------------
        NotRegisteredMsg.Title := "Mail not registered!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        NotRegisteredMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        NotRegisteredMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		NotRegisteredMsg.Destroy()
    }		
}
;----------------------------------------------------
InvalidEmailAddress(*) {
	ShowInvalidEmailMsg:
		if GuiPriorityAlwaysOnTop == true {
			InvEmailMsg := Gui("+AlwaysOnTop")
		} else {
			InvEmailMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		InvEmailMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				InvEmailMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				InvEmailMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			InvEmailMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		InvEmailMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		InvEmailMsg.Add("Text", "x50 y16 +Center w400", AppName)
		InvEmailMsg.Add("Text", "x450 y16 +Center w40", "")
		InvEmailMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		InvEmailMsg.Add("Text", "x390 y24 ", CurrentVersion)
		InvEmailMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		InvEmailMsg.SetFont()
		InvEmailMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		InvEmailMsg.Add("Text", "x75 y110 +Center w350 +0x200", "The Email address entered is invalid.")
		InvEmailMsg.Add("Text", "x90 y140 +Center w320 +0x200", "Check for any typos and try again.")
		;-----------------
        InvEmailMsg.Title := "Invalid Email Address"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        InvEmailMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        InvEmailMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		InvEmailMsg.Destroy()
    }		
}
;----------------------------------------------------
FieldsNotValidated() {
	ShowFieldsNotValidatedMsg:
		if GuiPriorityAlwaysOnTop == true {
			FldsNotValidMsg := Gui("+AlwaysOnTop")
		} else {
			FldsNotValidMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		FldsNotValidMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				FldsNotValidMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				FldsNotValidMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			FldsNotValidMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		FldsNotValidMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		FldsNotValidMsg.Add("Text", "x50 y16 +Center w400", AppName)
		FldsNotValidMsg.Add("Text", "x450 y16 +Center w40", "")
		FldsNotValidMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		FldsNotValidMsg.Add("Text", "x390 y24 ", CurrentVersion)
		FldsNotValidMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		FldsNotValidMsg.SetFont()
		FldsNotValidMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		FldsNotValidMsg.Add("Text", "x80 y130 +Center w340 +0x200", "Fields not validated.")
		;-----------------
        FldsNotValidMsg.Title := "Fields Not Validated!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        FldsNotValidMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        FldsNotValidMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		FldsNotValidMsg.Destroy()
    }		
}
;----------------------------------------------------
PasswordTooShort() {
    ShowPasswordTooShortMsg:
		if GuiPriorityAlwaysOnTop == true {
			PswdTooShortMsg := Gui("+AlwaysOnTop")
		} else {
			PswdTooShortMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		PswdTooShortMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				PswdTooShortMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				PswdTooShortMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			PswdTooShortMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		PswdTooShortMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		PswdTooShortMsg.Add("Text", "x50 y16 +Center w400", AppName)
		PswdTooShortMsg.Add("Text", "x450 y16 +Center w40", "")
		PswdTooShortMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		PswdTooShortMsg.Add("Text", "x390 y24 ", CurrentVersion)
		PswdTooShortMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		PswdTooShortMsg.SetFont()
		PswdTooShortMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		PswdTooShortMsg.Add("Text", "x80 y130 +Center w340 +0x200", "Entered password is too short.")
		;-----------------
        PswdTooShortMsg.Title := "Password Too Short!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        PswdTooShortMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        PswdTooShortMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		PswdTooShortMsg.Destroy()
    }	
}
;----------------------------------------------------
PasswordUpdateSuccessful(*) {
    ShowPasswordUpdSuccessMsg:
		if GuiPriorityAlwaysOnTop == true {
			PasswordUpdSuccessMsg := Gui("+AlwaysOnTop")
		} else {
			PasswordUpdSuccessMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		PasswordUpdSuccessMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				PasswordUpdSuccessMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				PasswordUpdSuccessMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			PasswordUpdSuccessMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		PasswordUpdSuccessMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		PasswordUpdSuccessMsg.Add("Text", "x50 y16 +Center w400", AppName)
		PasswordUpdSuccessMsg.Add("Text", "x450 y16 +Center w40", "")
		PasswordUpdSuccessMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		PasswordUpdSuccessMsg.Add("Text", "x390 y24 ", CurrentVersion)
		PasswordUpdSuccessMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		PasswordUpdSuccessMsg.SetFont()
		PasswordUpdSuccessMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		PasswordUpdSuccessMsg.Add("Text", "x80 y130 +Center w340 +0x200", "Password updated succesfully.")
		;-----------------
        PasswordUpdSuccessMsg.Title := "Password Updated!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        PasswordUpdSuccessMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        PasswordUpdSuccessMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		PasswordUpdSuccessMsg.Destroy()
    }
}
;----------------------------------------------------
CheckEmailAndPassword() {
    ShowChkEmailPswdMsg:
		if GuiPriorityAlwaysOnTop == true {
			ChkEmailPswdMsg := Gui("+AlwaysOnTop")
		} else {
			ChkEmailPswdMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		ChkEmailPswdMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				ChkEmailPswdMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				ChkEmailPswdMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			ChkEmailPswdMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		ChkEmailPswdMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		ChkEmailPswdMsg.Add("Text", "x50 y16 +Center w400", AppName)
		ChkEmailPswdMsg.Add("Text", "x450 y16 +Center w40", "")
		ChkEmailPswdMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ChkEmailPswdMsg.Add("Text", "x390 y24 ", CurrentVersion)
		ChkEmailPswdMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		ChkEmailPswdMsg.SetFont()
		ChkEmailPswdMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		ChkEmailPswdMsg.Add("Text", "x80 y110 +Center w340 +0x200", "Wrong Credentials.")
		ChkEmailPswdMsg.Add("Text", "x50 y140 +Center w400 +0x200", "Check entered Email and Password fields.")
		;-----------------
        ChkEmailPswdMsg.Title := "Check Email and Password fields or Connection!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        ChkEmailPswdMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        ChkEmailPswdMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		ChkEmailPswdMsg.Destroy()
    }
}
;----------------------------------------------------
CheckConnectionMsg(*) {
    ShowChkConnectionMsg:
		if GuiPriorityAlwaysOnTop == true {
			ChkConnectionMsg := Gui("+AlwaysOnTop")
		} else {
			ChkConnectionMsg := Gui()
		}
		LicenseKeyInFile := IniRead(LicenseFile, "Data", "LicenseKey")
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		ChkConnectionMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				ChkConnectionMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				ChkConnectionMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
			}
			catch {
				MessageBackgroundPicture := ""
				IniWrite MessageBackgroundPicture, IniFile, "Background", "MessageBackgroundPicture"
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
			}
		}
		try {
			ChkConnectionMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		ChkConnectionMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		ChkConnectionMsg.Add("Text", "x50 y16 +Center w400", AppName)
		ChkConnectionMsg.Add("Text", "x450 y16 +Center w40", "")
		ChkConnectionMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ChkConnectionMsg.Add("Text", "x390 y24 ", CurrentVersion)
		ChkConnectionMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		ChkConnectionMsg.SetFont()
		ChkConnectionMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		ChkConnectionMsg.Add("Text", "x80 y130 +Center w340 +0x200", "Check Your Connection and Try Again.")
		;-----------------
        ChkConnectionMsg.Title := "No Connection!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		if PosX == -32000 {
			PosX := IniRead(IniFile, "Properties", "PositionX")
		}
		if PosY == -32000 {
			PosY := IniRead(IniFile, "Properties", "PositionY")
		}
        ChkConnectionMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        ChkConnectionMsg.Opt("+LastFound")
		Destroy()
	Return
	
	Destroy(*) {
		Sleep ExitMessageTimeWait
		ChkConnectionMsg.Destroy()
    }
}
