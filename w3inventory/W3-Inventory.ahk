#SingleInstance, force
#NoEnv

; Inventory item slots' shortcut keys. Index corresponds to slot number.
origKeys := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
defaultHotkeys := ["!q", "!w", "!a", "!s", "!z", "!x"]

testHotkeys := ["!q", "!wa", "!a", "!s", "!z", "!x"]

; Default mapping
defaultMapping := map(defaultHotkeys, origKeys)
deepPrintObject(defaultMapping)

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
; create an object where newKeys[key]: origKeys[key]
map(keys, values){
	remap := {}

	For key in keys{
		if(values.HasKey(key)){
			remap[keys[key]] := values[key]
		}
	}

	return remap
}

/*
reverseMapping(obj){
	remap := {}

	For key, value in obj{
		remap[value] := key
	}

	return remap
}


setHotkey(key, targetLabel){
	ErrorLevel := 0
	Hotkey, %key%, %targetlabel%, UseErrorLevel
	return ErrorLevel
}

createHotkeys(keymap, targetLabel, enabled := false){
	For , value in keys{
		if(enabled){
			Hotkey, %value%, %targetLabel%, On
		}else{
			Hotkey, %value%, %targetLabel%, Off
		}		
	}

	return keymap
}
*/

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

	MsgBox, %str%
}