#SingleInstance, force
#NoEnv

#include w3inventory\W3-Inventory.ahk

;===================================
;			Constants
;===================================
HOTKEY_EDIT_PREFIX := "HKEdit"


;=================================================
;			Calculated Dimensions
;=================================================
BASE_FONT_SIZE := 10
TITLE_FONT_SIZE := BASE_FONT_SIZE * 1.5

MARGIN_X := MARGIN_Y := 12

HKE_LABEL_W := BASE_FONT_SIZE * 14
HKE_MARGIN := 20
HKE_W := BASE_FONT_SIZE * 14

CONTENT_W := HKE_LABEL_W + HKE_MARGIN + HKE_W

SLBUTTON_MARGIN := 20
SLBUTTON_W := Floor((HKE_LABEL_W + HKE_MARGIN + HKE_W - SLBUTTON_MARGIN) / 2)
STARTBUTTON_W := CONTENT_W

;====================================
;			GUI Creation
;====================================
Gui, New, , % "Test"
Gui, Margin, %MARGIN_X%, %MARGIN_Y%

; Title
Gui, Font, s%TITLE_FONT_SIZE% w700, Verdana
Gui, Add, Text, xm ym w%CONTENT_W% r1 center, % "W3 INVENTORY"

; Instructions
Gui, Font, s%BASE_FONT_SIZE% w400, Tahoma
Gui, Add, Text, xm w%CONTENT_W% r1 center, % "Click on the box and press desired hotkeys"

createHotkeyEditors()

Gui, Add, Button, section xm y+20 w%SLBUTTON_W% r1, % "Save Config"
Gui, Add, Button, x+%SLBUTTON_MARGIN% w%SLBUTTON_W% r1 gbuttonSaveConfig, % "Load Default"
Gui, Add, Button, xm w%CONTENT_W% r2, % "START"

updateHotkeyValues()

Gui, Show


;===================================
;			gLabel Functions
;===================================


buttonSaveConfig(){
	try{
		saveConfig()	
	}catch e{
		MsgBox, % "Error in saving.`n" . e.Message
	}
}


;===================================
;			Functions
;===================================

createHotkeyEditors(){
	global
	local yMargin := MARGIN_Y + 4

	For index, origKey in ORIG_KEYS{
		Gui, Add, Text, xm y+%yMargin% w%HKE_LABEL_W%, % "Slot " . index . " (Num " . SubStr(origKey, -1, 1) . "):"
		Gui, Add, Hotkey, x+%HKE_MARGIN% yp-4 w%HKE_W% v%HOTKEY_EDIT_PREFIX%%index% ghandleHotkeyEdit
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