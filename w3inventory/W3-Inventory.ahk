#SingleInstance, force
#NoEnv

#include %A_ScriptDir%\..\lib\ini-parser.ahk

;===================================
;			Constants
;===================================
DIR_PATH := ""
CONFIG_PATH := DIR_PATH . "keymap.ini"
KEYMAP_SECTION := "keymap"

; Read-Only Globals
W3_HOTKEYS_ACTIVE := false

; DEFAULTS
; Inventory item slots' shortcut keys. Index corresponds to slot number.
ORIG_KEYS := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
DEFAULT_HOTKEYS := ["!q", "!w", "!a", "!s", "!z", "!x"]

; Default mapping
DEFAULT_MAPPING := map(ORIG_KEYS, DEFAULT_HOTKEYS)

ActiveMapping := constructActiveMapping()
HotkeyLookup := reverseMap(ActiveMapping)


;=======================================
;		Script-specific Functions
;=======================================

hotkeyPress(){
	global HotkeyLookup

	Send, % HotkeyLookup[A_ThisHotkey]
}

/*
 *	Function: startHotkeys
 *	
 *	Starts the hotkeys mapped in `HotkeyLookup`
 *
 *	Returns:
 *		An object containing the hotkey strings as keys and the
 *		status as values. True if hotkey is valid and is installed,
 *		false otherwise
 */


toggleHotkeys(hkEnabled := true){
	global HotkeyLookup, W3_HOTKEYS_ACTIVE

	; Force to boolean
	hkEnabled := !!hkEnabled
	if(hkEnabled = W3_HOTKEYS_ACTIVE){
		return false
	}

	toggledHotkeys := {}

	For hk in HotkeyLookup{
		ErrorLevel := 0
		if(hkEnabled){
			Hotkey, %hk%, hotkeyPress, ON UseErrorLevel
		}else{
			Hotkey, %hk%, hotkeyPress, OFF UseErrorLevel
		}

		if(ErrorLevel = 0){
			toggledHotkeys[hk] := true
		}else
		if(ErrorLevel = 2){
			toggledHotkeys[hk] := false
		}else{
			throw Exception(ErrorLevel)
		}
	}

	W3_HOTKEYS_ACTIVE := hkEnabled

	return toggledHotkeys
}

resetHotkeysToDefault(){
	global

	if(W3_HOTKEYS_ACTIVE){
		return false
	}

	ActiveMapping := cloneMap(DEFAULT_MAPPING)
	HotkeyLookup := reverseMap(ActiveMapping)
	return true
}

setHotkeyMapping(slotNum, hkString){
	global ORIG_KEYS, ActiveMapping, HotkeyLookup, W3_HOTKEYS_ACTIVE

	if(W3_HOTKEYS_ACTIVE){
		MsgBox RUNNING. Cannot change hotkeys.
	}

	if(W3_HOTKEYS_ACTIVE || !ORIG_KEYS.HasKey(slotNum)){
		return false
	}

	origKey := ORIG_KEYS[slotNum]
	hkOldActive := ActiveMapping[origKey]

	if(hkString = hkOldActive){
		; Same mapping
		return false
	}

	HotkeyLookup.Delete(hkOldActive)			; Delete mapping to the to-be-replaced key
	previousOrigKey := HotkeyLookup[hkString]

	; Create new mapping
	HotkeyLookup[hkString] := origKey
	ActiveMapping[origKey] := hkString

	; Remove duplicate from ActiveMapping
	if(previousOrigKey != ""){
		ActiveMapping[previousOrigKey] := ""
	}

	return true
}

constructActiveMapping(){
	global
	local mapping := loadConfig(CONFIG_PATH, KEYMAP_SECTION)
	return (mapping != "" ? addDefaultValues(mapping, DEFAULT_MAPPING, true) : cloneMap(DEFAULT_MAPPING))
}


saveConfig(){
	global CONFIG_PATH, KEYMAP_SECTION, ORIG_KEYS, ActiveMapping

	configObj := {(KEYMAP_SECTION): map(reverseMap(ORIG_KEYS), ActiveMapping)}
	if(!writeINI(CONFIG_PATH, configObj)){
		throw Exception("Unable to save configuration")
	}
}


loadConfig(filepath, section){
	global ORIG_KEYS

	if(!FileExist(filepath)){
		return
	}

	config := mapping := ""

	try{
		config := readINI(filepath)
		if(config.HasKey(section)){
			mapping := map(ORIG_KEYS, config[section])
		}
	}catch e{
		return
	}

	return mapping
}

;=======================================
;			Helper Functions
;=======================================

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
addDefaultValues(map, defaultValues, unique := false){
	For key, value in defaultValues{
		if(!map.HasKey(key) && (!unique || (unique && !hasValue(map, value)))){
			map[key] := value
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