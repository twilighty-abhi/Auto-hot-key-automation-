#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


QuickToolTip(text, delay)
{
	ToolTip, %text%
	SetTimer ToolTipOff, %delay%
	return

	ToolTipOff:
	SetTimer ToolTipOff, Off
	ToolTip
	return
}



#SingleInstance

Gui, -MinimizeBox -MaximizeBox
Gui, Add, Picture,w720 h450, G:\Wallpapers PC\ian-schneider-TamMbr4okv4-unsplash.jpg
Gui, Font, s15, Courgette
Gui, Add, Text,center,`n Hello Twilighty Abhi `nWishing you a happy day... #Stay Positive N' Happy  `nThe Current Day: %A_DD%-%A_MMM%-%A_YYYY% `nDay: %A_DDDD% `nTime: %A_Hour%:%A_Min% `n

Gui, Font, s9, Adlery pro
Gui, Add, Button, W80 Default, Thanks 
Gui, Show,, Welcome
SoundPlay, *-1
Gui, +LastFound
WinWaitClose
ExitApp

GuiEscape:
ButtonThanks:
Gui, Destroy
Run, https://www.notion.so/
Run, https://todoist.com/app/today#
return

GuiSize:
GuiControlGet, Button1, Pos
GuiControl, Move, Button1, % "x" (A_GuiWidth-Button1W)//2
return