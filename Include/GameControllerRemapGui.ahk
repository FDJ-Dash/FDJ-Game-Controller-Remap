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
		   &RadioCtrlRemapYes,
		   &RadioCtrlRemapNo){
	;-------------------------------
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
				 &RotateCameraShiftdown){
	;-------------------------------
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
	ControllerRemapGui.Add("Text", "x1 y371 w250 h2 +0x10") ; Separator
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
	case NeedUpdate == "":
		FlagCheckTime := true
	}
	;-------------------------------
	if FlagCheckTime == true {
		Connected := CheckConnection()
		if Connected != true {
			ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
			ControllerRemapGui.SetFont("s8 Bold cRed", LicenseKeyFontType)
			ControllerRemapGui.Add("Text","x97 y376 w126 h20 +0x200", " No internet connection ")
			try {
				ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\NoInternetConnection.png")
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
			DownloadUrl := IniRead(DataFile, "EncriptedData", "GCRDownload")
			GCRLatestReleaseVersion := IniRead(DataFile, "GeneralData", "GCRLatestReleaseVersion")
			if GCRLatestReleaseVersion != CurrentVersion {
				if DownloadUrl != "" {
					ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
					ControllerRemapGui.SetFont("s8 Bold cYellow", LicenseKeyFontType)
					ControllerRemapGui.Add("Text","x97 y376 w126 h20 +0x200", " New version available ")
					try {
						ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\NewVersionAvailable.png")
					}
					catch {
					}
					NeedUpdate := true
					IniWrite NeedUpdate, IniFile, "Settings", "NeedUpdate"
				}
			}
			if GCRLatestReleaseVersion == CurrentVersion {
				ControllerRemapGui.Add("Text","x10 y376 h20 +0x200", "Update check: ")
				ControllerRemapGui.SetFont("s8 Bold cLime", LicenseKeyFontType)
				ControllerRemapGui.Add("Text","x97 y376 w126 h20 +0x200", " Version up to date ")
				if NeedUpdate == 1 or NeedUpdate == "" {
					IniWrite false, IniFile, "Settings", "NeedUpdate"
				}
				try {
					ControllerRemapGui.Add("Picture", "x230 y380 w10 h10 +border", IconLib . "\UpToDate.png")
				}
				catch {
				}
			}
			IniWrite A_Now, IniFile, "Settings", "LastUpdateCheckTimeStamp"
		}
	}
}