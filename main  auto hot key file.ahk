
/*
 AutoHotkey Version: 2.0.x
 Language:       English
 Platform:       Win 10 
 Author:         Twilighty Abhi

 Script Function:
 
	This script mimics all the shotcuts and fast functionality
	for the ease of use of the computer for Twilighty abhi.

 NOTE: In autohotkey, the following special characters (usually) represent modifier keys:
 # is the WIN key. (it can mean other things though, as you can see above.)
 ^ is CTRL
 ! is ALT
 + is SHIFT
 list of other keys: http://www.autohotkey.com/docs/Hotkeys.htm

If this is your first time using AutoHotkey, you must take this tutorial:
 https://autohotkey.com/docs/Tutorial.htm
 
	""If you find any keys miss behaving.. Well they  aren't ..... its you probably who mis-spelt the code LOL!!""
 
*/

 ;#include causes the script to behave as though the specified file's contents are present at this exact position.

; Just keep these little thingies here to optimize code as they say.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;------------------------------------------------------------------------------------------------------------


; Free space for  me
;------------------------------------------------------------------------------------------------------------


#SingleInstance Force ; just to force run only one instance of the script.

;					(\__/)  ||
;					(•ㅅ•)  ||
;					/ 　 \づ|| 


;How to call the Below function
; well LOL You know what i meant..


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
;lololol I have to have tippy(), but i can't redefine an existing function, so I either have to put it in another .ahk script and #include it, or I could go the lazy route and just add a "2" to the end of ALL of them in this file, because I am a such a bad spaghetti coder that I don't even know what that means.
;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

;XButton1::#+s



;WEBSITE SHOTCUTS
^y::
Run https://www.youtube.com  ;opens youtube
QuickToolTip("Youtube Vanney...", 1800)
	return

^g::
Run https://www.google.co.in/ ; opens google
;QuickToolTip("Opening Brilliant...", 2500)
 return

!f::
Run https://fast.com/ ; Opens fast.com for checking internet speed
QuickToolTip("Opening Speedcheck...", 1000)
	return

!g::
Run https://www.google.com/ ;open google
QuickToolTip("Google Maaman Opening ...", 2000)
;Control g does ssomething.
	return



;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------


;RUN APPLICATIONS

!c::

	if WinExist("ahk_exe msedge.exe")
		if WinActive()
			WinMinimize
		else
			WinActivate
	else
		{
			Run C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk ;opens Edge
			QuickToolTip("Edge is Rising ...", 2000)
		}
	
	return


!s::
Run https://open.spotify.com/
QuickToolTip("Chill With Spotify ...", 4000)
	
	return 
	
;open whatsapp
!w:: Run C:\Users\Twilighty Abhi\Desktop\Scripts\Shotcuts\WhatsApp - Shortcut.lnk ; opens whatsapp
	return

;Open whiteboard
!b::Run C:\Users\Twilighty Abhi\Desktop\Scripts\Shotcuts\Microsoft Whiteboard - Shortcut.lnk ; opens whiteboard
return



;open To do and calendar app
!t:: 	
	{
		Run C:\Users\Twilighty Abhi\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Todoist.lnk ;opens Todoist
	 	Run C:\Users\Twilighty Abhi\Desktop\Scripts\Shotcuts\Morgen - Shortcut.lnk ; opens morgen
		QuickToolTip("To Dooooo ...", 1000)
 	}	
	return




;opens the  music player
!m:: Run C:\Users\Twilighty Abhi\Desktop\Scripts\Shotcuts\Groove Music - Shortcut.lnk
	return




;Mouse butoon as tab switcher
;use this for tab switching
XButton2:: !Tab




/*
;For using mouse key 4 as paster
  XButton1:: ^v 
  Sleep 300
Send, {Enter 2}
    return 
	*/



;open calculator
^Numpad1::   ; <-- Open/Activate/Minimize Windows Calculator
{
	if WinExist("Calculator ahk_class CalcFrame") or WinExist("Calculator ahk_class ApplicationFrameWindow")
		if WinActive()
			WinMinimize
		else
			WinActivate
	else
		Run calc.exe
	return
}
;}
	return

; opens snipping tool

;F1::#+s 
;return

;aslo i can give myself a ---damn it i forgot it AS i was wriiting it. —a thing to always paste as SIMPLE, unformatted test. YEAH.

;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------




;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

;oh my god this code is so sloppy, it's great. And this is like, one of my best ever functions. I'm not even kidding. I use it like 20x an hour. 


;Text Expander 

	::@111:: abhiramnj@gmail.com ;enter personal email address 
	return

	::@222:: abhiztechz@gmail.com ;enter Private email address 
	return

	::@333:: info.abhiztechz@gmail.com ;enter useless email address 
	return

	::ahk:: auto hot key
	return

	::abh:: Abhiram N J
	::Twa:: Twilighty Abhi
	::HBD:: Wishing you a Happy Birthday💖💖
	::gn:: Good Night💫💖
	::gm:: morN'❤
	;::formalmailopener:: 



/*
;------------------------------------------------------------------------------
; AUto-COrrect TWo COnsecutive CApitals.
; Disabled by default to prevent unwanted corrections such as IfEqual->Ifequal.
; To enable it, remove the /*..*/ symbols around it.
; From Laszlo's script at http://www.autohotkey.com/forum/topic9689.html
;------------------------------------------------------------------------------

; The first line of code below is the set of letters, digits, and/or symbols
; that are eligible for this type of correction.  Customize if you wish:
keys = abcdefghijklmnopqrstuvwxyz
Loop Parse, keys
    HotKey ~+%A_LoopField%, Hoty
Hoty:
    CapCount := SubStr(A_PriorHotKey,2,1)="+" && A_TimeSincePriorHotkey<999 ? CapCount+1 : 1
    if CapCount = 2
        SendInput % "{BS}" . SubStr(A_ThisHotKey,3,1)
    else if CapCount = 3
        SendInput % "{Left}{BS}+" . SubStr(A_PriorHotKey,3,1) . "{Right}"
Return

*/

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------



; Custom volume buttons
;^.:: Send {Volume_Up} ;ctrl + .
;^,:: Send {Volume_Down} ;ctrl + ,
;break::Send {Media_Play_Pause} ; Break key mutes
;	return

;I'm doing it in this weird way just in case the function is not available -- this means it won't screw anything up.
	;effectsPanelType("") ;set to macro key G1 on my logitech K120 keyboard. 
	
	
;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

/*
;MUSIC CONTROLS

SendMode Input

;Ctrl & left: Previous Track
^Left::Media_Prev
	return

;Ctrl & right: Next Track
^Right::Media_Next
	return

;Ctrl &up: Volume Up
^Up::SoundSet +2
	return

;Ctrl & down: Volume Down
^Down::SoundSet -2
	return

;play/pause
^Numpad5::Volume_Mute
	return

*/
;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------


;COPIED GOOGLE SEARCH
^+s::
Send ^c
QuickToolTip("Searching....", 800)
Sleep 50
Run "http://www.google.com/search?q=%clipboard%"
	return






;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

;Auto open cmds upon startup
/*
!z:: 

	Run C:\Users\abhir\Desktop\Scripts\122\Microsoft Whiteboard - Shortcut  ;opens whiteboard
	sleep 3000
	Run   C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk   	    ;opens edge
	sleep 3000
;Run  C:\Users\abhir\Desktop\Scripts\122\Calendar - Shortcut				;Opens calender
sleep 3000
	Run C:\Users\abhir\Desktop\Scripts\122\Groove Music - Shortcut			;Opens music player
	sleep 3000


*/
;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------


/*

Simply scroll the mouse wheel up or down while hovering over 
Windows Systems Taskbar to adjust the Windows speaker volume. 
The script uses conditional directives to isolate the mouse scroll 
wheel as a Hotkey.

*/
;NOTE TO FUTURE ABHI: for Keyshower, put code here to find the first \ and remove the string before it. otherwise you can't see the FULL final folder name because it gets cropped off


;#If MouseIsOver("ahk_class Shell_TrayWnd")

;;;;;;

#If MouseIsOver("ahk_class Shell_TrayWnd")
   WheelUp::Send 		{Volume_Up}
   WheelDown::Send      {Volume_Down}
   XButton1::Send       {Media_Prev}
   XButton2::Send       {Media_Next}
   MButton::  send      {Media_Play_Pause}    
    
   
   
   
 ;function for the above code  
 ; LOL this just needs to be functional
 

MouseIsOver(WinTitle)
{
   MouseGetPos,,, Win
   Return WinExist(WinTitle . " ahk_id " . Win)
}

; I'm seeing some excellent sounding scripts in here which i might wish to take for myself:
; oh just kidding, they are in the TO DO section... they don't actually exist...




;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------



;; The below piece of code is working Perfectly when "alone".. Maybe it doesnt like being with other messy code. Will be in an developing stage to integrate this with the messy main script!!

; For using this code please go to : C:\Users\abhir\Desktop\Scripts\OSD time.ahk   <-- this code will automatically launch upon booting. NO WORRIES LEFT LaMo!!!


;===============================================================================================



; ;OBSOLETE - THESE NEVER WORKED VERY WELL
; sortExplorerByName(){
; IfWinActive, ahk_class CabinetWClass
	; {
	; ;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
	; send {alt}vo{enter} ;sort by name
	; ;tippy2("sort Explorer by name")
	; }
; }

; sortExplorerByDate(){
; IfWinActive, ahk_class CabinetWClass
	; {
	; ;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
	; send {alt}vo{down}{enter} ;sort by date modified, but it functions as a toggle...
	; ;tippy2("sort Explorer by date")
	; }
; }
; ;ABOVE IS OBSOLETE - THESE NEVER WORKED VERY WELL





;;================================================================================================================
;;================================================================================================================












/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
▒█▀▀▀ █▀▀▄ █▀▀▄ 　 ▒█▀▀▀█ █▀▀ 　 ▒█▀▀█ █▀▀█ █▀▀▄ █▀▀ 
▒█▀▀▀ █░░█ █░░█ 　 ▒█░░▒█ █▀▀ 　 ▒█░░░ █░░█ █░░█ █▀▀ 
▒█▄▄▄ ▀░░▀ ▀▀▀░ 　 ▒█▄▄▄█ ▀░░ 　 ▒█▄▄█ ▀▀▀▀ ▀▀▀░ ▀▀▀ 
────────────────────────────────────────────
─██████████████───██████████─██████████████─
─██░░░░░░░░░░██───██░░░░░░██─██░░░░░░░░░░██─
─██░░██████░░██───████░░████─██░░██████████─
─██░░██──██░░██─────██░░██───██░░██─────────
─██░░██████░░████───██░░██───██░░██████████─
─██░░░░░░░░░░░░██───██░░██───██░░░░░░░░░░██─
─██░░████████░░██───██░░██───██░░██████████─
─██░░██────██░░██───██░░██───██░░██─────────
─██░░████████░░██─████░░████─██░░██████████─
─██░░░░░░░░░░░░██─██░░░░░░██─██░░░░░░░░░░██─
─████████████████─██████████─██████████████─
────────────────────────────────────────────;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

*/
