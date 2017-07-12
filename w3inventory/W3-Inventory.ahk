#SingleInstance, force
#NoEnv

; Inventory item slots' shortcut keys. Index corresponds to slot number.
origHotkeys := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
defaultHotkeys := ["!q", "!w", "!a", "!s", "!z", "!x"]

testHotkeys := ["!q", "!wa", "!a", "!s", "!z", "!x"]

reverseHotkeyMap := buildRemapObject(origHotkeys, testHotkeys)
hotkeyMap := reverseMapping(reverseHotkeyMap)

MsgBox, % deepPrintObject(hotkeyMap)


;enableHotkeys(hotkeyMap, "hotkey_press")


Exit

;==========================================
;				Subroutines
;==========================================

hotkey_press:
	Send, % hotkeyMap[A_ThisHotkey]
return

;==========================================
;				Functions
;==========================================

setHotkey(key, targetlabel){
	ErrorLevel := 0
	Hotkey, %key%, %targetlabel%, UseErrorLevel
	return ErrorLevel
}

; create an object where newKeys[key]: origKeys[key]
buildRemapObject(origKeys, newKeys){
	remap := {}

	For key, value in origKeys{
		if(newKeys.HasKey(key)){
			remap[value] := newKeys[key]
		}
	}

	return remap
}

reverseMapping(obj){
	remap := {}

	For key, value in obj{
		remap[value] := key
	}

	return remap
}

enableHotkeys(keys, targetLabel){
	For key in keys{
		Hotkey, %key%, %targetLabel%
	}
}

disableHotkeys(keys){
	For key, value in keys{
		Hotkey, %key%,, Off
	}
}

deepPrintObject(obj, level := 1){
	str := "", pad := ""

	Loop, % (level - 1){
		pad .= "    "
	}

	For key, value in obj{
		str .= pad . key . ":"

		if(IsObject(value)){
			str .= "`n" . deepPrintObject(value, level + 1)
		}else{
			str .= " " . value . "`n"
		}
	}

	return str
}