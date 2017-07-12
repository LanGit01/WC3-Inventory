#SingleInstance, force
#NoEnv

; Inventory item slots' shortcut keys. Index corresponds to slot number.
origKeys := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
defaultHotkeys := ["!q", "!w", "!a", "!s", "!z", "!x"]

testMapping := ["!q", "!w", "!a", "!s", "!z", "!x", "!h", "!j"]

; Default mapping
defaultMapping := map(defaultHotkeys, origKeys)
reverseDefaultMapping := reverseMap(defaultMapping)

reverseActiveMapping := addMapDefaults(map(origKeys, testMapping), reverseDefaultMapping)
deepPrintObject(reverseActiveMapping)

activeMapping := reverseMap(reverseActiveMapping)
;deepPrintObject(activeMapping)

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

/*
 *	Function: map
 *
 *	Remaps the values of the first object to the values of the second object
 *	using their keys. If the second object has keys that the first do not, they
 *	are ignored.
 *	
 *	Returns:
 *		an object in which the key-value pairs are as such:
 *			keys[key]: values[key]
 */
map(keys, values){
	remap := {}

	For key in keys{
		if(values.HasKey(key)){
			remap[keys[key]] := values[key]
		}
	}

	return remap
}


reverseMap(obj){
	reversemap := {}

	For key, value in obj{
		reversemap[value] := key
	}

	return reversemap
}

addMapDefaults(map, defaults){
	For key, in defaults{
		if(!map.HasKey(key)){
			map[key] := defaults[key]
		}
	}

	return map
}
/*
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