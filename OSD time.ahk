#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

loop
{
#singleinstance force
Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
WA=%A_screenwidth%
HA=%A_screenheight%


SX:=(WA*88)/100     ;x-pos
SY:=(WA*1.5)/100    ;y-pos

SY2:= SY + 40

Coordmode Mouse, Screen
MouseGetPos xMPos, yMPos

If (xMPos >= SX) and (yMPos <= SY2)  ; If mouse cursor is top Right of screen

   {
   Gui, Color, FFFFFF
   Gui, Font, FFFAFAF s20 , verdana ;red
   Gui, Add, Text, vD y0, %a_hour%:%a_min%:%a_sec%
   Gui, Show, NoActivate x%SX%y%SY%,uptime
   WinSet, TransColor, CCCCCC 255,uptime
   sleep, 1000
   Gui, Destroy
   }
}