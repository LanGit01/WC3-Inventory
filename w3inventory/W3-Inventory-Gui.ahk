#SingleInstance, force
#NoEnv

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

/*

Gui, Add, Hotkey, vTest
GuiControlGet, TestVar, Pos, Test

MsgBox, % TestVarX

*/



Exit

/*
; Instructions
;Gui, Add, Text, center, % "Click on the box beside the Inventory slot number and press your hotkey combination"




Gui, Add, Text, xm y+10 w%HK_LABELW%, Text1
Gui, Add, Hotkey, x+20 yp-4 w%HK_W% r1 center

Gui, Add, Text, xm y+10 w%HK_LABELW%, Text1asdasdasdas
Gui, Add, Hotkey, x+20 yp-4 w%HK_W% r1 center

Gui, Add, Text, xm y+10 w%HK_LABELW%, Text1
Gui, Add, Hotkey, x+20 yp-4 w%HK_W% r1 center

Gui, Add, Text, xm y+10 w%HK_LABELW%, Text1
Gui, Add, Hotkey, x+20 yp-4 w%HK_W% r1 center

Gui, Add, Text, xm y+10 w%HK_LABELW%, Text1
Gui, Add, Hotkey, x+20 yp-4 w%HK_W% r1 center

Gui, Add, Text, xm y+10 w%HK_LABELW%, Text1
Gui, Add, Hotkey, x+20 yp-4 w%HK_W% r1 center

Gui, Add, Text, xm y+10 w%HK_LABELW%, Text1
Gui, Add, Hotkey, x+20 yp-4 w%HK_W% r1 center

Gui, Add, Button, xm, Save Hotkeys
Gui, Add, Button, x+20 +0x20, Reset Defaults
Gui, Add, Button, , Start W3Inventory*/

/*
Label:
	MsgBox, % A_GuiControl
return

hkEdit(){
	varName := A_GuiControl
	key := StrReplace(varName, "HK", , , 1)
	MsgBox, % key
}

GUIcreateHotkeyInputs(mapping, pseudoArrName, hkLabel){
	global
	local hotkeyVarName, key, value

	For key in mapping{
		hotkeyVarName := pseudoArrName . key

		Gui, Add, Text, xm, Slot %key%
		Gui, Add, Hotkey, v%hotkeyVarName% g%hkLabel%
	}
}
*/