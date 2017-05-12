#SingleInstance force

global  CPUMAX := 4000
global  CPUMIN := 800
global  CPUNOW := 1600

global  BrightnessIndex := 50



;test

;^b::

$#l::
	WinGetActiveTitle T
	Send #l
	Sleep 1000
	
	KeyWait Control  ; Wait for the key to be released.  Use one KeyWait for each of the hotkey's modifiers.
	KeyWait Alt
	BlockInput On
	
	; ... send keystrokes and mouse clicks ...
	;BlockInput Off
	;Run, notepad
	;WinWaitActive, Untitled - Notepad
	;Send, {F5} ; pastes time and date
	;Send " Input is blocked. Starting Screen saver and Looking PC.."
	
	set_CPU_speed(CPUMIN)
	Sleep 50
	run powercfg -Change -monitor-timeout-ac 1 , , Hide
	Sleep 50
	run powercfg.exe -setactive SCHEME_CURRENT , , Hide
	
	Sleep 800
	
	MoveBrightness(-100)

	Sleep 800

	SendMessage 0x112, 0xF140, 0, , Program Manager  ; Start screensaver
	
	Sleep 800

	SendMessage 0x112, 0xF170, 2, , Program Manager
	; (2 = off, 1 = standby, -1 = on)


return



RAlt & Backspace::
	;MsgBox, lower.
	MoveBrightness(5)
return


RAlt & \::
	;MsgBox, higer.
	MoveBrightness(-5)
return


LWin & Volume_Mute::
	;MsgBox, Volume_Mute.
	MoveBrightness(80)
	SoundSet, 0 

return

 




LAlt & Backspace::
	change_CPU_speed("UP")
return

LAlt & \::
	change_CPU_speed("DOWN")
return



CloseSplashText:
	;SplashTextOff
	SetTimer,, Off
	Gui Destroy
return


change_CPU_speed(CHANGE){
	global 
	
	;MsgBox, %CHANGE%
	
	if(CHANGE="UP"){
		CPUNOW := CPUNOW + 400
	}
	if(CHANGE="DOWN"){
		CPUNOW := CPUNOW - 400 
	}
	if( CPUNOW<CPUMIN){
		CPUNOW:=CPUMIN
	}
	
	if( CPUNOW>CPUMAX){
		CPUNOW:=CPUMAX
	}
	
	;MsgBox, %CPUNOW%
	Gui Destroy

	mwr = 430
	mwh = 230

	gui, Show, x100 y100 w%mwr% h%mwh% , CPU Performance
	gui, font, s30
	Gui, Add, Text,, CPU Speed

	gui, font, s50
	Gui, Add, Text,, %CPUNOW% MHZ
	SetTimer, CloseSplashText, 1000
	
	set_CPU_speed(CPUNOW)
	
}

set_CPU_speed(SPEED){
	run powercfg.exe -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCFREQMAX %SPEED% , , Hide
	Sleep 50
	run powercfg.exe -setactive SCHEME_CURRENT , , Hide
	Sleep 50
}



MoveBrightness(IndexMove){

	MaxIndex := 100
	MinIndex := 0
	
	BrightnessIndex += IndexMove
	if(BrightnessIndex>50){
		; lets jump 10 for above 50
		BrightnessIndex += IndexMove
	}
	
	
	
		
	if BrightnessIndex > %MaxIndex%
	   BrightnessIndex := MaxIndex
	   
	if BrightnessIndex < %MinIndex%
	   BrightnessIndex := 0
		 
	
	run powercfg.exe -setacvalueindex SCHEME_BALANCED SUB_VIDEO aded5e82-b909-4619-9949-f5d71dac0bcb %BrightnessIndex% , , Hide
	Sleep 50
	
	run powercfg -Change -monitor-timeout-ac 0 , , Hide
	Sleep 50
	
	run powercfg.exe -setactive SCHEME_CURRENT , , Hide
	
	Gui Destroy
	mwr = 430
	mwh = 230

	gui, Show, x100 y100 w%mwr% h%mwh% , SCREEN
	gui, font, s30
	Gui, Add, Text,, Brightness

	gui, font, s50
	Gui, Add, Text,, %BrightnessIndex% `%
	SetTimer, CloseSplashText, 1000

}

