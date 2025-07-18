;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains all submit handlers.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; SubmitCtrlRemap(...)
; SubmitNormalMode(...)
; SubmitRaceMode(...)
; SubmitCursorMovement(...)
; SubmitRotateCamera(...)
; SubmitRotateCameraCtrldown(...)
; SubmitRotateCameraShiftdown(...)
;----------------------------------------------------
; Submit Ctrl Remap
;----------------------------------------------------
SubmitCtrlRemap(*) {
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		Saved := ControllerRemapGui1.Submit(false)
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		Saved := ControllerRemapGui2.Submit(false)
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	CtrlRemapYesNo := IniRead(IniFile, "Properties", "CtrlRemapYesNo")
	CtrlRemapYesNo := !CtrlRemapYesNo
	IniWrite CtrlRemapYesNo, IniFile, "Properties", "CtrlRemapYesNo"
	; Dynamic Reload
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}
;----------------------------------------------------
; Submit Normal Mode
;----------------------------------------------------
SubmitNormalMode(*) {
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		Saved := ControllerRemapGui1.Submit(false)
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		Saved := ControllerRemapGui2.Submit(false)
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite true, IniFile, "Properties", "NormalMode"
	IniWrite false, IniFile, "Properties", "RaceMode"
	; Dynamic Reload
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}
;----------------------------------------------------
; Submit Race Mode
;----------------------------------------------------
SubmitRaceMode(*) {
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		Saved := ControllerRemapGui1.Submit(false)
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		Saved := ControllerRemapGui2.Submit(false)
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite true, IniFile, "Properties", "RaceMode"
	IniWrite false, IniFile, "Properties", "NormalMode"
	; Dynamic Reload
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}
;----------------------------------------------------
; Submit Cursor Movement
;----------------------------------------------------
SubmitCursorMovement(*) {
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		Saved := ControllerRemapGui1.Submit(false)
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		Saved := ControllerRemapGui2.Submit(false)
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite true, IniFile, "Properties", "CursorMovement"
	IniWrite false, IniFile, "Properties", "RotateCamera"
	IniWrite false, IniFile, "Properties", "RotateCameraCtrldown"
	IniWrite false, IniFile, "Properties", "RotateCameraShiftdown"
	; Dynamic Reload
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}
;----------------------------------------------------
; Submit Rotate Camera
;----------------------------------------------------
SubmitRotateCamera(*) {
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		Saved := ControllerRemapGui1.Submit(false)
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		Saved := ControllerRemapGui2.Submit(false)
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite false, IniFile, "Properties", "CursorMovement"
	IniWrite true, IniFile, "Properties", "RotateCamera"
	IniWrite false, IniFile, "Properties", "RotateCameraCtrldown"
	IniWrite false, IniFile, "Properties", "RotateCameraShiftdown"
	; Dynamic Reload
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}
;----------------------------------------------------
; Submit Rotate Camera Ctrl down
;----------------------------------------------------
SubmitRotateCameraCtrldown(*) {
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		Saved := ControllerRemapGui1.Submit(false)
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		Saved := ControllerRemapGui2.Submit(false)
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite false, IniFile, "Properties", "CursorMovement"
	IniWrite false, IniFile, "Properties", "RotateCamera"
	IniWrite true, IniFile, "Properties", "RotateCameraCtrldown"
	IniWrite false, IniFile, "Properties", "RotateCameraShiftdown"
	; Dynamic Reload
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}
;----------------------------------------------------
; Submit Rotate Camera Shift down
;----------------------------------------------------
SubmitRotateCameraShiftdown(*) {
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		Saved := ControllerRemapGui1.Submit(false)
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		Saved := ControllerRemapGui2.Submit(false)
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	IniWrite false, IniFile, "Properties", "CursorMovement"
	IniWrite false, IniFile, "Properties", "RotateCamera"
	IniWrite false, IniFile, "Properties", "RotateCameraCtrldown"
	IniWrite true, IniFile, "Properties", "RotateCameraShiftdown"
	; Dynamic Reload
	IniWrite PosX, IniFile, "Properties", "PositionX"
	IniWrite PosY, IniFile, "Properties", "PositionY"
	IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
}