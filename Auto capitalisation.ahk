
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



/*
March 5, 2020, This AutoCapSentence.ahk script sets up Hotstrings to capitalize every
letter following a period, question mark, or exclamation point with a single space between 
the punctuation mark and that letter.

It also contains a Hotstring which changes a lowercase "i" to an uppercase "I" when sitting alone.

The last routine uses the Standard Clipboard Routine, discussed in Chapter Nine: "AutoHotkey 
Windows Clipboard Techniques for Swapping Letters" of the book "AutoHotkey Hotkey Techniques":

https://www.computoredgebooks.com/AutoHotkey-Hotkey-Techniques-All-File-Formats_c41.htm

to create a Hotkey for capitalizing any word when you press the CapsLock key with the cursor 
located inside it.

March 15, 2020 — Added Sleep commands to word capitalization Hotkey for increased reliability.
*/

; Loops for setting up sentence initial caps.

AutoCap:

Loop, 26
	Hotstring(":C?*:. " . Chr(A_Index + 96),". " . Chr(A_Index + 64))
Loop, 26
	Hotstring(":CR?*:! " . Chr(A_Index + 96),"! " . Chr(A_Index + 64))
Loop, 26
	Hotstring(":C?*:? " . Chr(A_Index + 96),"? " . Chr(A_Index + 64))
Loop, 26
	Hotstring(":C?*:`n" . Chr(A_Index + 96),"`n" . Chr(A_Index + 64))

Return

; Capitalize the word I.

:C:i::I

; Hotkey for instant cap of any word.

CapsLock::
  OldClipboard := ClipboardAll
  Clipboard := ""     ; Clears the Clipboard
  SendInput ^+{left}  ; Selects word to the left
  Sleep, 100
  SendInput ^c        ; Copy text
  ClipWait 0 ;pause for Clipboard data
  If ErrorLevel
  {
    MsgBox, No text selected!
  }
  StringUpper, Clipboard, Clipboard, T  ; Cap first char (Title)
  Sleep, 100
  SendInput %Clipboard%
  Clipboard := OldClipboard
Return
