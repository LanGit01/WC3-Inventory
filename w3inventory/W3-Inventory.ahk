#SingleInstance, force
#NoEnv

#include lib\ini-parser.ahk

;===================================
;			Constants
;===================================
TEMP_DIR_PATH := "w3inventory\"
CONFIG_PATH := TEMP_DIR_PATH . "keymap.ini"
KEYMAP_SECTION := "keymap"

; DEFAULTS
; Inventory item slots' shortcut keys. Index corresponds to slot number.
ORIG_KEYS := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
DEFAULT_HOTKEYS := ["!q", "!w", "!a", "!s", "!z", "!x"]

; Default mapping
DEFAULT_MAPPING := map(ORIG_KEYS, DEFAULT_HOTKEYS)

ActiveMapping := constructActiveMapping()
hotkeyLookup := reverseMap(ActiveMapping)

MsgBox % deepPrintObject(activeMapping)
MsgBox % (setHotkeyMapping(1, "!w") ? "true" : "false")
MsgBox % deepPrintObject(activeMapping)
MsgBox % deepPrintObject(hotkeyLookup)




;==========================================
;				Subroutines
;==========================================

hotkey_press:
	Send, % hotkeyMap[A_ThisHotkey]
return




;==========================================
;				Functions
;==========================================

setHotkeyMapping(slotNum, hkString){
	global ORIG_KEYS, ActiveMapping, hotkeyLookup

	if(!ORIG_KEYS.HasKey(slotNum)){
		return false
	}

	origKey := ORIG_KEYS[slotNum]
	hkOldActive := ActiveMapping[origKey]

	if(hkString = hkOldActive){
		; Same mapping
		return false
	}

	hotkeyLookup.Delete(hkOldActive)
	duplicateOrigKey := hotkeyLookup[hkString]

	hotkeyLookup[hkString] := origKey
	ActiveMapping[origKey] := hkString

	; Update ActiveMapping
	if(duplicateOrigKey != ""){
		ActiveMapping[duplicateOrigKey] := ""
	}

	return true
}

constructActiveMapping(){
	global
	local mapping := fetchMappingFromConfig(CONFIG_PATH, KEYMAP_SECTION)
	return (mapping != "" ? addMapDefaults(mapping, DEFAULT_MAPPING, true) : cloneMap(DEFAULT_MAPPING))
}


fetchMappingFromConfig(filepath, section){
	global origKeys

	if(!FileExist(filepath)){
		return
	}

	config := mapping := ""

	try{
		config := readINI(filepath)
		if(config.HasKey(section)){
			mapping := map(origKeys, config[section])
		}
	}catch e{
		return
	}

	return mapping
}

/*
 *	Function: cloneMap
 *
 *	Clones a map (key-value pair) object. This is a shallow copy and does not clone 
 *	the contents of the object beyond the first level.
 *
 *	Returns:
 *		a clone of the map
 */
cloneMap(map){
	clonedMap := {}

	For key, value in map{
		clonedMap[key] := value
	}

	return clonedMap
}

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

keyOf(obj, sVal){
	; Key can be "" or 0 (?) so cannot be as
	; reliable for checking if object has value
	For key in obj{
		if(obj[key] = sVal){
			return key
		}
	}

	return false
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