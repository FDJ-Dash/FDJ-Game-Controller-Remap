;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains all posible messages handled by Game Controller Remap.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; ExitMsg(*)
; InvalidLicenseMsg(*)
; LicenseFileMissingMsg(*)
; MenuHandlerAbout(*)
; MenuHandlerGuide(*)
; ConnectionMessage(*)
; VerifyingPortAccess(*)
; Port3306Blocked(*)
; UpToDateMessage(*)
; NewVersionAvailableMessage(ReleaseVersion, *)
;----------------------------------------------------
ExitMsg(*){
	ShowExit:
		if GuiPriorityAlwaysOnTop == true {
			Exitmsg := Gui("+AlwaysOnTop")
		} else {
			Exitmsg := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		Exitmsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				Exitmsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				Exitmsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			Exitmsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		Exitmsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		Exitmsg.Add("Text", "x50 y16 +Center w400", AppName)
		Exitmsg.Add("Text", "x450 y16 +Center w40", "")
		Exitmsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		Exitmsg.Add("Text", "x390 y24 ", CurrentVersion)
		Exitmsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		Exitmsg.SetFont()
		Exitmsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		Exitmsg.Add("Text", "x45 y110 +Center w410 +0x200", "Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
        Exitmsg.Add("Text", "x100 y140 +Center w300 +0x200", "Have a nice day!")
        ;-----------------
		Exitmsg.Title := "Goodbye!"
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
        Exitmsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        Exitmsg.Opt("+LastFound")
	Return
}
;----------------------------------------------------
InvalidLicenseMsg(*){
	ShowLicense:
		if GuiPriorityAlwaysOnTop == true {
			InvLicMsg := Gui("+AlwaysOnTop")
		} else {
			InvLicMsg := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		InvLicMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				InvLicMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				InvLicMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			InvLicMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		InvLicMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		InvLicMsg.Add("Text", "x50 y16 +Center w400", AppName)
		InvLicMsg.Add("Text", "x450 y16 +Center w40", "")
		InvLicMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		InvLicMsg.Add("Text", "x390 y24 ", CurrentVersion)
		InvLicMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s14 cRed", MessageMainMsgFontType)
		InvLicMsg.Add("Text", "x100 y110 +Center w300 +0x200", "Invalid License Key")
        InvLicMsg.Add("Text", "x45 y140 +Center w410 +0x200", "Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
        ;-----------------
		InvLicMsg.Title := "Invalid License Key!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        InvLicMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
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
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		NoLicFileMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
			try {
				NoLicFileMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				NoLicFileMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			NoLicFileMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		NoLicFileMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		NoLicFileMsg.Add("Text", "x50 y16 +Center w400", AppName)
		NoLicFileMsg.Add("Text", "x450 y16 +Center w40", "")
		NoLicFileMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NoLicFileMsg.Add("Text", "x390 y24 ", CurrentVersion)
		NoLicFileMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s14 cRed", MessageMainMsgFontType)
		NoLicFileMsg.Add("Text", "x100 y110 +Center w300 +0x200", "License file not found")
        NoLicFileMsg.Add("Text", "x45 y140 +Center w410 +0x200", "Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
        ;-----------------
		NoLicFileMsg.Title := "License File Not Found!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        NoLicFileMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        NoLicFileMsg.Opt("+LastFound")
    Return
}
;----------------------------------------------------
MenuHandlerAbout(*) {
	ShowAbout:
		if GuiPriorityAlwaysOnTop == true {
			About := Gui("+AlwaysOnTop")
		} else {
			About := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		About.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				About.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				About.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			About.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		About.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		About.Add("Text", "x50 y16 +Center w400", AppName)
		About.Add("Text", "x450 y16 +Center w40", "")
		About.SetFont("s9 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x390 y24 ", CurrentVersion)
		About.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		About.SetFont()
		About.SetFont("s10 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		About.Add("Text", "x100 y75 +Center w300 h23 +0x200", " Programmed and designed by: ")
		About.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		About.Add("Text", "x100 y105 +Center w300 h28 +0x200", Creator)
		About.SetFont()
		About.SetFont("s10 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x100 y140 +Center w300 h23 +0x200", " Support mail: fdj.software@gmail.com ")
		About.Add("Text", "x0 y186 w500 h1 +0x5")
		About.SetFont()
		About.SetFont("s10 " . MessageFontColor, MessageFontType)
        About.Add("Text", "x10 y200 +Center w370 h23 +0x200", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		About.SetFont("s8 " . MessageFontColor, MessageFontType)
		ogcButtonOK := About.Add("Button", "x400 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
		;-----------------
        About.Title := "About"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        About.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        ControlFocus("Button1", "About")
        About.Opt("+LastFound")
	Return
	Destroy(*){
		About.Destroy()
	}
}
;----------------------------------------------------
MenuHandlerGuide(*) {
	ShowGuide:
		if GuiPriorityAlwaysOnTop == true {
			GuideMsg := Gui("+AlwaysOnTop")
		} else {
			GuideMsg := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		GuideMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				GuideMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				GuideMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			GuideMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		GuideMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		GuideMsg.Add("Text", "x50 y16 +Center w400", AppName)
		GuideMsg.Add("Text", "x450 y16 +Center w40", "")
		GuideMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		GuideMsg.Add("Text", "x390 y24 ", CurrentVersion)
		GuideMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		GuideMsg.SetFont()
		GuideMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		GuideMsg.Add("Text", "x100 y130 +Center w300 +0x200", "The guide will open in your browser.")
        ;-----------------
		GuideMsg.Title := "Guide"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        GuideMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        GuideMsg.Opt("+LastFound")
		run Guide
		Destroy()
	Return

	Destroy(*){
	    Sleep ExitMessageTimeWait
		GuideMsg.Destroy()
	}
}
;----------------------------------------------------
ConnectionMessage(*) {
	ShowConnection:
		if GuiPriorityAlwaysOnTop == true {
			ConnectionMsg := Gui("+AlwaysOnTop")
		} else {
			ConnectionMsg := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		ConnectionMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				ConnectionMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				ConnectionMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			ConnectionMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		ConnectionMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		ConnectionMsg.Add("Text", "x50 y16 +Center w400", AppName)
		ConnectionMsg.Add("Text", "x450 y16 +Center w40", "")
		ConnectionMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ConnectionMsg.Add("Text", "x390 y24 ", CurrentVersion)
		ConnectionMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s14 cRed", MessageMainMsgFontType)
		ConnectionMsg.Add("Text", "x80 y110 +Center w340 +0x200", "Unable to check for new updates.")
		ConnectionMsg.Add("Text", "x100 y140 +Center w300 +0x200", "Please verify your connection")		
        ;-----------------
		ConnectionMsg.Title := "Connection Failed!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        ConnectionMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        ConnectionMsg.Opt("+LastFound")
		Destroy()
	Return
	Destroy(*){
	    Sleep ExitMessageTimeWait
		ConnectionMsg.Destroy()
	}
}
;----------------------------------------------------
VerifyingPortAccess(*) {
	VerifPortAccess:
		if GuiPriorityAlwaysOnTop == true {
			VerifPortAccess := Gui("+AlwaysOnTop")
		} else {
			VerifPortAccess := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		VerifPortAccess.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				VerifPortAccess.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				VerifPortAccess.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			VerifPortAccess.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		VerifPortAccess.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		VerifPortAccess.Add("Text", "x50 y16 +Center w400", AppName)
		VerifPortAccess.Add("Text", "x450 y16 +Center w40", "")
		VerifPortAccess.SetFont("s9 " . MessageFontColor, MessageFontType)
		VerifPortAccess.Add("Text", "x390 y24 ", CurrentVersion)
		VerifPortAccess.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		VerifPortAccess.SetFont()
		VerifPortAccess.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		VerifPortAccess.Add("Text", "x100 y80 +Center w300 +0x200", "Authenticating session.")
		VerifPortAccess.Add("Text", "x50 y110 +Center w400 +0x200", "If ports are blocked then")
		VerifPortAccess.Add("Text", "x10 y140 +Center w480 +0x200", "the extensive check will take up to a minute")
        VerifPortAccess.SetFont("s8 " . MessageFontColor, MessageFontType)
		ogcButtonOK := VerifPortAccess.Add("Button", "x210 y190 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
		;-----------------
        VerifPortAccess.Title := "Port Access Verification"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        VerifPortAccess.Show("x" . PosX - 150 . " y" . PosY + 220 . "w500 h240")
        VerifPortAccess.Opt("+LastFound")
		Sleep ExitMessageTimeWait
		VerifPortAccess.Destroy()
    Return
	Destroy(*){
		VerifPortAccess.Destroy()
	}
}
;----------------------------------------------------
Port3306Blocked(*) {
	PortBlocked:
		if GuiPriorityAlwaysOnTop == true {
			PortBlocked := Gui("+AlwaysOnTop")
		} else {
			PortBlocked := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		PortBlocked.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				PortBlocked.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				PortBlocked.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			PortBlocked.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		PortBlocked.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		PortBlocked.Add("Text", "x50 y16 +Center w400", AppName)
		PortBlocked.Add("Text", "x450 y16 +Center w40", "")
		PortBlocked.SetFont("s9 " . MessageFontColor, MessageFontType)
		PortBlocked.Add("Text", "x390 y24 ", CurrentVersion)
		PortBlocked.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		PortBlocked.SetFont()
		PortBlocked.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		PortBlocked.Add("Text", "x10 y80 +Center w480 +0x200", "Unable to authenticate. Port 3306 is blocked.")
		PortBlocked.Add("Text", "x50 y110 +Center w400 +0x200", "The app will close")
		PortBlocked.Add("Text", "x10 y140 +Center w480 +0x200", "Maybe your VPN, ISP or firewall is blocking it.")
        PortBlocked.SetFont("s8 " . MessageFontColor, MessageFontType)
		ogcButtonOK := PortBlocked.Add("Button", "x210 y190 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
		;-----------------
        PortBlocked.Title := "Port 3306 Blocked"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        PortBlocked.Show("x" . PosX - 150 . " y" . PosY + 220 . "w500 h240")
        PortBlocked.Opt("+LastFound")
		Sleep 15000
		PortBlocked.Destroy()
		ExitApp
    Return
	Destroy(*){
	    PortBlocked.Destroy()
		ExitApp
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
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		UpToDateMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				UpToDateMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				UpToDateMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			UpToDateMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		UpToDateMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		UpToDateMsg.Add("Text", "x50 y16 +Center w400", AppName)
		UpToDateMsg.Add("Text", "x450 y16 +Center w40", "")
		UpToDateMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		UpToDateMsg.Add("Text", "x390 y24 ", CurrentVersion)
		UpToDateMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		UpToDateMsg.Add("Text", "x100 y130 +Center w300 +0x200", "Current version is up to date!")
        ;-----------------
		UpToDateMsg.Title := "Up To Date!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        UpToDateMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        UpToDateMsg.Opt("+LastFound")
		Destroy()
	Return
	Destroy(*){
	    Sleep ExitMessageTimeWait
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
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		NewVerMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				NewVerMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				NewVerMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			NewVerMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		NewVerMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		NewVerMsg.Add("Text", "x50 y16 +Center w400", AppName)
		NewVerMsg.Add("Text", "x450 y16 +Center w40", "")
		NewVerMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NewVerMsg.Add("Text", "x390 y24 ", CurrentVersion)
		NewVerMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		NewVerMsg.Add("Text", "x80 y115 +Center w340 +0x200", "New release version " . ReleaseVersion . " is available")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ogcButtonUpdate := NewVerMsg.Add("Button", "x205 y145 w80 h24", "Download")
		ogcButtonUpdate.OnEvent("Click", UpdateDownload)
		;-----------------
        NewVerMsg.Title := "New Version Available!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        NewVerMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        ControlFocus("Button1", "New Version Available!")
        NewVerMsg.Opt("+LastFound")
		NewVerMsg.OnEvent("Close", NewVerMsg_Close)
	Return
	Destroy(*){
		NewVerMsg.Destroy()
	}
	UpdateDownload(*){
		GCRName := IniRead(DataFile, "GeneralData", "GCRName")
		; Scaped character included: ``
		GCRDownloadPart1 := "NJdlcj]YIG27Q]LFCM\dIG27?HLFR\./FMNJLTY``ea86FK19Y``a]FNelNJ19]dmiZbah:4qm7?]dc_NVCMRYeaT\[bHD^fDBFK82FRWaDB*3szeaHPipkgV^7>HDNVelqmRZ5:LF]dqm\d[bieWaPXeleaHPszKGCAJR@Gea@EDAEP./COHQ45_kFT*3)&T\OVFG:FBM``iPQuq@Ldl=DT]F@CQRS]ikgBK\d:;IUNWLSa](0XY_kZcRYEA(0\]ah4@;89Da]NWFNIW]dWSCKFM,)B>TUHP]iahEA<E@H@AEPmt4@4B9B:;O[;8<G9B@NLM4@dmNJV^jk_fR\"
		GCRDownloadPart1 := DecryptMsg(GCRDownloadPart1)
		;------------------------
		GCRDownloadPart2 := IniRead(DataFile, "EncryptedData", "GCRDownload")
		GCRDownloadPart2 := DecryptMsg(GCRDownloadPart2)
		;------------------------
		GCRDownloadPart3 := "53qm"
		GCRDownloadPart3 := DecryptMsg(GCRDownloadPart3)
		;------------------------
		GCRDownloadPart4 := FileSelect("S16", A_MyDocuments . "\" . GCRName , "Save File", "Executable files (*.exe)")
		FullPathDownLoad := GCRDownloadPart1 . " " . GCRDownloadPart2 . " " . GCRDownloadPart3 . " " . GCRDownloadPart4
		if GCRDownloadPart4 != "" {
			RunWait(A_ComSpec " /c " . FullPathDownLoad . " > " TempCleanFileGCR, , "Hide")
		}
		NewVerMsg.Destroy()
	}
	NewVerMsg_Close(*){
		try {
			FileDelete TempCleanFileGCR
		}
		catch {
		}
	}
}
