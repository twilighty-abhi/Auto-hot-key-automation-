; The Operner Updater
; Patrick Lannigan
; This script will update an opener.ini file to make it compatible with the new v.2 format.
SetWorkingDir, %A_ScriptDir%

FileSelectFile, configFileName, 3, , Select the configuration file you want to update, Opener Configuration (*.ini)
If (!ErrorLevel)
{
  ;helper variables
  structure = structure
  blank := ""
  ;start reading info
  ControlCount := IniReadWrap(structure, "control_count")
  GroupCount := IniReadWrap(structure, "radio_group_count")
  CheckGroupNum := GroupCount + 1
  ;fix structure section
  IniRenamer(structure, "radio_group_count", "group_count")
  Loop, %GroupCount%
  {
    IniRenamer(structure, "radio_group" A_Index "_name", "group" A_Index "_name")
    IniRenamer(structure, "radio_group" A_Index "_cols", "group" A_Index "_cols")
    IniWrite, Radio, %configFileName%, structure, group%A_Index%_type
  }
  IniRenamer(structure, "radio_groupCB_name", "group" CheckGroupNum "_name")
  IniRenamer(structure, "radio_groupCB_cols", "group" CheckGroupNum "_cols")
  IniWrite, Checkbox, %configFileName%, structure, group%CheckGroupNum%_type
  IniWrite, %CheckGroupNum%, %configFileName%, structure, group_count
  IniWrite, 10, %configFileName%, structure, max_items_per_col
  IniDelete, %configFileName%, structure, has_check_group
  
  Loop, %ControlCount%
  {
    IniRead, value, %configFileName%, Control_%A_Index%, item_arguments, ArgsNotFound
    If (Value == "ArgsNotFound")
      IniWrite, %blank%, %configFileName%, Control_%A_Index%, item_arguments
    groupType := IniReadWrap("Control_" A_Index, "item_type")
    
    If (groupType == "Checkbox")
      IniWrite, %CheckGroupNum%, %configFileName%, Control_%A_Index%, item_group
    IniDelete, %configFileName%, Control_%A_Index%, item_type
  }
  MsgBox, The update has finished.
}
Return

IniReadWrap(Section, Key)
{
  global configFileName
  IniRead, value, %configFileName%, %Section%, %Key%, ERROR
  If (value == "ERROR")
  {
    MsgBox, The configuration file is not properly formated (%Section%,%Key%). Please delete it and start a new one.
    ExitApp
  }
  return value
}
IniRenamer(Section, oldKey, newKey)
{
  global configFileName
  value := IniReadWrap(Section, oldKey)
  IniWrite, %value%, %configFileName%, %Section%, %newKey%  
  IniDelete, %configFileName%, %Section%, %oldKey%
}