;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Jack Dunning, ceeditor@computoredge.com
;
; Script Function: Barebones To-Do List App
; This is the color version of ToDoList.ahk from the AutoHotkey column dated April 31, 2014	
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
OnExit, UpdateFile

Gui, default
Gui +AlwaysOnTop +Resize
Gui, Add, ListView, sort r10 checked -readonly vMyListView gMyListView AltSubmit, Items To Do 
Gui, Add, Button, section gAddItem,Add to list
Gui, Add, Edit, ys vNewItem w180 , <Enter New Item Here>

;LV_ModifyCol(2, 0)

SelectedRow := 0

IfExist, ToDoList.txt
{
Loop, Read, ToDoList.txt
  {
  If (A_index = 1 and SubStr(A_LoopReadLine, 1, 1) = "x")
     {
       WinPos := A_LoopReadLine
       If Substr(WinPos, 2, 1) = "-"
         WinPos := "x600 y200 w360 h220"

       Continue
     }
  If SubStr(A_LoopReadLine, 1, 1) = "*"
    {
     StringTrimLeft, CheckedText, A_LoopReadLine, 1
     LV_Add("Check", CheckedText,A_Index-1)
    }
  Else
     LV_Add("", A_LoopReadLine,A_Index-1)
  }

}



LV_ModifyCol(1,"AutoHdr")

Menu, MyContextMenu, Add, Edit, EditItem
Menu, MyContextMenu, Add, Delete, DeleteItem
Menu, Tray, Add, Show To Do List, ShowTodo


IfExist, ToDoList.txt
  {
     Gui, Show, %WinPos% , To Do List
  }
Else
  {
     WinGetPos,X1,Y1,W1,H1,Program Manager
     X2 := W1-300
     Gui, Show, x%x2% y50 , To Do List
  }

LV_ColorInitiate() ; (Gui_Number, Control) - defaults to: (1, SysListView321)
SetColor()

 
Hotkey, ^!t, ShowTodo
Return

ShowTodo:
  Gui, Show,, To Do List
  LV_ColorInitiate()
  SetColor()
Return

MyListView:
;  GUI, +LastFound
  HighlightRow := A_EventInfo
  If A_GuiEvent = e
    UpdateFile()
  If (A_GuiEvent = "I") and (InStr(ErrorLevel, "C", true))
        LV_ColorChange(HighlightRow, "0x660000", "0xCC99FF") 
  If (A_GuiEvent = "I") and (InStr(ErrorLevel, "c", true))
        LV_ColorChange(HighlightRow, "0x000000", "0xFFFFFF") 
;  MsgBox, %A_GuiEvent% %ErrorLevel%
Return

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
if A_GuiControl <> MyListView  ; Display the menu only for clicks inside the ListView.
    return

  LV_GetText(EditText, A_EventInfo) 
; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show , %A_GuiX%, %A_GuiY%
return


DeleteItem:  ; The user selected "Clear" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.

Loop
{
    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
    ; subtract 1 so that the search includes the same row number that was previously
    ; found (in case adjacent rows are selected):
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_Delete(RowNumber)  ; Clear the row from the ListView.
}
UpdateFile()
SetColor()

return

AddItem:
  Gui, Submit, NoHide

If SelectedRow = 0
{
  LV_Add("", trim(NewItem))
}
else
{
  LV_Modify(SelectedRow,"",Trim(NewItem))
  SelectedRow := 0
  GuiControl, ,Button1, Add to list
}
  UpdateFile()
  LV_ModifyCol(1,"AutoHdr")

  SetColor()

Return

EditItem:
  SelectedRow := LV_GetNext()
  GuiControl, ,Edit1, %EditText%
  GuiControl, ,Button1, Update
Return

UpdateFile:
  DetectHiddenWindows On
  UpdateFile()
  ExitApp
Return

GuiSize:  ; Expand or shrink the ListView in response to the user's resizing of the window.
if A_EventInfo = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the ListView to match.
GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 40)
GuiControl, Move, Button1, % "y" . (A_GuiHeight - 30) 
GuiControl, Move, Edit1, % "y" . (A_GuiHeight - 30) . "W" . (A_GuiWidth - 90)


Return

UpdateFile()
  {
    FileDelete, ToDoList.txt
    WinGetPos, X, Y, Width, Height, To Do List
    Width -= 16
    Height -= 38
    FileAppend, x%x% y%y% w%Width% h%Height% `n, ToDoList.txt
    Loop % LV_GetCount()
     {
       Gui +LastFound
       SendMessage, 4140, A_Index - 1, 0xF000, SysListView321 
       IsChecked := (ErrorLevel >> 12) - 1
       If IsChecked
        {
          LV_GetText(Text, A_Index)
          FileAppend, *%Text% `n, ToDoList.txt
        }
         else
        {
          LV_GetText(Text, A_Index)
          FileAppend, %Text% `n, ToDoList.txt
        }
      }
   }

SetColor() {
  Loop, % LV_GetCount()
  {
       SendMessage, 4140, A_Index - 1, 0xF000, SysListView321 
       IsChecked := (ErrorLevel >> 12) - 1
       If IsChecked
         LV_ColorChange(A_Index, "0x660000", "0xCC99FF")
       Else
         LV_ColorChange(A_Index, "0x000000", "0xFFFFFF") 
 
  }
}

; These are the functions that change the row colors. 
; I only changed WM_NOTIFY( p_w, p_l, p_m ) for this app

LV_ColorInitiate(Gui_Number=1, Control="") ; initiate listview color change procedure 
{ 
  global hw_LV_ColorChange 
  If Control =
    Control =SysListView321
  Gui, %Gui_Number%:+Lastfound 
  Gui_ID := WinExist() 
  ControlGet, hw_LV_ColorChange, HWND,, %Control%, ahk_id %Gui_ID% 
  OnMessage( 0x4E, "WM_NOTIFY" ) 
} 

LV_ColorChange(Index="", TextColor="", BackColor="") ; change specific line's color or reset all lines
{ 
  global
  If Index = 
    Loop, % LV_GetCount() 
      LV_ColorChange(A_Index) 
  Else
    { 
    Line_Color_%Index%_Text := TextColor 
    Line_Color_%Index%_Back := BackColor 
   WinSet, Redraw,, ahk_id %hw_LV_ColorChange% 
    } 
}



WM_NOTIFY( p_w, p_l, p_m )
{ 
  local  draw_stage, Current_Line, Index
  if ( DecodeInteger( "uint4", p_l, 0 ) = hw_LV_ColorChange ) { 
      if ( DecodeInteger( "int4", p_l, 8 ) = -12 ) {                            ; NM_CUSTOMDRAW 
          draw_stage := DecodeInteger( "uint4", p_l, 12 ) 
          if ( draw_stage = 1 )                                                 ; CDDS_PREPAINT 
              return, 0x20                                                      ; CDRF_NOTIFYITEMDRAW 
          else if ( draw_stage = 0x10000|1 ){                                   ; CDDS_ITEM 
              Current_Line := DecodeInteger( "uint4", p_l, 36 )+1 
;              LV_GetText(Index, Current_Line, 2) 
              If (Line_Color_%Current_Line%_Text != ""){ 
                  EncodeInteger( Line_Color_%Current_Line%_Text, 4, p_l, 48 )   ; foreground 
                  EncodeInteger( Line_Color_%Current_Line%_Back, 4, p_l, 52 )   ; background 
                } 
            } 
        } 
    } 
} 

DecodeInteger( p_type, p_address, p_offset, p_hex=true )
{ 
  old_FormatInteger := A_FormatInteger 
  ifEqual, p_hex, 1, SetFormat, Integer, hex 
  else, SetFormat, Integer, dec 
  StringRight, size, p_type, 1 
  loop, %size% 
      value += *( ( p_address+p_offset )+( A_Index-1 ) ) << ( 8*( A_Index-1 ) ) 
  if ( size <= 4 and InStr( p_type, "u" ) != 1 and *( p_address+p_offset+( size-1 ) ) & 0x80 ) 
      value := -( ( ~value+1 ) & ( ( 2**( 8*size ) )-1 ) ) 
  SetFormat, Integer, %old_FormatInteger% 
  return, value 
} 

EncodeInteger( p_value, p_size, p_address, p_offset )
{ 
  loop, %p_size% 
    DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) ) 
} 


#IfWinActive, To Do List
^a::LV_Modify(0,"Select")
#IfWinActive 	