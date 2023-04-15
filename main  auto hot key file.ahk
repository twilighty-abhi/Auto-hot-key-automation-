
/*
 AutoHotkey Version: 2.0.x
 Language:       English
 Platform:       Win 10 /win 11
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

/*
;spacebar rapid fire
#MaxThreadsperHotkey 2
~space::

Previouskey:= !PreviousKey

loop
{

if PreviousKey
{
sleep, 0
send, {space}
}
else

break

}
return
*/

;WEBSITE SHOTCUTS
^y::
Run https://www.youtube.com  ;opens youtube
QuickToolTip("Youtube Vanney...", 1800)
	return

^g::
Run https://www.google.co.in/ ; opens google
;QuickToolTip("Opening Google...", 2500)
 return

!f::
Run https://fast.com/ ; Opens fast.com for checking internet speed
QuickToolTip("Opening Speedcheck...", 1000)
	return

!g::
Run https://scholar.google.com/scholar? ;open google scholar for research type of files and help
QuickToolTip("Google buddy Opening ...", 2000)
;Alt g opens up google scholar.
	return



;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

;******************************************************************************
;			           RUN APPLICATIONS
;******************************************************************************





!x::

	if WinExist("ahk_exe msedge.exe")
		if WinActive()
			WinMinimize
		else
			WinActivate
	else
		{
			Run C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk ;opens Edge || change the directry to yours.
			QuickToolTip("Edge is Rising ...", 1500)
		}
	
	return


!s::
Run https://open.spotify.com/
QuickToolTip("Chill With Spotify ...", 4000)
	
	return 
	
;open whatsapp
!w:: Run C:\Users\a\Desktop\Scripts\Shotcuts\WhatsApp - Shortcut.lnk ; opens whatsapp || change the directry to yours.
	return

;Open whiteboard
!b::Run C:\Users\a\Desktop\Scripts\Shotcuts\Microsoft To Do - Shortcut.lnk ; opens microsoft todo list || change the directry to yours.
return



;open Todoist and Morgen calendar app
!t:: 	
	{
		Run C:\Users\a\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Todoist.lnk ;opens Todoist || change the directry to yours.
	 	Run C:\Users\a\Desktop\Scripts\Shotcuts\Morgen.lnk ; opens morgen || change the directry to yours.
		QuickToolTip("To Dooooo ...", 1000)
 	}	
	return




;opens the  music player
!m:: Run C:\Users\a\Desktop\Scripts\Shotcuts\Groove Music - Shortcut.lnk  ;change the directry to yours.
	return




;Mouse butoon as tab switcher
;use this for tab switching
XButton1:: !Tab








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

;******************************************************************************
;			Computer information
;******************************************************************************
::]myid::
SendInput %A_UserName%
Return

::]myip::
SendInput %A_IPAddress1%
Return

::]mycomp::
SendInput %A_ComputerName%
Return






;******************************************************************************
;			Date/Time Stamps
;******************************************************************************
::]d::
FormatTime, CurrentDate,, M/d/yyyy
SendInput %CurrentDate%
Return

::]dl::
FormatTime, CurrentDate,, dddd, MMMM d, yyyy
SendInput %CurrentDate%
Return

::]dc::
FormatTime, CurrentDate,, yyyy_MM_dd
SendInput %CurrentDate%
Return

::]d1::
FormatTime, CurrentDate,, M-d-yyyy
SendInput %CurrentDate%
Return

::]d2::
FormatTime, CurrentDateTime,, d-MMM-yyyy
SendInput %CurrentDateTime%
Return

::]d3::
FormatTime, CurrentDateTime,, yyyyMMdd
SendInput %CurrentDateTime%
Return

::]d4::
FormatTime, CurrentDateTime,, MMM-d-yyyy
SendInput %CurrentDateTime%
Return

::]d5::
FormatTime, CurrentDateTime,, M.d.yyyy
SendInput %CurrentDateTime%
Return

::]d6::
FormatTime, CurrentDateTime,, MM/dd/yyyy
SendInput %CurrentDateTime%
Return

::]d7::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput %CurrentDateTime%
Return

::]d8::
FormatTime, CurrentDateTime,, dMMMyyyy
SendInput %CurrentDateTime%
Return

::]d9::
FormatTime, CurrentDateTime,, ddMMMyyyy
SendInput %CurrentDateTime%
Return

::]ymd::
FormatTime, CurrentDateTime,, yyyy-MM-dd
SendInput %CurrentDateTime%
Return

::]t::
FormatTime, Time,, h:mm tt
sendinput %Time%
Return

::]t1::
FormatTime, Time,, H:mm
sendinput %Time%
Return

::]dt::
FormatTime, CurrentDateTime,, M/d/yyyy h:mm tt  
SendInput %CurrentDateTime%
Return

::]dt1::
FormatTime, CurrentDateTime,, M-d-yyyy h:mm tt  
SendInput %CurrentDateTime%
Return

::]dt2::
FormatTime, CurrentDateTime,, d-MMM-yyyy H:mm
SendInput %CurrentDateTime%
Return

::]dt3::
FormatTime, CurrentDateTime,, MMM-dd-yyyyThh:mm:ss
SendInput %CurrentDateTime%
Return

::]dt4::
FormatTime, CurrentDateTime,, MMM-dd-yyyy hh:mm:ss
SendInput %CurrentDateTime%
Return

::]dtl::
FormatTime, CurrentDate,, dddd, MMMM d, yyyy h:mm tt
SendInput %CurrentDate%
Return

^!PrintScreen::		; CTRL + ALT + Print Screen
   FormatTime, xx,, dddd, MMMM d, yyyy ; This is one type of the date format
   FormatTime, zz,, h:mm tt ; This is one type of the time format
   SendInput, %xx% %zz%
Return


;******************************************************************************
;			Message Box Greeting - Current Date and Time
;******************************************************************************

::]curdt::
FormatTime, DateTime,, dddd, M/d/yyyy  h:mm tt
Msgbox,
(
Hello Twilighty Abhi
Today is %DateTime%
)
clipboard = %DateTime%
Return


;------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------

;oh my god this code is so sloppy, it's great. And this is like, one of my best ever functions. I'm not even kidding. I use it like 20x an hour. 


;Text Expander 

	::em1::<email1> ;enter personal email address 
	return

	::em2::<email2> ;enters college email address 
	return

	::em3::<email3> ;enter useless email address 
	return

	

	::abh::Abhiram N J
	::Twa::Twilighty Abhi
	::HBD::Wishing you a Happy Birthday
	::gn::Good Night
	::gm::Good Morning
	::intro1::I'm Abhiram N J Second Yr CSE student at College of engineering Karunagapally
	
	;Social link Expander
	::]twitter::https://twitter.com/TwilightyAbhi
	::]instagram::https://www.instagram.com/abhiramhhh/
	::]polywork::https://www.polywork.com/twilighty_abhi
	::]peerlist::https://peerlist.io/abhiramnj
	::]linkedin::https://www.linkedin.com/in/abhiram-n-j/
	::]whatsapp::https://wa.me/919497704406
	::]portfolio::https://www.abhiramnj.live
	::]github::https://github.com/twilighty-abhi

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


;trial area
!h::MouseClick, left,,, 5

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
