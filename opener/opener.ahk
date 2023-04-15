; The Operner
; Patrick Lannigan
; v.2.3.1
; requires at least AutoHotkey v1.0.47.01
SetWorkingDir, %A_ScriptDir%
SetFormat, Float, 0.0
logging = 0 ; 0 for Off, 1 for On
SetTitleMatchMode, 2 ; Window Title contain WinTitle anywhere inside it to be a match
DetectHiddenWindows, On ; used to find windows that are minimized to tray
/*
[first_time]
first_time=0
remind_none_radio=1
*/
NoMainGui = 1
IniRead, FirstTime, %A_ScriptFullPath%, first_time, first_time, 1
IniRead, RemindNoneRadio, %A_ScriptFullPath%, first_time, remind_none_radio, 1
version = v.2.3.1
configFileName = opener.ini
tempFileName = opener.tmp
sampleFileName = sample.ini

string = -------------------------------------------------------------`n`nversion=%version%
LogToFile(string)
openerExists := FileExist(configFileName)
If (FirstTime)
{
  IniWrite, 0, %A_ScriptFullPath%, first_time, first_time
  string =
  (LTrim
  Welcome to The Opener.
  Since this is the first time running the script,
  you will need to setup the items you would like to launch.
  Would you like to pre-load the sample settings?
  If you are updating from a previous version and already have an
  configuration ready, choose No.
  
  If you need help:
  Read README.txt or
  Contact me at fes421@yahoo.com with questions.
  )
  MsgBox, 68, The Opener, %string%
  IfMsgBox Yes
  {
    If (openerExists)
    {
      MsgBox, 68, The Opener, A configuration file already exists with the default file name.`nDo you want to overwrite it?
      IfMsgBox, Yes
      {
        FileCopy, %sampleFileName%, %configFileName%, 1
        string = First Time`nSample Loaded - Overwrite existing configuration 
      }
      Else
      {
        string = First Time`nExisting Configuration Loaded
      }
    }
    Else
    {
      FileCopy, %sampleFileName%, %configFileName%, 1
      string = First Time`nSample Loaded
    }
    LogToFile(string)
    GoTo, RunEditSteup
  }
}
string = 0=%0%`n1=%1%
LogToFile(string)
If 0 = 1 ;if there is an argument
{
  configFileName = %1% ; set equal to argument
  string = Load passed configuration:%configFileName%
  LogToFile(string)
}
Else
{
  fileList := ""
  fileCount := buildFileList(fileList)
  If (fileCount == 1)
  {
    configFileName := fileList
    string = Only one configuration found:%configFileName%
    LogToFile(string)
  }
  Else If (fileCount != 0)
  {
    GoTo, SelectConfigFile
  }
}
ConfigFileNameSet:
openerExists := FileExist(configFileName)
If (!openerExists)
{
  string =
  (LTrim
  Your configuration file could not be found.
  
  You will be taken to setup what objects you would like to launch.
  )
  MsgBox, 48, The Opener, %string%
  string = Configuration not found
  LogToFile(string)
  GoTo, RunEditSteup
}
CheckGroupStructure()
BuildMainGui:
Gui, 1:Default
Gui, Destroy
NoMainGui = 0
fStyle = s9
fFace = Arial
fColor = 0x000000
pad_w = 28
Gui, Font, %fStyle% c%fColor%, %fFace%
; --------------------------------------------------
;     "Opener" Gui
;       Gui Number: 1
IniRead, ControlCount, %configFileName%, structure, control_count, 0
IniRead, GroupCount, %configFileName%, structure, group_count, 0
IniRead, MaxItemsPerCol, %configFileName%, structure, max_items_per_col, 10
If MaxItemsPerCol IS NOT INTEGER
{
  MaxItemsPerCol := 10
  IniWrite, %MaxItemsPerCol%, %configFileName%, structure, max_items_per_col
}
;Load group info
Loop, %GroupCount%
{
  IniRead, Group%A_Index%Cols, %configFileName%, structure, group%A_Index%_cols, 1
  IniRead, Group%A_Index%Label, %configFileName%, structure, group%A_Index%_name, Group %A_Index%
  IniRead, Group%A_Index%Type, %configFileName%, structure, group%A_Index%_type, Checkbox
}
If (ControlCount != 0)
{
  ;Load control info
  Loop, %ControlCount%
  {
    IniRead, GroupID, %configFileName%, control_%A_Index%, item_group, ---
    Group%GroupID%_0++
    ControlName := "Group" . GroupID . "_" . Group%GroupID%_0
      
    IniRead, %ControlName%Name, %configFileName%, control_%A_Index%, item_name, ---
    IniRead, %ControlName%IsDefault, %configFileName%, control_%A_Index%, item_is_default, ---
    %ControlName%ID := A_Index
    %ControlName%Width := GetTextSize(%ControlName%Name, fStyle "," fFace, 0 , pad_w)
  }
  GroupID := "", CurrentGroup := 0, NewGroup := 0, MostItemsPerCol := 0
  ItemsThisCol := 0, WidestThisCol := 0, GroupsThisCol := 1, MostGroupsPerCol := 0, MostItemsPerGroupCol := 0
  Loop, %GroupCount%
  {
    ItemID := 0, ItemRow := 0, NewGroup := 1, CurrentGroup++
    ItemsInGroup := Group%CurrentGroup%_0
    If Not ItemsInGroup
      ItemsInGroup = 0
    string := "CurrentGroup = " . CurrentGroup . "`nItemsInGroup = " . ItemsInGroup
    LogToFile(string)
    ColForGroup := Group%CurrentGroup%Cols
      ; Calculate Items/Col
    ItemsPerCol := Ceil(ItemsInGroup / ColForGroup)
    tempvar := ItemsInGroup / ItemsPerCol
    If ( tempvar == Round(tempvar) AND tempvar != ColForGroup) ; Adjust for blank last column
    {
      ColForGroup := tempvar
      Group%CurrentGroup%Cols := ColForGroup
    }
    string = ColForGroup := %ColForGroup%`nItemsPerCol := %ItemsPerCol%
    LogToFile(string)
  
    tempMaxColWidth := 0, tempTotalGroupWidth := 0, Col := 1, GroupType := Group%A_Index%Type
    Loop, %ItemsInGroup%
    {
      ItemID++, ItemRow++
      string := "Group" . CurrentGroup . "_" . ItemID . "Width = " . Group%CurrentGroup%_%A_Index%Width
      LogToFile(string)
      If (Group%CurrentGroup%_%ItemID%Width > tempMaxColWidth)
        tempMaxColWidth := Group%CurrentGroup%_%ItemID%Width
      string = tempMaxColWidth = %tempMaxColWidth%
      LogToFile(string)
      If (ItemRow == ItemsPerCol)
      {
        ;start new col
        tempTotalGroupWidth += tempMaxColWidth
        Group%CurrentGroup%_Col%Col%Width := tempMaxColWidth
        string = Col = %Col%`nGroup%CurrentGroup%_Col%Col%Width := %tempMaxColWidth%`ntempTotalGroupWidth := %tempTotalGroupWidth%
        LogToFile(string)
        tempMaxColWidth := 0, ItemRow:= 0, Col++
      }
    }
    If (!Group%CurrentGroup%_Col%Col%Width AND Col <= ColForGroup)
    {
      ;set value for last col if col didn't end exactly at ItemsPerCol
      tempTotalGroupWidth += tempMaxColWidth
      Group%CurrentGroup%_Col%Col%Width := tempMaxColWidth
      string := "------Col = " . Col . "`n------Group" . CurrentGroup . "_Col" . Col . "Width := " . Group%CurrentGroup%_Col%Col%Width
      string .= "`n------tempTotalGroupWidth :=" . tempTotalGroupWidth
      LogToFile(string)
    }
  
    GroupLabel := Group%A_Index%Label
    string = ItemsInGroup = %ItemsInGroup%|ItemsThisCol = %ItemsThisCol%|MostItemsPerCol = %MostItemsPerCol%
    LogToFile(string)
    If (ItemsInGroup == 0)
    {
      tempTotalGroupWidth := GetTextSize(GroupLabel, fStyle "," fFace, 0 , pad_w)
      string = tempTotalGroupWidth = %tempTotalGroupWidth%
      LogToFile(string)
    }
    If (CurrentGroup == 1)
    {
      Options = x10
    }
    Else If (ItemsPerCol + ItemsThisCol <= MaxItemsPerCol)
    {
      GroupsThisCol++
      Options := "xp-" . CalculateOffset() + 10
      string = ItemsThisCol = %ItemsThisCol%
      LogToFile(string)
    }
    Else
    {
      ;start a new column of groups
      Options := "xp+" . WidestThisCol - CalculateOffset() + 15
      If (MostItemsPerCol < ItemsThisCol)
      {
        MostItemsPerCol := ItemsThisCol
        string = ItemsThisCol = %ItemsThisCol%
        LogToFile(string)
      }
      If (MostGroupsPerCol < GroupsThisCol)
      {
        MostGroupsPerCol := GroupsThisCol
        string = GroupsThisCol = %GroupsThisCol%
        LogToFile(string)
      }
      GroupsThisCol := 1, ItemsThisCol := 0, WidestThisCol := 0
    }
    If (ItemsThisCol == 0)
      Options .= " y10"
    Else
    {
      string := "OldItemsPerCol = " . OldItemsPerCol . "|OldItemRow = " . OldItemRow
      LogToFile(string)
      Options .= " yp+" . (OldItemsPerCol - OldItemRow + 1) * 25 + 10
    }
    Options .= " w" . tempTotalGroupWidth + 15 . " h" . (ItemsPerCol + 1) * 25
    string = Gui, Add, GroupBox, %Options%, %GroupLabel%
    LogToFile(string)
    Gui, Add, GroupBox, %Options%, %GroupLabel%
    ItemsThisCol += ItemsPerCol
    string = --Start Loop--CurrentGroup= %CurrentGroup%
    LogToFile(string)
    Col := 1, ItemID := 0, ItemRow := 0, OldColWidth := 0
    Loop, %ItemsInGroup%
    {
      ItemID++, ItemRow++
      ; Positioning
      string = ItemRow = %ItemRow%`nItemID = %ItemID%
      LogToFile(string)
      If (ItemID != 1 AND ItemRow == 1)
        Options := "xp+" . OldColWidth . " yp-" . (OldItemRow - 1) * 25
      Else If (NewGroup == 1)
      {
        Options := "xp+10 yp+20"
        NewGroup = 0
      }
      Else
        Options := "xp yp+25"
      ; Default to Selected?
      If (Group%CurrentGroup%_%ItemID%IsDefault == "Yes")
        Options .= " Checked"
      If (GroupType == "Radio")
      {
        ; Start a new group of Radios?
        If (ItemID == 1)
          Options .= " Group vGroup" . CurrentGroup
      }
      Else
      {
        Options .= " vGroup" . CurrentGroup . "CB" . ItemID
      }
      Value := Group%CurrentGroup%_%ItemID%Name
      Gui, Add, %GroupType%, %Options%, %Value%
      string = Gui, Add, %GroupType%, %Options%, %Value%
      LogToFile(string)
      OldItemRow = %ItemRow%
      If (ItemRow == ItemsPerCol)
      {
        string = OldColWidth := %OldColWidth%, Col=%Col%
        LogToFile(string)
        ItemRow := 0, OldColWidth := Group%CurrentGroup%_Col%Col%Width, Col++
        string = OldColWidth := %OldColWidth%, Col=%Col%
        LogToFile(string)
      }
      Group%CurrentGroup%_%ItemID%Name := "", Group%CurrentGroup%_%ItemID%IsDefault := ""
    }
    OldItemsPerCol = %ItemsPerCol%
    If (Col > ColForGroup)
      Col--
    If (ItemsInGroup == 0)
      tempWidth := GetTextSize(GroupLabel, fStyle "," fFace, 0 , pad_w + 15)
    Else
      tempWidth := tempTotalGroupWidth
    If (tempWidth > WidestThisCol)
      WidestThisCol := tempWidth
  }
  ; clean up variables
  Loop, %GroupCount%
  {
    CurrentGroup := A_Index
    Loop
    {
      If Group%CurrentGroup%_Col%A_Index%Width
        Group%CurrentGroup%_Col%A_Index%Width := ""
      Else
        Break
    }
  }
  If (MostItemsPerCol < ItemsThisCol)
    MostItemsPerCol := ItemsThisCol
  
  ItemRow := OldItemRow
  string = OldItemRow = %OldItemRow%`nGroupsThisCol = %GroupsThisCol%`nMostItemsPerCol = %MostItemsPerCol%`nMostGroupsPerCol = %MostGroupsPerCol%`n
  If (MostItemsPerCol == 0)
    MostItemsPerCol := ItemsThisCol
  If (MostGroupsPerCol == 0)
    MostGroupsPerCol := GroupCount
  If (ItemRow == ItemsPerCol) ; If last group ended on how many items it has per col
    ItemRow := 0 ; change ItemRow because is already accounted for in MostItemsPerCol - ItemsThisCol
  string .= "(" . MostItemsPerCol . "-" . ItemsThisCol . "+" . ItemRow . ") * 25 + (" . MostGroupsPerCol . "-" . GroupsThisCol . ") * 30 + 45`nItemRow = " . ItemRow
  LogToFile(string)
  Options := "x10 yp+" . (MostItemsPerCol - ItemsThisCol + ItemRow) * 25 + (MostGroupsPerCol - GroupsThisCol) * 30 + 45
  string = GroupCount = %GroupCount%`nGui Add, Button, %Options% w65 gRunOK, Ok`nGui Add, Button, xp+75 yp w65 gRunCancel, Cancel
  Gui Add, Button, %Options% w65 gRunOK, Ok
  Gui Add, Button, xp+75 yp w65 gRunCancel, Cancel
}
Else ; There are no radio groups or checkboxes 
{
  string = GroupCount = %GroupCount%`nThere are no radio groups or checkboxes setup.`nGui Add, Text, x10 y10, There are no radio groups or checkboxes setup. 
  string .= "Gui Add, Button, xp yp+30 w65 gRunCancel, Cancel"
  Gui Add, Text, x10 y10, There are no radio groups or checkboxes setup. 
  Gui Add, Button, xp yp+30 w65 gRunCancel, Cancel
}
string .= "`nGui Add, Button, xp+75 yp w65 gRunEditSteup, Edit Setup`nGui Add, Button, xp+75 yp gRunEditPositioning, Edit Positioning"
LogToFile(string)
Gui Add, Button, x10 yp+30 w65 gRunEditSteup, Edit Setup
Gui Add, Button, xp+75 yp gRunEditPositioning, Edit Positioning
Gui Add, Button, xp+110 yp gSelectConfigFileBuildList, Select Setup
Gui, Show, ,The Opener %version%
Return

RunOK:
Gui, Submit
string = `n`nOK PRESSED`nGroupCount = %GroupCount%
LogToFile(string)
Loop, %GroupCount%
{
  GroupType := Group%A_Index%Type
  string = (Group%A_Index%)`n  GroupType := %GroupType%
  LogToFile(string)
  If (GroupType == "Radio")
  {
    GroupID := Group%A_Index% ;ID number of selected option
    string = (Group%A_Index%)`n  GroupID := %GroupID%
    LogToFile(string)
    If (GroupID != 0 && GroupID != "")
    {
      string = Result := LoadData(Group%A_Index%_%GroupID%ID, 1)
      LogToFile(string)
      Result := LoadData(Group%A_Index%_%GroupID%ID, 1) 
      If (Result == -1)
        Continue
      Else If (Result == 0)
      {
        Gui, Show
        Return
      }
    }
  }
  Else
  {
    CurrentGroup := A_Index
    Loop, % Group%CurrentGroup%_0
    {
      string := "  Group" . CurrentGroup . "CB" . A_Index . " := " . Group%CurrentGroup%CB%A_Index%
      LogToFile(string)
      If (Group%CurrentGroup%CB%A_Index% AND !LoadData(Group%CurrentGroup%_%A_Index%ID))
      {
        Gui, Show
        Return
      }
    }
  }
}
ExitApp

GuiClose:
RunCancel:
ExitApp
Return
;     End "Opener" Gui
; --------------------------------------------------

; --------------------------------------------------
;     "Edit Items" Gui
;       Gui Number: 2

RunEditSteup:
Gui, +Disabled
Gui, 2:Default
Gui, +Resize +MinSize
If (NoMainGui)
  Gui, +Owner1  
Gui, Add, Text, x10 y7, Name
Gui, Add, Edit, xp yp+25 w120 h20 vItemName,
Gui, Add, Text, xp yp+55, Window Title
Gui, Add, Edit, xp yp+25 w120 h20 vItemWinTitle, 
Gui, Add, Text, xp+150 yp-105, Default
Gui, Add, Checkbox, xp yp+25 vItemIsDefault, Yes
Gui, Add, Text, xp+70 yp-25, Minimize
Gui, Add, Checkbox, xp yp+25 vItemMinimize, Yes
Gui, Add, Text, xp-70 yp+55, Location
Gui, Add, Button, xp+75 yp gSelectLoc, Select
Gui, Add, Edit, xp-75 yp+25 w120 h20 ReadOnly -Tabstop vItemLoc,
Gui, Add, Text, xp+160 yp-105, Group

IniRead, GroupCount, %configFileName%, structure, group_count, 1
select =
Loop,  %GroupCount%
{
  select .= A_Index . "|"
  If (A_Index = 1)
    select .= "|" 
}

Gui, Add, DropDownList, xp yp+20 w40 gGroupSelectionChange vItemGroup, %select%
Gui, Add, Text, xp+50 yp+5 w50 vItemType, %Group1Type%
Gui, Add, Button, xp-50 yp+25 gEditGroups, Edit Groups
Gui, Add, Text, xp-5 yp+30, Priority
Gui, Add, DropDownList, xp yp+25 w75 +R5 vItemPriority, High|Above Normal|Normal||Below Normal|Low
Gui, Add, Text, xp+130 yp-105, Run Code
Gui, Add, CheckBox, xp yp+25 gEditRunCode vItemRunCode, Yes
Gui, Add, Text, xp+50 yp vScriptCountText, Script Count: 0
Gui, Add, Button, xp-50 yp+25 Disabled gSelectRunCode vSelectRunCode, Select
Gui, Add, Text, xp yp+35, Command Line Arguments
Gui, Add, Edit, xp yp+25 w130 h20 vItemCmdArgs,
Gui, Add, Button, xp-400 yp+60 w125 h30 gEditSelected, Edit Selected
Gui, Add, Button, xp+175 yp w125 h30 gRemoveSelected, Remove Selected
Gui, Add, Button, xp+175 yp w125 h30 gSaveEdits, Save Edits
names = Name|Window Title|Location|Group|Default|Minimize|Priority|Arguments|Run Code|Script Count
Gui, Add, ListView, xp-385 yp+50 w575 h180 Grid NoSort vLV_Items, %names%
Gui, Add, Button, xp+30 yp+190 w125 h30 gMoveSelected, Move Selected Up
Gui, Add, Button, xp+175 yp w125 h30 gMoveSelected, Move Selected Down
Gui, Add, Button, xp+175 yp w125 h30 g2GuiClose, Save && Close

;Fill ListView
FileCopy, %configFileName%, %tempFileName%, 1 
IniRead, ItemCount, %configFileName%, structure, control_count, 0
Loop, %ItemCount%
{
  IniRead, tempName, %configFileName%, Control_%A_Index%, item_name,
  IniRead, tempWinTitle, %configFileName%, Control_%A_Index%, item_win_title,
  IniRead, tempLoc, %configFileName%, Control_%A_Index%, item_loc,
  IniRead, tempGroup, %configFileName%, Control_%A_Index%, item_group,
  IniRead, tempIsDefault, %configFileName%, Control_%A_Index%, item_is_default,
  IniRead, tempMinimize, %configFileName%, Control_%A_Index%, item_minimize,
  IniRead, tempPriority, %configFileName%, Control_%A_Index%, item_priority,
  IniRead, tempCmdArgs, %configFileName%, Control_%A_Index%, item_arguments,
  IniRead, tempRunCode, %configFileName%, Control_%A_Index%, item_run_code,
  IniRead, tempScriptCount, %configFileName%, Control_%A_Index%, item_script_count,
  Gui, ListView, LV_Items
  LV_Add("", tempName, tempWinTitle, tempLoc, tempGroup, tempIsDefault, tempMinimize, tempPriority 
    , tempCmdArgs, tempRunCode, tempScriptCount)
  IniDelete, %configFileName%, Control_%A_Index%
}
tempName := "", tempWinTitle := "", tempLoc := "", tempGroup := "", tempIsDefault := ""
tempMinimize := "", tempPriority := "", tempCmdArgs := "", tempRunCode := "", tempScriptCount := "", select := ""
ResizeLV()

Gui, Show, , Edit Items
ItemId := LV_GetCount() + 1 
ItemScriptCount = 0
ItemEdit = 0
Return

2GuiSize:
Anchor("LV_Items", "wh")
Anchor("Move Selected Up", "y")
Anchor("Move Selected Down", "y")
Anchor("Save && Close", "y")
Return

SelectLoc:
Gui, +OwnDialogs
FileSelectFile, Loc, 3, ,Select File...
If (ErrorLevel == 0)
  GuiControl, , ItemLoc, %Loc%
Return

GroupSelectionChange:
GuiControlGet, theItemGroup, , ItemGroup
GuiControl, , ItemType, % Group%theItemGroup%Type
theItemGroup := ""
Return

EditRunCode:
Gui, Submit, NoHide
ItemScriptCount = 0
If ItemRunCode
  GuiControl, Enable, SelectRunCode
Else
  GuiControl, Disable, SelectRunCode
GuiControl, , ScriptCountText, Script Count: %ItemScriptCount%
Return

EditSelected:
NewItemId := LV_GetNext()
If (NewItemId != 0)
{
  ItemId := NewItemId 
  LV_GetText(theItemName, ItemId, 1)
  LV_GetText(theItemWinTitle, ItemId, 2)
  LV_GetText(theItemLoc, ItemId, 3)
  LV_GetText(theItemGroup, ItemId, 4)
  LV_GetText(theItemIsDefault, ItemId, 5)
  LV_GetText(theItemMinimize, ItemId, 6)
  LV_GetText(theItemPriority, ItemId, 7)
  LV_GetText(theItemCmdArgs, ItemId, 8)
  LV_GetText(theItemRunCode, ItemId, 9)
  LV_GetText(theItemScriptCount, ItemId, 10)
  If theItemScriptCount Is Not Integer
    theItemScriptCount = 0
  If theItemGroup Is Not Integer
    theItemGroup = 1
  GuiControl, , ItemName, %theItemName%
  GuiControl, , ItemWinTitle, %theItemWinTitle%
  GuiControl, , ItemLoc, %theItemLoc%
  GuiControl, Choose, ItemGroup, %theItemGroup%
  GuiControl, , ItemType, % Group%theItemGroup%Type
  GuiControl, , ItemCmdArgs, %theItemCmdArgs%
  
  If (theItemIsDefault == "Yes")
    GuiControl, , ItemIsDefault, 1
  Else
    GuiControl, , ItemIsDefault, 0
  If (theItemMinimize == "Yes")
    GuiControl, , ItemMinimize, 1
  Else
    GuiControl, , ItemMinimize, 0
  If (theItemPriority == "High")
    GuiControl, Choose, ItemPriority, 1
  Else If (theItemPriority == "Above Normal")
    GuiControl, Choose, ItemPriority, 2
  Else If (theItemPriority == "Below Normal")
    GuiControl, Choose, ItemPriority, 4
  Else If (theItemPriority == "Low")
    GuiControl, Choose, ItemPriority, 5
  Else
    GuiControl, Choose, ItemPriority, 3
  If (theItemRunCode == "Yes")
  {
    GuiControl, , ItemRunCode, 1
    GuiControl, Enable, SelectRunCode
  }
  Else
  {
    GuiControl, , ItemRunCode, 0
    GuiControl, Disable, SelectRunCode
  }
  If theItemScriptCount Is Not Integer
    theItemScriptCount = 0
  GuiControl, , ScriptCountText, Script Count: %theItemScriptCount%
}
theItemName := "", theItemWinTitle := "", theItemLoc := "", theItemGroup := "", theItemIsDefault := ""
theItemMinimize := "", theItemPriority := "", theItemCmdArgs := "", theItemRunCode := "", theItemScriptCount := ""
Return

SaveEdits:
Gui, Submit, NoHide
;Name|Window Title|Location|Group|Default|Minimize|Priority|Arguments|Run Code|Script Count
If (ItemName == "")
   MsgBox, , Missing Data, Name can not be blank.
Else
{
  WasError = 0
  ; Check for more than one Default in the Radio Group
  If (Group%ItemGroup%Type == "Radio" AND ItemIsDefault)
  {
    Loop, % LV_GetCount()
    {
      If (A_Index != ItemID)
      {
        LV_GetText(tempGroup, A_Index, 4)
        If (tempGroup == ItemGroup)
        {
          LV_GetText(tempIsDefault, A_Index, 5)
          If (tempIsDefault == "Yes")
          {
            WasError = 1
            Msgbox, 16, Error,
            (LTrim
            There are presently two Radio elements set as Default for Group %ItemGroup%.
            Please set only one to be the Default.
            )
          }
        }
      }
    }
  }
  If (ItemLoc == "")
  {
    If (Group%ItemGroup%Type != "Radio" )
    {
      WasError = 1;
      MsgBox, 16, Error, Checkbox items must be given a file location.
    }
    Else If (RemindNoneRadio AND MsgBoxYesNo("You did not enter a file Location.`nIf you are intending to use this as a Radio that "
      . "will not run/open any program/file, make sure that the Window Title is set to 'None' (no quotes).`n`nWould you like this "
      . "to be the last time you are reminded of this?"))
    {
      RemindNoneRadio:= 0
      IniWrite, 0, %A_ScriptFullPath%, first_time, remind_none_radio
    }
  }
  If (!WasError)
  {
    If ItemIsDefault
      ItemIsDefault = Yes
    Else
      ItemIsDefault = No
    If ItemMinimize
      ItemMinimize = Yes
    Else
      ItemMinimize = No
    If ItemRunCode
      ItemRunCode = Yes
    Else
      ItemRunCode = No
    
    If ItemScriptCount Is Not Integer
      ItemScriptCount = 0
    Gui, ListView, LV_Items
    If (LV_GetCount() < ItemId)
      LV_Add("", ItemName, ItemWinTitle, ItemLoc, ItemGroup, ItemIsDefault, ItemMinimize, ItemPriority, ItemCmdArgs
        , ItemRunCode, ItemScriptCount)
    Else
      LV_Modify(ItemID, "", ItemName, ItemWinTitle, ItemLoc, ItemGroup, ItemIsDefault, ItemMinimize
        , ItemPriority, ItemCmdArgs, ItemRunCode, ItemScriptCount)
    ResizeLV()
    ; Set back to defaults
    GuiControl, , ItemName,
    GuiControl, , ItemWinTitle,
    GuiControl, , ItemLoc,
    GuiControl, Choose, ItemGroup, 1
    GuiControl, , ItemType, % Group1Type
    GuiControl, , ItemIsDefault, 0
    GuiControl, , ItemMinimize, 0
    GuiControl, Choose, ItemPriority, 3
    GuiControl, , ItemCmdArgs,
    GuiControl, , ItemRunCode, 0
    GuiControl, Disable, SelectRunCode
    GuiControl, , ScriptCountText, Script Count: 0
    ItemID := LV_GetCount() +1
    ItemEdit = 1
  }
}
Return

RemoveSelected:
if (InStr(A_GuiControl,"Remove Selected") != 0)
{
  theLV = LV_Items
  ItemEdit = 1
}
Else
{
  theLV = LV_Groups
  GroupEdit = 1
}
Gui, ListView, %theLV%
Row := LV_GetNext()
If (Row1 != 0)
  LV_Delete(Row)
If (theLV = "LV_Groups")
{
  GroupID := LV_GetCount()
  ; Shift lines up if row was not last group
  If (Row <= GroupID)
  {
    Loop, %GroupID%
    {
      LV_Modify(A_Index, "Col1", A_Index)
    }
  }
  GroupID++
}
Else
  ItemID := LV_GetCount() + 1
Return

MoveSelected:
if (InStr(A_GuiControl,"Move Selected") != 0)
{
  StringReplace, Direction, A_GuiControl, Move%A_SPACE%Selected%A_SPACE%,
  theLV = LV_Items
  ItemEdit = 1
  ExcludedCols := ""
}
Else
{
  StringReplace, Direction, A_GuiControl, Move%A_SPACE%,
  theLV = LV_Groups
  GroupEdit = 1
  ExcludedCols = 1
}
Gui, ListView, %theLV%
Row1 := LV_GetNext()
If (Row1 != 0)
{
  If (Direction == "Up")
    Row2 := Row1 - 1
  Else
    Row2 := Row1 + 1
  SwitchLVRows(theLV, Row1, Row2, ExcludedCols)
}
Return

2GuiClose:
If (ItemEdit == 0 OR ( A_GuiControl != "Save && Close" AND (MsgBoxYesNo("You have made edits that have not been saved!`n"
      . "Would you like to save them?", "Cancel Edits?") == 0) ))
{
  FileMove, %tempFileName%, %configFileName%, 1
}
Else
{
  GoSub, FinalizeItems
  FileDelete, %tempFileName%
}
ItemEdit = 0
Gui, Destroy
ClearMainGuiVars()
GoTo, BuildMainGui
Return

FinalizeItems:
Gui, ListView, LV_Items
Items := LV_GetCount()
GroupList =
Loop, %Items%
{
  ItemID := A_Index
  LV_GetText(theItemName, ItemID, 1)
  LV_GetText(theItemWinTitle, ItemID, 2)
  LV_GetText(theItemLoc, ItemID, 3)
  LV_GetText(theItemGroup, ItemID, 4)
  LV_GetText(theItemIsDefault, ItemID, 5)
  LV_GetText(theItemMinimize, ItemID, 6)
  LV_GetText(theItemPriority, ItemID, 7)
  LV_GetText(theItemCmdArgs, ItemID, 8)
  LV_GetText(theItemRunCode, ItemID, 9)
  LV_GetText(theItemScriptCount, ItemID, 10)
  
  string = TheItemGroup = %theItemGroup%
  LogToFile(string)
  If theItemGroup Not In %GroupList%
  {
    GroupList .= "," . theItemGroup
    string = %theItemGroup% added to GroupList |%GroupList%|
    LogToFile(string) 
  }
  If (InStr(GroupList, ",") == 1)
    StringTrimLeft, GroupList, GroupList, 1
  
  IniWrite, %theItemName%, %configFileName%, Control_%ItemID%, item_name
  IniWrite, %theItemWinTitle%, %configFileName%, Control_%ItemID%, item_win_title
  IniWrite, %theItemLoc%, %configFileName%, Control_%ItemID%, item_loc
  IniWrite, %theItemGroup%, %configFileName%, Control_%ItemID%, item_group
  IniWrite, %theItemIsDefault%, %configFileName%, Control_%ItemID%, item_is_default
  IniWrite, %theItemMinimize%, %configFileName%, Control_%ItemID%, item_minimize
  IniWrite, %theItemPriority%, %configFileName%, Control_%ItemID%, item_priority
  ; IniRead drops outside quotes, ex: "some" "text" -> some" "text
  ; so wrap with double quotes if needed
  If (RegExMatch(theItemCmdArgs, "^"".*""$"))
  	theItemCmdArgs = "%theItemCmdArgs%"
  IniWrite, %theItemCmdArgs%, %configFileName%, Control_%ItemID%, item_arguments
  IniWrite, %theItemRunCode%, %configFileName%, Control_%ItemID%, item_run_code
  If (theItemRunCode = "No")
    IniDeleteMatch(configFileName, "Control_" . ItemID, "script_\d+")
  IniWrite, %theItemScriptCount%, %configFileName%, Control_%ItemID%, item_script_count
  If (theItemScriptCount != 0)
  {
    LogToFile("start script finding|count " . theItemScriptCount)
    ;script names need to be copied over from the temp file if SelectRunCode is never run for the item
    Loop, %theItemScriptCount%
    {
      IniRead, tempScriptName, %configFileName%, Control_%ItemID%, script_%A_Index%, SCRIPT_NOT_FOUND
      LogToFile("copied from config file|" . tempScriptName . "|")
      If (tempScriptName == "SCRIPT_NOT_FOUND")
      {
        IniRead, tempScriptName, %tempFileName%, Control_%ItemID%, script_%A_Index%, SCRIPT_NOT_FOUND
        IniWrite, %tempScriptName%, %configFileName%, Control_%ItemID%, script_%A_Index%
        LogToFile("script wasn't in config file, copied from tempfile|" . tempScriptName . "|")
      }
    }
  }
}
IniWrite, %Items%, %configFileName%, structure, control_count
CheckGroupStructure(GroupList)
theItemName := "", theItemWinTitle := "", theItemLoc := "", theItemGroup := "", theItemIsDefault := ""
theItemMinimize := "", theItemPriority := "", theItemCmdArgs := "", theItemRunCode := "", theItemScriptCount := ""
Return

;     End "Edit Items" Gui
; --------------------------------------------------

; --------------------------------------------------
;     "Edit Groups" Gui
;       Gui Number: 3
EditGroups:
Gui, Submit, NoHide
Gui, +Disabled
Gui, 3:Default
Gui, +Owner2
Gui, Add, Text, x7 y7, Groups for separating Itmes
Gui, Add, Text, xp yp+25, Group Name
Gui, Add, Edit, xp yp+25 w130 h20 vGroupName,
Gui, Add, Text, xp+140 yp-25, Columns Count
Gui, Add, Edit, xp+10 yp+25 w40 h20 Limit2 vGroupCol Number,
Gui, Add, UpDown, Range1-10, 1
Gui, Add, Text, xp-150 yp+30, Group Type
Gui, Add, Radio, xp+75 yp Group vGroupType Checked, Radio
Gui, Add, Radio, xp+60 yp , Checkbox
Gui, Add, Button, xp-105 yp+30 w65 gGroupEdit, Edit
Gui, Add, Button, xp+100 yp w65 gGroupSave, Save
Gui, Add, ListView, xp-130 yp+30 w225 h100 vLV_Groups, Group|Group Name|Type|Columns Count
Gui, Add, Button, xp yp+125 w70 gMoveSelected, Move Up
Gui, Add, Button, xp+80 yp w70 gMoveSelected, Move Down
Gui, Add, Button, xp+80 yp w70 gRemoveSelected, Remove
Gui, Add, Button, xp-130 yp+30 w70 g3GuiClose, Cancel
Gui, Add, Button, xp+100 yp w70 g3GuiClose, Done

IniRead, GroupCount, %configFileName%, structure, group_count, 1
Gui, ListView, LV_Groups
Loop, %GroupCount%
{
  IniRead, Name, %configFileName%, structure, group%A_Index%_name, -
  IniRead, Cols, %configFileName%, structure, group%A_Index%_cols, 1
  IniRead, Type, %configFileName%, structure, group%A_Index%_type, Radio
  IniDelete, %configFileName%, Control_%ItemID%, radio_group%A_Index%_cols
  IniDelete, %configFileName%, Control_%ItemID%, radio_group%A_Index%_name
  IniDelete, %configFileName%, Control_%ItemID%, radio_group%A_Index%_type
  LV_Add("", A_Index, Name, Type, Cols)
}
GroupID :=  GroupCount + 1
GroupEdit = 0
LV_ModifyCol(2, "AutoHdr")
LV_ModifyCol(3, "AutoHdr")
Gui, Show, , Edit Group List
Return

GroupEdit:
Gui, ListView, LV_Groups
GroupID := LV_GetNext()
If (GroupID != 0)
{
  LV_GetText(GroupName, GroupID, 2)
  LV_GetText(GroupType, GroupID, 3)
  LV_GetText(GroupCol, GroupID, 4)
  GuiControl, , GroupName, %GroupName%
  GuiControl, , %GroupType%, 1
  GuiControl, , GroupCol, %GroupCol%
}
Return

GroupSave:
Gui, Submit, NoHide
If (GroupName == "")
  Msgbox, , Missing Data, Group Name can not be blank.
Else
{
  GroupEdit = 1
  If (GroupType == 1)
    GroupType = Radio
  Else
    GroupType = Checkbox
  Gui, ListView, LV_Groups
  If (GroupID > LV_GetCount())
    LV_Add("", GroupID, GroupName, GroupType, GroupCol)
  Else
    LV_Modify(GroupID, "", GroupID, GroupName, GroupType, GroupCol)
  GuiControl, , GroupName, 
  GuiControl, , GroupCol, 1
  GuiControl, , Radio, 1
  GroupID := LV_GetCount() + 1
}
Return

FinalizeGroups:
Gui, Submit
Gui, ListView, LV_Groups
GroupCount := LV_GetCount()
IniDeleteMatch(configFileName,"structure","group") ; Delete all keys containing group
Loop, %GroupCount%
{
  LV_GetText(Name, A_Index, 2)
  LV_GetText(Type, A_Index, 3)
  LV_GetText(Cols, A_Index, 4)
  IniWrite, %Name%, %configFileName%, structure, group%A_Index%_name
  IniWrite, %Cols%, %configFileName%, structure, group%A_Index%_cols
  IniWrite, %Type%, %configFileName%, structure, group%A_Index%_type
  IniWrite, %Name%, %tempFileName%, structure, group%A_Index%_name
  IniWrite, %Cols%, %tempFileName%, structure, group%A_Index%_cols
  IniWrite, %Type%, %tempFileName%, structure, group%A_Index%_type
  Group%A_Index%Type := Type
}
IniWrite, %GroupCount%, %configFileName%, structure, group_count
IniWrite, %GroupCount%, %tempFileName%, structure, group_count
select =
Loop,  %GroupCount%
{
  select .= A_Index . "|"
  If (A_Index == 1)
    select .= "|" 
}
GuiControl, 2:, ItemGroup, |%select%
select =
Return

3GuiClose:
Gui, Submit, NoHide
If (A_GuiControl = "Done" OR (A_GuiControl != "Cancel"
    AND (GroupEdit = 1 OR CBName != CheckboxName OR CBCols != CheckBoxCol) 
    AND (MsgBoxYesNo("You have made edits that have not been saved!`nWould you like to save them?"
      , 52, "Cancel Edits?") = 1)))
{
  GoSub, FinalizeGroups
  GroupEdit = 0
}
Gui, 2:Default
Gui, -Disabled
Gui, 3:Destroy

Gui, Show
Return
;     End "Edit Groups" Gui
; --------------------------------------------------


; --------------------------------------------------
;     "Edit Script List" Gui
;       Gui Number: 4
SelectRunCode:
Gui, Submit, NoHide
Gui, +Disabled
Gui, 4:Default
Gui, +Owner2
Gui, Add, Text, x7 y7, Scripts to run when Item is launched:
Gui, Add, ListView, xp yp+30 w225 h100 vLV_Scripts, Script Path
Gui, Add, Button, xp yp+125 w65 gAddScript, Add Script
Gui, Add, Button, xp+80 yp w65 gRmScript, Remove
Gui, Add, Button, xp+80 yp w65 g4GuiClose, Done
file := configFileName
IniRead, ScriptCount, %configFileName%, Control_%ItemID%,item_script_count, --
If (ScriptCount == "--") ; Script has not been edited yet
{
  IniRead, ScriptCount, %tempFileName%, Control_%ItemID%,item_script_count, --
  file := tempFileName
}
Gui, ListView, LV_Scripts
Loop, %ScriptCount%
{
  IniRead, Script, %file%, Control_%ItemID%, script_%A_Index%, Control_%ItemID%-script_%A_Index%
  LV_Add("", Script)
  LV_ModifyCol()
}
Gui, Show, , Edit Script List

Return

AddScript:
Gui, +OwnDialogs
FileSelectFile, Loc, 3, ,Select File..., AutoHotkey Script (*.ahk)
If (ErrorLevel = 0)
{
  Gui, ListView, LV_Scripts
  LV_Add("", Loc)
  LV_ModifyCol()
}
Return

RmScript:
Gui, ListView, LV_Scripts
LV_Delete(LV_GetNext()) 
Return

4GuiClose:
Gui, ListView, LV_Scripts
ItemScriptCount := LV_GetCount()
Loop %ItemScriptCount%
{
  LV_GetText(Script, A_Index)
  IniWrite, %Script%, %configFileName%, Control_%ItemID%, script_%A_Index%
}
IniWrite, %ItemScriptCount%, %configFileName%, Control_%ItemID%, item_script_count
Gui, 2:Default
GuiControl, , ScriptCountText, Script Count: %ItemScriptCount%
Gui, -Disabled
Gui, 4:Destroy
Gui, Show
Return

;     End "Edit Script List" Gui
; --------------------------------------------------

; --------------------------------------------------
;     "Select ConfigFile" Gui
;       Gui Number: 5
SelectConfigFileBuildList:
buildFileList(fileList)
SelectConfigFile:
string = Selecting a configuration:%fileList%
LogToFile(string)
StringReplace, fileList, fileList, |, ||
Gui, 5:Default
Gui, Add, Text, x16 y10, Choose and existing configuration:
Gui, Add, DropDownList, xp yp+20 w190 vExistingConfigFile, %fileList%
Gui, Add, Button, xp+205 yp w40 gChooseExistingConfigFile, OK
Gui, Add, Text, xp-205 yp+30, Start a new configuration:
Gui, Add, Edit, xp yp+20 w190 vNewConfigFile, 
Gui, Add, Button, xp+205 yp w40 gChooseNewConfigFile, OK
Gui, -MinimizeBox
Gui, Show, , The Opener: Select a Configuration
Return

ChooseExistingConfigFile:
Gui, Submit
configFileName := ExistingConfigFile
string = Selected configuration:%configFileName%
LogToFile(string)
fileList := "", fileExt := "", ExistingConfigFile := "", NewConfigFile := ""
Gui, 5:Destroy
ClearMainGuiVars()
GoTo ConfigFileNameSet
Return

ChooseNewConfigFile:
Gui, Submit
string := ""
StringRight, fileExt, NewConfigFile, 4
If (NewConfigFile == "")
{
  string = You did not enter a file name.
}
Else If (fileExt != ".ini")
{
  string = The file name must end with ".ini"
}
Else If (FileExist(NewConfigFile))
{
  string = This file already exists. Pick a unique name.
}
If (string == "")
{
  configFileName := NewConfigFile
  string = Start a new configuration:%configFileName%
  LogToFile(string)
  fileList := "", fileExt := "", ExistingConfigFile := "", NewConfigFile := ""
  Gui, 5:Destroy
  GoTo, RunEditSteup
}
MsgBox, , The Opener, %string%
Gui, Show
Return

5GuiClose:
If (MsgBoxYesNo("You have not selected a configuration. Do you want to quit The Opener?", "The Opener") == 1)
{
  ExitApp
}
Else
{
  Gui, Show
}
Return

;     End "Select ConfigFile" Gui
; --------------------------------------------------


; --------------------------------------------------
;     "Edit Positioning" Gui
;       Gui Number: 6
RunEditPositioning:
string = Edit Positioning
LogToFile(string)
prevMaxItemsPerCol := MaxItemsPerCol
Gui, +Disabled
Gui, 6:Default
Gui, Add, Text, x16 y10, Maximum number of items`nthat can appear in one column:
Gui, Add, Edit, xp+10 yp+35 w40 h20 Limit2 vItemMax Number,
Gui, Add, UpDown, Range1-99, %MaxItemsPerCol%
Gui, Add, Button, xp+60 yp w40 gSaveItemMax, OK
Gui, -MinimizeBox +ToolWindow
Gui, Show, , The Opener: Edit Positioning
Return

6GuiClose:
SaveItemMax:
Gui, Submit
Gui, 1:-Disabled
If (prevMaxItemsPerCol != ItemMax)
{
  MaxItemsPerCol := ItemMax
  IniWrite, %MaxItemsPerCol%, %configFileName%, structure, max_items_per_col
  string = MaxItemsPerCol from %prevMaxItemsPerCol% to %MaxItemsPerCol%
  LogToFile(string)
  Gui, Destroy
  ClearMainGuiVars()
  GoTo, BuildMainGui
}
Else
{
  Gui, Destroy
  Gui, 1:Default
  Gui, +LastFound
}
Return

;     End "Edit Positioning" Gui
; --------------------------------------------------
; --------------------------------------------------
;                     Functions
; --------------------------------------------------
buildFileList(ByRef fileList)
{
  global sampleFileName
  fileCount := 0
  Loop, *.ini
  {
    If (A_LoopFileName != sampleFileName)
    {
      fileList .= "|" . A_LoopFileName
      fileCount++
    }
  }
  StringTrimLeft, fileList, fileList, 1
  return fileCount
}
CheckGroupStructure(GroupList="")
{
  global configFileName
  If (GroupList = "")
  {
    IniRead, ControlCount, %configFileName%, structure, control_count, 0
    Loop, %ControlCount%
    {
      IniRead, theItemGroup, %configFileName%, Control_%A_Index%, item_group, NotExistError
      string = ControlID = %A_Index%`nTheItemGroup = %theItemGroup%
      LogToFile(string)
      If (theItemGroup = "NotExistError")
        Continue
      If theItemGroup Not In %GroupList%
      {
        GroupList .= "," . theItemGroup
        string = %theItemGroup% added to GroupList |%GroupList%|
        LogToFile(string) 
      }
    }
    StringTrimLeft, GroupList, GroupList, 1
  }
  theGroupName =
  string = Checking for GroupList structure: |%GroupList%|
  LogToFile(string)
  i := 0, GroupAdded := 0
  Loop, Parse, GroupList, `,
  {
    i++
    LogToFile(A_LoopField)
    IniRead, theGroupName , %configFileName%, structure, group%A_LoopField%_name, NotExistError
    If (theGroupName == "NotExistError")
    {
      ;group not found, so set name, cols and
      GroupAdded++ 
      string = Group "%A_LoopField%" was not assigned a name
      IniWrite, Group%A_LoopField%, %configFileName%, structure, group%A_LoopField%_name
      IniWrite, 1, %configFileName%, structure, group%A_LoopField%_cols
      string .= " Group" . A_LoopField . ", listed in 1 column"
      LogToFile(string)
    }
  }
  If (GroupAdded != 0)
  {
    IniWrite, %i%, %configFileName%, structure, group_count
  }
  string = Finish CheckGroupStructure
  LogToFile(string)
}
ClearMainGuiVars()
{
  global
  ;clear variables
  i = 0
  Loop, %GroupCount%
  {
    j = 0
    i++
    tempGroupName = Group%i%
    count = %tempGroupName%_0
    count := %count%
    Loop, %count%
    {
      j++
      %tempGroupName%_%j%Name := ""
      %tempGroupName%_%j%IsDefault := ""
    }
    %tempGroupName%Cols := ""
    %tempGroupName%Label := ""
    %tempGroupName%Type := ""
    %tempGroupName%_0 := ""
  }
  i := "", j := "", tempGroupName := "", string := "`nNew Build"
  LogToFile(string)
}
CalculateOffset()
{
  global
  local offset := 0, lastGroup := CurrentGroup -1
  string := "lastGroup = " . lastGroup . "|ColForlastGroup = " . Group%lastGroup%Cols . "|offset = " . offset
  LogToFile(string)
  Loop, % Group%lastGroup%Cols - 1
  {
    offset += Group%lastGroup%_Col%A_Index%Width
  }
  string = offset = %offset%
  LogToFile(string)
  return offset
}
ResizeLV()
{
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  LV_ModifyCol(3, "AutoHdr")
  LV_ModifyCol(7, "AutoHdr")
  LV_ModifyCol(8, "AutoHdr")
  LV_ModifyCol(10, "AutoHdr")
}
SwitchLVRows(theLV, Row1, Row2, ExcludedCols)
{
  global configFileName
  Gui, ListView, %theLV%
  Rows := LV_GetCount()
  Result = 1
  If (Row1 > 0 AND Row2 > 0 AND Rows >= Row1 AND Rows >= Row2)
  {
    Loop % LV_GetCount("Column")
    {
        If A_Index Not In %ExcludedCols%
        {
          LV_GetText(tempvar1, Row1, A_Index)
          LV_GetText(tempvar2, Row2, A_Index)
          LV_Modify(Row1, "Col" . A_Index, tempvar2)
          LV_Modify(Row2, "Col" . A_Index, tempvar1)
        }
    }
    Result = 0
    If (theLV == "LV_Items")
    {
      Loop, 2
      {
        file := configFileName
        ItemID := Row%A_Index%
        string = ItemID = %ItemID%
        LogToFile(string)
        IniRead, %ItemID%ScriptCount, %configFileName%, Control_%ItemID%,item_script_count, --
        If (%ItemID%ScriptCount == "--") ; Script has not been edited yet
        {
          string := ItemID . "ScriptCount = " . %ItemID%ScriptCount
          IniRead, %ItemID%ScriptCount, %tempFileName%, Control_%ItemID%,item_script_count, 0
          file := tempFileName
          string .= "`nIniRead, " . ItemID . "ScriptCount, " . tempFileName . ", Control_" . ItemID . ",item_script_count, 0`n" . %ItemID%ScriptCount
          LogToFile(string)
        }
        Loop, % %ItemID%ScriptCount
        {
          IniRead, %ItemID%Script%A_Index%, %file%, Control_%ItemID%, script_%A_Index%
          string := "file = " . file . "`nIniRead, " . ItemID . "Script" . A_Index . ", " . file . ", Control_" . ItemID . ", script_"
          . A_Index . "`n" . %ItemID%Script%A_Index%
          LogToFile(string)
          If (file == configFileName)
            IniDelete, %file%, Control_%ItemID%, script_%A_Index%
        }
      }
      Loop, 2
      {
        OldID := Row%A_Index%
        If (A_Index = 1)
          ItemID := Row2
        Else
          ItemID := Row1
        IniWrite, % %OldID%ScriptCount, %configFileName%, Control_%ItemID%, item_script_count
        Loop, % %OldID%ScriptCount
          IniWrite, % %OldID%Script%A_Index%, %configFileName%, Control_%ItemID%, script_%A_Index%
      }
    }
  }
  Return %Result%
}
MsgBoxOKCancel(Text, Title = "", Timeout = "" )
{ ; Return 0 on Cancel, 1 on OK, -1 on Timeout
  MsgBox, 257, %Title%, %Text%, %Timeout%
  IfMsgBox Cancel
    Return 0
  IfMsgBox OK
    Return 1
  IfMsgBox Timeout
    Return -1
}
MsgBoxYesNo(Text, Title = "", Timeout = "" )
{ ; Return 0 on No, 1 on Yes, -1 on Timeout
  MsgBox, 4, %Title%, %Text%, %Timeout%
  IfMsgBox No
    Return 0
  IfMsgBox Yes
    Return 1
  IfMsgBox Timeout
    Return -1
}
StartApp(loc, title = "", minwin = "", prioritystatus = "", arguments = "")
{
  LogToFile("loc|" . loc . "|`ntitle|" . title . "|`nminwin|" . minwin . "|`nprioritystatus|" . prioritystatus
    . "|`narguments|" . arguments)
  procCheck := "ProcTitle|"
  found := 0
  If (InStr(title, procCheck) == 1)
  {
    StringReplace, title, title, %procCheck%,
    LogToFile("In ProcCheck, title|" . title)
    Process, Exist, %title%
    PID := ErrorLevel
    LogToFile("result|" . PID)
    If (PID != 0)
    {
      found := 1
      WinActivate, ahk_pid %PID%
    }
  }
  Else If (title != "" AND WinExist(title) != 0)
  {
    found := 1
    WinActivate, %title%
  }
  If (!found)
  {
    If (minwin == "Yes")
      minwin := "Min"
    Else
      minwin := ""
    IfInString, loc, \
    {
      RegExMatch(loc, "(.*)\\(.*)", loc)
      string = Run, %loc1%\%loc2% %arguments%, %loc1%, %minwin%, NewPID
      Run, %loc1%\%loc2% %arguments%, %loc1%, %minwin%, NewPID
    }
    Else
    {
      string = Run, %loc% %arguments%, , %minwin%, NewPID
      Run, %loc% %arguments%, , %minwin%, NewPID
    }
    LogToFile(string)
      
    If NewPID
      Process, Priority, %NewPID%, %prioritystatus%
    Sleep, 500
  }
}

LoadData(ItemID, CheckForNone = 0)
{ ; Return 0 on failure, 1 on success, -1 on Item was None (can only happen if CheckForNone is not 0)
  global configFileName
  IniRead, Name, %configFileName%, Control_%ItemID%, item_name, Failed to read file name.
  IniRead, WinTitle, %configFileName%, Control_%ItemID%, item_win_title, --
  IniRead, Location, %configFileName%, Control_%ItemID%, item_loc, Failed to read file location.
  IniRead, Minimize, %configFileName%, Control_%ItemID%, item_minimize, --
  IniRead, Priority, %configFileName%, Control_%ItemID%, item_priority, --
  IniRead, Arguments, %configFileName%, Control_%ItemID%, item_arguments, --
  IniRead, RunCode, %configFileName%, Control_%ItemID%, item_run_code, --
  string = ItemID = %ItemID%`nCheckForNone = %CheckForNone%`nLocation = %Location%`nWinTitle = %WinTitle%
  LogToFile(string)
  If (CheckForNone AND Location == "" AND WinTitle == "None")
    Return -1
  If !CheckAndRun(Location, Name, WinTitle, Minimize, Priority, Arguments)
    Return 0
  If (RunCode == "Yes")
  {
    IniRead, ScriptCount, %configFileName%, Control_%ItemID%, item_script_count, 0
    string = %A_Space%%A_Space%ScriptCount = %ScriptCount%`n
    LogToFile(string)
    Loop, %ScriptCount%
    {
      IniRead, ScriptLoc, %configFileName%, Control_%ItemID%, script_%A_Index%, Failed to read script location.
      string = %A_Space%%A_Space%ScriptID = script_%A_Index%`n  ScriptLoc = %ScriptLoc%
      LogToFile(string)
      If !CheckAndRun(ScriptLoc, Name)
        Return 0
    }
  }
  Return 1
}
CheckAndRun(loc, Name, title = "", minwin = "", prioritystatus = "", arguments = "")
{ ; Return 0 on failure, 1 on success, 2 on ignore error 
  Result = 1
  IfExist, %loc%
    StartApp(loc, title, minwin, prioritystatus, arguments)
  Else
  {
    string = ScriptLoc Not Found
    LogToFile(string)
    If (MsgBoxOKCancel("Error: File not found for " . Name . "`nAttempted to launch:`n"
        . loc . "`n`nPress OK to continue launching other items or`nCancel to edit settings."
        , "Error") == 1)
    {
      Result = 2
      string = Ignore error.
      LogToFile(string)
    }
    Else
    {
      Result = 0
      string = Return to gui.
      LogToFile(string)
    }
  }
  Return %Result%
}
LogToFile(string)
{
  global logging
  If logging
    FileAppend, %string%`n, Log.txt
}
; --------------------------------------------------
;               Functions by others
; --------------------------------------------------
GetTextSize(pStr, pFont="", pHeight=false, pAdd=0) { ; <By.majkinetor>
  local height, weight, italic, underline, strikeout , nCharSet
  local hdc := DllCall("GetDC", "Uint", 0)
  local hFont, hOldFont
  local resW, resH, SIZE

  ;parse font
  italic      := InStr(pFont, "italic")    ?  1   :  0
  underline   := InStr(pFont, "underline") ?  1   :  0
  strikeout   := InStr(pFont, "strikeout") ?  1   :  0
  weight      := InStr(pFont, "bold")      ? 700  : 400

  ;height
  RegExMatch(pFont, "(?<=[S|s])(\d{1,2})(?=[ ,])", height)
  if (height = "")
    height := 10

  RegRead, LogPixels, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI, LogPixels
  Height := -DllCall("MulDiv", "int", Height, "int", LogPixels, "int", 72)
  ;face
  RegExMatch(pFont, "(?<=,).+", fontFace)   
  if (fontFace != "")
    fontFace := RegExReplace( fontFace, "(^\s*)|(\s*$)")      ;trim
  else fontFace := "MS Sans Serif"

  ;create font
  hFont   := DllCall("CreateFont", "int", height, "int", 0, "int", 0, "int", 0
                        , "int",  weight,   "Uint", italic,   "Uint", underline,"uint", strikeOut
                        , "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", fontFace)
  hOldFont := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)                               

  VarSetCapacity(SIZE, 16)
  curW=0
  Loop,  parse, pStr, `n
  {
    DllCall("DrawTextA", "Uint", hDC, "str", A_LoopField, "int", StrLen(pStr), "uint", &SIZE, "uint", 0x400)
    resW := NumGet(SIZE, 8)
    curW := resW > curW ? resW : curW
  }
  DllCall("DrawTextA", "Uint", hDC, "str", pStr, "int", StrLen(pStr), "uint", &SIZE, "uint", 0x400)
  ;clean   
  DllCall("SelectObject", "Uint", hDC, "Uint", hOldFont)
  DllCall("DeleteObject", "Uint", hFont)
  DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

  resW := NumGet(SIZE, 8) + pAdd
  resH := NumGet(SIZE, 12) + pAdd

  if (pHeight)
    resW = W%resW% H%resH%
  return %resW%
}
Anchor(c, a, r = false) { ; v3.5.1 - Titan
	static d
	GuiControlGet, p, Pos, %c%
	If !A_Gui or ErrorLevel
		Return
	i = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%.`n%A_Gui%:%c%=
	StringSplit, i, i, .
	d .= (n := !InStr(d, i9)) ? i9 :
	Loop, 4
		x := A_Index, j := i%x%, i6 += x = 3
		, k := !RegExMatch(a, j . "([\d.]+)", v) + (v1 ? v1 : 0)
		, e := p%j% - i%i6% * k, d .= n ? e . i5 : ""
		, RegExMatch(d, RegExReplace(i9, "([[\\\^\$\.\|\?\*\+\(\)])", "\$1")
		. "(?:([\d.\-]+)/){" . x . "}", v)
		, l .= InStr(a, j) ? j . v1 + i%i6% * k : ""
	r := r ? "Draw" :
	GuiControl, Move%r%, %c%, %l%
}
IniKeyGet(File,Sect,Array)
{
  Global
  Local i := 0, LineNum := 0, KeyName0, KeyName1, KeyName2, LL, Section, LineCont, ErrLvl
  Loop, Read, %File%
  {
    LineNum ++
    Section = [%Sect%]
    If A_LoopReadLine = %Section%
    {
      LineNum++
      Loop
      {
        FileReadLine, LineCont, %File%, %LineNum%
        ;Check is line may be a section, not a key name
        If (ErrorLevel OR SubStr(LineCont, 1, 1) = "[")
        {
          ;Declare Array0 Value
          %Array%0 := i
          Return i
        }
        ;Line not a key
        If LineCont Not Contains =
        {   
          LineNum++
          Continue
        }
        i++
        StringSplit, KeyName, LineCont, =
        %Array%%i% := KeyName1
        LineNum++
      }
    }
  }
}
IniSectionGet(File,Array)
{
   Global
   Local L, R, Econt, i = 0  ;Index used for array element number
   Loop, Read, %File%
   {
      StringLeft, L, A_LoopReadLine, 1
      ;Possible Section name, so check right side
      If L = [
      {
         StringRight, R, A_LoopReadLine, 1
         ;If its a right bracket Section found
         If R = ]
         {
            i++
            ;Econt = Element Contents
            ECont = %A_LoopReadLine%
            StringTrimLeft, ECont, ECont, 1
            StringTrimRight, ECont, ECont, 1
            %Array%%i% = %ECont%
         }
      }
   }
   %Array%0 = %i%
}
IniDeleteMatch(File, Sect, Key="", Array="TheArray")
{
  Global
  Local tempvar, i := 0
  If (Key != "") ; Delete keys that match Key in Sect
  {
    IniKeyGet(File,Sect,Array)
    Loop, % %Array%0
    {
      If (RegExMatch(%Array%%A_Index%,Key))
      {
        tempvar := %Array%%A_Index%, i++
        IniDelete, %File%, %Sect%, %tempvar%
      }
    }
  }
  Else ; Delete sections that match Sect
  {
    IniSectionGet(File,Array)
    Loop, % %Array%0
    {
      If (RegExMatch(%Array%%A_Index%,Sect))
      {
        tempvar := %Array%%A_Index%, i++
        IniDelete, %File%, %tempvar%
      }
    }
  }
  Loop, % %Array%0
    %Array%%A_Index% :=
  %Array%0 :=
  Return i
}
