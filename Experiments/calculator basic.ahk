#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.




file = C:\Users\abhir\Desktop\Scripts\backup.ahk             ; any unused filename
Gui Add, ComboBox, X0 Y0 H1 W300 vExpr
Gui Add, Button, Default, OK     ; button activated by Enter, Gui Show cuts it off
Gui -Caption +Border             ; small window w/o title bar

!#z::
   Gui Show, H24 W277            ; cut off unnecessary parts
Return

GuiEscape:
   Gui Show, Hide                ; keep data for next run
Return

ButtonOK:
   GuiControlGet Expr,,Expr      ; get Expr from ComboBox
   GuiControl,,Expr,%Expr%       ; write Expr to internal ComboBox list
   FileDelete %file%             ; delete old temporary file -> write new
   FileAppend #NoTrayIcon`nFileDelete %file%`nFileAppend `% %Expr%`, %file%, %file%
   RunWait %A_AhkPath% %file%    ; run AHK to execute temp script, evaluate expression
   FileRead Result, %file%       ; get result
   FileDelete %file%
   GuiControl,,Expr,%Result%     ; write Result to internal ComboBox list
   N += 2                        ; count lines
   GuiControl Choose,Expr,%N%    ; show Result
Return