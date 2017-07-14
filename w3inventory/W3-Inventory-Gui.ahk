#SingleInstance, force
#NoEnv

#include w3inventory\W3-Inventory.ahk

;ORIG_KEYS := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]

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
Gui, Add, Button, x+%BUTTON_MARGIN% w%BUTTON_W% r1, % "Load Default"
Gui, Add, Button, xm w%CONTENT_W% r2, % "START"

ActiveMapping["{Numpad7}"] := ""
HotkeyLookup.Delete("!q")


updateHotkeyValues()

Gui, Show



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

/*
FONT_SIZE := 10
HK_LABELW := FONT_SIZE * 12
HK_W := FONT_SIZE * 12
HK_M := 50


global_GuiPosX := global_GuiPosY := global_GuiPosW := global_GuiPosH := ""

origKeys := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
testMap := {"{Numpad7}" : "!q", "{Numpad8}" : "!w", "{Numpad4}" : "!a", "{Numpad5}" : "!s", "{Numpad1}" : "!z", "{Numpad2}" : "!x"}


contentAreaW := HK_LABELW + HK_M + HK_W
editbuttonsW := FONT_SIZE * 12
startbuttonW := contentAreaW * 0.7

Gui, New, , % "W3 Inventory Hotkey"

Gui, Font, s12 w600, Tahoma
Gui, Add, Text, xm ym+10 w%ContentAreaW% r2 center, W3Inventory Hotkeys


Gui, Font, s%FONT_SIZE% w400, Monospace


GUIcreateHotkeyInputs(origKeys, "HK")

; Create Buttons


Gui, Add, Button, xm w%editbuttonsW% y+20 r1, Save Mapping
Gui, Add, Button, % "x+" (contentAreaW - (editbuttonsW * 2)) " w" editbuttonsW " r1", Restore Defaults

Gui, Add, Button, % "xm+" ((contentAreaW - startButtonW) / 2) " w" startButtonW " r2", Start W3Inventory

Gui, Show


GUIcreateHotkeyInputs(origKeyArray, hkVarPrefix){
	global

	local key

	For key in origKeyArray{
		Gui, Add, Text, xm y+10 w%HK_LABELW%, % "Slot " key " (Numkey " SubStr(origKeyArray[key], -1, 1) "):"
		Gui, Add, Hotkey, x+%HK_M% w%HK_W%
	}
}


getMax(val1, val2){
	return (val1 > val2 ? val1)
}

Exit
*/