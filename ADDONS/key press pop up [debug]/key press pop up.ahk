#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


/*
			-------------------------------------------------------
								HotShow 1.0
			-------------------------------------------------------

			This program will show any pressed key or combination 
			of keys on screen in a very elegant way.
			
			Perfect for people who creates video tutorials
			and want to show which hotkeys they press during
			a demostration of the software being used.

----[Author]--------------------------------------------------------
This program was created by RaptorX
Thanks to Tidbit and Titan for help in some of the functions
----[Features]------------------------------------------------------
Right now the program is in its basic form.
Features will be added soon, Please read the To Do  list
----[TODO]----------------------------------------------------------
Customization of: 
-Background Image
-Transparency settings
-Fade in/Fade out settings
-Window Positioning options
-A Function that if the program detects a word instead of a shortcut it will wait for what you typed and then display the whole word/sentence at once.
--------------------------------------------------------------------
*/
#SingleInstance Force
#NoEnv
OnExit, Clean

FileInstall, BG-Blue.png, BG-Blue.png, 1 ;Background Image
FileInstall, BG-Red.png, BG-Red.png, 1

;These are the windows for the background image, created to be able to create the fade in / fade out effects
Gui, +owner +AlwaysOnTop +Disabled +Lastfound -Caption 
Gui, Color, FFFFFF
Gui, Add, Picture,,BG-Red.png
WinsetTitle,Background 
Winset, transcolor, FFFFFF 0

Gui, 2: +Owner +AlwaysOnTop +Disabled +Lastfound -Caption
Gui, 2: Color, 026D8D
Gui, 2: Font, Bold s15 Arial
Gui, 2: Add, Text, Center CWhite W250 vHotkeys,
WinsetTitle,HotkeyText
Winset, transcolor, 026D8D 0

Gui, Show, Hide
Gui, 2: Show, Hide

;End of background windows, both are hidden until we press a key

;This loop includes all the alphanumerical characters using the ascii code.
; Code 32 = Space until code 127 = Delete
Loop, 95
{ 
	key := Chr(A_Index + 31)
	Hotkey, ~*%key%, Display
}

Loop, 24 ;Support for function Keys F1-F24
{
	Hotkey, ~*F%a_index%, Display
}

Hotkey, ~*Numpad0, Display ;Adding Numpad0
Loop, 9 ;Support for Numpad Numbers
{
	Hotkey, ~*Numpad%a_index%, Display
}

NumpadKeys=NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter ; Support for Numpad operands.

Loop, Parse, NumpadKeys,`,
{
	Hotkey, ~*%a_loopfield%, Display
}

Otherkeys=Tab,Enter,Esc,BackSpace,Del,Insert,Home,End,PgUp,PgDn,Up,Down,Left,Right,ScrollLock,CapsLock,NumLock,Pause

Loop, parse, Otherkeys, `,
{
	Hotkey, ~*%a_loopfield%, Display
}

Display:
If A_ThisHotkey =
	Return

;Msgbox, %a_thishotkey%

mods = Ctrl,Shift,Alt,LWin,RWin
prefix =

Loop, Parse, mods,`,
{
	GetKeyState, mod, %A_LoopField%
	If mod = D
		prefix = %prefix%%A_LoopField% +
}

StringTrimLeft, key, A_ThisHotkey, 2
if key=%a_Space%
	key=Space
Gosub, Show
Return

Show:
Alpha=0
Duration=150
Imgx=23
Imgy=630

GuiControl, 2: Text, Hotkeys, %prefix% %key%
Gui, Show, x%imgx% y%imgy% NoActivate
imgx-=10
imgy+=15
Gui, 2: Show, x%imgx% y%imgy% NoActivate

Gosub, Fadein
Sleep 2000
Gosub, Fadeout
Gui, Hide
Gui, 2: Hide
Return

Fadein:
If faded=1 ;Do not fade if the window already faded in.
{
	Winset, transcolor, FFFFFF 255, Background
	Winset, transcolor, 026D8D 255, HotkeyText
	return
}

Loop, %duration% ; Fade in routine.
{
	Alpha+=255/duration
	Winset, transcolor, FFFFFF %Alpha%, Background
	Winset, transcolor, 026D8D %Alpha%, HotkeyText
	faded=1
}
Return

Fadeout:
Loop, %duration% ; Fade out routine
{
	Alpha-=255/duration
	Winset, transcolor, FFFFFF %Alpha%, Background
	Winset, transcolor, 026D8D %Alpha%, HotkeyText
	faded=0
}
return

Clean:
FileDelete, *.png
ExitApp

~*Esc::Goto, Clean
Pause::Suspend, toggle
/*
-[Created By]-------------------------------------------------------
						 -RaptorX-
						 
This project can be modified or copied, for personal or commercial
uses provided that you mention the original author.
--------------------------------------------------------------------
*/