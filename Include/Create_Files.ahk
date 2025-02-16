;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains file creations needed.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; CreateNewIniFile(*)
;----------------------------------------------------
CreateNewIniFile(*) {
	FileAppend "; ------------ Credits ------------`n" , IniFile
	FileAppend "; Creator: Fernando Daniel Jaime.`n" , IniFile
	FileAppend "; Programmer Alias: FDJ-Dash.`n" , IniFile
	FileAppend "; ------------ App Details ------------`n" , IniFile
	FileAppend "; App Name: Game Controller Remap.`n" , IniFile
	FileAppend "; Description: This is an app aimed towards game controller devices not recognized by some games`n" , IniFile
	FileAppend "; but still recognized by the Operating System.`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "; HINT: If you delete this file or move it away from its forder,`n" , IniFile
	FileAppend "; Game Controller Remap will generate a new file on the spot.`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "; Find the list of key names here: https://www.autohotkey.com/docs/v2/KeyList.htm`n" , IniFile
	FileAppend ";-------------------------------`n" , IniFile
	FileAppend "; See the list of recommended fonts here: https://www.autohotkey.com/docs/v2/misc/FontsStandard.htm`n" , IniFile
	FileAppend ";-------------------------------`n" , IniFile
	FileAppend "; See the list of color names and RGB values here: https://www.autohotkey.com/docs/v2/misc/Colors.htm`n" , IniFile
	FileAppend "; Black Silver Gray White Maroon Red Purple Fuchsia Green Lime Olive Yellow Navy Blue Teal Aqua`n" , IniFile
	FileAppend "; If the color name you need is not listed you can still write its RGB value`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Properties]`n" , IniFile
	FileAppend "ExitMessageTimeWait=3000`n" , IniFile
	FileAppend "GuiPriorityAlwaysOnTop=1`n" , IniFile
	FileAppend "ControllerLoopInterval=100`n" , IniFile
	FileAppend ";----------`n" , IniFile
	FileAppend "PositionX=605`n" , IniFile
	FileAppend "PositionY=324`n" , IniFile
	FileAppend ";----------`n" , IniFile
	FileAppend "ExitGameControllerRemap=|`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Settings]`n" , IniFile
	FileAppend "CheckforUpdatesDaily=1`n" , IniFile
	FileAppend "CheckforupdatesWeekly=0`n" , IniFile
	FileAppend "NeverCheckForUpdates=0`n" , IniFile
	FileAppend "NeedUpdate=0`n" , IniFile
	FileAppend "LastUpdateCheckTimeStamp=`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerCursorMovement]`n" , IniFile
	FileAppend "CursorSensRight=100`n" , IniFile
	FileAppend "CursorSensDown=100`n" , IniFile
	FileAppend "CursorSensLeft=-100`n" , IniFile
	FileAppend "CursorSensUp=-100`n" , IniFile
	FileAppend "CursorSpeed=0`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerCameraRotation]`n" , IniFile
	FileAppend "ShiftDownRotation=Shift`n" , IniFile
	FileAppend "CtrlDownRotation=Ctrl`n" , IniFile
	FileAppend "RotateLeft=Left`n" , IniFile
	FileAppend "RotateRight=Right`n" , IniFile
	FileAppend "RotateUp=Up`n" , IniFile
	FileAppend "RotateDown=Down`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerNormalModeRemap]`n" , IniFile
	FileAppend "ButtonA=Space`n" , IniFile
	FileAppend "ButtonB=RButton`n" , IniFile
	FileAppend "ButtonX=esc`n" , IniFile
	FileAppend "ButtonY=f`n" , IniFile
	FileAppend "SprintLB=Shift`n" , IniFile
	FileAppend "ScannerRB=n`n" , IniFile
	FileAppend "ButtonRT=w`n" , IniFile
	FileAppend "ButtonLT=s`n" , IniFile
	FileAppend "ButtonStart=tab`n" , IniFile
	FileAppend "ButtonBack=i`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerAxisRemap]`n" , IniFile
	FileAppend "TurnLeft=a`n" , IniFile
	FileAppend "TurnRight=d`n" , IniFile
	FileAppend "MoveForward=w`n" , IniFile
	FileAppend "MoveBackward=s`n" , IniFile
	FileAppend "LeftPOV=a`n" , IniFile
	FileAppend "RightPOV=d`n" , IniFile
	FileAppend "ForwadPOV=w`n" , IniFile
	FileAppend "BackwardPOV=s`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[ControllerRaceModeRemap]`n" , IniFile
	FileAppend "AfterBurnerButtonA=Shift`n" , IniFile
	FileAppend "ButtonLB=a`n" , IniFile
	FileAppend "ButtonRB=d`n" , IniFile
	FileAppend "RespawnY=r`n" , IniFile
	FileAppend "AcelerateButtonRT=w`n" , IniFile
	FileAppend "ReverseButtonLT=s`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[FontType]`n" , IniFile
	FileAppend "MainFontType=Comic Sans MS`n" , IniFile
	FileAppend "MessageAppNameFontType=Georgia`n" , IniFile
	FileAppend "LicenseKeyFontType=Comic Sans MS`n" , IniFile
	FileAppend "MessageMainMsgFontType=Georgia`n" , IniFile
	FileAppend "MessageFontType=Georgia`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[FontColors]`n" , IniFile
	FileAppend "MainFontColor=FF9933`n" , IniFile
	FileAppend "MessageAppNameFontColor=FF9933`n" , IniFile
	FileAppend "LicenseKeyFontColor=70A0FA`n" , IniFile
	FileAppend "MessageMainMsgFontColor=FF9933`n" , IniFile
	FileAppend "MessageFontColor=FF9933`n" , IniFile
	FileAppend ";--------------------------------------------------`n" , IniFile
	FileAppend "[Background]`n" , IniFile
	FileAppend "BackgroundColor=2F2F2F`n" , IniFile
	FileAppend "BackgroundPicture=`n" , IniFile
	FileAppend "MessageBackgroundPicture=`n" , IniFile
}