#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Start of Alarm Clock Program Activation Script

#SingleInstance Force
#Persistent
#NoEnv
SetBatchLines, -1
SetWorkingDir, %A_Temp%

Gosub, TrayMenu

Menu, Tray, NoStandard
Menu, Tray, Add, Alarm Clock, TrayClick
Menu, Tray, Add,
Menu, Tray, Standard
Menu, Tray, Default, Alarm Clock
Menu, Tray, Click, 1

Gui, Font, s10 CDefault w400, Arial Bold
Gui, Add, Edit, x16 y29 w220 h23, %File_to_Run%
Gui, Font, s11 CBlue w700, Arial Bold
Gui, Add, GroupBox, x7 y6 w390 h58, File to Run
Gui, Font, s10 CDefault w400, Arial
Gui, Add, Button, x245 y28 w70 h25, Browse...
Gui, Add, Button, x323 y28 w65 h25, Run
Gui, Font, s11 CBlue Bold, Arial Bold
Gui, Add, GroupBox, x7 y70 w287 h59, Date and Time
Gui, Font, s12 CDefault w400, Arial Bold
Gui, Add, DateTime, x16 y93 w125 h25
Gui, Add, DateTime, x150 y93 w133 h25, Time
Gui, Font, s13 CDefault Underline w400, Arial
Gui, Add, Button, x300 y80 w96 h46, Set Alarm
Gui, Font, s13 CGreen Norm Bold, Tahoma Bold
Gui, Add, Text, x303 y130, Alarm Set!
GuiControl, Hide, Alarm Set!
Gui, Font, s8 CDefault w400, Arial
Gui, Add, Button, x300 y152 w96 h20, Check Alarm Time
GuiControl, Hide, Check Alarm Time
Gui, Font, s11 CGreen w700, Arial Bold
FormatTime, Current_Time, , hh:mm:ss tt
Gui, Add, Text, vDate x60 y133, DATE: %A_MM%/%A_DD%/%A_YYYY%
Gui, Add, Text, vTime x60 y155, TIME: %Current_Time%
Gui, Show, h175 w404 Center, Alarm Clock
SetTimer, Loop, 1000

Gui, +AlwaysOnTop
Return

GuiSize:
If A_EventInfo <> 1 ; Minimized
Return

Loop:
FormatTime, Current_Time, , hh:mm:ss tt
GuiControl, , Time, TIME: %Current_Time%
GuiControl, , Date, DATE: %A_MM%/%A_DD%/%A_YYYY%
If Alarm_Time = %Current_Time%
Goto, Alarm
Return

ButtonBrowse...:
Gui +OwnDialogs
FileSelectFile, File_to_Run, 3, , Select File, File (*)
ControlSetText, , %File_to_Run%, Alarm Clock
Return

ButtonRun:
ControlGetText, File_to_Run, , Alarm Clock
If File_to_Run =
{
      Error = No file has been selected.
      Gosub, Error
      Return
}

Run, %File_to_Run%, , UseErrorLevel
If Errorlevel = Error
{
      Error = Unable to find file.
      Cst = On
      Gosub, Error
      Return
}
Return

ButtonCheckAlarmTime:
Gui +OwnDialogs
MsgBox, 8192, Alarm Clock, Alarm is set for %Alarm_Date% at %Alarm_Time%
Return

ButtonSetAlarm:
If File_to_Run =
{
      Error = No file has been selected.
      Gosub, Error
      Return
}

ControlGetText, Alarm_Date, SysDateTimePick321, Alarm Clock
StringSplit, Alarm_MDY, Alarm_Date, /
StringLen, Alarm_M_Cnt, Alarm_MDY1
If Alarm_M_Cnt = 1
      Alarm_Month = 0%Alarm_MDY1%
Else
      Alarm_Month = %Alarm_MDY1%
StringLen, Alarm_D_Cnt, Alarm_MDY2
If Alarm_D_Cnt = 1
      Alarm_Day = 0%Alarm_MDY2%
Else
      Alarm_Day = %Alarm_MDY2%
Alarm_Year = %Alarm_MDY3%
Num_Current_Date = %A_MM%%A_DD%%A_YYYY%
Num_Alarm_Date = %Alarm_Month%%Alarm_Day%%Alarm_Year%
If Alarm_Year < %A_YYYY%
{
      Error = The alarm date has already passed.
      Gosub, Error
      Return
}
If Alarm_Year = %A_YYYY%
{
      If Alarm_Month < %A_MM%
      {
            Error = The alarm date has already passed.
            Gosub, Error
            Return
      }
      If Alarm_Month = %A_MM%
      {
            If Alarm_Day < %A_DD%
            {
               Error = The alarm date has already passed.
               Gosub, Error
               Return
            }
      }
}
ControlGetText, Alarm_Time, SysDateTimePick322, Alarm Clock
StringSplit, Alarm_HMS, Alarm_Time, %A_Space%:
Alarm_Hour = %Alarm_HMS1%
Alarm_Minute = %Alarm_HMS2%
Alarm_Second = %Alarm_HMS3%
Alarm_AmPm = %Alarm_HMS4%
StringLen, Alarm_Hour_Cnt, Alarm_Hour
If Alarm_Hour_Cnt = 1
      Alarm_Hour = 0%Alarm_Hour%
If Alarm_AmPm = Pm
{
      If Alarm_Hour = 12
            Alarm_Military_Hour = 12
      Else
      {
         Alarm_Military_Hour = %Alarm_Hour%
         Alarm_Military_Hour += 12
      }
}
If Alarm_AmPm = Am
{
      If Alarm_Hour = 12
            Alarm_Military_Hour = 00
      Else
      Alarm_Military_Hour = %Alarm_Hour%
}
FormatTime, Military_Time, , HHmmss
Current_Military_Time = %Military_Time%
Alarm_Military_Time = %Alarm_Military_Hour%%Alarm_Minute%%Alarm_Second%
Alarm_Time = %Alarm_Hour%:%Alarm_Minute%:%Alarm_Second% %Alarm_AmPm%
Alarm_Date_X = %Alarm_Month%%Alarm_Day%%Alarm_Year%
If Alarm_Date_X = %A_MM%%A_DD%%A_YYYY%
{
      If Current_Military_Time > %Alarm_Military_Time%
      {
            Error = The alarm time has already passed.
            Gosub, Error
            Return
      }
}
GuiControl, Show, Alarm Set!
GuiControl, Show, Check Alarm
Menu, Tray, Enable, Check Alarm Time
Menu, Tray, Enable, Run
Menu, Tray, Tip, Alarm is set for %Alarm_Date% at %Alarm_Time%
Return

TrayMenu:
Menu, Tray, MainWindow
Menu, Tray, NoStandard
Menu, Tray, DeleteAll
Menu, Tray, Add, Alarm Clock, AlarmClock
Menu, Tray, Add,
Menu, Tray, Add, Check Alarm Time, CheckAlarmTime
Menu, Tray, Add, Run, Run
Menu, Tray, Add, Volume, Volume
Menu, Tray, Add, Show, Show
Menu, Tray, Add, Hide, Hide
Menu, Tray, Add, Exit, GuiClose
Menu, Tray, Disable, Check Alarm Time
Menu, Tray, Disable, Run
Menu, Tray, Disable, Show
Menu, Tray, Default, Alarm Clock
Return

AlarmClock:
IfWinExist, Alarm Clock
      WinActivate, Alarm Clock
IfWinNotExist, Alarm Clock
      Goto, Show
Return

CheckAlarmTime:
Gui +OwnDialogs
MsgBox, 8192, Alarm Clock, Alarm is set for %Alarm_Date% at %Alarm_Time%
Return

Run:
Run, %File_to_Run%
Return

Volume:
Run, sndvol32.exe
Return

Show:
Gui, Show, h175 w404 Center, Alarm Clock
Menu, Tray, ToggleEnable, Hide
Menu, Tray, ToggleEnable, Show
Return

Hide:
Gui, Submit, Alarm Clock
Menu, Tray, ToggleEnable, Hide
Menu, Tray, ToggleEnable, Show
Return

Error:
Gui +OwnDialogs
MsgBox, 8208, ERROR, %Error%
If Cst = On
ControlSetText, , , Alarm Clock 
GuiControl, Hide, Alarm Set!
GuiControl, Hide, Check Alarm
Menu, Tray, Disable, Check Alarm Time
Menu, Tray, Disable, Run
Menu, Tray, Tip
Error =
Cst =
Return

Alarm:
Run, %File_to_Run%
Goto, GuiClose
Return

WriteFile(File,Data)
{
      Handle := DllCall("CreateFile","Str",File,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   Loop
      {
              If StrLen(Data) = 0
                    Break
              StringLeft, Hex, Data, 2
              StringTrimLeft, Data, Data, 2 
              Hex = 0x%Hex%
              DllCall("WriteFile","UInt",Handle,"UChar *",Hex,"UInt",1,"UInt *",UnusedVariable,"UInt",0)
       }
      DllCall("CloseHandle", "Uint", Handle)
         Return
}
Return

WriteFile_1(File_1,Blocks)
{
   Global
         Local Handle, Data_1, Hex
         Handle := DllCall("CreateFile","Str",File_1,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
         Loop, Parse, Blocks, |
            {
                  Data_1 := %A_LoopField%
                  Loop,
                     {
                        If StrLen(Data_1) = 0
                             Break
                        StringLeft, Hex, Data_1, 2
                        StringTrimLeft, Data_1, Data_1, 2
                        Hex = 0x%Hex%
                        DllCall("WriteFile","UInt",Handle,"UChar *",Hex,"UInt",1,"UInt *",UnusedVariable,"UInt",0)
                     }
            }
      DllCall("CloseHandle", "Uint", Handle)
      Return
}
Return

GuiClose:
   Gui, cancel ; Hide the window
   Return

TrayClick:
   GuiControlGet, IsVisible, Visible
   if IsVisible
      Gui, Cancel
   else
      Gui, Show
   Return

; End of Alarm Clock Program Activation Script