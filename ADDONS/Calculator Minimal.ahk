#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



file = C:\Users\abhir\Desktop\Scripts\backupcalc.ahk

Menu Tray, Icon, Shell32.dll, 97
IntMode = Decimal                ; default output mode
Prec = 0.6                       ; default floating point precision
Gui Add, ComboBox, X0 Y0 W300 vExpr
Gui Add, Button, Default, OK     ; button activated by Enter, Gui Show cuts it off
Gui Add, Button, gIntM, &Binary  ; Alt-B: binary integer output
Gui Add, Button, gIntM, &Decimal ; Alt-D: decimal integer output
Gui Add, Button, gIntM, &Hex     ; Alt-H: hex integer output
Gui Add, Button,      , &Eng     ; Alt-E: On/Off engineering mode float output
Gui Add, Button, gPrec, &0
Loop 9                           ; Alt-number buttons for setting precision
   Gui Add, Button, gPrec, &%A_Index%
Gui -Caption +Border             ; small window w/o title bar

!#z::
   Gui Show, H24 W277            ; calculator window: cut off unnecessary parts
Return

GuiEscape:
   Gui Show, Hide                ; hide, keep data for next run
Return

IntM:                            ; setting decimal/hex/binary Integer output Mode
   StringTrimLeft IntMode, A_GuiControl, 1
   TrayTip,,%IntMode%
Return

ButtonEng:                       ; toggle engineering mode
   EngMode := !EngMode
   TrayTip,,Eng-Mode = %EngMode%
Return

Prec:                            ; set floating point precision
   StringTrimLeft p, A_GuiControl, 1
   If (A_TickCount > Tick0+999)  ; long delay = set precision to entered digit
        pp = %p%
   Else pp = %pp%%p%             ; short delay = append digit to precision
   TrayTip,,Precision = %pp%     ; TrayTip w/o "0."
   Prec = 0.%pp%
   Tick0 = %A_TickCount%
Return

ButtonOK:                        ; calculate
   GuiControlGet Expr,,Expr      ; get Expr from ComboBox
   GuiControl,,Expr,%Expr%       ; append Expr to internal ComboBox list
   StringReplace Expr,Expr,`;,`n,All
   StringGetPos Last, Expr, `n, R1
   StringLeft Pre, Expr, Last    ; separate Pre-amble code and Expr to evaluate
   StringTrimLeft Expr,Expr,Last+1
   FileDelete %file%             ; delete old temporary file -> write new
   FileAppend #NoTrayIcon`nSetFormat Float`,%Prec%`nFileDelete %file%`n%pre%`nFileAppend `% %Expr%`,%file%,%file%
   RunWait %A_AhkPath% %file%    ; run AHK to execute temp script, evaluate expression
   FileRead Result, %file%       ; get result
   FileDelete %file%
   GuiControl,,Expr,% OM(Result) ; append Result to internal ComboBox list
   N += 2                        ; count lines
   GuiControl Choose,Expr,%N%    ; show Result
Return

OM(x) {                          ; format x according to the Output Mode
   Global IntMode, EngMode, Prec
   If x is not Integer
   {
      SetFormat Float, %Prec%    ; used precision
      If (!EngMode OR x+0 = "" or x = 0)
          Return x+0
      Loop                       ; engineering mode
         If (Abs(x) < 1) {
            e--
            x *= 10              ; move the decimal point
         } Else If (Abs(x) >= 10) {
            e++
            x *= .1
         } Else Break            ; normalized if 1 <= x < 10
      Return x chr(101+e-e) e    ; 1.23e4, no "e" if e = ""
   }
   IfEqual IntMode,Binary, {     ; binary integer output
      Loop {
         b := x&1 b
         x := x>>1
         If (x = x>>1)           ; negative x: leading 11..1 omitted
            Break
      }
      Return b
   }
   SetFormat Integer,%IntMode%   ; Decimal, Hex
   Return x+0
}