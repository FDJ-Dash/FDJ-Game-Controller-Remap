;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap
; File Description: This file contains general functions.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; ExitMenu(ExitReason,ExitCode)
; EncryptMsg(OriginalMsg, *)
; DecryptMsg(EncryptedMsgGCR, *)
; ParseRequest(*)
; CheckConnection(*)
;----------------------------------------------------
ExitMenu(ExitReason,ExitCode)
{
	SB.SetText("Quiting..")
	GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
	if GuiName == "ControllerRemapGui1" {
		ControllerRemapGui1.GetPos(&PosX, &PosY)
	} else {
		ControllerRemapGui2.GetPos(&PosX, &PosY)
	}
	if PosX != -32000 {
		IniWrite PosX, IniFile, "Properties", "PositionX"
	}
	if PosY != -32000 {
		IniWrite PosY, IniFile, "Properties", "PositionY"
	}
	If ExitReason == "Reload" {
		return 0
	}
	try {
		FileDelete DataFile
		FileDelete TempCleanFileGCR
	}
	catch {
	}
	Send("{w up}")
	Send("{shift up}")
	Send("{Ctrl up}")
	ExitMsg
	sleep ExitMessageTimeWait
	try {
		FileDelete TempSystemFile
	}
	catch {
	}
	return 0
}
;----------------------------------------------------
EncryptMsg(OriginalMsg, *){
	MixedPattern := "Az0By9Cx7Da8Eb2Fc4Gw3Hv5Ij6Js1KlLhMpNeOtPgQnRrSiTqUoVkWmXdYfZu"
	PunctuationPattern := "!#$%&'()*+,-./:;<=>?@[\]^_`"{|}~ "
	
	EncryptedMsg := ""
	FlagSignCount := 0
	FlagNmCount := 0
	Flag_az_Count := 0
	Flag_AZ_Count2 := 0
	Loop Parse OriginalMsg {
		switch true {
		case ord(A_LoopField) > 31 and ord(A_LoopField) < 48:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 7)
						EncryptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 4)
						EncryptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 10)
						EncryptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 21)
						EncryptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 47 and ord(A_LoopField) < 58:
			; (0,9)
			EncryptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case FlagNmCount == 0:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 4)
						EncryptedMsg .= chr(index + 34 + 1)
						FlagNmCount++
						break
					}
				case FlagNmCount == 1:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 5)
						EncryptedMsg .= chr(index + 34 + 16)
						FlagNmCount++
						break
					}
				case FlagNmCount == 2:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 9)
						EncryptedMsg .= chr(index + 34 + 23)
						FlagNmCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 57 and ord(A_LoopField) < 65:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 7)
						EncryptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 4)
						EncryptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 10)
						EncryptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 21)
						EncryptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 64 and ord(A_LoopField) < 91:
			; (A-Z)
			EncryptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case Flag_AZ_Count2 == 0:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 14)
						EncryptedMsg .= chr(index + 34 + 26)
						Flag_AZ_Count2++
						break
					}
				case Flag_AZ_Count2 == 1:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 7)
						EncryptedMsg .= chr(index + 34 + 16)
						Flag_AZ_Count2++
						break
					}
				case Flag_AZ_Count2 == 2:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 11)
						EncryptedMsg .= chr(index + 34 + 12)
						Flag_AZ_Count2 := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 90 and ord(A_LoopField) < 97:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 7)
						EncryptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 4)
						EncryptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 10)
						EncryptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 21)
						EncryptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 96 and ord(A_LoopField) < 123:
			; (a-z)
			EncryptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case Flag_az_Count == 0:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 27)
						EncryptedMsg .= chr(index + 34 + 23)
						Flag_az_Count++
						break
					}
				case Flag_az_Count == 1:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 4)
						EncryptedMsg .= chr(index + 34 + 12)
						Flag_az_Count++
						break
					}
				case Flag_az_Count == 2:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 19)
						EncryptedMsg .= chr(index + 34 + 26)
						Flag_az_Count := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 122 and ord(A_LoopField) < 127:
			; punctuation signs
			for index, letter in StrSplit(PunctuationPattern) {
				switch true {
				case FlagSignCount == 0:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 7)
						EncryptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 4)
						EncryptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 10)
						EncryptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncryptedMsg .= chr(index + 34 + 21)
						EncryptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		}
	}
	return EncryptedMsg
}
;----------------------------------------------------
DecryptMsg(EncryptedMsgGCR, *) {
	MixedPattern := "Az0By9Cx7Da8Eb2Fc4Gw3Hv5Ij6Js1KlLhMpNeOtPgQnRrSiTqUoVkWmXdYfZu"
	PunctuationPattern := "!#$%&'()*+,-./:;<=>?@[\]^_`"{|}~ "
	DecryptedMsg := ""

	count := 1
	DiffValue := 0
	IndexKey := 0
	Loop Parse EncryptedMsgGCR {
		if Mod(count, 2) == 1 {
			RealKey := ord(A_LoopField)
		}
		
		if Mod(count, 2) == 0 {
			AddedKey1 := ord(A_LoopField)
			DiffValue := Abs(RealKey - AddedKey1)
			flagLetterFound := 0
			switch true {
			case DiffValue == 1:
				IndexKey := RealKey - 34 - 11
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 2:
				IndexKey := RealKey - 34 - 7
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 3:
				IndexKey := RealKey - 34 - 4
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 4:
				IndexKey := RealKey - 34 - 27
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 5:
				IndexKey := RealKey - 34 - 4
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 6:
				IndexKey := RealKey - 34 - 10
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 7:
				IndexKey := RealKey - 34 - 19
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 8:
				IndexKey := RealKey - 34 - 4
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 9:
				IndexKey := RealKey - 34 - 7
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 10:
				IndexKey := RealKey - 34 - 21
				for index, letter in StrSplit(PunctuationPattern) {
					if IndexKey < 0 {
						; continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 11:
				IndexKey := RealKey - 34 - 5
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 12:
				IndexKey := RealKey - 34 - 14
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			case DiffValue == 14:
				IndexKey := RealKey - 34 - 9
				for index, letter in StrSplit(MixedPattern) {
					if IndexKey < 0 {
						continue
					}
					if index == IndexKey {
						DecryptedMsg .= letter
						break
					}
				}
			}
		}
		count++
	}
	return DecryptedMsg
}
;----------------------------------------------------
ParseRequest(*){
	TempFileGCR := A_Temp . "\GCR_UpdateData.ini"
	EncCurl := "NJdlcj]YIG27Q]LFCM53CKRY]Y27RZip82kgLTLSqm\d[bWa_[NV]da]CK8649:4@Ga]V^DN_fmiNVW^{w4<64FMqm^f49cjc_JRipZV:49B78LXCM3<19RY_[75=>:FEN27@A19mtc_827CZbaheaT\ip]YFN[bkgCMV_LTmtHDJR75cjc_FN[bHDCK[bZV49FN@GeaLTRYea"
	RunWait(A_ComSpec " /c " . DecryptMsg(EncCurl) . " > " TempFileGCR, , "Hide")
	
	Count := 0
	Loop Read, TempFileGCR
	{
		; Check if the current line is empty
		if !A_LoopReadLine {
			Count++
			continue
		}
		
		; Process the non-empty line here
		Flag1stLetter := 0
		CountOrd34 := 0
		FlagAddedSpace := 0
		CleanLine := ""
		Loop parse A_LoopReadLine {
			if ord(A_LoopField) == 34 {
				CountOrd34++
				if CountOrd34 == 4 {
					break
				}
			}
			if Flag1stLetter == 1 {
				Switch true {
				case ord(A_LoopField) == 32 and FlagAddedSpace == 0:
					CleanLine .= A_LoopField
					FlagAddedSpace := 1
				case ord(A_LoopField) == 34 and FlagAddedSpace == 0:
					CleanLine .= " "
					FlagAddedSpace := 1
				case ord(A_LoopField) == 44:
				    ; Continue with next line if comma is found
					break
				case ord(A_LoopField) != 34:
					CleanLine .= A_LoopField
					FlagAddedSpace := 0
				}	
			} 
			if ord(A_LoopField) != 32 and Flag1stLetter == 0 {
				Flag1stLetter := 1
				if ord(A_LoopField) != 34 {
					break
				}
			}
		}
		FileAppend CleanLine . "`n", TempCleanFileGCR
		Match := RegExMatch(CleanLine, "tag_name : v\d+\.\d+", &tag_name)
		Match2 := RegExMatch(CleanLine, "browser_download_url : https://github.com/FDJ-Dash/FDJ-Game-Controller-Remap/releases/download/v\d+\.\d+/\w+-\w+-\w+-\w+-\w+-v\d+\.\d+\.\w+", &download_url)
		Match3 := RegExMatch(CleanLine, "name : \w+-\w+-\w+-\w+-\w+-v\d+\.\d+\.\w+", &name)

		Switch true {
		case Match == true:
			for index, word in StrSplit(tag_name[0], A_Space) {
				if index == 3 {
					GCRLatestReleaseVersion := word
					IniWrite GCRLatestReleaseVersion, DataFile, "GeneralData", "GCRLatestReleaseVersion"
				}
			}
		case Match2 == true:
			for index, word in StrSplit(download_url[0], A_Space) {
				if index == 3 {
					DownloadUrl := word
					DownloadUrl := EncryptMsg(DownloadUrl)
					IniWrite DownloadUrl, DataFile, "EncryptedData", "GCRDownload"
				}
			}
		case Match3 == true:
			for index, word in StrSplit(name[0], A_Space) {
				if index == 3 {
					Name := word
					IniWrite Name, DataFile, "GeneralData", "GCRName"
				}
			}
		}
	}
	
	try {
		FileDelete TempFileGCR
	}
	catch {

	}
}
;----------------------------------------------------
CheckConnection(*){
	TempFileConnectionGCR := A_Temp . "\GCR_Connection.log"
	RunWait(A_ComSpec " /c curl -k -L https://www.google.com > " TempFileConnectionGCR, , "Hide")
	Match := false
	Count := 0
	; if anything longer than 1 line is found, then there is connection.
	Loop Read, TempFileConnectionGCR
	{
		; Check if the current line is empty
		if !A_LoopReadLine {
			Count++
			continue
		}
		if Count > 0 {
			Match := true
			break
		}
		Count++
	}
	
	try {
		FileDelete TempFileConnectionGCR
	}
	catch {

	}
	return Match
}


