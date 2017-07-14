#SingleInstance, force
#NoEnv

#include w3inventory\W3-Inventory.ahk

HOTKEY_EDIT_PREFIX := "HKEdit"

;=================================================
;			Calculated Dimensions
;=================================================
MARGIN_X := MARGIN_Y := 12
BASE_FONT_SIZE := 10
TITLE_FONT_SIZE := BASE_FONT_SIZE * 1.5
HK_LABEL_W := BASE_FONT_SIZE * 14
HK_MARGIN := 20
HK_W := BASE_FONT_SIZE * 14
CONTENT_W := HK_LABEL_W + HK_MARGIN + HK_W
BUTTON_MARGIN := 20
BUTTON_W := Floor((HK_LABEL_W + HK_MARGIN + HK_W - BUTTON_MARGIN) / 2)

Gui, New, , % "Test"
Gui, Margin, %MARGIN_X%, %MARGIN_Y%

Gui, Font, s%TITLE_FONT_SIZE% w700, Verdana
Gui, Add, Text, xm ym w%CONTENT_W% r1 center, % "W3 INVENTORY"

Gui, Font, s%BASE_FONT_SIZE% w400, Tahoma
Gui, Add, Text, xm w%CONTENT_W% r1 center, % "Click on the box and press desired hotkeys"
createHotkeyEditors(ORIG_KEYS, HOTKEY_EDIT_PREFIX)

Gui, Add, Button, section xm y+20 w%BUTTON_W% r1, % "Save Config"
Gui, Add, Button, x+%BUTTON_MARGIN% w%BUTTON_W% r1 gbuttonSaveConfig, % "Load Default"
Gui, Add, Button, xm w%CONTENT_W% r2 gbuttonStartHotkeys, % "START"

updateHotkeyValues()

Gui, Show

buttonSaveConfig(){
	MsgBox, Saving


	try{
		saveConfig()	
	}catch e{
		MsgBox, % e.Message
	}
	
}

buttonLoadDefault(){

}

buttonStartHotkeys(){
	startHotkeys()
}

createHotkeyEditors(origKeysArray, hkVarPrefix){
	global

	For index, origKey in origKeysArray{
		Gui, Add, Text, xm y+12 w%HK_LABEL_W%, % "Slot " . index . " (Num " . SubStr(origKey, -1, 1) . "):"
		Gui, Add, Hotkey, x+%HK_MARGIN% yp-4 w%HK_W% v%hkVarPrefix%%index% ghandleHotkeyEdit
	}
}


handleHotkeyEdit(){
	capturedHotkey := %A_GuiControl%
	if capturedHotkey in +,^,!,+^,^!,+^!
		return

	key := SubStr(A_GuiControl, 0, 1)
	if(setHotkeyMapping(key, capturedHotkey)){
		updateHotkeyValues()
	}
}

updateHotkeyValues(){
	global ActiveMapping, ORIG_KEYS, HOTKEY_EDIT_PREFIX
	

	For index, origKey in ORIG_KEYS{
		hkVarName := HOTKEY_EDIT_PREFIX . index
		GuiControl, , %hkVarName%, % ActiveMapping[origKey]
	}
}