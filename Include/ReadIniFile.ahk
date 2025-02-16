;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file reads and validates ini file variables.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; ReadFontTypes(...)
; ReadFontColors(...)
; ReadBackground(...)
; ReadProperties(...)
; ReadSetting(...)
; ReadCursorMovement(...)
; ReadControllerCameraRotation(...)
; ReadControllerNormalModeRemap(...)
; ReadControllerRaceModeRemap(...)
; ReadControllerAxisRemap(...)
;----------------------------------------------------
; Ini Read Font types
;----------------------------------------------------
ReadFontTypes(&MainFontType, 
			  &MessageAppNameFontType, 
			  &LicenseKeyFontType, 
			  &MessageMainMsgFontType, 
			  &MessageFontType){
	MainFontType := IniRead(IniFile, "FontType", "MainFontType")
	MessageAppNameFontType := IniRead(IniFile, "FontType", "MessageAppNameFontType")
	LicenseKeyFontType := IniRead(IniFile, "FontType", "LicenseKeyFontType")
	MessageMainMsgFontType := IniRead(IniFile, "FontType", "MessageMainMsgFontType")
	MessageFontType := IniRead(IniFile, "FontType", "MessageFontType")
}
;----------------------------------------------------
; Ini Read Font Colors
;----------------------------------------------------
ReadFontColors(&MainFontColor, 
			   &MessageAppNameFontColor,
			   &MessageMainMsgFontColor,
			   &MessageFontColor, 
			   &LicenseKeyFontColor){
	MainFontColor := "c"
	MainFontColor .= IniRead(IniFile, "FontColors", "MainFontColor")
	;-------------------------------
	MessageAppNameFontColor := "c"
	MessageAppNameFontColor .= IniRead(IniFile, "FontColors", "MessageAppNameFontColor")
	;-------------------------------
	MessageMainMsgFontColor := "c"
	MessageMainMsgFontColor .= IniRead(IniFile, "FontColors", "MessageMainMsgFontColor")
	;-------------------------------
	MessageFontColor := "c"
	MessageFontColor .= IniRead(IniFile, "FontColors", "MessageFontColor")
	;-------------------------------
	LicenseKeyFontColor := "c0x"
	LicenseKeyFontColor .= IniRead(IniFile, "FontColors", "LicenseKeyFontColor")
}
;----------------------------------------------------
; Ini Read Background
;----------------------------------------------------
ReadBackground(&BackgroundMainColor, 
			   &BackgroundColor,
			   &BackgroundPicture,
			   &MessageBackgroundPicture){
	BackgroundMainColor := "Background"
	BackgroundColor := IniRead(IniFile, "Background", "BackgroundColor")
	BackgroundMainColor .= BackgroundColor
	BackgroundPicture := IniRead(IniFile, "Background", "BackgroundPicture")
	MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")	   
}
;----------------------------------------------------
; Read Ini Properties
;----------------------------------------------------
ReadProperties(&ExitMessageTimeWait, 
			   &GuiPriorityAlwaysOnTop,
			   &ControllerLoopInterval,
			   &PositionX,
			   &PositionY,
			   &ExitGameControllerRemap){
	;-------------------------------
	ExitMessageTimeWait := IniRead(IniFile, "Properties", "ExitMessageTimeWait")
	GuiPriorityAlwaysOnTop := IniRead(IniFile, "Properties", "GuiPriorityAlwaysOnTop")
	if GuiPriorityAlwaysOnTop < 0 or GuiPriorityAlwaysOnTop > 1 {
		GuiPriorityAlwaysOnTop := 0
		IniWrite GuiPriorityAlwaysOnTop, IniFile, "Properties", "GuiPriorityAlwaysOnTop"
	}
	;-------------------------------
	ControllerLoopInterval := IniRead(IniFile, "Properties", "ControllerLoopInterval")
	if ControllerLoopInterval < 0  {
		ControllerLoopInterval := 0
		IniWrite ControllerLoopInterval, IniFile, "Properties", "ControllerLoopInterval"
	}
	;-------------------------------
	PositionX := IniRead(IniFile, "Properties", "PositionX")
	PositionY := IniRead(IniFile, "Properties", "PositionY")
	if isInteger(PositionX) != true or PositionX == ""{
		PositionX := A_ScreenWidth / 2 - 200
	}
	if isInteger(PositionY) != true or PositionY == ""{
		PositionY := 150
	}
	;-------------------------------
	ExitGameControllerRemap := IniRead(IniFile, "Properties", "ExitGameControllerRemap")
}
;----------------------------------------------------
; Read ini Settings
;----------------------------------------------------
ReadSetting(&CheckforUpdatesDaily, 
			&CheckforupdatesWeekly, 
			&NeverCheckForUpdates,
			&LastUpdateCheckTimeStamp,
			&NeedUpdate){
	CheckforUpdatesDaily := IniRead(IniFile, "Settings", "CheckforUpdatesDaily")
	CheckforupdatesWeekly := IniRead(IniFile, "Settings", "CheckforupdatesWeekly")
	NeverCheckForUpdates := IniRead(IniFile, "Settings", "NeverCheckForUpdates")
	LastUpdateCheckTimeStamp := IniRead(IniFile, "Settings", "LastUpdateCheckTimeStamp")
	NeedUpdate := IniRead(IniFile, "Settings", "NeedUpdate")
	switch true {
	case CheckforUpdatesDaily == true:
		CheckforupdatesWeekly := false
		NeverCheckForUpdates := false
	case CheckforupdatesWeekly == true:
		CheckforUpdatesDaily := false
		NeverCheckForUpdates := false
	case NeverCheckForUpdates == true:
		CheckforUpdatesDaily := false
		CheckforupdatesWeekly := false
	}		
}
;----------------------------------------------------
; Read ini Cursor Movement
;----------------------------------------------------
ReadCursorMovement(&CursorSensRight,
				   &CursorSensDown,
				   &CursorSensLeft,
				   &CursorSensUp,
				   &CursorSpeed){
	CursorSensRight := IniRead(IniFile, "ControllerCursorMovement", "CursorSensRight")
	CursorSensDown := IniRead(IniFile, "ControllerCursorMovement", "CursorSensDown")
	CursorSensLeft := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
	CursorSensUp := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
	CursorSpeed := IniRead(IniFile, "ControllerCursorMovement", "CursorSpeed")
}
;----------------------------------------------------
; Read ini Controller Camera Rotation
;----------------------------------------------------
ReadControllerCameraRotation(&ShiftDownRotation,
							 &CtrlDownRotation,
						     &RotateLeft,
						     &RotateRight,
						     &RotateUp,
							 &RotateDown){
	ShiftDownRotation := IniRead(IniFile, "ControllerCameraRotation", "ShiftDownRotation")
	CtrlDownRotation := IniRead(IniFile, "ControllerCameraRotation", "CtrlDownRotation")
	RotateLeft := IniRead(IniFile, "ControllerCameraRotation", "RotateLeft")
	RotateRight := IniRead(IniFile, "ControllerCameraRotation", "RotateRight")
	RotateUp := IniRead(IniFile, "ControllerCameraRotation", "RotateUp")
	RotateDown := IniRead(IniFile, "ControllerCameraRotation", "RotateDown")
}
;----------------------------------------------------
; Read ini Controller Normal Mode Remap
;----------------------------------------------------
ReadControllerNormalModeRemap(&ButtonA,
							  &ButtonB,
						      &ButtonX,
						      &ButtonY,
						      &SprintLB,
							  &ScannerRB,
							  &ButtonLT,
							  &ButtonRT,
							  &ButtonBack,
							  &ButtonStart){
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
}
;----------------------------------------------------
; Read ini Controller Race Mode Remap
;----------------------------------------------------
ReadControllerRaceModeRemap(&AfterBurnerButtonA,
							&ButtonLB,
						    &ButtonRB,
						    &RespawnY,
						    &AcelerateButtonRT,
							&ReverseButtonLT){
	AfterBurnerButtonA := IniRead(IniFile, "ControllerRaceModeRemap", "AfterBurnerButtonA")
	ButtonLB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonLB")
	ButtonRB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonRB")
	RespawnY := IniRead(IniFile, "ControllerRaceModeRemap", "RespawnY")
	AcelerateButtonRT := IniRead(IniFile, "ControllerRaceModeRemap", "AcelerateButtonRT")
	ReverseButtonLT := IniRead(IniFile, "ControllerRaceModeRemap", "ReverseButtonLT")
}
;----------------------------------------------------
; Read ini Controller Axis Remap
;----------------------------------------------------
ReadControllerAxisRemap(&TurnLeft,
						&TurnRight,
						&MoveForward,
						&MoveBackward,
						&LeftPOV,
						&RightPOV,
						&ForwadPOV,
						&BackwardPOV){
	TurnLeft := IniRead(IniFile, "ControllerAxisRemap", "TurnLeft")
	TurnRight := IniRead(IniFile, "ControllerAxisRemap", "TurnRight")
	MoveForward := IniRead(IniFile, "ControllerAxisRemap", "MoveForward")
	MoveBackward := IniRead(IniFile, "ControllerAxisRemap", "MoveBackward")
	LeftPOV := IniRead(IniFile, "ControllerAxisRemap", "LeftPOV")
	RightPOV := IniRead(IniFile, "ControllerAxisRemap", "RightPOV")
	ForwadPOV := IniRead(IniFile, "ControllerAxisRemap", "ForwadPOV")
	BackwardPOV := IniRead(IniFile, "ControllerAxisRemap", "BackwardPOV")
}