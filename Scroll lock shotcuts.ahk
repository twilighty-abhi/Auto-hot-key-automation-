#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force
#If GetKeyState("ScrollLock", "T")



Numpad0:: !Tab
return
Numpad1:: MouseClick
return
Numpad2::
	sleep, 100
	send {PrintScreen}
	sleep, 500
	run MSPaint
	Sleep, 1000
	Send, #{Up}
	Sleep, 500
	Mouseclick, left, 250, 250, 5
	Sleep, 200
	send ^v
	sleep, 150
		Send ^s
	Random, filename, 10000, 99999
	Sleep, 500
	Send  %A_DD%-%A_MM%-%A_YYYY%
	Sleep, 500
	Send ^l
	Sleep, 200
	Send, desktop
	Loop, 5 {
	Send, {enter}
	Sleep, 300
	}
	
	
return
Numpad3::#d
return


;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

;This is the code to make hotkey for gink app that is used to write on screen

Numpad5::^!g
;Launches the app from tray(This is a inline app hotkey Not launced from this call)
return

;Numpad5::^!p
;This line is a inline hotkey calling to pan mouse pointer inside the software
;return


;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------


/*

Numpad6::
return
Numpad7::
return
Numpad8::
return
*/

Numpad9:: ^+Esc
return



;End of the script you FoooL