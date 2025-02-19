;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains all menu handlers.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; MenuHandlerExit(*)
; EditIniFileHandler(*)
; MenuHandlerUpdate(*)
; MenuHandlerCheckUptDaily(*)
; MenuHandlerCheckUptWeekly(*)
; MenuHandlerNeverCheckUpt(*)
; MenuHandlerQuickFix(*)
; GuiPriorityAlwaysOnTopHandler(*)
;----------------------------------------------------
MenuHandlerExit(*){
	ExitApp()
}
;----------------------------------------------------
EditIniFileHandler(*) {
	run IniFile
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
	DownloadUrl := IniRead(DataFile, "EncriptedData", "GCRDownload")
	GCRLatestReleaseVersion := IniRead(DataFile, "GeneralData", "GCRLatestReleaseVersion")
	IniWrite A_Now, IniFile, "Settings", "LastUpdateCheckTimeStamp"
	if GCRLatestReleaseVersion != CurrentVersion {
		if DownloadUrl != "" {
			IniWrite true, IniFile, "Settings", "NeedUpdate"
			NewVersionAvailableMessage(GCRLatestReleaseVersion)
		}
	}
	if GCRLatestReleaseVersion == CurrentVersion {
		if NeedUpdate == 1 {
			IniWrite false, IniFile, "Settings", "NeedUpdate"
		}
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
	; Reload
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
}
;----------------------------------------------------
MenuHandlerCheckUptWeekly(*){
	CheckforUpdatesDaily := false
	CheckforupdatesWeekly := true
	NeverCheckForUpdates := false
	IniWrite CheckforUpdatesDaily, IniFile, "Settings", "CheckforUpdatesDaily"
	IniWrite CheckforupdatesWeekly, IniFile, "Settings", "CheckforupdatesWeekly"
	IniWrite NeverCheckForUpdates, IniFile, "Settings", "NeverCheckForUpdates"
	; Reload
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
}
;----------------------------------------------------
MenuHandlerNeverCheckUpt(*){
	CheckforUpdatesDaily := false
	CheckforupdatesWeekly := false
	NeverCheckForUpdates := true
	IniWrite CheckforUpdatesDaily, IniFile, "Settings", "CheckforUpdatesDaily"
	IniWrite CheckforupdatesWeekly, IniFile, "Settings", "CheckforupdatesWeekly"
	IniWrite NeverCheckForUpdates, IniFile, "Settings", "NeverCheckForUpdates"
	; Reload
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
}
;----------------------------------------------------
MenuHandlerQuickFix(*) {
	Send("{w up}")
	Send("{shift up}")
	Send("{Ctrl up}")
	Reload
}
;----------------------------------------------------
GuiPriorityAlwaysOnTopHandler(*){
	GuiPriorityAlwaysOnTop := IniRead(IniFile, "Properties", "GuiPriorityAlwaysOnTop")
	GuiPriorityAlwaysOnTop := !GuiPriorityAlwaysOnTop
	IniWrite GuiPriorityAlwaysOnTop, IniFile, "Properties", "GuiPriorityAlwaysOnTop"
	; Reload
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DinamicReload"
}