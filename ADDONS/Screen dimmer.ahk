; ScreenDimmer
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	To dim or lighten the screen brightness
;
/*
This script has been modified with unique identifiers for running either as a
standalone app or integrated with another script. To add to a master script
simply (1) add "GoSub, ScreenDimmer" to the auto-execute section of the master script
and (2) insert "#Include [path]\ScreenDimmer.ahk" at an location after the end of the
auto-execute section of the master script.
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ScreenDimmer:

Gui Dimmer:+AlwaysOnTop
Gui, Dimmer:Add, Text, vDim x0 y0, Dimmer
Gui, Dimmer:Add, Text, vBright x0 y0, Brighter
Options := "Range60-180 NoTicks Buddy1Dim Buddy2Bright vSD_MySlider gSD_Dimmer"
Gui, Dimmer:Add, Slider, W200 x50 y5 AltSubmit Tooltip Reverse %options% , 128
Gui, Dimmer:Add, StatusBar, gSD_Reset, Default Brightness 128 `t`t(Click Status Bar to Reset)
SB_SetIcon("Shell32.dll", 44)
DisplaySetBrightness( 128 )

Menu, Tray, Icon, Shell32.dll, 44
Menu, Tray, Add, Reset Dimmer, SD_Reset
Menu, Tray, Icon, Reset Dimmer, Shell32.dll, 44  ; Change icon to a star
Menu, Tray, Add, Show Dimmer, SD_ShowWindow
Menu, Tray, Icon, Show Dimmer, Shell32.dll, 44  ; Change icon to a star
Menu, Tray, Default, Show Dimmer
Menu, Tray, Click, 1
Gui, Dimmer:Show, W300, Screen Brightness

Return

SD_Dimmer:
  Gui, Dimmer:Submit, NoHide
  DisplaySetBrightness( SD_MySlider )
  SB_SetText("Brightness level is " . SD_MySlider . "`t`t(Click Status Bar to Reset)")
Return

DisplaySetBrightness( Br=128 ) {
 Loop, % VarSetCapacity( GR,1536 ) / 6
   NumPut( ( n := (Br+128)*(A_Index-1)) > 65535 ? 65535 : n, GR, 2*(A_Index-1), "UShort" )
 DllCall( "RtlMoveMemory", UInt,&GR+512,  UInt,&GR, UInt,512 )
 DllCall( "RtlMoveMemory", UInt,&GR+1024, UInt,&GR, UInt,512 )
 Return DllCall( "SetDeviceGammaRamp", UInt,hDC := DllCall( "GetDC", UInt,0 ), UInt,&GR )
     , DllCall( "ReleaseDC", UInt,0, UInt,hDC )
}

SD_ShowWindow:
  Gui, Dimmer:Show, W300, Screen Brightness
Return

SD_Reset:
  DisplaySetBrightness( 128 )
  GuiControl, Dimmer:, SD_MySlider, 128
  SB_SetText("Default Brightness 128`t`t(Click Status Bar to Reset)",dimmer)
Return
