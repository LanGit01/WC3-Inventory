#SingleInstance, force
#NoEnv

#include w3inventory\W3-Inventory.ahk

HKREMAP_RUNNING := false

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
Gui, W3Inventory: New, HwndGuiHwnd, % "W3 Inventory"
Gui, Margin, %MARGIN_X%, %MARGIN_Y%

; Title
Gui, Font, s%TITLE_FONT_SIZE% w700, Verdana
Gui, Add, Text, xm ym w%CONTENT_W% r1 center, % "W3 INVENTORY"

; Instructions
Gui, Font, s%BASE_FONT_SIZE% w400, Tahoma
Gui, Add, Text, xm w%CONTENT_W% r1 center, % "Press ESC to minimize to tray"
Gui, Add, Text, xm y+0 w%CONTENT_W% r1 center, % "Click on the box and press desired hotkeys"

createHotkeyEditors()

Gui, Add, Button, section xm y+20 w%SLBUTTON_W% r1 gbuttonSaveMapping, % "Save Mapping"
Gui, Add, Button, x+%SLBUTTON_MARGIN% w%SLBUTTON_W% r1 gbuttonLoadDefault, % "Load Default"
Gui, Add, Button, xm w%CONTENT_W% r2 vstartButton gbuttonToggleHotkeys, % "START"

updateHotkeyValues()

Menu, Tray, NoStandard
Menu, Tray, Add, % "Show Window", showGui
Menu, Tray, Standard
Menu, Tray, Default, % "Show Window"

GoSub showGui
Exit

showGui:
	Gui, W3Inventory:Show
return

W3InventoryGuiEscape:
	Gui, W3Inventory:Cancel
return

W3InventoryGuiClose:
	MsgBox, 0x4, % "Exit Prompt", % "Do you really want to exit?"
	IfMsgBox, Yes
		ExitApp
return

;===================================
;			gLabel Functions
;===================================

buttonSaveMapping(){
	try{
		saveConfig()
		MsgBox, , Save Mapping, Mapping Saved
	}catch e{
		MsgBox, , Save Mapping, % "Error in saving.`n" . e.Message
	}
}

buttonLoadDefault(){
	if(resetHotkeysToDefault()){
		updateHotkeyValues()
	}else{
		MsgBox, , Load Default, % "Cannot edit hotkeys while running!"
	}
}

buttonToggleHotkeys(){
	global HKREMAP_RUNNING

	toggleStatus := toggleHotkeys(!HKREMAP_RUNNING)
	errorString := ""	

	if(toggleStatus){
		HKREMAP_RUNNING := !HKREMAP_RUNNING
		
		; Display errors here
		For key, value in toggleStatus{
			
		}

		GuiControl, , startButton, % (HKREMAP_RUNNING ? "STOP" : "START")
		toggleEnableHotkeyEditors(!HKREMAP_RUNNING)
	}

	
}

;===================================
;			Functions
;===================================

toggleEnableHotkeyEditors(enable := true){
	global
	local index

	For index in ORIG_KEYS{
		if(enable){
			GuiControl, Enable, %HOTKEY_EDIT_PREFIX%%index%
		}else{
			GuiControl, Disable, %HOTKEY_EDIT_PREFIX%%index%
		}
	}
}

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