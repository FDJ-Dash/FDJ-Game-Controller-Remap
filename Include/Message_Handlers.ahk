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
; MenuHandlerAbout(*)
; MenuHandlerGuide(*)
; MenuHandlerWebLink(*)
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
				About.Add("Picture", "x0 y0 w500 h375", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				About.Add("Picture", "x0 y0 w500 h375", MessageBackgroundPicture)
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
		About.Add("Text", "x100 y75 +Center w300 h28 +0x200", " Programmed and designed by: ")
		About.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		About.Add("Text", "x100 y105 +Center w300 h28 +0x200", Creator)
		About.SetFont()
		About.SetFont("s10 " . MessageFontColor, MessageFontType)

		About.Add("Picture", "x100 y135 w260 h28 +border", ImageLib . "\LinkedIn-logo5.png")
		ogcLinkedInButton := About.Add("Button", "x368 y135 w30 h28", "Go")
		ogcLinkedInButton.OnEvent("Click", OnLinkedinClick)
		
		About.Add("Picture", "x100 y165 w260 h28 +border", ImageLib . "\BuyMeACoffee2.png")
		ogcBuyCoffeeButton := About.Add("Button", "x368 y165 w30 h28", "Go")
		ogcBuyCoffeeButton.OnEvent("Click", OnBuyMeACoffeeClick)
		
		About.Add("Picture", "x100 y195 w260 h28 +border", ImageLib . "\Github3.png")
		ogcBuyCoffeeButton := About.Add("Button", "x368 y195 w30 h28", "Go")
		ogcBuyCoffeeButton.OnEvent("Click", OnGithubClick)

        About.Add("Text", "x100 y225 +Center w300 h28 +0x200", " This Software is free and licensed under: ")
		
		About.Add("Picture", "x100 y255 w260 h28 +border", ImageLib . "\GLP-3.0-License3.png")
		ogcBuyCoffeeButton := About.Add("Button", "x368 y255 w30 h28", "Go")
		ogcBuyCoffeeButton.OnEvent("Click", OnLicenseClick)

		About.SetFont("s7 " . MessageFontColor, MessageFontType)
		About.Add("Text", "x25 y297 +Center w450 h15 +0x200", " You can reach me by email: fernando.daniel.jaime@gmail.com ")
		
		About.Add("Text", "x0 y324 w500 h1 +0x5")
		About.SetFont()
		
		About.SetFont("s8 " . MessageFontColor, MessageFontType)
        About.Add("Text", "x25 y333 +Center w350 h15 +0x200", "Copyright (C) 2024 Fernando Daniel Jaime")
		About.Add("Text", "x25 y353 +Center w350 h15 +0x200", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := About.Add("Button", "x400 y338 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
		;-----------------
        About.Title := "About"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        About.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h375")
        ControlFocus("Button1", "About")
        About.Opt("+LastFound")
	Return
	Destroy(*){
		About.Destroy()
	}
	OnLinkedinClick(*) {
        Run "https://www.linkedin.com/in/fernando-daniel-jaime/"
		; Opening on web browser message
		MenuHandlerWebLink
		sleep 1000
    }
	OnBuyMeACoffeeClick(*) {
        Run "https://buymeacoffee.com/fdjdash"
		; Opening on web browser message
		MenuHandlerWebLink
		sleep 1000
    }
	OnGithubClick(*) {
	    Run "https://github.com/FDJ-Dash/FDJ-Game-Controller-Remap"
		; Opening on web browser message
		MenuHandlerWebLink
		sleep 1000
	}
	OnLicenseClick(*) {
		Run "https://www.gnu.org/licenses/gpl-3.0.html"
		; Opening on web browser message
		MenuHandlerWebLink
		sleep 1000
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
MenuHandlerWebLink(*) {
	ShowWebLink:
		if GuiPriorityAlwaysOnTop == true {
			WebLinkMsg := Gui("+AlwaysOnTop")
		} else {
			WebLinkMsg := Gui()
		}
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		WebLinkMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				WebLinkMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				WebLinkMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			WebLinkMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		WebLinkMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		WebLinkMsg.Add("Text", "x50 y16 +Center w400", AppName)
		WebLinkMsg.Add("Text", "x450 y16 +Center w40", "")
		WebLinkMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		WebLinkMsg.Add("Text", "x390 y24 ", CurrentVersion)
		WebLinkMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;-----------------
		WebLinkMsg.SetFont()
		WebLinkMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		WebLinkMsg.Add("Text", "x100 y130 +Center w300 +0x200", "The link will open in your browser.")
        ;-----------------
		WebLinkMsg.Title := "Guide"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        WebLinkMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        WebLinkMsg.Opt("+LastFound")
		Destroy()
	Return

	Destroy(*){
	    Sleep ExitMessageTimeWait
		WebLinkMsg.Destroy()
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
		GCRDownloadPart1 := "NJdlcj]YIG27Q]LFCM53CKRY]Y27RZip82kgLTLSqm\d[b"
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
