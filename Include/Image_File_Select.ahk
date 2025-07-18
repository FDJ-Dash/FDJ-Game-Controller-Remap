;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains functions related to file selection on main app.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; ChangeBackgroundHandler(*)
; ChangeMessageBackgroundHandler(*)
;----------------------------------------------------
ChangeBackgroundHandler(*){
	SelectedFile := FileSelect(3, "", "Open a file", "Text Documents (*.ico; *.png; *.jpg)")
	IniWrite SelectedFile, IniFile, "Background", "BackgroundPicture"
	; DynamicReload
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}
;----------------------------------------------------
ChangeMessageBackgroundHandler(*){
	SelectedFile := FileSelect(3, "", "Open a file", "Text Documents (*.ico; *.png; *.jpg)")
	IniWrite SelectedFile, IniFile, "Background", "MessageBackgroundPicture"
	; DynamicReload
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}