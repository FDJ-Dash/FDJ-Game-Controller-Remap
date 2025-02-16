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
; GetMacAddress(*)
; EncriptMsg(OriginalMsg, *)
; DecriptMsg(EncriptedMsgGCR, *)
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
	If ExitCode == 2 {
		InvalidLicenseMsg
		sleep ExitMessageTimeWait
		return 0
	}
	If ExitCode == 3 {
		LicenseFileMissingMsg
		sleep ExitMessageTimeWait
		return 0
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
GetMacAddress(*){
	TempFile := A_Temp . "\AuxData.ini"
	if !FileExist(TempFile) {
		RunWait(A_ComSpec " /c getmac /NH > " TempFile, , "Hide") ; ipconfig (slow)
		FileAppend "[AuxData]" , TempFile
	}
	Count := 0
	FlagError := 0
	Loop Read, TempFile
	{
		; Check if the current line is empty
		if !A_LoopReadLine {
			Count++
			continue
		}

		; Process the non-empty line here
		Match := RegExMatch(A_LoopReadLine, ".*?([0-9A-F])(?!\\Device)", &mac)
		Match2 := RegExMatch(A_LoopReadLine, ".*?([0-9A-Z])(?!\\w\\Device)", &mac)
		Switch true {
		case Match == true:
			MacAddress := StrSplit( A_LoopReadLine, A_Space)
		case Match2 == true:
			MacAddress := StrSplit( A_LoopReadLine, A_Space)
		Default:
			MacAddress := "An Error Ocurred"
			FlagError := 1
		}
		break
	}
	
	try {
		FileDelete TempFile
	}
	catch {

	}

	if FlagError == 0 {
		StringMacAddress := MacAddress[Count]
	} else {
		StringMacAddress := MacAddress
	}
	return StringMacAddress
}
;----------------------------------------------------
EncriptMsg(OriginalMsg, *){
	MixedPattern := "Az0By9Cx7Da8Eb2Fc4Gw3Hv5Ij6Js1KlLhMpNeOtPgQnRrSiTqUoVkWmXdYfZu"
	PunctuationPattern := "!#$%&'()*+,-./:;<=>?@[\]^_`"{|}~ "
	
	EncriptedMsg := ""
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
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 47 and ord(A_LoopField) < 58:
			; (0,9)
			EncriptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case FlagNmCount == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 1)
						FlagNmCount++
						break
					}
				case FlagNmCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 5)
						EncriptedMsg .= chr(index + 34 + 16)
						FlagNmCount++
						break
					}
				case FlagNmCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 9)
						EncriptedMsg .= chr(index + 34 + 23)
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
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 64 and ord(A_LoopField) < 91:
			; (A-Z)
			EncriptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case Flag_AZ_Count2 == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 14)
						EncriptedMsg .= chr(index + 34 + 26)
						Flag_AZ_Count2++
						break
					}
				case Flag_AZ_Count2 == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 16)
						Flag_AZ_Count2++
						break
					}
				case Flag_AZ_Count2 == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 11)
						EncriptedMsg .= chr(index + 34 + 12)
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
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		case ord(A_LoopField) > 96 and ord(A_LoopField) < 123:
			; (a-z)
			EncriptedString := A_LoopField
			for index, letter in StrSplit(MixedPattern) {
				switch true {
				case Flag_az_Count == 0:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 27)
						EncriptedMsg .= chr(index + 34 + 23)
						Flag_az_Count++
						break
					}
				case Flag_az_Count == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 12)
						Flag_az_Count++
						break
					}
				case Flag_az_Count == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 19)
						EncriptedMsg .= chr(index + 34 + 26)
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
						EncriptedMsg .= chr(index + 34 + 7)
						EncriptedMsg .= chr(index + 34 + 5)
						FlagSignCount++
						break
					}
				case FlagSignCount == 1:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 4)
						EncriptedMsg .= chr(index + 34 + 9)
						FlagSignCount++
						break
					}
				case FlagSignCount == 2:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 10)
						EncriptedMsg .= chr(index + 34 + 4)
						FlagSignCount++
						break
					}
				case FlagSignCount == 3:
					if (letter == A_LoopField) {
						EncriptedMsg .= chr(index + 34 + 21)
						EncriptedMsg .= chr(index + 34 + 31)
						FlagSignCount := 0
						break
					}
				}
			}
		}
	}
	return EncriptedMsg
}
;----------------------------------------------------
DecriptMsg(EncriptedMsgGCR, *) {
	MixedPattern := "Az0By9Cx7Da8Eb2Fc4Gw3Hv5Ij6Js1KlLhMpNeOtPgQnRrSiTqUoVkWmXdYfZu"
	PunctuationPattern := "!#$%&'()*+,-./:;<=>?@[\]^_`"{|}~ "
	DecriptedMsg := ""

	count := 1
	DiffValue := 0
	IndexKey := 0
	Loop Parse EncriptedMsgGCR {
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
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
						DecriptedMsg .= letter
						break
					}
				}
			}
		}
		count++
	}
	return DecriptedMsg
}
;----------------------------------------------------
ParseRequest(*){
	TempFileGCR := A_Temp . "\GCR_UpdateData.ini"
	EncCurl := "NJdlcj]YIG27\dLFCMFRIGAF*3szeaHPipkgV^7>HDNVelqmRZ;5Wa]dqm\d[bieIGPXeleaHPszKG@EJR@GeaF@DAEP./COHQ45_kFT*3)&T\OVFG:FBM``iPQuq@Ldl=DT]Q[CQRS]ikgBK\d:;IUNWLSa](0XY_kZcRYEA(0\]ah4@;89Da]NWFNIW]dWSCKFM,)B>TUHP]iahEA<E@H@AEPmt4@4B9B:;O[;8<G9B@NLM4@dmNJV^jk_fDBFK_[NV]da]CK;5EO75@Ga]V^38_fmiNVW^{w4<93FMqm^fEOcjc_JRipZV75@L3<IJ27:F19RY_[:4LUNOCMCO19mtc_5309ZbaheaT\ip]YFN[bkg27Z[LTmtHDJR:4cjc_FN[bHDCK[bZVEOFN@GeaLTRYea"
	RunWait(A_ComSpec " /c " . DecriptMsg(EncCurl) . " > " TempFileGCR, , "Hide")
	
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
		Match2 := RegExMatch(CleanLine, "url : https://api.github.com/repos/FDJ-Dash/ML-Game-Controller-Remap/releases/assets/\d+", &download_url)
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
					DownloadUrl := EncriptMsg(DownloadUrl)
					IniWrite DownloadUrl, DataFile, "EncriptedData", "GCRDownload"
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