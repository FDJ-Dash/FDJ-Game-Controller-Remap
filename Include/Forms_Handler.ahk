;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains all registration and login related forms.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; LoginOrRegister(*) ; Level 1
;    LoginAccount(*)     ; Level 2
;        Login(*)               ; Level 3A
;        ForgotPswd(*)          ; Level 3A
;            UpdatePassword(*)      ; Level 4A
;            ForgotPswd_Close(*)    ; Level 4A
;            SendValidationEmail(*) ; Level 4A
;            ValidateCode(*)        ; Level 4A
;            ValidatePassword(*)    ; Level 4A
;            GoBackMenu(*)          ; Level 4A
;            Destroy(*)             ; Level 4A
;        LoginMsg_Close(*)      ; Level 3A
;        GoBackMenu(*)          ; Level 3A
;        Destroy(*)             ; Level 3A
;    RegisterAccount(*)  ; Level 2
;        Register(*)            ; Level 3B 
;        RegMsg_Close(*)        ; Level 3B
;        SendValidationEmail(*) ; Level 3B
;        ValidateCode(*)        ; Level 3B
;        ValidatePassword(*)    ; Level 3B
;        GoBackMenu(*)          ; Level 3B
;        Destroy(*)             ; Level 3B
;    LogRegMsg_Close(*)  ; Level 2
;    ExitMenu(*)         ; Level 2
;    Destroy(*)          ; Level 2
; ManageDevices(Email, Pswd, MacAddress) ; Level 1
; MenuManageDevices(*) ; Level 1
;     MenuManageDevForgotPswd(*) ; Level 2
;----------------------------------------------------
; LoginOrRegister(*) ; Level 1
;----------------------------------------------------
LoginOrRegister(*) {
	LoginOrRegisterMsg:
		if GuiPriorityAlwaysOnTop == true {
			LogRegMsg := Gui("+AlwaysOnTop")
		} else {
			LogRegMsg := Gui()
		}
		FlagRegisteredDevice := false
		GuiName := IniRead(TempSystemFile, "GeneralData", "GuiName")
		LogRegMsg.BackColor := "0x" . BackgroundColor
		MessageBackgroundPicture := IniRead(IniFile, "Background", "MessageBackgroundPicture")
		if MessageBackgroundPicture == "" {
		try {
				LogRegMsg.Add("Picture", "x0 y0 w500 h240", ImageLib . DefaultMsgBackgroundImage)
			}
			catch {
			}
		} else {
			try {
				LogRegMsg.Add("Picture", "x0 y0 w500 h240", MessageBackgroundPicture)
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
			LogRegMsg.Add("Picture", "x9 y10 w32 h32 +border", IconLib . FDJ_SoftwareIcon)
		}
		catch {
		}
		LogRegMsg.SetFont("s16 W700 Q4 " . MessageAppNameFontColor, MessageAppNameFontType)
		LogRegMsg.Add("Text", "x50 y16 +Center w400", AppName)
		LogRegMsg.Add("Text", "x450 y16 +Center w40", "")
		LogRegMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		LogRegMsg.Add("Text", "x390 y24 ", CurrentVersion)
		LogRegMsg.Add("Text", "x0 y54 w500 h1 +0x5")
		;---------------------
		LogRegMsg.SetFont()
		LogRegMsg.SetFont("s14 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		;---------------------
		; Verify existing device
        ;---------------------
		MySqlInst := DatabaseConnetion()
		;------------------------
		QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Mac_Address='" StringMacAddress "'" )
		if QueryResult == 0 {
			ResultSet := MySqlInst.GetResult()
			Device := 0
			for k, v in ResultSet.Rows {
				; Process each row (Could be more than 1 row)
				if StringMacAddress == v["Mac_Address"] {
					; Device := v["Device_Number"]
					; CustomerId := v["Customer_Id"]
					FlagRegisteredDevice := true
				}
			}
		}
		;---------------------
		if FlagRegisteredDevice == false {
		    LogRegMsg.Add("Text", "x50 y85 +Center w400", "Register new account or login to add new device.")
		} else {
		    LogRegMsg.Add("Text", "x30 y85 +Center w440", "This device is registered. Login to validate account.")
		}
		
		LogRegMsg.SetFont()
		LogRegMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		if FlagRegisteredDevice == false {
		    ogcButtonRegister := LogRegMsg.Add("Button", "x80 y135 w150 h24", "Register Account")
		} else {
		    ogcButtonRegister := LogRegMsg.Add("Button", "x80 y135 w150 h24 +disabled", "Register Account")
		    ; ogcButtonRegister := LogRegMsg.Add("Button", "x80 y135 w150 h24", "Register Account")
		}
		ogcButtonRegister.OnEvent("Click", RegisterAccount)
		ogcButtonLogin := LogRegMsg.Add("Button", "x265 y135 w150 h24", "Login Account")
		ogcButtonLogin.OnEvent("Click", LoginAccount)
		LogRegMsg.Add("Text", "x0 y180 w500 h1 +0x5")
		;---------------------
		LogRegMsg.SetFont()
		LogRegMsg.SetFont("s10 " . MessageFontColor, MessageFontType)
        LogRegMsg.Add("Text", "x25 y205", "Copyright 2024 FDJ-Software. All Rights Reserved.")
		LogRegMsg.SetFont("s9 " . MessageFontColor, MessageFontType)
		ogcButtonCancel := LogRegMsg.Add("Button", "x400 y200 w80 h24", "Exit")
		ogcButtonCancel.OnEvent("Click", ExitMenu)
		;---------------------
        LogRegMsg.Title := "Register Account or Login!"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
        LogRegMsg.Show("x" . PosX - 150 . " y" . PosY + 120 . "w500 h240")
        ControlFocus("Button1", "Register Account or Login!")
        LogRegMsg.Opt("+LastFound")
		LogRegMsg.OnEvent("Close", LogRegMsg_Close)
		; suspend true
	Return
	;----------------------------------------------------
	; LoginAccount(*) ; Level 2
	;----------------------------------------------------
	LoginAccount(*) {
		LogRegMsg.Destroy()
		ShowLoginMsg:
		    if GuiPriorityAlwaysOnTop == true {
				LoginMsg := Gui("+AlwaysOnTop")
			} else {
				LoginMsg := Gui()
			}
			;------------------------
			LoginMsg.BackColor := "0x" . BackgroundColor
			LoginMsg.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
			
			LoginMsg.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)

			LoginMsg.Add("Text", "x10 y10 w116 h20 +0x200", " Email: ")
			EditEmail := LoginMsg.Add("Edit", "vEmail x136 y10 w341 h20")
			EditEmail.Opt("" . BackgroundMainColor . "")
			;------------------------
			LoginMsg.Add("Text", "x10 y41 w116 h20 +0x200", " Password: ")
			EditPassword := LoginMsg.Add("Edit", "vPswd x136 y41 w112 h20 +Limit16 +Password")
			EditPassword.Opt("" . BackgroundMainColor . "")
			;------------------------
			; LoginMsg.Add("Text", "x1 y67 w488 h2 +0x10") ; Separator
			LoginMsg.Add("Text", "x10 y76 +Center w468 h20 +0x200", " If you bought a new app, please also include your receipt id below ")
			LoginMsg.Add("Text", "x10 y111 w116 h20 +0x200", " Receipt Id: ")
			EditReceiptIdTA := LoginMsg.Add("Edit", "vReceiptIdGCR x136 y111 w250 h20 ") ; add +Limit40 +Password
			EditReceiptIdTA.Opt("" . BackgroundMainColor . "")
			; LoginMsg.Add("Text", "x1 y137 w488 h2 +0x10") ; Separator
			;------------------------
			ogcButtonRegister := LoginMsg.Add("Button", "x80 y146 w120 h24", "Login")
			ogcButtonRegister.OnEvent("Click", Login)
			;------------------------
			ogcButtonCancel := LoginMsg.Add("Button", "x288 y146 w120 h24", "Go Back")
			ogcButtonCancel.OnEvent("Click", GoBackMenu)
			;------------------------
			ogcButtonRegister := LoginMsg.Add("Button", "x185 y181 w120 h24", "Forgot Password")
			ogcButtonRegister.OnEvent("Click", ForgotPswd)
			
			LoginMsg.Title := "Login Account"
			if GuiName == "ControllerRemapGui1" {
				ControllerRemapGui1.GetPos(&PosX, &PosY)
			} else {
				ControllerRemapGui2.GetPos(&PosX, &PosY)
			}
			LoginMsg.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
			SB_RegMsg := LoginMsg.Add("StatusBar", , "Ready.")
			LoginMsg.Show("x" . PosX - 160 . " y" . PosY + 120 . "w488 h240")
			
			ControlFocus("Button1", "Login")
			LoginMsg.Opt("+LastFound")
			LoginMsg.OnEvent("Close", LoginMsg_Close)
			pause true
		Return
		;----------------------------------------------------
	    ; login(*) ; Level 3
	    ;----------------------------------------------------
		login(*) {
			Saved := LoginMsg.Submit(false)

			if Saved.Email == "" {
				InvalidEmailAddress()
				return
			}
			
			try {
				validMail := RegExMatch(Saved.Email, "^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
			}
			catch {
				validMail := false
			}
			
			if validMail == false {
				InvalidEmailAddress()
				return
			}
			
			if StrLen(Saved.Pswd) < 8 {
				; Password is too short
				PasswordTooShort()
				return
			}
			SB.SetText("Validating User..")
			MacAddress := GetMacAddress()
			Saved.Pswd := EncryptPsw(Saved.Pswd)
			Lic_Amount_GCR := 3
			Date_GCR := A_Now
			Date_GCR := FormatTime(Date_GCR, "yyyy-MM-dd")
			
			UserCredentials := ValidateUser(Saved.Email,
			                                Saved.Pswd,
											MacAddress,
											Saved.ReceiptIdGCR,
											Lic_Amount_GCR,
											Date_GCR)
			
			switch true {
			case CheckConnection() != true:
			    ; No connection.
				CheckConnectionMsg()
			case UserCredentials == 0:
			    ; Login successful
				IniWrite LicenseKey, LicenseFile, "Data", "LicenseKey"
				WelcomeMessage()
				; suspend false
				Destroy()
				exitApp
			case UserCredentials == 2:
				; Do not allow access due to license amount.
				IniWrite LicenseKey, LicenseFile, "Data", "LicenseKey"
				LoginMsg.Destroy()
				ManageDevices(Saved.Email, Saved.Pswd, MacAddress)
				; LicenseAmountMaxedOut()
			case UserCredentials == 1:
				; Wrong credentials
				CheckEmailAndPassword()
			} 
		}
		;----------------------------------------------------
	    ; ForgotPswd(*) ; Level 3
	    ;----------------------------------------------------
		ForgotPswd(*) {
			LoginMsg.Destroy()
			ShowForgotPswdMsg:
			
				DynamicReload2 := true
				GuiCount2 := 1
				GuiName2 := ""
				FlagSentMail := false
				IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
				IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
				IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
				IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
				;------------------------
				totalTime := 60000
				remainingTime := totalTime
				elapsed := 0
				;------------------------
				Email := ""
				ValidCode := ""
				InputCode := ""
				EmailStatus := ""
				Pswd := ""
				PasswordStatus := ""
				IniWrite Email, TempSystemFile, "GeneralData", "Email"
				IniWrite ValidCode, TempSystemFile, "GeneralData", "ValidCode"
				IniWrite InputCode, TempSystemFile, "GeneralData", "InputCode"
				IniWrite EmailStatus, TempSystemFile, "GeneralData", "EmailStatus"
				IniWrite Pswd, TempSystemFile, "GeneralData", "Pswd"
				IniWrite PasswordStatus, TempSystemFile, "GeneralData", "PasswordStatus"
				
				MailSent := false
				;----------------------------------------------------
				; General Loop Start
				;----------------------------------------------------
				Loop {
					DynamicReload2 := IniRead(TempSystemFile, "GeneralData", "DynamicReload2")
					FlagSentMail := IniRead(TempSystemFile, "GeneralData", "FlagSentMail")
					try {
						Email := IniRead(TempSystemFile, "GeneralData", "Email")
						ValidCode := IniRead(TempSystemFile, "GeneralData", "ValidCode")
						ValidCode := DecryptMsg(ValidCode)
						InputCode := IniRead(TempSystemFile, "GeneralData", "InputCode")
						EmailStatus := IniRead(TempSystemFile, "GeneralData", "EmailStatus")
						Pswd := IniRead(TempSystemFile, "GeneralData", "Pswd")
						PasswordStatus := IniRead(TempSystemFile, "GeneralData", "PasswordStatus")
					}
					catch {
					}
					if DynamicReload2 == true {
						;----------------------------------------------------
						; GUI Properties
						;----------------------------------------------------
						if Mod(GuiCount2, 2) == 1 {
							;----------------------------------------------------
							; GUI 1 instance - Inside Dynamic Reload
							;----------------------------------------------------
							GuiName2 := "ForgotPswdMsg1"
							IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
							if GuiPriorityAlwaysOnTop == true {
								ForgotPswdMsg1 := Gui("+AlwaysOnTop")
							} else {
								ForgotPswdMsg1 := Gui()
							}
							ForgotPswdMsg1.BackColor := "0x" . BackgroundColor
							ForgotPswdMsg1.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
							
							ForgotPswdMsg1.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
							if ValidCode == "" {
								ValidCode := Random(100000, 999999)
								IniWrite EncryptMsg(ValidCode), TempSystemFile, "GeneralData", "ValidCode"
							}
							ForgotPswdMsg1.Add("Text", "x10 y10 w116 h20 +0x200", " Email: ")
							EditEmail := ForgotPswdMsg1.Add("Edit", "vEmail x136 y10 w341 h20")
							EditEmail.Opt("" . BackgroundMainColor . "")
							EditEmail.Value := Email
							;------------------------
							if FlagSentMail == false {
								ogcButtonSendMail := ForgotPswdMsg1.Add("Button", "x490 y10 w90 h20", "Send Mail")
								ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
							} else {
								ogcButtonSendMail := ForgotPswdMsg1.Add("Button", "x490 y10 w90 h20 +disabled", "Send Mail")
								ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
							}
							;------------------------
							ForgotPswdMsg1.Add("Text", "x10 y41 w116 h20 +0x200", " Email Code: ")
							EditInputCode := ForgotPswdMsg1.Add("Edit", "vInputCode x136 y41 w90 h20")
							EditInputCode.Opt("" . BackgroundMainColor . "")
							EditInputCode.Value := InputCode
							;------------------------
							EditEmailStatus := ForgotPswdMsg1.Add("Text", "x365 y41 +Center w112 h20 +0x200", "Not Validated")
							if EmailStatus != "" {
								EditEmailStatus.Value := EmailStatus
							}
							;------------------------
							ogcButtonValidateCode := ForgotPswdMsg1.Add("Button", "x490 y41 w90 h20", "Validate Code")
							ogcButtonValidateCode.OnEvent("Click", ValidateCode)
							;------------------------
							ForgotPswdMsg1.Add("Text", "x10 y71 w116 h20 +0x200", " Password: ")
							EditPassword := ForgotPswdMsg1.Add("Edit", "vPswd x136 y71 w112 h20 +Limit16 +Password")
							EditPassword.Opt("" . BackgroundMainColor . "")
							EditPassword.Value := Pswd
							;------------------------
							EditReEnteredPsw := ForgotPswdMsg1.Add("Text", "x10 y102 w116 h20 +0x200", " Re-enter Password: ")
							EditReEnterPassword := ForgotPswdMsg1.Add("Edit", "vReEnterPassword x136 y102 w112 h20 +Limit16 +Password")
							EditReEnterPassword.Opt("" . BackgroundMainColor . "")
							if PasswordStatus == "Ok" {
								EditReEnterPassword.Value := Pswd
							}
							;------------------------
							EditPasswordStatus := ForgotPswdMsg1.Add("Text", "x365 y102 +Center w112 h20 +0x200", "Not Validated")
							if PasswordStatus != "" {
							    EditPasswordStatus.Value := PasswordStatus
							}
							;------------------------
							ogcButtonValidatePassword := ForgotPswdMsg1.Add("Button", "x490 y102 w90 h20", "Validate")
							ogcButtonValidatePassword.OnEvent("Click", ValidatePassword)
							;------------------------
							ogcButtonRegister := ForgotPswdMsg1.Add("Button", "x90 y199 w150 h24", "Update Password")
							ogcButtonRegister.OnEvent("Click", UpdatePassword)
							;------------------------
							ogcButtonCancel := ForgotPswdMsg1.Add("Button", "x355 y199 w150 h24", "Go Back")
							ogcButtonCancel.OnEvent("Click", GoBackMenu)
							ForgotPswdMsg1.Title := "Forgot Password"
							if GuiName == "ControllerRemapGui1" {
								ControllerRemapGui1.GetPos(&PosX, &PosY)
							} else {
								ControllerRemapGui2.GetPos(&PosX, &PosY)
							}
							ForgotPswdMsg1.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
							SB_RegMsg := ForgotPswdMsg1.Add("StatusBar", , "Ready.")
							ForgotPswdMsg1.Show("x" . PosX - 225 . " y" . PosY + 120 . "w595 h260")
							
							ControlFocus("Button1", "Forgot Password")
							ForgotPswdMsg1.Opt("+LastFound")
							ForgotPswdMsg1.OnEvent("Close", ForgotPswd_Close)
						} else {
							;----------------------------------------------------
							; GUI 2 instance - Inside Dynamic Reload
							;----------------------------------------------------
							GuiName2 := "ForgotPswdMsg2"
							IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
							if GuiPriorityAlwaysOnTop == true {
								ForgotPswdMsg2 := Gui("+AlwaysOnTop")
							} else {
								ForgotPswdMsg2 := Gui()
							}
							ForgotPswdMsg2.BackColor := "0x" . BackgroundColor
							ForgotPswdMsg2.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
							
							ForgotPswdMsg2.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
							if ValidCode == "" {
								ValidCode := Random(100000, 999999)
								IniWrite EncryptMsg(ValidCode), TempSystemFile, "GeneralData", "ValidCode"
							}
							ForgotPswdMsg2.Add("Text", "x10 y10 w116 h20 +0x200", " Email: ")
							EditEmail := ForgotPswdMsg2.Add("Edit", "vEmail x136 y10 w341 h20")
							EditEmail.Opt("" . BackgroundMainColor . "")
							EditEmail.Value := Email
							;------------------------
							if FlagSentMail == false {
								ogcButtonSendMail := ForgotPswdMsg2.Add("Button", "x490 y10 w90 h20", "Send Mail")
								ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
							} else {
								ogcButtonSendMail := ForgotPswdMsg2.Add("Button", "x490 y10 w90 h20 +disabled", "Send Mail")
								ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
							}
							;------------------------
							ForgotPswdMsg2.Add("Text", "x10 y41 w116 h20 +0x200", " Email Code: ")
							EditInputCode := ForgotPswdMsg2.Add("Edit", "vInputCode x136 y41 w90 h20")
							EditInputCode.Opt("" . BackgroundMainColor . "")
							EditInputCode.Value := InputCode
							;------------------------
							EditEmailStatus := ForgotPswdMsg2.Add("Text", "x365 y41 +Center w112 h20 +0x200", "Not Validated")
							if EmailStatus != "" {
								EditEmailStatus.Value := EmailStatus
							}
							;------------------------
							ogcButtonValidateCode := ForgotPswdMsg2.Add("Button", "x490 y41 w90 h20", "Validate Code")
							ogcButtonValidateCode.OnEvent("Click", ValidateCode)
							;------------------------
							ForgotPswdMsg2.Add("Text", "x10 y71 w116 h20 +0x200", " Password: ")
							EditPassword := ForgotPswdMsg2.Add("Edit", "vPswd x136 y71 w112 h20 +Limit16 +Password")
							EditPassword.Opt("" . BackgroundMainColor . "")
							EditPassword.Value := Pswd
							;------------------------
							EditReEnteredPsw := ForgotPswdMsg2.Add("Text", "x10 y102 w116 h20 +0x200", " Re-enter Password: ")
							EditReEnterPassword := ForgotPswdMsg2.Add("Edit", "vReEnterPassword x136 y102 w112 h20 +Limit16 +Password")
							EditReEnterPassword.Opt("" . BackgroundMainColor . "")
							if PasswordStatus == "Ok" {
								EditReEnterPassword.Value := Pswd
							}
							;------------------------
							EditPasswordStatus := ForgotPswdMsg2.Add("Text", "x365 y102 +Center w112 h20 +0x200", "Not Validated")
							if PasswordStatus != "" {
							    EditPasswordStatus.Value := PasswordStatus
							}
							;------------------------
							ogcButtonValidatePassword := ForgotPswdMsg2.Add("Button", "x490 y102 w90 h20", "Validate")
							ogcButtonValidatePassword.OnEvent("Click", ValidatePassword)
							;------------------------
							ogcButtonRegister := ForgotPswdMsg2.Add("Button", "x90 y199 w150 h24", "Update Password")
							ogcButtonRegister.OnEvent("Click", UpdatePassword)
							;------------------------
							ogcButtonCancel := ForgotPswdMsg2.Add("Button", "x355 y199 w150 h24", "Go Back")
							ogcButtonCancel.OnEvent("Click", GoBackMenu)
							ForgotPswdMsg2.Title := "Forgot Password"
							if GuiName == "ControllerRemapGui1" {
								ControllerRemapGui1.GetPos(&PosX, &PosY)
							} else {
								ControllerRemapGui2.GetPos(&PosX, &PosY)
							}
							ForgotPswdMsg2.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
							SB_RegMsg := ForgotPswdMsg2.Add("StatusBar", , "Ready.")
							ForgotPswdMsg2.Show("x" . PosX - 225 . " y" . PosY + 120 . "w595 h260")
							
							ControlFocus("Button1", "Forgot Password")
							ForgotPswdMsg2.Opt("+LastFound")
							ForgotPswdMsg2.OnEvent("Close", ForgotPswd_Close)
						} 
						;----------------------------------------------------
						; Destroy previous Gui
						;----------------------------------------------------
						if GuiCount2 != 1 {
							if Mod(GuiCount2, 2) == 0 {
								ForgotPswdMsg1.Destroy
							} else {
								ForgotPswdMsg2.Destroy
							}
						}
						GuiCount2++
						IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
						
						SB.SetText("Awaiting registration..")
						;----------------------------------------------------
						; Set DynamicReload2 to false again
						;----------------------------------------------------
						DynamicReload2 := false
						IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
						;----------------------------------------------------
					} ; End DimamicReload2 / GUI Static code
					;----------------------------------------------------
					; Dynamic code starts here
					;----------------------------------------------------
					
					if FlagSentMail == true {
						elapsed += ControllerLoopInterval 
						remainingTime := round((totalTime - elapsed) / 1000)
						if (remainingTime <= 0) {
							remainingTime := 0
						}
						SB_RegMsg.SetText("Mail sent. Retry in " remainingTime " secs.")
						if MailSent == false {
							SendMailForgotPswd(ValidCode, Email)
							MailSent := true
						}
					}
					
					if remainingTime == 0 {
						remainingTime := totalTime
						elapsed := 0
						FlagSentMail := false
						MailSent := false
						IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
						; Save any other user input value too
						if GuiName2 == "ForgotPswdMsg1" {
							Saved := ForgotPswdMsg1.Submit(false)
						} else {
							Saved := ForgotPswdMsg2.Submit(false)
						}
						IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
						IniWrite Saved.InputCode, TempSystemFile, "GeneralData", "InputCode"
						IniWrite Saved.Pswd, TempSystemFile, "GeneralData", "Pswd"
						DynamicReload2 := true
						IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
					}
					Sleep ControllerLoopInterval
				} ; End Registration General loop
			Return
			;----------------------------------------------------
	        ; UpdatePassword(*) ; Level 4
	        ;----------------------------------------------------
			UpdatePassword(*) {
				if EditPasswordStatus.Value != "Ok" or
				   EditEmailStatus.Value != "Ok" {
					; Fields Not Validated
					FieldsNotValidated()
					return
				}
				GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
				if GuiName2 == "ForgotPswdMsg1" {
					Saved := ForgotPswdMsg1.Submit(false)
				} else {
					Saved := ForgotPswdMsg2.Submit(false)
				}
		        Saved.Pswd := EncryptPsw(Saved.Pswd)
				QueryResult := UpdateUserPassword(Saved.Email,
											      Saved.Pswd)  
				if QueryResult == 0 {
					; Registration successful
					IniWrite LicenseKey, LicenseFile, "Data", "LicenseKey"
					WelcomeMessage()
					DynamicReload := true
					IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
					Reload
				}
				if QueryResult == 1 {
				    ; No internet connection
				    CheckConnectionMsg()
				}
			}
			;----------------------------------------------------
	        ; ForgotPswd_Close(*) ; Level 4
	        ;----------------------------------------------------
			ForgotPswd_Close(*) {
			    ExitMenu()
			}
			;----------------------------------------------------
	        ; SendValidationEmail(*) ; Level 4
	        ;----------------------------------------------------
			SendValidationEmail(*) {
				GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
				if GuiName2 == "ForgotPswdMsg1" {
					Saved := ForgotPswdMsg1.Submit(false)
				} else {
					Saved := ForgotPswdMsg2.Submit(false)
				}
				
				If Saved.Email == "" {
					InvalidEmailAddress()
					return
				}
				
				try {
				    validMail := RegExMatch(Saved.Email, "^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
				}
				catch {
				    validMail := false
				}
				
				if validMail == false {
					InvalidEmailAddress()
					return
				}
				
				SB.SetText("Validating mail..")
				MailExistInDatabase := ValidateMail(Saved.Email)
				if MailExistInDatabase == 1 {
					; No mail Found on database.
					MailNotRegistered()
					return
				}
				if MailExistInDatabase == 2 {
					; No internet Connection
					CheckConnectionMsg()
					return
				}
				MailValidationMessage(Saved.Email)
				IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
				FlagSentMail := true
				IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
				DynamicReload2 := true
				IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
			}
			;----------------------------------------------------
	        ; ValidateCode(*) ; Level 4
	        ;----------------------------------------------------
			ValidateCode(*) {
				GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
				if GuiName2 == "ForgotPswdMsg1" {
					Saved := ForgotPswdMsg1.Submit(false)
				} else {
					Saved := ForgotPswdMsg2.Submit(false)
				}
				if (ValidCode == Saved.InputCode) {
					EditEmailStatus.Value := "Ok"
				} else {
					EditEmailStatus.Value := "Mismatch"
				}
				FlagSentMail := false
				IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
				remainingTime := totalTime
				IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
				IniWrite Saved.InputCode, TempSystemFile, "GeneralData", "InputCode"
				IniWrite EditEmailStatus.Value, TempSystemFile, "GeneralData", "EmailStatus"
				IniWrite Saved.Pswd, TempSystemFile, "GeneralData", "Pswd"
				IniWrite EditPasswordStatus.Value, TempSystemFile, "GeneralData", "PasswordStatus"
				DynamicReload2 := true
				IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
			}
			;----------------------------------------------------
	        ; ValidatePassword(*) ; Level 4
	        ;----------------------------------------------------
			ValidatePassword(*) {
				if EditPassword.Value != EditReEnterPassword.Value {
					EditPasswordStatus.Value := "Mismatch"
				} else {
					EditPasswordStatus.Value := "Ok"
				}
				if StrLen(EditPassword.Value) < 8 {
				    EditPasswordStatus.Value := "8-characters min"
				}
				IniWrite EditPasswordStatus.Value, TempSystemFile, "GeneralData", "PasswordStatus"
			}
			;----------------------------------------------------
	        ; GoBackMenu(*) ; Level 4
	        ;----------------------------------------------------
			GoBackMenu(*) {
				; LoginOrRegister()
				LoginAccount()
				Destroy()
			}
			;----------------------------------------------------
	        ; Destroy(*) ; Level 4
	        ;----------------------------------------------------
			Destroy(*) {
			    GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
				if GuiName2 == "ForgotPswdMsg1" {
					try {
						ForgotPswdMsg1.Destroy()
					}
					catch {
					}	
				} else {
					try {
						ForgotPswdMsg2.Destroy()
					}
					catch {
					}	
				}
			}
		}
		;----------------------------------------------------
	    ; LoginMsg_Close(*) ; Level 3
	    ;----------------------------------------------------
		LoginMsg_Close(*) {
			ExitMenu()
		}
		;----------------------------------------------------
	    ; GoBackMenu(*) ; Level 3
	    ;----------------------------------------------------
		GoBackMenu(*) {
			LoginOrRegister()
			Destroy()
		}
		;----------------------------------------------------
	    ; Destroy(*) ; Level 3
	    ;----------------------------------------------------
		Destroy(*) {
            ; cant use Dynamic reload due to msg call to msg locks 
			; the app in a pause-like state
			Reload
		}
	}
	;----------------------------------------------------
	; RegisterAccount(*) ; Level 2
	;----------------------------------------------------
	RegisterAccount(*) {
		; Destroy LoginOrRegisterMsg Gui
		LogRegMsg.Destroy()
		RegisterMsg:
			DynamicReload2 := true
			GuiCount2 := 1
			GuiName2 := ""
			FlagSentMail := false
			IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
			IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
			IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
			IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
			;------------------------
			totalTime := 60000
			remainingTime := totalTime
			elapsed := 0
			;------------------------
			Email := ""
			ValidCode := ""
			InputCode := ""
			EmailStatus := ""
			Pswd := ""
			PasswordStatus := ""
			UserName := ""
			ReceiptIdGCR := ""
			MailSent := false
			IniWrite Email, TempSystemFile, "GeneralData", "Email"
			IniWrite ValidCode, TempSystemFile, "GeneralData", "ValidCode"
			IniWrite InputCode, TempSystemFile, "GeneralData", "InputCode"
			IniWrite EmailStatus, TempSystemFile, "GeneralData", "EmailStatus"
			IniWrite Pswd, TempSystemFile, "GeneralData", "Pswd"
			IniWrite PasswordStatus, TempSystemFile, "GeneralData", "PasswordStatus"
			IniWrite UserName, TempSystemFile, "GeneralData", "UserName"
			IniWrite ReceiptIdGCR, TempSystemFile, "GeneralData", "ReceiptIdGCR"
			;----------------------------------------------------
			; General Loop Start
			;----------------------------------------------------
			Loop {
				DynamicReload2 := IniRead(TempSystemFile, "GeneralData", "DynamicReload2")
				FlagSentMail := IniRead(TempSystemFile, "GeneralData", "FlagSentMail")
				try {
					Email := IniRead(TempSystemFile, "GeneralData", "Email")
					ValidCode := IniRead(TempSystemFile, "GeneralData", "ValidCode")
					ValidCode := DecryptMsg(ValidCode)
					InputCode := IniRead(TempSystemFile, "GeneralData", "InputCode")
					EmailStatus := IniRead(TempSystemFile, "GeneralData", "EmailStatus")
					Pswd := IniRead(TempSystemFile, "GeneralData", "Pswd")
					PasswordStatus := IniRead(TempSystemFile, "GeneralData", "PasswordStatus")
					UserName := IniRead(TempSystemFile, "GeneralData", "UserName")
					ReceiptIdGCR := IniRead(TempSystemFile, "GeneralData", "ReceiptIdGCR")
				}
				catch {
				}
				if DynamicReload2 == true {
					;----------------------------------------------------
					; GUI Properties
					;----------------------------------------------------
					if Mod(GuiCount2, 2) == 1 {
						;----------------------------------------------------
						; GUI 1 instance - Inside Dynamic Reload
						;----------------------------------------------------
						GuiName2 := "RegMsg1"
						IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
						if GuiPriorityAlwaysOnTop == true {
							RegMsg1 := Gui("+AlwaysOnTop")
						} else {
							RegMsg1 := Gui()
						}
						RegMsg1.BackColor := "0x" . BackgroundColor
						RegMsg1.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
						
						RegMsg1.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
						if ValidCode == "" {
						    ValidCode := Random(100000, 999999)
							IniWrite EncryptMsg(ValidCode), TempSystemFile, "GeneralData", "ValidCode"
						}
						RegMsg1.Add("Text", "x10 y10 w116 h20 +0x200", " Email: ")
						EditEmail := RegMsg1.Add("Edit", "vEmail x136 y10 w341 h20")
						EditEmail.Opt("" . BackgroundMainColor . "")
						EditEmail.Value := Email
						;------------------------
						if FlagSentMail == false {
							ogcButtonSendMail := RegMsg1.Add("Button", "x490 y10 w90 h20", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						} else {
							ogcButtonSendMail := RegMsg1.Add("Button", "x490 y10 w90 h20 +disabled", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						}
						;------------------------
						RegMsg1.Add("Text", "x10 y41 w116 h20 +0x200", " Email Code: ")
						EditInputCode := RegMsg1.Add("Edit", "vInputCode x136 y41 w90 h20")
						EditInputCode.Opt("" . BackgroundMainColor . "")
						EditInputCode.Value := InputCode
						;------------------------
						EditEmailStatus := RegMsg1.Add("Text", "x395 y41 +Center h20 +0x200", " Not validated ")
						if EmailStatus != "" {
						    EditEmailStatus.Value := EmailStatus
						}
						;------------------------
						ogcButtonValidateCode := RegMsg1.Add("Button", "x490 y41 w90 h20", "Validate Code")
						ogcButtonValidateCode.OnEvent("Click", ValidateCode)
						;------------------------
						RegMsg1.Add("Text", "x10 y71 w116 h20 +0x200", " Password: ")
						EditPassword := RegMsg1.Add("Edit", "vPswd x136 y71 w112 h20 +Limit16 +Password")
						EditPassword.Opt("" . BackgroundMainColor . "")
						EditPassword.Value := Pswd
						;------------------------
						EditReEnteredPsw := RegMsg1.Add("Text", "x10 y102 w116 h20 +0x200", " Re-enter Password: ")
						EditReEnterPassword := RegMsg1.Add("Edit", "vReEnterPassword x136 y102 w112 h20 +Limit16 +Password")
						EditReEnterPassword.Opt("" . BackgroundMainColor . "")
						if PasswordStatus == "Ok" {
						    EditReEnterPassword.Value := Pswd
						}
						;------------------------
						EditPasswordStatus := RegMsg1.Add("Text", "x395 y102 +Center h20 +0x200", " Not Validated ")
						EditPasswordStatus.Value := PasswordStatus
						;------------------------
						ogcButtonValidatePassword := RegMsg1.Add("Button", "x490 y102 w90 h20", "Validate")
						ogcButtonValidatePassword.OnEvent("Click", ValidatePassword)
						;------------------------
						RegMsg1.Add("Text", "x10 y133 w116 h20 +0x200", " User Name: ")
						EditUserName := RegMsg1.Add("Edit", "vUserName x136 y133 w250 h20")
						EditUserName.Opt("" . BackgroundMainColor . "")
						EditUserName.Value := UserName
						;------------------------
						RegMsg1.Add("Text", "x10 y164 w116 h20 +0x200", " Receipt Id: ")
						EditReceiptIdGCR := RegMsg1.Add("Edit", "vReceiptIdGCR x136 y164 w250 h20 ") ; add +Limit40 +Password
						EditReceiptIdGCR.Opt("" . BackgroundMainColor . "")
						EditReceiptIdGCR.Value := ReceiptIdGCR
						;------------------------
						ogcButtonRegister := RegMsg1.Add("Button", "x90 y199 w150 h24", "Register")
						ogcButtonRegister.OnEvent("Click", Register)
						;------------------------
						ogcButtonCancel := RegMsg1.Add("Button", "x355 y199 w150 h24", "Go Back")
						ogcButtonCancel.OnEvent("Click", GoBackMenu)
						RegMsg1.Title := "Register Account!"
						if GuiName == "ControllerRemapGui1" {
							ControllerRemapGui1.GetPos(&PosX, &PosY)
						} else {
							ControllerRemapGui2.GetPos(&PosX, &PosY)
						}
						RegMsg1.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
						SB_RegMsg := RegMsg1.Add("StatusBar", , "Ready.")
						RegMsg1.Show("x" . PosX - 225 . " y" . PosY + 120 . "w595 h260")
						
						ControlFocus("Button1", "Register")
						RegMsg1.Opt("+LastFound")
						RegMsg1.OnEvent("Close", RegMsg_Close)
					} else {
						;----------------------------------------------------
						; GUI 2 instance - Inside Dynamic Reload
						;----------------------------------------------------
						GuiName2 := "RegMsg2"
						IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
						if GuiPriorityAlwaysOnTop == true {
							RegMsg2 := Gui("+AlwaysOnTop")
						} else {
							RegMsg2 := Gui()
						}
						RegMsg2.BackColor := "0x" . BackgroundColor
						RegMsg2.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
						
						RegMsg2.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
						if ValidCode == "" {
						    ValidCode := Random(100000, 999999)
							IniWrite EncryptMsg(ValidCode), TempSystemFile, "GeneralData", "ValidCode"
						}
						RegMsg2.Add("Text", "x10 y10 w116 h20 +0x200", " Email: ")
						EditEmail := RegMsg2.Add("Edit", "vEmail x136 y10 w341 h20")
						EditEmail.Opt("" . BackgroundMainColor . "")
						EditEmail.Value := Email
						;------------------------
						if FlagSentMail == false {
							ogcButtonSendMail := RegMsg2.Add("Button", "x490 y10 w90 h20", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						} else {
							ogcButtonSendMail := RegMsg2.Add("Button", "x490 y10 w90 h20 +disabled", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						}
						;------------------------
						RegMsg2.Add("Text", "x10 y41 w116 h20 +0x200", " Email Code: ")
						EditInputCode := RegMsg2.Add("Edit", "vInputCode x136 y41 w90 h20")
						EditInputCode.Opt("" . BackgroundMainColor . "")
						EditInputCode.Value := InputCode
						;------------------------
						EditEmailStatus := RegMsg2.Add("Text", "x395 y41 +Center h20 +0x200", " Not validated ")
						if EmailStatus != "" {
						    EditEmailStatus.Value := EmailStatus
						}
						;------------------------
						ogcButtonValidateCode := RegMsg2.Add("Button", "x490 y41 w90 h20", "Validate Code")
						ogcButtonValidateCode.OnEvent("Click", ValidateCode)
						;------------------------
						RegMsg2.Add("Text", "x10 y71 w116 h20 +0x200", " Password: ")
						EditPassword := RegMsg2.Add("Edit", "vPswd x136 y71 w112 h20 +Limit16 +Password")
						EditPassword.Opt("" . BackgroundMainColor . "")
						EditPassword.Value := Pswd
						;------------------------
						EditReEnteredPsw := RegMsg2.Add("Text", "x10 y102 w116 h20 +0x200", " Re-enter Password: ")
						EditReEnterPassword := RegMsg2.Add("Edit", "vReEnterPassword x136 y102 w112 h20 +Limit16 +Password")
						EditReEnterPassword.Opt("" . BackgroundMainColor . "")
						if PasswordStatus == "Ok" {
						    EditReEnterPassword.Value := Pswd
						}
						;------------------------
						EditPasswordStatus := RegMsg2.Add("Text", "x395 y102 +Center h20 +0x200", " Not Validated ")
						EditPasswordStatus.Value := PasswordStatus
						;------------------------
						ogcButtonValidatePassword := RegMsg2.Add("Button", "x490 y102 w90 h20", "Validate")
						ogcButtonValidatePassword.OnEvent("Click", ValidatePassword)
						;------------------------
						RegMsg2.Add("Text", "x10 y133 w116 h20 +0x200", " User Name: ")
						EditUserName := RegMsg2.Add("Edit", "vUserName x136 y133 w250 h20")
						EditUserName.Opt("" . BackgroundMainColor . "")
						EditUserName.Value := UserName
						;------------------------
						RegMsg2.Add("Text", "x10 y164 w116 h20 +0x200", " Receipt Id: ")
						EditReceiptIdGCR := RegMsg2.Add("Edit", "vReceiptIdGCR x136 y164 w250 h20 ") ; add +Limit40 +Password
						EditReceiptIdGCR.Opt("" . BackgroundMainColor . "")
						EditReceiptIdGCR.Value := ReceiptIdGCR
						;------------------------
						ogcButtonRegister := RegMsg2.Add("Button", "x90 y199 w150 h24", "Register")
						ogcButtonRegister.OnEvent("Click", Register)
						;------------------------
						ogcButtonCancel := RegMsg2.Add("Button", "x355 y199 w150 h24", "Go Back")
						ogcButtonCancel.OnEvent("Click", GoBackMenu)
						RegMsg2.Title := "Register Account!"
						if GuiName == "ControllerRemapGui1" {
							ControllerRemapGui1.GetPos(&PosX, &PosY)
						} else {
							ControllerRemapGui2.GetPos(&PosX, &PosY)
						}
						RegMsg2.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
						SB_RegMsg := RegMsg2.Add("StatusBar", , "Ready.")
						RegMsg2.Show("x" . PosX - 225 . " y" . PosY + 120 . "w595 h260")
						
						ControlFocus("Button1", "Register")
						RegMsg2.Opt("+LastFound")
						RegMsg2.OnEvent("Close", RegMsg_Close)
					
					} 
					;----------------------------------------------------
					; Destroy previous Gui
					;----------------------------------------------------
					if GuiCount2 != 1 {
						if Mod(GuiCount2, 2) == 0 {
							RegMsg1.Destroy
						} else {
							RegMsg2.Destroy
						}
					}
					GuiCount2++
					IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
					
					SB.SetText("Awaiting registration..")
					;----------------------------------------------------
					; Set DynamicReload to false again
					;----------------------------------------------------
					DynamicReload2 := false
					IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
					;----------------------------------------------------
				} ; End DimamicReload2 / GUI Static code
				;----------------------------------------------------
				; Dynamic code starts here
				;----------------------------------------------------
				
				if FlagSentMail == true {
					elapsed += ControllerLoopInterval 
					remainingTime := round((totalTime - elapsed) / 1000)
					if (remainingTime <= 0) {
						remainingTime := 0
					}
					SB_RegMsg.SetText("Mail sent. Retry in " remainingTime " secs.")
					if MailSent == false {
					    SendMail(ValidCode, Email)
					    MailSent := true
					}
				}
				
				if remainingTime == 0 {
					remainingTime := totalTime
					elapsed := 0
					FlagSentMail := false
					MailSent := false
					IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
					; Save any other user input value too
					if GuiName2 == "RegMsg1" {
						Saved := RegMsg1.Submit(false)
					} else {
						Saved := RegMsg2.Submit(false)
					}
					IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
					IniWrite Saved.InputCode, TempSystemFile, "GeneralData", "InputCode"
					IniWrite Saved.Pswd, TempSystemFile, "GeneralData", "Pswd"
					IniWrite Saved.UserName, TempSystemFile, "GeneralData", "UserName"
					IniWrite Saved.ReceiptIdGCR, TempSystemFile, "GeneralData", "ReceiptIdGCR"
					DynamicReload2 := true
					IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
				}
				Sleep ControllerLoopInterval
			} ; End Registration General loop 
		Return
		;----------------------------------------------------
		; Register(*) ; Level 3
		;----------------------------------------------------
		Register(*) {
			; Destroy()
			if EditPasswordStatus.Value != "Ok" or
			   EditEmailStatus.Value != "Ok" {
				; Fields Not Validated
				FieldsNotValidated()
				return
			}
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "RegMsg1" {
				Saved := RegMsg1.Submit(false)
			} else {
				Saved := RegMsg2.Submit(false)
			}
			
			Lic_Amount_GCR := 3
			Date_GCR := A_Now
			Date_GCR := FormatTime(Date_GCR, "yyyy-MM-dd")
			MacAddress := GetMacAddress()
			Saved.Pswd := EncryptPsw(Saved.Pswd)
			QueryResult := RegisterUser(Saved.Email,
										Saved.Pswd, 
										Saved.UserName, 
										Saved.ReceiptIdGCR, 
										Lic_Amount_GCR, 
										Date_GCR, 
										MacAddress)  
			if QueryResult == 0 {
				; Registration successful
				IniWrite LicenseKey, LicenseFile, "Data", "LicenseKey"
				IniWrite Saved.UserName, LicenseFile, "Data", "UserName"
				; Standard License amount is 3
				IniWrite 3, LicenseFile, "Data", "LicenceAmount"
				; First device is always 1
				IniWrite 1, LicenseFile, "Data", "DeviceNumber"
				WelcomeMessage()
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
				Destroy()
			}
			
		}
		;----------------------------------------------------
		; RegMsg_Close(*) ; Level 3
		;----------------------------------------------------
		RegMsg_Close(*) {
			ExitMenu()
		}
		;----------------------------------------------------
		; SendValidationEmail(*) ; Level 3
		;----------------------------------------------------
		SendValidationEmail(*) {
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "RegMsg1" {
				Saved := RegMsg1.Submit(false)
			} else {
				Saved := RegMsg2.Submit(false)
			}
			
			If Saved.Email == "" {
				InvalidEmailAddress()
				return
			}
			
			try {
				validMail := RegExMatch(Saved.Email, "^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
			}
			catch {
				validMail := false
			}
			
			if validMail == false {
				InvalidEmailAddress()
				return
			}
			
			SB.SetText("Validating mail..")
			MailExistInDatabase := ValidateMail(Saved.Email)
			if MailExistInDatabase == 0 {
				MailAlreadyRegistered()
				LoginOrRegister()
				Destroy()
				return
			}
			if MailExistInDatabase == 2 {
				; No internet Connection
				CheckConnectionMsg()
				return
			}
			MailValidationMessage(Saved.Email)
			IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
			FlagSentMail := true
			IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
			DynamicReload2 := true
			IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
		}
		;----------------------------------------------------
		; ValidateCode(*) ; Level 3
		;----------------------------------------------------
		ValidateCode(*) {
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "RegMsg1" {
				Saved := RegMsg1.Submit(false)
			} else {
				Saved := RegMsg2.Submit(false)
			}
			if (ValidCode == Saved.InputCode) {
				EditEmailStatus.Value := "Ok"
			} else {
				EditEmailStatus.Value := "Mismatch"
			}
			FlagSentMail := false
			IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
			remainingTime := totalTime
			IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
			IniWrite Saved.InputCode, TempSystemFile, "GeneralData", "InputCode"
			IniWrite EditEmailStatus.Value, TempSystemFile, "GeneralData", "EmailStatus"
			IniWrite Saved.Pswd, TempSystemFile, "GeneralData", "Pswd"
			IniWrite EditPasswordStatus.Value, TempSystemFile, "GeneralData", "PasswordStatus"
			IniWrite Saved.UserName, TempSystemFile, "GeneralData", "UserName"
			IniWrite Saved.ReceiptIdGCR, TempSystemFile, "GeneralData", "ReceiptIdGCR"
			DynamicReload2 := true
			IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
		}
		;----------------------------------------------------
		; ValidatePassword(*) ; Level 3
		;----------------------------------------------------
		ValidatePassword(*) {
			if EditPassword.Value != EditReEnterPassword.Value {
				EditPasswordStatus.Value := "Mismatch"
			} else {
				EditPasswordStatus.Value := "Ok"
			}
			if StrLen(EditPassword.Value) < 8 {
				EditPasswordStatus.Value := "8-characters min"
			}
			IniWrite EditPasswordStatus.Value, TempSystemFile, "GeneralData", "PasswordStatus"
		}
		;----------------------------------------------------
		; GoBackMenu(*) ; Level 3
		;----------------------------------------------------
		GoBackMenu(*) {
			LoginOrRegister()
			Destroy()
		}
		;----------------------------------------------------
		; Destroy(*) ; Level 3
		;----------------------------------------------------
		Destroy(*) {
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "RegMsg1" {
				try {
					RegMsg1.Destroy()
				}
				catch {
				}	
			} else {
				try {
					RegMsg2.Destroy()
				}
				catch {
				}	
			}
            ; cant use Dynamic reload due to msg call to msg locks the app in a pause-like state
			Reload
		}
    }
	;----------------------------------------------------
	; LogRegMsg_Close(*) ; Level 2
	;----------------------------------------------------
	LogRegMsg_Close(*) {
		ExitMenu()
	}
	;----------------------------------------------------
	; ExitMenu(*) ; Level 2
	;----------------------------------------------------
	ExitMenu(*) {
		Destroy()
		ExitApp()
	}
	;----------------------------------------------------
	; Destroy(*) ; Level 2
	;----------------------------------------------------
	Destroy(*) {
		LogRegMsg.Destroy()
	}
}

;----------------------------------------------------
ManageDevices(Email, Pswd, MacAddress) {
    ShowMngDevicesMsg:
	    DynamicReload2 := true
		GuiCount2 := 1
		GuiName2 := ""
		FlagOverwriteDone := false
		CurrentDevice := ""
		IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
		IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
		IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
		IniWrite FlagOverwriteDone, TempSystemFile, "GeneralData", "FlagOverwriteDone"
		;------------------------
		; Connect Database
		;------------------------
		MySqlInst := DatabaseConnetion()
		;----------------------------------------------------
		; General Loop Start
		;----------------------------------------------------
		Loop {
			DynamicReload2 := IniRead(TempSystemFile, "GeneralData", "DynamicReload2")
			FlagOverwriteDone := IniRead(TempSystemFile, "GeneralData", "FlagOverwriteDone")
			if DynamicReload2 == true {
				;----------------------------------------------------
				; GUI Properties
				;----------------------------------------------------
				if Mod(GuiCount2, 2) == 1 {
					;----------------------------------------------------
					; GUI 1 instance - Inside Dynamic Reload
					;----------------------------------------------------
					GuiName2 := "MngDevicesMsg1"
					IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
					if GuiPriorityAlwaysOnTop == true {
						MngDevicesMsg1 := Gui("+AlwaysOnTop")
					} else {
						MngDevicesMsg1 := Gui()
					}
					;------------------------
					
					MngDevicesMsg1.BackColor := "0x" . BackgroundColor
					MngDevicesMsg1.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
					
					MngDevicesMsg1.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
					
					QueryResult := MySqlInst.Query("SELECT * FROM customers WHERE Email='" Email "' AND Password='" Pswd "'")
					row := 0
					UserDevices.CurrentMacAddress := MacAddress
					switch true {
					case QueryResult == 0:
						ResultSet := MySqlInst.GetResult()
						for k, v in ResultSet.Rows {
							; Process each row (Will always be a unique row for costumers table)
							UserDevices.Customer_Id := v["Customer_Id"]
						}
						;------------------------
						; Verify
						QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Customer_Id='" UserDevices.Customer_Id "'" )
						if QueryResult == 0 {
							ResultSet := MySqlInst.GetResult()
							for k, v in ResultSet.Rows {
								; Process each row
								row++
								try {
								    UserDevices.DeviceNumber[row] := v["Device_Number"]
									UserDevices.StoredMacAddress[row] := v["Mac_Address"]
								}
								catch {
								    UserDevices.DeviceNumber.Push v["Device_Number"]
								    UserDevices.StoredMacAddress.Push v["Mac_Address"]
								}
								if MacAddress == v["Mac_Address"] {
								    CurrentDevice := v["Device_Number"]
								}
							}
						}
						QueryResult := MySqlInst.Query("SELECT * FROM billing_gcr WHERE Customer_Id='" UserDevices.Customer_Id "'" )
						if QueryResult == 0 {
							ResultSet := MySqlInst.GetResult()
							for k, v in ResultSet.Rows {
								; Process each row (Will always be a unique row for billing_gcr table)
								Lic_Amount_GCR := v["Lic_Amount_GCR"]
							}
						}
					}
					;------------------------
					if CurrentDevice == "" {
					    MngDevicesMsg1.Add("Text", "x50 y10 +Center w400 h20 +0x200", "Current device is not assigned")
					} else {
					    MngDevicesMsg1.Add("Text", "x50 y10 +Center w400 h20 +0x200", "Current device assigned number is " . CurrentDevice)
					}
					;------------------------
					MngDevicesMsg1.Add("Text", "x50 y45 +Center w400 h20 +0x200", "Your GCR License Amount allows up to " . Lic_Amount_GCR . " devices.")
					MngDevicesMsg1.Add("Text", "x5 y80 +Center w490 h20 +0x200", "Overwrite an old device or extend your license amount if your device is unassigned.")
					
					ogcButtonExtend := MngDevicesMsg1.Add("Button", "x175 y115 +Center w150 h20 +0x200", "Extend License Amount")
					ogcButtonExtend.OnEvent("Click", ExtendLicenseAmount)
					;------------------------
					MngDevicesMsg1.Add("Text", "x50 y150 +Center w400 h20 +0x200", "User Devices for Game Controller Remap")
					;------------------------
					MngDevicesMsg1.Add("Text", "x30 y185 +Center w60 h20 +0x200", "Device#")
					MngDevicesMsg1.Add("Text", "x120 y185 +Center w120 h20 +0x200", "Mac Address")
					MngDevicesMsg1.Add("Text", "x270 y185 +Center w80 h20 +0x200", "Overwrite")
					MngDevicesMsg1.Add("Text", "x380 y185 +Center w80 h20 +0x200", "Delete")
					;------------------------
					MngDevicesMsg1.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
					
					if row > 0 {
						switch true {
						case CurrentDevice == 1:
						    MngDevicesMsg1.Add("Text", "x30 y220 +Center w60 h20 +0x200", UserDevices.DeviceNumber[1])
							MngDevicesMsg1.Add("Text", "x120 y220 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[1])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y220 +Center w80 h20 +0x200 +disabled", "Overwrite #1")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y220 +Center w80 h20 +0x200 +disabled", "Delete #1")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						case CurrentDevice != "":
						    MngDevicesMsg1.Add("Text", "x30 y220 +Center w60 h20 +0x200", UserDevices.DeviceNumber[1])
							MngDevicesMsg1.Add("Text", "x120 y220 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[1])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y220 +Center w80 h20 +0x200 +disabled", "Overwrite #1")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y220 +Center w80 h20 +0x200", "Delete #1")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						default:
						    MngDevicesMsg1.Add("Text", "x30 y220 +Center w60 h20 +0x200", UserDevices.DeviceNumber[1])
							MngDevicesMsg1.Add("Text", "x120 y220 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[1])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y220 +Center w80 h20 +0x200", "Overwrite #1")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y220 +Center w80 h20 +0x200", "Delete #1")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						}
					}
					;------------------------
					if row > 1 {
						switch true {
						case CurrentDevice == 2:
						    MngDevicesMsg1.Add("Text", "x30 y255 +Center w60 h20 +0x200", UserDevices.DeviceNumber[2])
							MngDevicesMsg1.Add("Text", "x120 y255 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[2])
							ogcButtonOverwrite2 := MngDevicesMsg1.Add("Button", "x270 y255 +Center w80 h20 +0x200 +disabled", "Overwrite #2")
							ogcButtonOverwrite2.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete2 := MngDevicesMsg1.Add("Button", "x380 y255 +Center w80 h20 +0x200 +disabled", "Delete #2")
							ogcButtonDelete2.OnEvent("Click", DeleteDevice)
						case CurrentDevice != "":
						    MngDevicesMsg1.Add("Text", "x30 y255 +Center w60 h20 +0x200", UserDevices.DeviceNumber[2])
							MngDevicesMsg1.Add("Text", "x120 y255 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[2])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y255 +Center w80 h20 +0x200 +disabled", "Overwrite #2")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y255 +Center w80 h20 +0x200", "Delete #2")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						default:
						    MngDevicesMsg1.Add("Text", "x30 y255 +Center w60 h20 +0x200", UserDevices.DeviceNumber[2])
							MngDevicesMsg1.Add("Text", "x120 y255 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[2])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y255 +Center w80 h20 +0x200", "Overwrite #2")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y255 +Center w80 h20 +0x200", "Delete #2")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						}
					}
					;------------------------
					if row > 2 {
					    switch true {
						case CurrentDevice == 3:
						    MngDevicesMsg1.Add("Text", "x30 y290 +Center w60 h20 +0x200", UserDevices.DeviceNumber[3])
							MngDevicesMsg1.Add("Text", "x120 y290 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[3])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y290 +Center w80 h20 +0x200 +disabled", "Overwrite #3")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y290 +Center w80 h20 +0x200 +disabled", "Delete #3")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						case CurrentDevice != "":
						    MngDevicesMsg1.Add("Text", "x30 y290 +Center w60 h20 +0x200", UserDevices.DeviceNumber[3])
							MngDevicesMsg1.Add("Text", "x120 y290 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[3])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y290 +Center w80 h20 +0x200 +disabled", "Overwrite #3")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y290 +Center w80 h20 +0x200", "Delete #3")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						default:
						    MngDevicesMsg1.Add("Text", "x30 y290 +Center w60 h20 +0x200", UserDevices.DeviceNumber[3])
							MngDevicesMsg1.Add("Text", "x120 y290 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[3])
							ogcButtonOverwrite1 := MngDevicesMsg1.Add("Button", "x270 y290 +Center w80 h20 +0x200", "Overwrite #3")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg1.Add("Button", "x380 y290 +Center w80 h20 +0x200", "Delete #3")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						}
					}
					;------------------------
					MngDevicesMsg1.Title := "Manage Devices"
					if GuiName == "ControllerRemapGui1" {
						ControllerRemapGui1.GetPos(&PosX, &PosY)
					} else {
						ControllerRemapGui2.GetPos(&PosX, &PosY)
					}
					MngDevicesMsg1.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
					SB_MngDevicesMsg := MngDevicesMsg1.Add("StatusBar", , "Ready.")
					
					height := 185 + row * 35 + 60
					
					MngDevicesMsg1.Show("x" . PosX - 160 . " y" . PosY + 120 . "w500 h" . height)
					MngDevicesMsg1.Opt("+LastFound")
					MngDevicesMsg1.OnEvent("Close", MngDevicesMsg_Close)
				} else {
				    ;----------------------------------------------------
					; GUI 2 instance - Inside Dynamic Reload
					;----------------------------------------------------
					GuiName2 := "MngDevicesMsg2"
					IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
					if GuiPriorityAlwaysOnTop == true {
						MngDevicesMsg2 := Gui("+AlwaysOnTop")
					} else {
						MngDevicesMsg2 := Gui()
					}
					;------------------------
					
					MngDevicesMsg2.BackColor := "0x" . BackgroundColor
					MngDevicesMsg2.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
					
					MngDevicesMsg2.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
					
					QueryResult := MySqlInst.Query("SELECT * FROM customers WHERE Email='" Email "' AND Password='" Pswd "'")
					row := 0
					UserDevices.CurrentMacAddress := MacAddress
					switch true {
					case QueryResult == 0:
						ResultSet := MySqlInst.GetResult()
						for k, v in ResultSet.Rows {
							; Process each row (Will always be a unique row for costumers table)
							UserDevices.Customer_Id := v["Customer_Id"]
						}
						;------------------------
						; Verify
						QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Customer_Id='" UserDevices.Customer_Id "'" )
						if QueryResult == 0 {
							ResultSet := MySqlInst.GetResult()
							for k, v in ResultSet.Rows {
								; Process each row
								row++
								try {
								    UserDevices.DeviceNumber[row] := v["Device_Number"]
									UserDevices.StoredMacAddress[row] := v["Mac_Address"]
								}
								catch {
								    UserDevices.DeviceNumber.Push v["Device_Number"]
								    UserDevices.StoredMacAddress.Push v["Mac_Address"]
								}
								if MacAddress == v["Mac_Address"] {
								    CurrentDevice := v["Device_Number"]
								}
							}
						}
						QueryResult := MySqlInst.Query("SELECT * FROM billing_gcr WHERE Customer_Id='" UserDevices.Customer_Id "'" )
						if QueryResult == 0 {
							ResultSet := MySqlInst.GetResult()
							for k, v in ResultSet.Rows {
								; Process each row (Will always be a unique row for billing_gcr table)
								Lic_Amount_GCR := v["Lic_Amount_GCR"]
							}
						}
					}
					;------------------------
					if CurrentDevice == "" {
					    MngDevicesMsg2.Add("Text", "x50 y10 +Center w400 h20 +0x200", "Current device is not assigned")
					} else {
					    MngDevicesMsg2.Add("Text", "x50 y10 +Center w400 h20 +0x200", "Current device assigned number is " . CurrentDevice)
					}
					;------------------------
					MngDevicesMsg2.Add("Text", "x50 y45 +Center w400 h20 +0x200", "Your GCR License Amount allows up to " . Lic_Amount_GCR . " devices.")
					MngDevicesMsg2.Add("Text", "x5 y80 +Center w490 h20 +0x200", "Overwrite an old device or extend your license amount if your device is unassigned.")
					
					ogcButtonExtend := MngDevicesMsg2.Add("Button", "x175 y115 +Center w150 h20 +0x200", "Extend License Amount")
					ogcButtonExtend.OnEvent("Click", ExtendLicenseAmount)
					;------------------------
					MngDevicesMsg2.Add("Text", "x50 y150 +Center w400 h20 +0x200", "User Devices for Game Controller Remap")
					;------------------------
					MngDevicesMsg2.Add("Text", "x30 y185 +Center w60 h20 +0x200", "Device#")
					MngDevicesMsg2.Add("Text", "x120 y185 +Center w120 h20 +0x200", "Mac Address")
					MngDevicesMsg2.Add("Text", "x270 y185 +Center w80 h20 +0x200", "Overwrite")
					MngDevicesMsg2.Add("Text", "x380 y185 +Center w80 h20 +0x200", "Delete")
					;------------------------
					MngDevicesMsg2.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)

					if row > 0 {
						switch true {
						case CurrentDevice == 1:
						    MngDevicesMsg2.Add("Text", "x30 y220 +Center w60 h20 +0x200", UserDevices.DeviceNumber[1])
							MngDevicesMsg2.Add("Text", "x120 y220 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[1])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y220 +Center w80 h20 +0x200 +disabled", "Overwrite #1")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y220 +Center w80 h20 +0x200 +disabled", "Delete #1")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						case CurrentDevice != "":
						    MngDevicesMsg2.Add("Text", "x30 y220 +Center w60 h20 +0x200", UserDevices.DeviceNumber[1])
							MngDevicesMsg2.Add("Text", "x120 y220 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[1])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y220 +Center w80 h20 +0x200 +disabled", "Overwrite #1")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y220 +Center w80 h20 +0x200", "Delete #1")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						default:
						    MngDevicesMsg2.Add("Text", "x30 y220 +Center w60 h20 +0x200", UserDevices.DeviceNumber[1])
							MngDevicesMsg2.Add("Text", "x120 y220 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[1])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y220 +Center w80 h20 +0x200", "Overwrite #1")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y220 +Center w80 h20 +0x200", "Delete #1")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						}
					}
					;------------------------
					if row > 1 {
						switch true {
						case CurrentDevice == 2:
						    MngDevicesMsg2.Add("Text", "x30 y255 +Center w60 h20 +0x200", UserDevices.DeviceNumber[2])
							MngDevicesMsg2.Add("Text", "x120 y255 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[2])
							ogcButtonOverwrite2 := MngDevicesMsg2.Add("Button", "x270 y255 +Center w80 h20 +0x200 +disabled", "Overwrite #2")
							ogcButtonOverwrite2.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete2 := MngDevicesMsg2.Add("Button", "x380 y255 +Center w80 h20 +0x200 +disabled", "Delete #2")
							ogcButtonDelete2.OnEvent("Click", DeleteDevice)
						case CurrentDevice != "":
						    MngDevicesMsg2.Add("Text", "x30 y255 +Center w60 h20 +0x200", UserDevices.DeviceNumber[2])
							MngDevicesMsg2.Add("Text", "x120 y255 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[2])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y255 +Center w80 h20 +0x200 +disabled", "Overwrite #2")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y255 +Center w80 h20 +0x200", "Delete #2")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						default:
						    MngDevicesMsg2.Add("Text", "x30 y255 +Center w60 h20 +0x200", UserDevices.DeviceNumber[2])
							MngDevicesMsg2.Add("Text", "x120 y255 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[2])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y255 +Center w80 h20 +0x200", "Overwrite #2")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y255 +Center w80 h20 +0x200", "Delete #2")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						}
					}
					;------------------------
					if row > 2 {
					    switch true {
						case CurrentDevice == 3:
						    MngDevicesMsg2.Add("Text", "x30 y290 +Center w60 h20 +0x200", UserDevices.DeviceNumber[3])
							MngDevicesMsg2.Add("Text", "x120 y290 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[3])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y290 +Center w80 h20 +0x200 +disabled", "Overwrite #3")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y290 +Center w80 h20 +0x200 +disabled", "Delete #3")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						case CurrentDevice != "":
						    MngDevicesMsg2.Add("Text", "x30 y290 +Center w60 h20 +0x200", UserDevices.DeviceNumber[3])
							MngDevicesMsg2.Add("Text", "x120 y290 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[3])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y290 +Center w80 h20 +0x200 +disabled", "Overwrite #3")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y290 +Center w80 h20 +0x200", "Delete #3")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						default:
						    MngDevicesMsg2.Add("Text", "x30 y290 +Center w60 h20 +0x200", UserDevices.DeviceNumber[3])
							MngDevicesMsg2.Add("Text", "x120 y290 +Center w120 h20 +0x200", UserDevices.StoredMacAddress[3])
							ogcButtonOverwrite1 := MngDevicesMsg2.Add("Button", "x270 y290 +Center w80 h20 +0x200", "Overwrite #3")
							ogcButtonOverwrite1.OnEvent("Click", OverwriteDevice)
							ogcButtonDelete1 := MngDevicesMsg2.Add("Button", "x380 y290 +Center w80 h20 +0x200", "Delete #3")
							ogcButtonDelete1.OnEvent("Click", DeleteDevice)
						}
					}
					;------------------------
					MngDevicesMsg2.Title := "Manage Devices"
					if GuiName == "ControllerRemapGui1" {
						ControllerRemapGui1.GetPos(&PosX, &PosY)
					} else {
						ControllerRemapGui2.GetPos(&PosX, &PosY)
					}
					MngDevicesMsg2.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
					SB_MngDevicesMsg := MngDevicesMsg2.Add("StatusBar", , "Ready.")
					
					height := 185 + row * 35 + 60
					
					MngDevicesMsg2.Show("x" . PosX - 160 . " y" . PosY + 120 . "w500 h" . height)
					; ControlFocus("Button1", "Login")
					MngDevicesMsg2.Opt("+LastFound")
					MngDevicesMsg2.OnEvent("Close", MngDevicesMsg_Close)
				}
				;----------------------------------------------------
				; Destroy previous Gui
				;----------------------------------------------------
				if GuiCount2 != 1 {
					if Mod(GuiCount2, 2) == 0 {
						MngDevicesMsg1.Destroy
					} else {
						MngDevicesMsg2.Destroy
					}
				}
				GuiCount2++
				IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
				if FlagOverwriteDone != true {
				    SB_MngDevicesMsg.SetText("Overwrite old device or expand license amount to continue.")
				} else {
				    SB_MngDevicesMsg.SetText("All set. You can close this window.")
				}
				;----------------------------------------------------
				; Set DynamicReload to false again
				;----------------------------------------------------
				DynamicReload2 := false
				IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
				;----------------------------------------------------
			} ; End Dynamic Reload
			;----------------------------------------------------
			; Dynamic code starts here
			;----------------------------------------------------
			
			Sleep ControllerLoopInterval
		} ; End Manage User Devices General loop
	Return
		
	OverwriteDevice(GuiCtrlObj, Info) {
	    ; Overwrite Mac address
		SB_MngDevicesMsg.SetText("Updating..")
		switch true {
		case GuiCtrlObj.text == "Overwrite #1":
			QueryResult := MySqlInst.Query("UPDATE gcr_mac SET Mac_Address='" UserDevices.CurrentMacAddress "' WHERE Customer_Id='" UserDevices.Customer_Id "' AND Device_Number='" UserDevices.DeviceNumber[1] "'")	
		case GuiCtrlObj.text == "Overwrite #2":
		    QueryResult := MySqlInst.Query("UPDATE gcr_mac SET Mac_Address='" UserDevices.CurrentMacAddress "' WHERE Customer_Id='" UserDevices.Customer_Id "' AND Device_Number='" UserDevices.DeviceNumber[2] "'")
		case GuiCtrlObj.text == "Overwrite #3":
		    QueryResult := MySqlInst.Query("UPDATE gcr_mac SET Mac_Address='" UserDevices.CurrentMacAddress "' WHERE Customer_Id='" UserDevices.Customer_Id "' AND Device_Number='" UserDevices.DeviceNumber[3] "'")
		}
		; You are all set message.
		WelcomeMessage()
		reload
		FlagOverwriteDone := true
		IniWrite FlagOverwriteDone, TempSystemFile, "GeneralData", "FlagOverwriteDone"
        DynamicReload2 := true
		IniWrite true, TempSystemFile, "GeneralData", "DynamicReload2"
	}
	
	DeleteDevice(GuiCtrlObj, Info) {
	    ; Delete Mac address
		SB_MngDevicesMsg.SetText("Updating..")
		switch true {
		case GuiCtrlObj.text == "Delete #1":
			QueryResult := MySqlInst.Query("UPDATE gcr_mac SET Mac_Address='' WHERE Customer_Id='" UserDevices.Customer_Id "' AND Device_Number='" UserDevices.DeviceNumber[1] "'")	
		case GuiCtrlObj.text == "Delete #2":
		    QueryResult := MySqlInst.Query("UPDATE gcr_mac SET Mac_Address='' WHERE Customer_Id='" UserDevices.Customer_Id "' AND Device_Number='" UserDevices.DeviceNumber[2] "'")
		case GuiCtrlObj.text == "Delete #3":
		    QueryResult := MySqlInst.Query("UPDATE gcr_mac SET Mac_Address='' WHERE Customer_Id='" UserDevices.Customer_Id "' AND Device_Number='" UserDevices.DeviceNumber[3] "'")
		}
		DynamicReload2 := true
		IniWrite true, TempSystemFile, "GeneralData", "DynamicReload2"
	}
	
	ExtendLicenseAmount(*) {
	    ; Extend License Amount
	}
	
	MngDevicesMsg_Close(*) {
	    Reload
	}
}
;----------------------------------------------------
MenuManageDevices(*) {
	ShowMenuManageDevicesMsg:
		if GuiPriorityAlwaysOnTop == true {
			ManageDevicesMsg := Gui("+AlwaysOnTop")
		} else {
			ManageDevicesMsg := Gui()
		}
		;------------------------
		ManageDevicesMsg.BackColor := "0x" . BackgroundColor
		ManageDevicesMsg.Add("Picture", "x0 y0 w500 h440", ImageLib . DefaultMsgBackgroundImage)
		
		ManageDevicesMsg.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)

        ManageDevicesMsg.Add("Text", "x50 y10 +Center w400 h20 +0x200", "Verify your credentials to access Manage Devices Menu")
		ManageDevicesMsg.Add("Text", "x10 y45 w116 h20 +0x200", " Email: ")
		EditEmail := ManageDevicesMsg.Add("Edit", "vEmail x136 y45 w351 h20")
		EditEmail.Opt("" . BackgroundMainColor . "")
		;------------------------
		ManageDevicesMsg.Add("Text", "x10 y80 w116 h20 +0x200", " Password: ")
		EditPassword := ManageDevicesMsg.Add("Edit", "vPswd x136 y80 w112 h20 +Limit16 +Password")
		EditPassword.Opt("" . BackgroundMainColor . "")
		;------------------------
		ManageDevicesMsg.SetFont("s8 " . MessageMainMsgFontColor, MessageMainMsgFontType)
		ogcButtonManDev := ManageDevicesMsg.Add("Button", "x150 y115 w200 h24", "Access Manage Devices Menu")
		ogcButtonManDev.OnEvent("Click", ManageDevicesMenu)
		;------------------------
		ogcButtonForgotPswd := ManageDevicesMsg.Add("Button", "x190 y150 w120 h24", "Forgot Password")
		ogcButtonForgotPswd.OnEvent("Click", MenuManageDevForgotPswd)
		
		ManageDevicesMsg.Title := "Verify Credentials"
		if GuiName == "ControllerRemapGui1" {
			ControllerRemapGui1.GetPos(&PosX, &PosY)
		} else {
			ControllerRemapGui2.GetPos(&PosX, &PosY)
		}
		ManageDevicesMsg.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
		SB_RegMsg := ManageDevicesMsg.Add("StatusBar", , "Ready.")
		ManageDevicesMsg.Show("x" . PosX - 160 . " y" . PosY + 120 . "w500 h205")
		
		ControlFocus("Button1", "Verify Credentials")
		ManageDevicesMsg.Opt("+LastFound")
		Pause true
	Return
	;----------------------------------------------------
	; MenuManageDevices(*) ; Level 1
	;----------------------------------------------------
	ManageDevicesMenu(*) {
		Saved := ManageDevicesMsg.Submit(false)

		if Saved.Email == "" {
			InvalidEmailAddress()
			return
		}
		
		try {
			validMail := RegExMatch(Saved.Email, "^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
		}
		catch {
			validMail := false
		}
		
		if validMail == false {
			InvalidEmailAddress()
			return
		}
		
		if StrLen(Saved.Pswd) < 8 {
			; Password is too short
			PasswordTooShort()
			return
		}
		SB.SetText("Validating User..")
		MacAddress := GetMacAddress()
		Saved.Pswd := EncryptPsw(Saved.Pswd)
		; Dummy data
		ReceiptIdGCR := ""
		Lic_Amount_GCR := 3
		Date_GCR := A_Now
		Date_GCR := FormatTime(Date_GCR, "yyyy-MM-dd")
		
		UserCredentials := ValidateUser(Saved.Email,
		                                Saved.Pswd,
										MacAddress,
										; Saved.ReceiptIdGCR,
										ReceiptIdGCR,
										Lic_Amount_GCR,
										Date_GCR)
		
		switch true {
		case CheckConnection() != true:
			; No connection.
			CheckConnectionMsg()
		case UserCredentials == 0 or UserCredentials == 2:
			; credentials validated 
			ManageDevicesMsg.Destroy()
			Pause false
			ManageDevices(Saved.Email, Saved.Pswd, MacAddress)
		case UserCredentials == 1:
			; Wrong credentials
			CheckEmailAndPassword()
		} 
	}
	
	;----------------------------------------------------
	MenuManageDevForgotPswd(*) {
		ManageDevicesMsg.Destroy()
		ShowManageDevForgotPswdMsg:
			DynamicReload2 := true
			GuiCount2 := 1
			GuiName2 := ""
			FlagSentMail := false
			IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
			IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
			IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
			IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
			;------------------------
			totalTime := 60000
			remainingTime := totalTime
			elapsed := 0
			;------------------------
			Email := ""
			ValidCode := ""
			InputCode := ""
			EmailStatus := ""
			Pswd := ""
			PasswordStatus := ""
			IniWrite Email, TempSystemFile, "GeneralData", "Email"
			IniWrite ValidCode, TempSystemFile, "GeneralData", "ValidCode"
			IniWrite InputCode, TempSystemFile, "GeneralData", "InputCode"
			IniWrite EmailStatus, TempSystemFile, "GeneralData", "EmailStatus"
			IniWrite Pswd, TempSystemFile, "GeneralData", "Pswd"
			IniWrite PasswordStatus, TempSystemFile, "GeneralData", "PasswordStatus"
			
			MailSent := false
			;----------------------------------------------------
			; General Loop Start
			;----------------------------------------------------
			Loop {
				DynamicReload2 := IniRead(TempSystemFile, "GeneralData", "DynamicReload2")
				FlagSentMail := IniRead(TempSystemFile, "GeneralData", "FlagSentMail")
				try {
					Email := IniRead(TempSystemFile, "GeneralData", "Email")
					ValidCode := IniRead(TempSystemFile, "GeneralData", "ValidCode")
					ValidCode := DecryptMsg(ValidCode)
					InputCode := IniRead(TempSystemFile, "GeneralData", "InputCode")
					EmailStatus := IniRead(TempSystemFile, "GeneralData", "EmailStatus")
					Pswd := IniRead(TempSystemFile, "GeneralData", "Pswd")
					PasswordStatus := IniRead(TempSystemFile, "GeneralData", "PasswordStatus")
				}
				catch {
				}
				if DynamicReload2 == true {
					;----------------------------------------------------
					; GUI Properties
					;----------------------------------------------------
					if Mod(GuiCount2, 2) == 1 {
						;----------------------------------------------------
						; GUI 1 instance - Inside Dynamic Reload
						;----------------------------------------------------
						GuiName2 := "ManageDevForgotPswdMsg1"
						IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
						if GuiPriorityAlwaysOnTop == true {
							ManageDevForgotPswdMsg1 := Gui("+AlwaysOnTop")
						} else {
							ManageDevForgotPswdMsg1 := Gui()
						}
						ManageDevForgotPswdMsg1.BackColor := "0x" . BackgroundColor
						ManageDevForgotPswdMsg1.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
						
						ManageDevForgotPswdMsg1.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
						if ValidCode == "" {
							ValidCode := Random(100000, 999999)
							IniWrite EncryptMsg(ValidCode), TempSystemFile, "GeneralData", "ValidCode"
						}
						ManageDevForgotPswdMsg1.Add("Text", "x10 y10 w116 h20 +0x200", " Email: ")
						EditEmail := ManageDevForgotPswdMsg1.Add("Edit", "vEmail x136 y10 w341 h20")
						EditEmail.Opt("" . BackgroundMainColor . "")
						EditEmail.Value := Email
						;------------------------
						if FlagSentMail == false {
							ogcButtonSendMail := ManageDevForgotPswdMsg1.Add("Button", "x490 y10 w90 h20", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						} else {
							ogcButtonSendMail := ManageDevForgotPswdMsg1.Add("Button", "x490 y10 w90 h20 +disabled", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						}
						;------------------------
						ManageDevForgotPswdMsg1.Add("Text", "x10 y41 w116 h20 +0x200", " Email Code: ")
						EditInputCode := ManageDevForgotPswdMsg1.Add("Edit", "vInputCode x136 y41 w90 h20")
						EditInputCode.Opt("" . BackgroundMainColor . "")
						EditInputCode.Value := InputCode
						;------------------------
						EditEmailStatus := ManageDevForgotPswdMsg1.Add("Text", "x365 y41 +Center w112 h20 +0x200", "Not Validated")
						if EmailStatus != "" {
							EditEmailStatus.Value := EmailStatus
						}
						;------------------------
						ogcButtonValidateCode := ManageDevForgotPswdMsg1.Add("Button", "x490 y41 w90 h20", "Validate Code")
						ogcButtonValidateCode.OnEvent("Click", ValidateCode)
						;------------------------
						ManageDevForgotPswdMsg1.Add("Text", "x10 y71 w116 h20 +0x200", " Password: ")
						EditPassword := ManageDevForgotPswdMsg1.Add("Edit", "vPswd x136 y71 w112 h20 +Limit16 +Password")
						EditPassword.Opt("" . BackgroundMainColor . "")
						EditPassword.Value := Pswd
						;------------------------
						EditReEnteredPsw := ManageDevForgotPswdMsg1.Add("Text", "x10 y102 w116 h20 +0x200", " Re-enter Password: ")
						EditReEnterPassword := ManageDevForgotPswdMsg1.Add("Edit", "vReEnterPassword x136 y102 w112 h20 +Limit16 +Password")
						EditReEnterPassword.Opt("" . BackgroundMainColor . "")
						if PasswordStatus == "Ok" {
							EditReEnterPassword.Value := Pswd
						}
						;------------------------
						EditPasswordStatus := ManageDevForgotPswdMsg1.Add("Text", "x365 y102 +Center w112 h20 +0x200", "Not Validated")
						if PasswordStatus != "" {
							EditPasswordStatus.Value := PasswordStatus
						}
						;------------------------
						ogcButtonValidatePassword := ManageDevForgotPswdMsg1.Add("Button", "x490 y102 w90 h20", "Validate")
						ogcButtonValidatePassword.OnEvent("Click", ValidatePassword)
						;------------------------
						ogcButtonRegister := ManageDevForgotPswdMsg1.Add("Button", "x90 y199 w150 h24", "Update Password")
						ogcButtonRegister.OnEvent("Click", UpdatePassword)
						;------------------------
						ogcButtonCancel := ManageDevForgotPswdMsg1.Add("Button", "x355 y199 w150 h24", "Go Back")
						ogcButtonCancel.OnEvent("Click", GoBackMenu)
						ManageDevForgotPswdMsg1.Title := "Forgot Password"
						if GuiName == "ControllerRemapGui1" {
							ControllerRemapGui1.GetPos(&PosX, &PosY)
						} else {
							ControllerRemapGui2.GetPos(&PosX, &PosY)
						}
						ManageDevForgotPswdMsg1.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
						SB_RegMsg := ManageDevForgotPswdMsg1.Add("StatusBar", , "Ready.")
						ManageDevForgotPswdMsg1.Show("x" . PosX - 225 . " y" . PosY + 120 . "w595 h260")
						
						ControlFocus("Button1", "Forgot Password")
						ManageDevForgotPswdMsg1.Opt("+LastFound")
						; ManageDevForgotPswdMsg1.OnEvent("Close", ForgotPswd_Close)
					} else {
						;----------------------------------------------------
						; GUI 2 instance - Inside Dynamic Reload
						;----------------------------------------------------
						GuiName2 := "ManageDevForgotPswdMsg2"
						IniWrite GuiName2, TempSystemFile, "GeneralData", "GuiName2"
						if GuiPriorityAlwaysOnTop == true {
							ManageDevForgotPswdMsg2 := Gui("+AlwaysOnTop")
						} else {
							ManageDevForgotPswdMsg2 := Gui()
						}
						ManageDevForgotPswdMsg2.BackColor := "0x" . BackgroundColor
						ManageDevForgotPswdMsg2.Add("Picture", "x0 y0 w595 h440", ImageLib . DefaultMsgBackgroundImage)
						
						ManageDevForgotPswdMsg2.SetFont("s8 Bold " . MessageMainMsgFontColor, MessageMainMsgFontType)
						if ValidCode == "" {
							ValidCode := Random(100000, 999999)
							IniWrite EncryptMsg(ValidCode), TempSystemFile, "GeneralData", "ValidCode"
						}
						ManageDevForgotPswdMsg2.Add("Text", "x10 y10 w116 h20 +0x200", " Email: ")
						EditEmail := ManageDevForgotPswdMsg2.Add("Edit", "vEmail x136 y10 w341 h20")
						EditEmail.Opt("" . BackgroundMainColor . "")
						EditEmail.Value := Email
						;------------------------
						if FlagSentMail == false {
							ogcButtonSendMail := ManageDevForgotPswdMsg2.Add("Button", "x490 y10 w90 h20", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						} else {
							ogcButtonSendMail := ManageDevForgotPswdMsg2.Add("Button", "x490 y10 w90 h20 +disabled", "Send Mail")
							ogcButtonSendMail.OnEvent("Click", SendValidationEmail)
						}
						;------------------------
						ManageDevForgotPswdMsg2.Add("Text", "x10 y41 w116 h20 +0x200", " Email Code: ")
						EditInputCode := ManageDevForgotPswdMsg2.Add("Edit", "vInputCode x136 y41 w90 h20")
						EditInputCode.Opt("" . BackgroundMainColor . "")
						EditInputCode.Value := InputCode
						;------------------------
						EditEmailStatus := ManageDevForgotPswdMsg2.Add("Text", "x365 y41 +Center w112 h20 +0x200", "Not Validated")
						if EmailStatus != "" {
							EditEmailStatus.Value := EmailStatus
						}
						;------------------------
						ogcButtonValidateCode := ManageDevForgotPswdMsg2.Add("Button", "x490 y41 w90 h20", "Validate Code")
						ogcButtonValidateCode.OnEvent("Click", ValidateCode)
						;------------------------
						ManageDevForgotPswdMsg2.Add("Text", "x10 y71 w116 h20 +0x200", " Password: ")
						EditPassword := ManageDevForgotPswdMsg2.Add("Edit", "vPswd x136 y71 w112 h20 +Limit16 +Password")
						EditPassword.Opt("" . BackgroundMainColor . "")
						EditPassword.Value := Pswd
						;------------------------
						EditReEnteredPsw := ManageDevForgotPswdMsg2.Add("Text", "x10 y102 w116 h20 +0x200", " Re-enter Password: ")
						EditReEnterPassword := ManageDevForgotPswdMsg2.Add("Edit", "vReEnterPassword x136 y102 w112 h20 +Limit16 +Password")
						EditReEnterPassword.Opt("" . BackgroundMainColor . "")
						if PasswordStatus == "Ok" {
							EditReEnterPassword.Value := Pswd
						}
						;------------------------
						EditPasswordStatus := ManageDevForgotPswdMsg2.Add("Text", "x365 y102 +Center w112 h20 +0x200", "Not Validated")
						if PasswordStatus != "" {
							EditPasswordStatus.Value := PasswordStatus
						}
						;------------------------
						ogcButtonValidatePassword := ManageDevForgotPswdMsg2.Add("Button", "x490 y102 w90 h20", "Validate")
						ogcButtonValidatePassword.OnEvent("Click", ValidatePassword)
						;------------------------
						ogcButtonRegister := ManageDevForgotPswdMsg2.Add("Button", "x90 y199 w150 h24", "Update Password")
						ogcButtonRegister.OnEvent("Click", UpdatePassword)
						;------------------------
						ogcButtonCancel := ManageDevForgotPswdMsg2.Add("Button", "x355 y199 w150 h24", "Go Back")
						ogcButtonCancel.OnEvent("Click", GoBackMenu)
						ManageDevForgotPswdMsg2.Title := "Forgot Password"
						if GuiName == "ControllerRemapGui1" {
							ControllerRemapGui1.GetPos(&PosX, &PosY)
						} else {
							ControllerRemapGui2.GetPos(&PosX, &PosY)
						}
						ManageDevForgotPswdMsg2.SetFont("s8 " . MessageMainMsgFontColor, MainFontType)
						SB_RegMsg := ManageDevForgotPswdMsg2.Add("StatusBar", , "Ready.")
						ManageDevForgotPswdMsg2.Show("x" . PosX - 225 . " y" . PosY + 120 . "w595 h260")
						
						ControlFocus("Button1", "Forgot Password")
						ManageDevForgotPswdMsg2.Opt("+LastFound")
						; ManageDevForgotPswdMsg2.OnEvent("Close", ForgotPswd_Close)
					
					} 
					;----------------------------------------------------
					; Destroy previous Gui
					;----------------------------------------------------
					if GuiCount2 != 1 {
						if Mod(GuiCount2, 2) == 0 {
							ManageDevForgotPswdMsg1.Destroy
						} else {
							ManageDevForgotPswdMsg2.Destroy
						}
					}
					GuiCount2++
					IniWrite GuiCount2, TempSystemFile, "GeneralData", "GuiCount2"
					
					SB.SetText("Awaiting registration..")
					;----------------------------------------------------
					; Set DynamicReload to false again
					;----------------------------------------------------
					DynamicReload2 := false
					IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
					;----------------------------------------------------
				} ; End DynamicReload2 / GUI Static code
				;----------------------------------------------------
				; Dynamic code starts here
				;----------------------------------------------------
				
				if FlagSentMail == true {
					elapsed += ControllerLoopInterval 
					remainingTime := round((totalTime - elapsed) / 1000)
					if (remainingTime <= 0) {
						remainingTime := 0
					}
					SB_RegMsg.SetText("Mail sent. Retry in " remainingTime " secs.")
					if MailSent == false {
						SendMailForgotPswd(ValidCode, Email)
						MailSent := true
					}
				}
				
				if remainingTime == 0 {
					remainingTime := totalTime
					elapsed := 0
					FlagSentMail := false
					MailSent := false
					IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
					; Save any other user input value too
					if GuiName2 == "ManageDevForgotPswdMsg1" {
						Saved := ManageDevForgotPswdMsg1.Submit(false)
					} else {
						Saved := ManageDevForgotPswdMsg2.Submit(false)
					}
					IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
					IniWrite Saved.InputCode, TempSystemFile, "GeneralData", "InputCode"
					IniWrite Saved.Pswd, TempSystemFile, "GeneralData", "Pswd"
					DynamicReload2 := true
					IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
				}
				Sleep ControllerLoopInterval
			} ; End Registration General loop
		Return
		;----------------------------------------------------
		; UpdatePassword(*) ; Level 1
		;----------------------------------------------------
		UpdatePassword(*) {
			if EditPasswordStatus.Value != "Ok" or
			   EditEmailStatus.Value != "Ok" {
				; Fields Not Validated
				FieldsNotValidated()
				return
			}
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "ManageDevForgotPswdMsg1" {
				Saved := ManageDevForgotPswdMsg1.Submit(false)
			} else {
				Saved := ManageDevForgotPswdMsg2.Submit(false)
			}
			Saved.Pswd := EncryptPsw(Saved.Pswd)
			QueryResult := UpdateUserPassword(Saved.Email,
											  Saved.Pswd)  
			if QueryResult == 0 {
				; Registration successful
				IniWrite LicenseKey, LicenseFile, "Data", "LicenseKey"
				PasswordUpdateSuccessful()
				DynamicReload := true
				IniWrite true, TempSystemFile, "GeneralData", "DynamicReload"
				Reload
			}
			if QueryResult == 1 {
				; No internet connection
				CheckConnectionMsg()
			}
		}
		;----------------------------------------------------
		; ForgotPswd_Close(*) ; Level 1
		;----------------------------------------------------
		; ForgotPswd_Close(*) {
			; MenuManageDevices()
			; ExitMenu()
		; }
		;----------------------------------------------------
		; SendValidationEmail(*) ; Level 1
		;----------------------------------------------------
		SendValidationEmail(*) {
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "ManageDevForgotPswdMsg1" {
				Saved := ManageDevForgotPswdMsg1.Submit(false)
			} else {
				Saved := ManageDevForgotPswdMsg2.Submit(false)
			}
			
			If Saved.Email == "" {
				InvalidEmailAddress()
				return
			}
			
			try {
				validMail := RegExMatch(Saved.Email, "^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
			}
			catch {
				validMail := false
			}
			
			if validMail == false {
				InvalidEmailAddress()
				return
			}
			
			SB.SetText("Validating mail..")
			MailExistInDatabase := ValidateMail(Saved.Email)
			if MailExistInDatabase == 1 {
				; No mail Found on database.
				MailNotRegistered()
				return
			}
			if MailExistInDatabase == 2 {
				; No internet Connection
				CheckConnectionMsg()
				return
			}
			MailValidationMessage(Saved.Email)
			IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
			FlagSentMail := true
			IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
			DynamicReload2 := true
			IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
		}
		;----------------------------------------------------
		; ValidateCode(*) ; Level 1
		;----------------------------------------------------
		ValidateCode(*) {
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "ManageDevForgotPswdMsg1" {
				Saved := ManageDevForgotPswdMsg1.Submit(false)
			} else {
				Saved := ManageDevForgotPswdMsg2.Submit(false)
			}
			if (ValidCode == Saved.InputCode) {
				EditEmailStatus.Value := "Ok"
			} else {
				EditEmailStatus.Value := "Mismatch"
			}
			FlagSentMail := false
			IniWrite FlagSentMail, TempSystemFile, "GeneralData", "FlagSentMail"
			remainingTime := totalTime
			IniWrite Saved.Email, TempSystemFile, "GeneralData", "Email"
			IniWrite Saved.InputCode, TempSystemFile, "GeneralData", "InputCode"
			IniWrite EditEmailStatus.Value, TempSystemFile, "GeneralData", "EmailStatus"
			IniWrite Saved.Pswd, TempSystemFile, "GeneralData", "Pswd"
			IniWrite EditPasswordStatus.Value, TempSystemFile, "GeneralData", "PasswordStatus"
			DynamicReload2 := true
			IniWrite DynamicReload2, TempSystemFile, "GeneralData", "DynamicReload2"
		}
		;----------------------------------------------------
		; ValidatePassword(*) ; Level 1
		;----------------------------------------------------
		ValidatePassword(*) {
			if EditPassword.Value != EditReEnterPassword.Value {
				EditPasswordStatus.Value := "Mismatch"
			} else {
				EditPasswordStatus.Value := "Ok"
			}
			if StrLen(EditPassword.Value) < 8 {
				EditPasswordStatus.Value := "8-characters min"
			}
			IniWrite EditPasswordStatus.Value, TempSystemFile, "GeneralData", "PasswordStatus"
		}
		;----------------------------------------------------
		; GoBackMenu(*) ; Level 1
		;----------------------------------------------------
		GoBackMenu(*) {
			; LoginAccount()
			MenuManageDevices()
			Destroy()
		}
		;----------------------------------------------------
		; Destroy(*) ; Level 1
		;----------------------------------------------------
		Destroy(*) {
			GuiName2 := IniRead(TempSystemFile, "GeneralData", "GuiName2")
			if GuiName2 == "ManageDevForgotPswdMsg1" {
				try {
					ManageDevForgotPswdMsg1.Destroy()
				}
				catch {
				}	
			} else {
				try {
					ManageDevForgotPswdMsg2.Destroy()
				}
				catch {
				}	
			}
		}
	}
}

