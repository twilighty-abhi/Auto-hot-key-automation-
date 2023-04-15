#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


!j::
Send ^c
sleep 50
;send ^t
;sleep 100 
Run "https://wa.me/%clipboard%"
 ;https://wa.me/%clipboard%?text=Greetings%0A%0AHope%20you%20are%20doing%20good.%20Thank%20you%20for%20showing%20your%20interest%20in%20Rust%20Study%20Jams.%20%0A%0AAs%20the%20next%20step%2C%20we%20would%20like%20you%20to%20complete%20the%20shortlisting%20task%20that%20has%20been%20mailed%20to%20you.%20Kindly%20check%20your%20email%20for%20further%20details%20%0A%0AHope%20you%20have%20a%20good%20day%20ahead.%0A%0ABest%C2%A0Regards%2C%0AAbhiram%20NJ

return
