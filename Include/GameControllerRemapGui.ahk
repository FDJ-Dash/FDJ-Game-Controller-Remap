;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file creates Game Controller Remap GUI.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; Controller(...)
; ControllerStatus(...)
; CheckForUpdates(...)
;----------------------------------------------------
; Y-10 / Controller
;----------------------------------------------------
Controller(ControllerRemapGui,
		   &TextOnOffController,
		   &ControllerName,
		   &CtrlRemapYesNo,
		   &ControllerAvailable,
		   &LicenseKeyInFile,
		   &LicenseKey){
	;-------------------------------
	ControllerRemapGui.Add("Text","x10 y10 w68 h20 +0x200", " Controller:")
	TextOnOffController := ControllerRemapGui.Add("Text","x85 y10 w155 h20 +0x200", " Controller Not Found.")
	ControllerName := ControllerRemapGui.Add("Text","x10 y35 w230 h20 +0x200", " - - - - - - - - - -")
	;----------------------------------------------------
	ControllerRemapGui.Add("Text", "x1 y59 w250 h2 +0x10") ; Separator
	;----------------------------------------------------
	switch true {
	; case ControllerAvailable == false or LicenseKeyInFile != LicenseKey:
	case ControllerAvailable == false:
		GCRButton := ControllerRemapGui.Add("Button", "x10 y65 w175 h20 +disabled", "Turn ON")
		ControllerRemapGui.Add("Text","x193 y65 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y69 w10 h10 +border", IconLib . "\OrangeIcon.png")
	case CtrlRemapYesNo:
		GCRButton := ControllerRemapGui.Add("Button", "x10 y65 w175 h20", "Turn OFF")
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y65 w30 h20 +0x200", " ON ")
		ControllerRemapGui.Add("Picture", "x230 y69 w10 h10 +border", IconLib . "\UpToDate.png")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
	Default:
		GCRButton := ControllerRemapGui.Add("Button", "x10 y65 w175 h20", "Turn ON")
		ControllerRemapGui.Add("Text","x193 y65 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y69 w10 h10 +border", IconLib . "\OrangeIcon.png")
	}
	GCRButton.OnEvent("Click", SubmitCtrlRemap)
	ControllerRemapGui.Add("Text", "x1 y89 w250 h2 +0x10") ; Separator
	;----------------------------------------------------
}
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
				 ControllerRemapGui,
				 &CursorMovement,
				 &RotateCamera,
				 &RotateCameraCtrldown,
				 &RotateCameraShiftdown,
				 &LicenseKeyInFile,
				 &LicenseKey){
	;-------------------------------
	TextAxisInfo := ControllerRemapGui.Add("Text","x20 y95 w212 h20 +0x200", " " )
	ButtonAOnOff := ControllerRemapGui.Add("Text","x20 y120 w20 h20 +0x200", " - ")
	ButtonBOnOff := ControllerRemapGui.Add("Text","x40 y120 w20 h20 +0x200", " - ")
	ButtonXOnOff := ControllerRemapGui.Add("Text","x60 y120 w20 h20 +0x200", " - ")
	ButtonYOnOff := ControllerRemapGui.Add("Text","x80 y120 w20 h20 +0x200", " - ")
	ButtonLBOnOff := ControllerRemapGui.Add("Text","x100 y120 w20 h20 +0x200", " - ")
	ButtonRBOnOff := ControllerRemapGui.Add("Text","x120 y120 w20 h20 +0x200", " - ")
	ButtonBackOnOff := ControllerRemapGui.Add("Text","x140 y120 w45 h20 +0x200", " -   -")
	ButtonStartOnOff := ControllerRemapGui.Add("Text","x185 y120 w47 h20 +0x200", "-   -")
	;-----------------
	switch true {
	; case ControllerAvailable == false or LicenseKeyInFile != LicenseKey:
	case ControllerAvailable == false:
		SelectButtonN := ControllerRemapGui.Add("Button", "x10 y145 w175 h20 +disabled", "Normal Mode")
		ControllerRemapGui.Add("Text","x193 y145 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y149 w10 h10 +border", IconLib . "\OrangeIcon.png")
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		;-----------------
		SelectButtonR := ControllerRemapGui.Add("Button", "x10 y168 w175 h20 +disabled", "Race Mode")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y168 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y172 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case CtrlRemapYesNo == false:
		SelectButtonN := ControllerRemapGui.Add("Button", "x10 y145 w175 h20 +disabled", "Normal Mode")
		ControllerRemapGui.Add("Text","x193 y145 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y149 w10 h10 +border", IconLib . "\OrangeIcon.png")
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		;-----------------
		SelectButtonR := ControllerRemapGui.Add("Button", "x10 y168 w175 h20 +disabled", "Race Mode")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y168 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y172 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case NormalMode:
		SelectButtonN := ControllerRemapGui.Add("Button", "x10 y145 w175 h20", "Normal Mode")
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y145 w30 h20 +0x200", " ON ")
		ControllerRemapGui.Add("Picture", "x230 y149 w10 h10 +border", IconLib . "\UpToDate.png")
		;-----------------
		SelectButtonR := ControllerRemapGui.Add("Button", "x10 y168 w175 h20", "Race Mode")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y168 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y172 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case RaceMode:
		SelectButtonN := ControllerRemapGui.Add("Button", "x10 y145 w175 h20", "Normal Mode")
		ControllerRemapGui.Add("Text","x193 y145 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y149 w10 h10 +border", IconLib . "\OrangeIcon.png")
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		;-----------------
		SelectButtonR := ControllerRemapGui.Add("Button", "x10 y168 w175 h20", "Race Mode")
		ControllerRemapGui.Add("Text","x193 y168 w30 h20 +0x200", " ON ")
		ControllerRemapGui.Add("Picture", "x230 y172 w10 h10 +border", IconLib . "\UpToDate.png")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		;-----------------
	}
	SelectButtonN.OnEvent("Click", SubmitNormalMode)
	SelectButtonR.OnEvent("Click", SubmitRaceMode)
	;----------------------------------------------------
	ControllerRemapGui.Add("Text", "x1 y190 w250 h2 +0x10") ; Separator
	ControllerRemapGui.Add("Text","x80 y195 w90 h20 +0x200", " Camera Rotation")
	;-----------------
	switch true {
	; case ControllerAvailable == false or LicenseKeyInFile != LicenseKey:
	case ControllerAvailable == false:
		SelectButton1 := ControllerRemapGui.Add("Button", "x10 y220 w175 h20 +disabled", "Cursor Movement")
		SelectButton1.OnEvent("Click", SubmitCursorMovement)
		ControllerRemapGui.Add("Text","x193 y220 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y224 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton2 := ControllerRemapGui.Add("Button", "x10 y245 w175 h20 +disabled", "Rotate with arrow keys")
		SelectButton2.OnEvent("Click", SubmitRotateCamera)
		ControllerRemapGui.Add("Text","x193 y245 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y249 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton3 := ControllerRemapGui.Add("Button", "x10 y270 w175 h20 +disabled", "Rotate Ctrl Down + arrow keys")
		SelectButton3.OnEvent("Click", SubmitRotateCameraCtrldown)
		ControllerRemapGui.Add("Text","x193 y270 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y274 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton4 := ControllerRemapGui.Add("Button", "x10 y295 w175 h20 +disabled", "Rotate Shift Down + arrow keys")
		SelectButton4.OnEvent("Click", SubmitRotateCameraShiftdown)
		ControllerRemapGui.Add("Text","x193 y295 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y299 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case CtrlRemapYesNo == false:
		SelectButton1 := ControllerRemapGui.Add("Button", "x10 y220 w175 h20 +disabled", "Cursor Movement")
		SelectButton1.OnEvent("Click", SubmitCursorMovement)
		ControllerRemapGui.Add("Text","x193 y220 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y224 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton2 := ControllerRemapGui.Add("Button", "x10 y245 w175 h20 +disabled", "Rotate with arrow keys")
		SelectButton2.OnEvent("Click", SubmitRotateCamera)
		ControllerRemapGui.Add("Text","x193 y245 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y249 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton3 := ControllerRemapGui.Add("Button", "x10 y270 w175 h20 +disabled", "Rotate Ctrl Down + arrow keys")
		SelectButton3.OnEvent("Click", SubmitRotateCameraCtrldown)
		ControllerRemapGui.Add("Text","x193 y270 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y274 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton4 := ControllerRemapGui.Add("Button", "x10 y295 w175 h20 +disabled", "Rotate Shift Down + arrow keys")
		SelectButton4.OnEvent("Click", SubmitRotateCameraShiftdown)
		ControllerRemapGui.Add("Text","x193 y295 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y299 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case CursorMovement:
		SelectButton1 := ControllerRemapGui.Add("Button", "x10 y220 w175 h20", "Cursor Movement")
		SelectButton1.OnEvent("Click", SubmitCursorMovement)
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y220 w30 h20 +0x200", " ON ")
		ControllerRemapGui.Add("Picture", "x230 y224 w10 h10 +border", IconLib . "\UpToDate.png")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		;-----------------
		SelectButton2 := ControllerRemapGui.Add("Button", "x10 y245 w175 h20", "Rotate with arrow keys")
		SelectButton2.OnEvent("Click", SubmitRotateCamera)
		ControllerRemapGui.Add("Text","x193 y245 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y249 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton3 := ControllerRemapGui.Add("Button", "x10 y270 w175 h20", "Rotate Ctrl Down + arrow keys")
		SelectButton3.OnEvent("Click", SubmitRotateCameraCtrldown)
		ControllerRemapGui.Add("Text","x193 y270 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y274 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton4 := ControllerRemapGui.Add("Button", "x10 y295 w175 h20", "Rotate Shift Down + arrow keys")
		SelectButton4.OnEvent("Click", SubmitRotateCameraShiftdown)
		ControllerRemapGui.Add("Text","x193 y295 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y299 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case RotateCamera:
		SelectButton1 := ControllerRemapGui.Add("Button", "x10 y220 w175 h20", "Cursor Movement")
		SelectButton1.OnEvent("Click", SubmitCursorMovement)
		ControllerRemapGui.Add("Text","x193 y220 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y224 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton2 := ControllerRemapGui.Add("Button", "x10 y245 w175 h20", "Rotate with arrow keys")
		SelectButton2.OnEvent("Click", SubmitRotateCamera)
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y245 w30 h20 +0x200", " ON ")
		ControllerRemapGui.Add("Picture", "x230 y249 w10 h10 +border", IconLib . "\UpToDate.png")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		;-----------------
		SelectButton3 := ControllerRemapGui.Add("Button", "x10 y270 w175 h20", "Rotate Ctrl Down + arrow keys")
		SelectButton3.OnEvent("Click", SubmitRotateCameraCtrldown)
		ControllerRemapGui.Add("Text","x193 y270 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y274 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton4 := ControllerRemapGui.Add("Button", "x10 y295 w175 h20", "Rotate Shift Down + arrow keys")
		SelectButton4.OnEvent("Click", SubmitRotateCameraShiftdown)
		ControllerRemapGui.Add("Text","x193 y295 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y299 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case RotateCameraCtrldown:
		SelectButton1 := ControllerRemapGui.Add("Button", "x10 y220 w175 h20", "Cursor Movement")
		SelectButton1.OnEvent("Click", SubmitCursorMovement)
		ControllerRemapGui.Add("Text","x193 y220 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y224 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton2 := ControllerRemapGui.Add("Button", "x10 y245 w175 h20", "Rotate with arrow keys")
		SelectButton2.OnEvent("Click", SubmitRotateCamera)
		ControllerRemapGui.Add("Text","x193 y245 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y249 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton3 := ControllerRemapGui.Add("Button", "x10 y270 w175 h20", "Rotate Ctrl Down + arrow keys")
		SelectButton3.OnEvent("Click", SubmitRotateCameraCtrldown)
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y270 w30 h20 +0x200", " ON ")
		ControllerRemapGui.Add("Picture", "x230 y274 w10 h10 +border", IconLib . "\UpToDate.png")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		;-----------------
		SelectButton4 := ControllerRemapGui.Add("Button", "x10 y295 w175 h20", "Rotate Shift Down + arrow keys")
		SelectButton4.OnEvent("Click", SubmitRotateCameraShiftdown)
		ControllerRemapGui.Add("Text","x193 y295 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y299 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
	case RotateCameraShiftdown:
		SelectButton1 := ControllerRemapGui.Add("Button", "x10 y220 w175 h20", "Cursor Movement")
		SelectButton1.OnEvent("Click", SubmitCursorMovement)
		ControllerRemapGui.Add("Text","x193 y220 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y224 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton2 := ControllerRemapGui.Add("Button", "x10 y245 w175 h20", "Rotate with arrow keys")
		SelectButton2.OnEvent("Click", SubmitRotateCamera)
		ControllerRemapGui.Add("Text","x193 y245 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y249 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton3 := ControllerRemapGui.Add("Button", "x10 y270 w175 h20", "Rotate Ctrl Down + arrow keys")
		SelectButton3.OnEvent("Click", SubmitRotateCameraCtrldown)
		ControllerRemapGui.Add("Text","x193 y270 w30 h20 +0x200", " OFF ")
		ControllerRemapGui.Add("Picture", "x230 y274 w10 h10 +border", IconLib . "\OrangeIcon.png")
		;-----------------
		SelectButton4 := ControllerRemapGui.Add("Button", "x10 y295 w175 h20", "Rotate Shift Down + arrow keys")
		SelectButton4.OnEvent("Click", SubmitRotateCameraShiftdown)
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x193 y295 w30 h20 +0x200", " ON ")
		ControllerRemapGui.Add("Picture", "x230 y299 w10 h10 +border", IconLib . "\UpToDate.png")
		ControllerRemapGui.SetFont("s8 Bold cFF9933", LicenseKeyFontType)
		;-----------------
	}
}
;----------------------------------------------------
; Y-371 / Check for updates
;----------------------------------------------------
CheckForUpdates(ControllerRemapGui, 
				&FlagCheckTime,
				&LastUpdateCheckTimeStamp,
				&LicenseKeyFontType,
				&CheckforUpdatesDaily,
				&CheckforupdatesWeekly,
				&NeverCheckForUpdates, 
				&NeedUpdate,
				&Connected,
				&GCRLatestReleaseVersion,
				&DownloadUrl,
				&CurrentVersion){
	;-------------------------------
	ControllerRemapGui.Add("Text", "x1 y318 w250 h2 +0x10") ; Separator
	FlagCheckTime := false

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
		ControllerRemapGui.Add("Text","x10 y324 h20 +0x200", "Update check: ")
		ControllerRemapGui.SetFont("s8 Bold c00A8F3", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x97 y324 w126 h20 +0x200", " Update check disabled ")
		try {
			ControllerRemapGui.Add("Picture", "x230 y328 w10 h10 +border", IconLib . "\UpdateCheckDisabled.png")
		}
		catch {
		}
	case NeedUpdate == true:
		ControllerRemapGui.Add("Text","x10 y324 h20 +0x200", "Update check: ")
		ControllerRemapGui.SetFont("s8 Bold cYellow", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x97 y324 w126 h20 +0x200", " New version available ")
		try {
			ControllerRemapGui.Add("Picture", "x230 y328 w10 h10 +border", IconLib . "\NewVersionAvailable.png")
		}
		catch {
		}
	case FlagCheckTime == false and NeedUpdate == false:
		ControllerRemapGui.Add("Text","x10 y324 h20 +0x200", "Update check: ")
		ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
		ControllerRemapGui.Add("Text","x97 y324 w126 h20 +0x200", " Version up to date ")
		try {
			ControllerRemapGui.Add("Picture", "x230 y328 w10 h10 +border", IconLib . "\UpToDate.png")
		}
		catch {
		}
	case NeedUpdate == "":
		FlagCheckTime := true
	}
	;-------------------------------
	if FlagCheckTime == true {
		Connected := CheckConnection()
		if Connected != true {
			ControllerRemapGui.Add("Text","x10 y324 h20 +0x200", "Update check: ")
			ControllerRemapGui.SetFont("s8 Bold cRed", LicenseKeyFontType)
			ControllerRemapGui.Add("Text","x97 y324 w126 h20 +0x200", " No internet connection ")
			try {
				ControllerRemapGui.Add("Picture", "x230 y328 w10 h10 +border", IconLib . "\NoInternetConnection.png")
			}
			catch {
			}
		} else {
			if !FileExist(DataFile) {
				ParseRequest()
			}
			GCRLatestReleaseVersion := IniRead(DataFile, "GeneralData", "GCRLatestReleaseVersion")
			if GCRLatestReleaseVersion == "" {
				ParseRequest()
			}
			DownloadUrl := IniRead(DataFile, "EncryptedData", "GCRDownload")
			GCRLatestReleaseVersion := IniRead(DataFile, "GeneralData", "GCRLatestReleaseVersion")
			if GCRLatestReleaseVersion != CurrentVersion {
				if DownloadUrl != "" {
					ControllerRemapGui.Add("Text","x10 y324 h20 +0x200", "Update check: ")
					ControllerRemapGui.SetFont("s8 Bold cYellow", LicenseKeyFontType)
					ControllerRemapGui.Add("Text","x97 y324 w126 h20 +0x200", " New version available ")
					try {
						ControllerRemapGui.Add("Picture", "x230 y328 w10 h10 +border", IconLib . "\NewVersionAvailable.png")
					}
					catch {
					}
					NeedUpdate := true
					IniWrite NeedUpdate, IniFile, "Settings", "NeedUpdate"
				}
			}
			if GCRLatestReleaseVersion == CurrentVersion {
				ControllerRemapGui.Add("Text","x10 y324 h20 +0x200", "Update check: ")
				ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
				ControllerRemapGui.Add("Text","x97 y324 w126 h20 +0x200", " Version up to date ")
				if NeedUpdate == 1 or NeedUpdate == "" {
					IniWrite false, IniFile, "Settings", "NeedUpdate"
				}
				try {
					ControllerRemapGui.Add("Picture", "x230 y328 w10 h10 +border", IconLib . "\UpToDate.png")
				}
				catch {
				}
			}
			IniWrite A_Now, IniFile, "Settings", "LastUpdateCheckTimeStamp"
		}
	}
}