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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			Exitmsg.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		Exitmsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		Exitmsg.Add("Text", "x80 y16", AppName)
		Exitmsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		Exitmsg.Add("Text", "x415 y31 ", CurrentVersion)
		Exitmsg.Add("Text", "x80 y55", "License key: ")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		Exitmsg.Add("Text", "x160 y55", LicenseKey)
		Exitmsg.Add("Text", "x0 y90 w470 h1 +0x5")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		Exitmsg.Add("Text", "x45 y110", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
        Exitmsg.Add("Text", "x175 y140", "Have a nice day!")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		Exitmsg.Add("Text", "x0 y180 w470 h1 +0x5")
		Exitmsg.Add("Text", "x107 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		Exitmsg.Add("Text", "x116 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
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
        Exitmsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			InvLicMsg.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		InvLicMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
        InvLicMsg.Add("Text", "x80 y16", AppName)
		InvLicMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		InvLicMsg.Add("Text", "x415 y31 ", CurrentVersion)
		InvLicMsg.Add("Text", "x80 y55", "License key: ")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s8 Bold cRed", LicenseKeyFontType)
		InvLicMsg.Add("Text", "x160 y55", "???")
		InvLicMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s12 cRed", MessageMainMsgFontType)
		InvLicMsg.Add("Text", "x167 y110", "Invalid License Key")
        InvLicMsg.Add("Text", "x45 y140", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		InvLicMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		InvLicMsg.Add("Text", "x100 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		InvLicMsg.SetFont()
		InvLicMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		InvLicMsg.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        InvLicMsg.Title := "Invalid License Key!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
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
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			NoLicFileMsg.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		NoLicFileMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
        NoLicFileMsg.Add("Text", "x80 y16", AppName)
		NoLicFileMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NoLicFileMsg.Add("Text", "x415 y31 ", CurrentVersion)
		NoLicFileMsg.Add("Text", "x80 y55", "License key: ")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s8 Bold cRed", LicenseKeyFontType)
		NoLicFileMsg.Add("Text", "x160 y55", "???")
		NoLicFileMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s12 cRed", MessageMainMsgFontType)
		NoLicFileMsg.Add("Text", "x160 y110", "License file not found")
        NoLicFileMsg.Add("Text", "x45 y140", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NoLicFileMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		NoLicFileMsg.Add("Text", "x100 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		NoLicFileMsg.SetFont()
		NoLicFileMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		NoLicFileMsg.Add("Text", "x120 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        NoLicFileMsg.Title := "Invalid License Key!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        NoLicFileMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			About.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		About.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		About.Add("Text", "x80 y16", AppName)
		About.SetFont("s9 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x415 y31 ", CurrentVersion)
		About.Add("Text", "x80 y55", "License key: ")
		About.SetFont()
		About.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		About.Add("Text", "x160 y55", LicenseKey)
		About.Add("Text", "x0 y90 w470 h1 +0x5")
		About.SetFont()
		About.SetFont("s10 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		About.Add("Text", "x135 y100", " Programmed and designed by: ")
		About.SetFont("s14 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
		About.Add("Text", "x115 y125", Creator)
		; About.Add("Link", "x310 y115", "<a href=`"https://github.com/FDJ-Dash`">FDJ-Dash</a>")
		About.SetFont()
		About.SetFont("s9 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x124 y156", " Support mail: fdj.software@gmail.com ")
		About.Add("Text", "x0 y180 w470 h1 +0x5")
        About.Add("Text", "x25 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		About.SetFont()
		About.SetFont("s8 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := About.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        About.Title := "About"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        About.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			GuideMsg.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		GuideMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		GuideMsg.Add("Text", "x80 y16", AppName)
		GuideMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		GuideMsg.Add("Text", "x415 y31 ", CurrentVersion)
		GuideMsg.Add("Text", "x80 y55", "License key: ")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		GuideMsg.Add("Text", "x160 y55", LicenseKey)
		GuideMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		GuideMsg.Add("Text", "x100 y110", "The guide will open in your browser.")
        GuideMsg.Add("Text", "x137 y140", "You can close this message.")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		GuideMsg.Add("Text", "x0 y180 w470 h1 +0x5")
		GuideMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		GuideMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
        ogcButtonOK := GuideMsg.Add("Button", "x370 y200 w80 h24 Default", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        GuideMsg.Title := "Guide"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			ConnectionMsg.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		ConnectionMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		ConnectionMsg.Add("Text", "x80 y16", AppName)
		ConnectionMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ConnectionMsg.Add("Text", "x415 y31 ", CurrentVersion)
		ConnectionMsg.Add("Text", "x80 y55", "License key: ")
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		ConnectionMsg.Add("Text", "x160 y55", LicenseKey)
		ConnectionMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s12 cRed", MessageMainMsgFontType)
		ConnectionMsg.Add("Text", "x115 y110", "Unable to check for new updates.")
		ConnectionMsg.Add("Text", "x127 y140", "Please verify your connection")		
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ConnectionMsg.Add("Text", "x0 y180 w470 h1 +0x5")
        ConnectionMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		ConnectionMsg.SetFont()
		ConnectionMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		ConnectionMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := ConnectionMsg.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        ConnectionMsg.Title := "Connection Failed!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
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
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			UpToDateMsg.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		UpToDateMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		UpToDateMsg.Add("Text", "x80 y16", AppName)
		UpToDateMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		UpToDateMsg.Add("Text", "x415 y31 ", CurrentVersion)
		UpToDateMsg.Add("Text", "x80 y55", "License key: ")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		UpToDateMsg.Add("Text", "x160 y55", LicenseKey)
		UpToDateMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		UpToDateMsg.Add("Text", "x135 y123", "Current version is up to date!")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		UpToDateMsg.Add("Text", "x0 y180 w470 h1 +0x5")
        UpToDateMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		UpToDateMsg.SetFont()
		UpToDateMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		UpToDateMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := UpToDateMsg.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
        UpToDateMsg.Title := "Up To Date!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
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
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
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
				; Reload
				if GuiName == "ControllerRemapGui1" {
					ControllerRemapGui1.GetPos(&PosX, &PosY)
				} else {
					ControllerRemapGui2.GetPos(&PosX, &PosY)
				}
				IniWrite PosX, IniFile, "Properties", "PositionX"
				IniWrite PosY, IniFile, "Properties", "PositionY"
				IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
			}
		}
		try {
			NewVerMsg.Add("Picture", "x9 y12 w64 h64 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		NewVerMsg.SetFont("s20 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		NewVerMsg.Add("Text", "x80 y16", AppName)
		NewVerMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		NewVerMsg.Add("Text", "x415 y31 ", CurrentVersion)
		NewVerMsg.Add("Text", "x80 y55", "License key: ")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s8 Bold " . LicenseKeyFontColor, LicenseKeyFontType)
		NewVerMsg.Add("Text", "x160 y55", LicenseKey)
		NewVerMsg.Add("Text", "x0 y90 w470 h1 +0x5")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s12 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		NewVerMsg.Add("Text", "x100 y115", "New release version " . ReleaseVersion . " is available")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ogcButtonUpdate := NewVerMsg.Add("Button", "x190 y145 w80 h24", "Download")
		ogcButtonUpdate.OnEvent("Click", UpdateDownload)
		NewVerMsg.Add("Text", "x0 y180 w470 h1 +0x5")
        NewVerMsg.Add("Text", "x25 y190", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		NewVerMsg.SetFont()
		NewVerMsg.SetFont("s8 " . MessageFontColor, MessageFontType)
		NewVerMsg.Add("Text", "x25 y212", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := NewVerMsg.Add("Button", "x370 y200 w80 h24", "Close")
		ogcButtonOK.OnEvent("Click", Destroy)
        NewVerMsg.Title := "New Version Available!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        NewVerMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w470 h240")
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
		GCRDownloadPart1 := DecriptMsg(GCRDownloadPart1)
		;------------------------
		GCRDownloadPart2 := IniRead(DataFile, "EncriptedData", "GCRDownload")
		GCRDownloadPart2 := DecriptMsg(GCRDownloadPart2)
		;------------------------
		GCRDownloadPart3 := "53qm"
		GCRDownloadPart3 := DecriptMsg(GCRDownloadPart3)
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
