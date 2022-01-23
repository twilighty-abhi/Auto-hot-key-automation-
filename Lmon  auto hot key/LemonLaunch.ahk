/*
	Copyright (C) <2014>  <AfterLemon -	Shawn Mihalek>

	This program is free software: you	can redistribute it and/or modify	it under the terms of the GNU General Public License
	as published by the Free Software Foundation, either	version 3 of the License, or (at your option)	any later version.
	
	This program is distributed in the hope that it will	be useful, but WITHOUT ANY	WARRANTY;
	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with this program.
	If not, see <http://www.gnu.org/licenses/>.
*/

SetWorkingDir,%A_ScriptDir%
FileInstall,LemonLaunchSettings.ini,LemonLaunchSettings.ini,1

#SingleInstance,Force
#InstallKeybdHook
SetBatchLines,-1
SetControlDelay,-1
CoordMode,Pixel
FileGetSize,SettingsSize,LemonLaunchSettings.ini
FileGetTime,SettingsTime,LemonLaunchSettings.ini
Global Setup:=[],History:=[]

Search:=[],Direct:=[],IniReadWrite("LemonLaunchSettings.ini"),Temp:=[]
For i in Search
	Temp[A_Index]:="search " i
For i in Direct
	Temp.Insert(i)
Temp.Remove("search")

If !Setup["Hotkey"]{
	MsgBox,0,No Hotkey Found,No Hotkey Found`nPlease Set a Hotkey,2
	ExitApp
}else{
	(Setup["Separator"]?"":Setup["Separator"]:="|")
	Hotkey,% Setup["Hotkey"],Hotkey,On
	If Setup["VoiceHotkey"]
		Hotkey,% Setup["VoiceHotkey"],Voice,On
}return

Hotkey:
	If Setup["ColorMatch"]
		SetTimer,PGColor,50
	PreWin:=WinActive("A")
	If !WinExist(Setup["Title"]){
		If Setup["Trans"]
			Gui,Color,F0F0F0,F0F0F0
		Gui,Font,% (Setup["TextSize"]?"s" Setup["TextSize"]:"") (Setup["TextWeight"]?" w" Setup["TextWeight"]:"") (Setup["TextColor"]?" c" Setup["TextColor"]:"")
		Gui,Add,Progress,% "x0	y0 w" Setup["w"] " h" Setup["h"] " BackgroundF0F0F0 Disabled vBGP"
		Gui,Add,Edit,% "x" (Setup["Identifier"]?23:0) " y0 w" Setup["w"]-(Setup["Identifier"]?23:0) " h" Setup["h"] (Setup["Trans"]?" -E0x200":"") " -0x40 vData"
		If Setup["Identifier"]{
			Gui,Add,Progress,% "x0	y0 w" Setup["h"] " h" Setup["h"] " Disabled vIdentifierP"
			Gui,Font,s10 w700
			Gui,Add,Text,% "x0 y0 w" Setup["h"] " h" Setup["h"] " BackgroundTrans Center vIdentifierT",LL
			Gui,Font,% (Setup["TextSize"]?"s" Setup["TextSize"]:"") (Setup["TextWeight"]?" w" Setup["TextWeight"]:"") (Setup["TextColor"]?" c" Setup["TextColor"]:"")
		}Gui,Add,Button,Default Hidden gOK
		Gui,-Caption +ToolWindow +AlwaysOnTop +LastFound hwndHWND
		Gui,Show,% "x" Setup["x"] " y" Setup["y"] " w"	Setup["w"] " h" Setup["h"],%	Setup["Title"]
		If Setup["Trans"]
			WinSet,TransColor,F0F0F0
	}else If !WinActive(Setup["Title"]){
		Gui,+LastFound
		GuiControl,Show,IdentifierP
		GuiControl,Show,IdentifierT
		WinActivate
		WinWaitActive
		GuiControl,Focus,Data
		SendInput,^a
}return

Voice:
	cSpeaker:=ComObjCreate("SAPI.SpVoice"),cSpeaker.Speak("Please State your Input")
	s:=new SpeechRecognizer
	s.Recognize(Temp)
	SoundPlay,*-1
	SearchIn:=s.Prompt()
	If(SubStr(SearchIn,1,InStr(SearchIn," ")-1)="search"){
		s:="",cSpeaker.Speak("What is your Search?")
		s:=new SpeechRecognizer
		s.Recognize(True)
		SoundPlay,*-1
		Data:=SubStr(SearchIn,InStr(SearchIn," ")+1) " | " s.Prompt()
	}else Data:=SearchIn " | "
	SearchIn:="",s:="",SearchPart1:="",cSpeaker:=""
	If !Run(Data)
		Tooltip,There was an error processing	your request.
	SetTimer,Tooltip,-2000
return

PGColor:
	PixelGetColor,BGColor,% (Setup["x"]+(Setup["w"]/2)),% Setup["y"]-1,Alt RGB
	SetFormat,IntegerFast,h
	(StrLen(Invert:=SubStr(0xFFFFFF-BGColor,3))<6?Invert:=0 Invert:""),BGColor:=SubStr(BGColor,3)
	SetFormat,IntegerFast,d
	If(Invert=00)
		Invert:=000000
	Gui,+LastFound
	Gui,Color,,%BGColor%
	Gui,Font,c%BGColor% s10 w700
	GuiControl,+Background%BGColor%,BGP
	GuiControl,Font,IdentifierT
	GuiControl,+Background%Invert%,IdentifierP
	Gui,Font,% (Setup["TextSize"]?"s" Setup["TextSize"]:"s7") (Setup["TextWeight"]?" w" Setup["TextWeight"]:"w400") " c" Invert
	GuiControl,Font,Data
	If Setup["Trans"]
		WinSet,TransColor,%BGColor%
	Gui,2:+LastFound
	Gui,2:Color,%BGColor%,%BGColor%
	GuiControl,2:+Background%BGColor%,HistoryList
	Gui,2:Font,c%Invert%
	GuiControl,2:Font,HistoryList
	GuiControl,2:Font,Close2
	If Setup["TransList"]
		WinSet,TransColor,%BGColor%
return

#If WinActive(Setup["Title"])
Esc::
	WinActivate,ahk_id %PreWin%
	Gui,+LastFound
	GuiControl,Hide,IdentifierP
	GuiControl,Hide,IdentifierT
return
Tab::SendInput,% " " Setup["Separator"] " "
#If (WinActive(Setup["Title"])&&Setup["ClickDeactivate"])
~LButton::
	WinGetPos,,,gWin
	If(gWin!="HistoryList"||gWin!=Setup["Title"]){
		Gui,+LastFound
		GuiControl,Hide,IdentifierP
		GuiControl,Hide,IdentifierT
}return
#If

OK:
	Gui,Submit,NoHide
	GuiControl,Hide,IdentifierP
	GuiControl,Hide,IdentifierT
	GuiControl,,Data
	If !Run(Data)
		Tooltip,There was an error processing	your request.
	SetTimer,Tooltip,-2000
return

Tooltip:
	Tooltip
return

InternalActions(Code){
global SettingsSize,SettingsTime,HistoryList,BGColor,Invert,Close2
	If(Code="History"){
		If !WinExist("HistoryList"){
			If Setup["ColorMatchList"]{
				Gui,2:Color,%BGColor%,%BGColor%
				Gui,2:Font,c%Invert%
			}Gui,2:Add,ListView,% "x-1 y-1 w" Setup["w"]+2 " h201 -Hdr -Multi gHistoryList vHistoryList",History
			Gui,2:Add,Text,% "x1 y200 w" Setup["w"]-2 " h20 c" Invert	" Center vClose2 gClose2",Close
			Gui,2:-Caption +ToolWindow +AlwaysOnTop +Border
			Gui,2:Default
			Loop,% History.MaxIndex()
				LV_Add(,History[A_Index])
			Gui,2:Show,% "x" Setup["x"] " y" Setup["y"]-203-Setup["h"] " w" Setup["w"] " h220",HistoryList
	}}else If(Code="Reload")
		reload
	else If(Code="Settings"){
		Run,LemonLaunchSettings.ini
		SetTimer,CheckSettings,100
	}else If(Code="Exit")
		ExitApp
	else return 0
return 1

HistoryList:
	If(A_GuiEvent="DoubleClick"){
		LV_GetText(Data,A_EventInfo)
		Run(Data)
}return

2GuiEscape:
Close2:
	WinActivate,% Setup["Title"]
	Gui,2:Destroy
return

CheckSettings:
	FileGetSize,SettingsSizeNew,LemonLaunchSettings.ini
	FileGetTime,SettingsTimeNew,LemonLaunchSettings.ini
	If((SettingsSizeNew!=SettingsSize||SettingsTimeNew!=SettingsTime||Check10k=10000),(Check10k?Check10k++:Check10k:=1))
		reload
return
}

Run(Data){
global Search,Direct
	If !(Data~="i)(History|Settings|Exit|Reload).*\|")
		History.Insert(Data)
	If WinExist("HistoryList"){
		Gui,2:Default
		LV_Add(,History[History.MaxIndex()])
	}StringReplace,Data,Data,+,% "%2B",1
	If(InStr(Data,Setup["Separator"]),Int:=RegExReplace(SubStr(Data,1,InStr(Data,Setup["Separator"])-1)," ")){
		If InternalActions(Int)
			return 1
		If !S:=Search[Int]
			S:=Search[Int "s"]
		If !W:=Direct[Int]
			W:=Direct[Int "s"]
		If(SubStr(Data:=SubStr(Data,InStr(Data,Setup["Separator"])+1),1,1)=" ")
			Data:=SubStr(Data,2)
		If(S="explorer"){
			WinActivate,ahk_class Shell_TrayWnd
			WinWaitActive,ahk_class Shell_TrayWnd
			Send,{F3}
			If(Data!=""){
				WinWaitActive,Search Results
				SendInput,%Data%
		}}else Run,% (Data=""?W:S Data),,UseErrorLevel
	}else If RegExMatch(Data,"\..{2,3}"){
		If(SubStr(Data,1,7)!="http://")
			Data:="http://" Data
		Run,%Data%,,UseErrorLevel
	}else Run,% Search[Setup["DefaultSearch"]] Data,,UseErrorLevel
return (ErrorLevel||E?0:1)
}

IniReadWrite(filename:="",Section:="",Write*){
global
local c,p,k,y,s,i,w
	FileRead,s,% (filename?filename:SubStr(A_ScriptName,1,-4) ".ini")
	s:=RegExReplace(RegExReplace(s,";.*"),"\t")
	Loop,Parse,s,`n,`r%A_Space%%A_Tab%
		c:=SubStr(A_LoopField,1,1),(c="["?y:=SubStr(A_LoopField,2,-1):(c=";"?"":((p:=InStr(A_LoopField,"="))?(k:=RegExReplace(SubStr(A_LoopField,1,p-1),"[ \-\(\)]*"),(y:=RegExReplace(y,"[ \-\(\)]*"),%y%[k]:=SubStr(A_LoopField,p+1))):"")))
}

class SpeechRecognizer
{	static	Contexts:={}
	__New(){
		Try{
			this.cListener:=ComObjCreate("SAPI.SpInprocRecognizer"),cAudioInputs:=this.cListener.GetAudioInputs(),this.cListener.AudioInput:=cAudioInputs.Item(0)
		}Catch e{
			If(SubStr(e.Message,1,10)="0x80045039")
				MsgBox,You do not have a microphone active.
			else Throw Exception("Could not create recognizer: " e.Message)
		}Try this.cContext:=this.cListener.CreateRecoContext()
			Catch e
				Throw Exception("Could not create recognition context: " e.Message)
		Try this.cGrammar:=this.cContext.CreateGrammar()
			Catch e
				Throw Exception("Could not create recognition grammar: " e.Message)
		Try{
			this.cRules:=this.cGrammar.Rules(),this.cRule:=this.cRules.Add("WordsRule",0x1|0x20)
		}Catch e
			Throw Exception("Could not create speech recognition grammar rules: " e.Message)
		this.Phrases(["hello","hi","greetings","salutations"]),this.Dictate(True),SpeechRecognizer.Contexts[&this.cContext]:=&this,this.Prompting:=False,ComObjConnect(this.cContext,"SpeechRecognizer_")
	}
	Recognize(Values=True){
		If Values{
			If(IsObject(Values),this.Listen(True))
				this.Phrases(Values)
			Else this.Dictate(True)
		}Else this.Listen(False)
	Return,this
	}
	Listen(State=True){
		Try{
			If State
				this.cListener.State:=1
			Else this.cListener.State:=0
		}Catch e
			Throw Exception("Could not set listener state: " e.Message)
	Return,this
	}
	Prompt(Timeout=-1){
		this.Prompting:=True
		this.SpokenText:=""
		If(Timeout<0){
			While,this.Prompting
				Sleep,0
		}Else{
			StartTime:=A_TickCount
			While(this.Prompting&&(A_TickCount-StartTime>Timeout))
				Sleep,0
	}Return,this.SpokenText
	}
	Phrases(PhraseList){
		Try this.cRule.Clear()
			Catch e
				Throw Exception("Could not reset rule: " e.Message)
		Try cState:=this.cRule.InitialState()
			Catch e
				Throw Exception("Could not obtain rule initial state: " e.Message)
		cNull:=ComObjParameter(13,0)
		For Index,Phrase In PhraseList
		{	Try cState.AddWordTransition(cNull,Phrase) ;add a no-op rule state transition	triggered by a	phrase
				Catch e
					Throw Exception("Could not add rule """ Phrase """: " e.Message)
		}Try this.cRules.Commit()
			Catch e
				Throw Exception("Could not update rule: " e.Message)
		this.Dictate(False)
	Return,this
	}
	Dictate(Enable=True){
		Try{
			If Enable
				this.cGrammar.DictationSetState(1),this.cGrammar.CmdSetRuleState("WordsRule",0)
			Else this.cGrammar.DictationSetState(0),this.cGrammar.CmdSetRuleState("WordsRule",1)
		}Catch e
				Throw Exception("Could not set grammar dictation state: " e.Message)
	Return,this
	}
	OnRecognize(Text){
	}
	__Delete(){
		this.base.Contexts.Remove(&this.cContext,"")
	}
}

SpeechRecognizer_Recognition(StreamNumber,StreamPosition,RecognitionType,cResult,cContext){
	Try
		pPhrase:=cResult.PhraseInfo(),Text:=pPhrase.GetText()
	Catch e
		Throw Exception("Could not obtain recognition result text: " e.Message)
	Instance:=Object(SpeechRecognizer.Contexts[&cContext])
	If Instance.Prompting
		Instance.SpokenText:=Text,Instance.Prompting:=False
	Instance.OnRecognize(Text)
}