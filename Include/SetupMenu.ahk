;------------- Credits ------------
; Creator: Fernando Daniel Jaime.
; Programmer Alias: FDJ-Dash.
;------------- File Details ------------
; App Name: Game Controller Remap.
; File Description: This file contains the Setup Menu that interacts with the GUI.
;----------------------------------------------------
; Header list:
;----------------------------------------------------
; SetupMenuBar(...)
;----------------------------------------------------
; Setup Menu Bar
;----------------------------------------------------
SetupMenuBar(&MenuBar_Storage,
			 &FileMenu,
			 &ExitGameControllerRemap,
			 &OptionsMenu,
			 &SettingsMenu,
			 &HelpMenu,
			 ControllerRemapGui){
	MenuBar_Storage := MenuBar()
	;-------------------------------
	FileMenu := Menu()
	MenuBar_Storage.Add("&File", FileMenu)
	FileMenu.Add("&Exit`t" . ExitGameControllerRemap,MenuHandlerExit)
	try {
		FileMenu.SetIcon("&Exit`t" . ExitGameControllerRemap,IconLib . "\exit.ico")
	}
	catch {
	}
	;-------------------------------
	OptionsMenu := Menu()
	MenuBar_Storage.Add("&Options", OptionsMenu)
	OptionsMenu.Add("Edit &Ini File", EditIniFileHandler)
	OptionsMenu.Insert()
	OptionsMenu.Add("Change Background &Image", ChangeBackgroundHandler)
	OptionsMenu.Add("Change M&essage Background Image", ChangeMessageBackgroundHandler)
	OptionsMenu.Insert()
	OptionsMenu.Add("&Always On Top: ON/OFF", GuiPriorityAlwaysOnTopHandler)

	try {
		OptionsMenu.SetIcon("Edit &Ini File", IconLib . "\File.ico")
		OptionsMenu.SetIcon("Change Background &Image", IconLib . "\ChangeBackground.png")
		OptionsMenu.SetIcon("Change M&essage Background Image", IconLib . "\ChangeBackground.png")
		OptionsMenu.SetIcon("&Always On Top: ON/OFF", IconLib . "\Switch2.ico")
	}
	catch {
	}
	;-------------------------------
	SettingsMenu := Menu()
	MenuBar_Storage.Add("&Settings", SettingsMenu)
	SettingsMenu.Add("Check for updates &daily", MenuHandlerCheckUptDaily)
	SettingsMenu.Add("Check for updates &weekly", MenuHandlerCheckUptWeekly)
	SettingsMenu.Add("&Never check for updates", MenuHandlerNeverCheckUpt)

	try {
		SettingsMenu.SetIcon("Check for updates &daily", IconLib . "\CheckDaily.png")
		SettingsMenu.SetIcon("Check for updates &weekly", IconLib . "\CheckWeekly.png")
		SettingsMenu.SetIcon("&Never check for updates", IconLib . "\stop.ico")
	}
	catch {
	}
	;-------------------------------
	HelpMenu := Menu()
	MenuBar_Storage.Add("&Help", HelpMenu)
	HelpMenu.Add("Guide", MenuHandlerGuide)
	HelpMenu.Add("Quick Fix", MenuHandlerQuickFix)
	HelpMenu.Insert()
	HelpMenu.Add("Update", MenuHandlerUpdate)
	HelpMenu.Insert()
	HelpMenu.Add("About", MenuHandlerAbout)

	try {
		HelpMenu.SetIcon("Guide", IconLib . "\Logo-MLGCR.ico")
		HelpMenu.SetIcon("Quick Fix", IconLib . "\Fix.ico")
		HelpMenu.SetIcon("Update", IconLib . "\Update.png")
		HelpMenu.SetIcon("About", IconLib . "\info.ico")
	}
	catch {
	}
	;-------------------------------
	ControllerRemapGui.MenuBar := MenuBar_Storage
}