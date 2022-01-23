Gui, Add, ComboBox, x172 y-103 w-120 h142 , ComboBox
Gui, Add, Button, x182 y329 w100 h40 , Launch
Gui, Add, CheckBox, x42 y79 w90 h30 , Notes
Run, Explorer C:\Users\abhir\Desktop\IIT Class Notes
Gui, Add, CheckBox, x42 y39 w90 h30 , Spotify
Run C:\Users\abhir\Desktop\Scripts\122\Spotify - Shortcut.lnk
; Generated using SmartGUI Creator 4.0
Gui, Show, x147 y135 h379 w479, App Launcher
Return

GuiClose:
ExitApp