;----------------------------------------------------
; AutoHotkey V2 MySQL Connection
;----------------------------------------------------
; AutoHotkey V2 can connect to a MySQL database using a class wrapper for MySQL C API functions.
; The class MySQLAPI provides methods to interact with MySQL databases, including connecting,
; querying, and fetching results. However, the specific implementation details and methods, 
; such as GetNextRow, are tailored for handling MySQL result sets.
;----------------------------------------------------
; App Full Name: Game Controller Remap.
;----------------------------------------------------
; #Requires AutoHotkey v2
; #Include "*i %A_ScriptDir%\MySQLAPI-v1.1.ahk"
;----------------------------------------------------
; RegisterUser(*)
; ValidateUser(Email, Pswd, MacAddress)
; UpdateMacAddress(MacAddress)
; ValidateMail(Email)
; UpdateUserPassword(Email, Pswd)
;----------------------------------------------------
; Register User
;----------------------------------------------------
RegisterUser(Email, Pswd, UserName, ReceiptId, LicAmountGCR, DateGCR, MacAddress) {
	MySqlInst := DatabaseConnetion()
	;------------------------
	QueryResult := MySqlInst.Query("INSERT INTO customers ( Email, Password, User_Name) VALUES ( '" Email "', '" Pswd "', '" UserName "' )")
	switch true {
	case QueryResult == 0:
	Default:
		; MsgBox("No inserted rows in customers table for " Email " ,Pswd: " Pswd " ,UserName: " UserName )
		return QueryResult
	}
	;------------------------
	QueryResult := MySqlInst.Query("SELECT Customer_Id FROM customers WHERE Email='" Email "'")
	switch true {
	case QueryResult == 0:
		ResultSet := MySqlInst.GetResult()
		for k, v in ResultSet.Rows {
			fk_Customer_Id := v["Customer_Id"]
		}
	default:
		; MsgBox("No Customer Id matches that Email")
		return QueryResult
	}
	;------------------------
    QueryResult := MySqlInst.Query("INSERT INTO billing_gcr ( Customer_Id, Receipt_Id_GCR, Lic_Amount_GCR, Date_GCR) VALUES ( '" fk_Customer_Id "', '" ReceiptId "', '" LicAmountGCR "', '" DateGCR "' )")
	switch true {
	case QueryResult == 0:
	Default:
		; MsgBox("No inserted rows in billing_gcr table")
	}
	;------------------------
	QueryResult := MySqlInst.Query("INSERT INTO gcr_mac ( Customer_Id, Mac_Address ) VALUES ( '" fk_Customer_Id "', '" MacAddress "' )")
	switch true {
	case QueryResult == 0:
	Default:
		; MsgBox("No inserted rows in DeviceGCR table")
	}
	return QueryResult
}

;----------------------------------------------------
; Validate User
;----------------------------------------------------
ValidateUser(Email, Pswd, MacAddress, ReceiptId, LicAmount, DateGCR) {
	MySqlInst := DatabaseConnetion()
	;------------------------
	QueryResult := MySqlInst.Query("SELECT * FROM customers WHERE Email='" Email "' AND Password='" Pswd "'")
	fk_Customer_Id := ""
	switch true {
	case QueryResult == 0:
		ResultSet := MySqlInst.GetResult()
		for k, v in ResultSet.Rows {
			; Process each row (Will always be a unique row for costumers table)
			fk_Customer_Id := v["Customer_Id"]
			UserName := v["User_Name"]
			IniWrite UserName, LicenseFile, "Data", "UserName"
		}
		;------------------------
		if fk_Customer_Id != "" {
			QueryResult := MySqlInst.Query("SELECT * FROM billing_gcr WHERE Customer_Id='" fk_Customer_Id "'" )
			if QueryResult == 0 {
			    LicAmountGCR := ""
				ResultSet := MySqlInst.GetResult()
				for k, v in ResultSet.Rows {
					; Process each row (Will always be a unique row for billing_gcr table)
					LicAmountGCR := v["Lic_Amount_GCR"]
					IniWrite LicAmountGCR, LicenseFile, "Data", "LicenceAmount"
				}
				;------------------------
				if LicAmountGCR == "" {
					; This user already has an account on another app (TA)
					; so we need to populate the billing table with new receipt Id
					
					QueryResult := MySqlInst.Query("INSERT INTO billing_gcr ( Customer_Id, Receipt_Id_GCR, Lic_Amount_GCR, Date_GCR) VALUES ( '" fk_Customer_Id "', '" ReceiptId "', '" LicAmount "', '" DateGCR "' )")
					switch true {
					case QueryResult == 0:
						IniWrite LicAmount, LicenseFile, "Data", "LicenceAmount"
						LicAmountGCR := LicAmount
					Default:
						; MsgBox("No inserted rows in billing_ta table")
					}
				}
				;------------------------
				; Verify
				QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Customer_Id='" fk_Customer_Id "'" )
				if QueryResult == 0 {
					ResultSet := MySqlInst.GetResult()
					RowCount := 0
					for k, v in ResultSet.Rows {
						; Process each row (Could be more than 1 row)
						; if MacAddress is already registered then login successful
						if MacAddress == v["Mac_Address"] {
							; Login successful
							Device := v["Device_Number"]
							IniWrite Device, LicenseFile, "Data", "DeviceNumber"
							return QueryResult
						}
						RowCount++
					}
					;------------------------
					if RowCount < LicAmountGCR {
						; Add new Mac Address row
						NewDevice := RowCount + 1
						QueryResult := MySqlInst.Query("INSERT INTO gcr_mac ( Customer_Id, Device_Number, Mac_Address ) VALUES ( '" fk_Customer_Id "', '" NewDevice "', '" MacAddress "' )")
						if QueryResult == 0 {
							; New device added. - Login successful.
							IniWrite NewDevice, LicenseFile, "Data", "DeviceNumber"
							return QueryResult
						}
					} else {
						; MsgBox("Device License maxed out. Delete a device access or expand your license ammout.")
						return 2
					}				
				} else {
					; MsgBox("No row matched on gcr_mac table")
				}
			} else {
				; MsgBox("No row matched on billing_gcr table")
			}
		}
	Default:
		; No connection
	}
	return 1
}

;----------------------------------------------------
; Update Mac Address
;----------------------------------------------------
UpdateMacAddress(Email, Pswd, MacAddress) {
	MySqlInst := DatabaseConnetion()
	;------------------------
	QueryResult := MySqlInst.Query("SELECT * FROM customers WHERE Email='" Email "' AND Password='" Pswd "'")
	switch true {
	case QueryResult == 0:
		ResultSet := MySqlInst.GetResult()
		for k, v in ResultSet.Rows {
			; Process each row (Will always be a unique row for costumers table)
			; MsgBox("Customer_Id: " v["Customer_Id"] " UserName: " v["User_Name"])
			fk_Customer_Id := v["Customer_Id"]
		}
		;------------------------
		; Verify
		QueryResult := MySqlInst.Query("SELECT * FROM gcr_mac WHERE Customer_Id='" fk_Customer_Id "'" )
		if QueryResult == 0 {
			ResultSet := MySqlInst.GetResult()
			row := 0
			DeviceNumber := []
			StoredMacAddress := []
			for k, v in ResultSet.Rows {
				; Process each row (Could be more than 1 row)
				row++
				DeviceNumber.Push v["Device_Number"]
				StoredMacAddress.Push v["Mac_Address"]
				; MsgBox("Device Number 1: " DeviceNumber[row])
			}
			; update device 1 
			QueryResult := MySqlInst.Query("UPDATE gcr_mac SET Mac_Address='" MacAddress "' WHERE Customer_Id='" fk_Customer_Id "' AND Device_Number='" DeviceNumber[1] "'")
			if QueryResult == 0 {
				MsgBox("This device was added succesfully")
			} else {
				MsgBox("No rows updated")
			}
		}
	Default:
		; MsgBox("No rows matched customers table")
		; No connection
	}
}

;----------------------------------------------------
; Validate Mail
;----------------------------------------------------
ValidateMail(Email) {
	MySqlInst := DatabaseConnetion()
	;------------------------
	QueryResult := MySqlInst.Query("SELECT Customer_Id FROM customers WHERE Email='" Email "'")
	fk_Customer_Id := ""
	
	switch true {
	case QueryResult == 0:
		ResultSet := MySqlInst.GetResult()
			for k, v in ResultSet.Rows {
				fk_Customer_Id :=  v["Customer_Id"]
			}
	default:
		; No connection
		return 2
	}
	if fk_Customer_Id == "" {
		; No mail found
		return 1
	} else {
		return 0
	}
}

;----------------------------------------------------
; Update User Password
;----------------------------------------------------
UpdateUserPassword(Email, Pswd) {
	MySqlInst := DatabaseConnetion()
	;------------------------
	QueryResult := MySqlInst.Query("SELECT * FROM customers WHERE Email='" Email "'")
	switch true {
	case QueryResult == 0:
		ResultSet := MySqlInst.GetResult()
		for k, v in ResultSet.Rows {
			; Process each row (Will always be a unique row for costumers table)
			; MsgBox("Customer_Id: " v["Customer_Id"] " UserName: " v["User_Name"])
			fk_Customer_Id := v["Customer_Id"]
			UserName := v["User_Name"]
			
		}
		if fk_Customer_Id != "" {
		    QueryResult := MySqlInst.Query("UPDATE customers SET Password='" Pswd "' WHERE Customer_Id='" fk_Customer_Id "' AND Email='" Email "'")
		    if QueryResult == 0 {
				; MsgBox("This device was added succesfully")
				IniWrite UserName, LicenseFile, "Data", "UserName"
				return 0
			} else {
				; MsgBox("No rows updated")
			}
		}
	Default:
		; Port 3306 closed
	}
	return 1
}
