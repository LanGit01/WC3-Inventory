#SingleInstance, force
#NoEnv

#include lib\ini-parser.ahk

;===================================
;			Constants
;===================================
TEMP_DIR_PATH := "w3inventory\"
CONFIG_PATH := TEMP_DIR_PATH . "keymap.ini"
KEYMAP_SECTION := "keymap"

; Inventory item slots' shortcut keys. Index corresponds to slot number.
origKeys := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
defaultHotkeys := ["!q", "!w", "!a", "!s", "!z", "!x"]

testMapping := ["!q", "!w", "!a", "!s", "!z", "!x", "!h", "!j"]

; Default mapping [hotkey:origkey]
defaultMapping := map(defaultHotkeys, origKeys)
rDefaultMapping := reverseMap(defaultMapping)

rActiveMapping := rDefaultMapping

; Fetch config file
if(FileExist(CONFIG_PATH)){
	try{
		config := readINI(CONFIG_PATH)
		if(config.HasKey(KEYMAP_SECTION)){
			rActiveMapping := addMapDefaults(map(origKeys, config[KEYMAP_SECTION]), rDefaultMapping, true)
		}
	}catch e{
		; Not a even a bite...
	}
}

; Remove duplicates here

MsgBox, % deepPrintObject(rActiveMapping)

/*
 	- map origKeys:newKeys (possible: no mapped key, duplicate new key)
	- addMapDefaults (possible: duplicate new key)
	- reverse
*/

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

/*
 *	Function: reverseMap
 *
 *	Returns:
 *		A new object in which the keys and values of the `obj`
 *		parameter are switched (key=value -> value=key)
 */
reverseMap(obj){
	reversemap := {}

	For key, value in obj{
		reversemap[value] := key
	}

	return reversemap
}

/*
 *	Function: addMapDefaults
 *
 *	Adds to `map` missing key-value pairs.
 *
 *	Returns:
 *		The object `map` with the added defaults
 */
addMapDefaults(map, defaults, unique := false){
	For key in defaults{
		if(!map.HasKey(key) && (!unique || (unique && !hasValue(map, defaults[key])))){
			map[key] := defaults[key]
		}
	}

	return map
}

hasValue(obj, sVal){
	For key in obj{
		if(obj[key] = sVal){
			return true
		}
	}

	return false
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

	return str
}