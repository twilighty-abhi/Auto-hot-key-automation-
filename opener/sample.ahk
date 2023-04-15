SetTitleMatchMode, 2
WinWait, Notepad
WinActivate, Notepad
WinWaitActive, Notepad
Send, This script was launched after Notepad was opened.
MsgBox, Done