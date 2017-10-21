#SingleInstance, force
#NoEnv

#include %A_ScriptDir%\lib\ini_parser.ahk
#include %A_SCriptDir%\lib\map_lib.ahk

;========================================
;              Constants
;========================================
DIR_PATH := A_ScriptDir
CONFIG_PATH := DIR_PATH . "\keymap.ini"
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


;========================================
;            API Functions
;========================================

hotkeyPress(){
	global HotkeyLookup

	Send, % HotkeyLookup[A_ThisHotkey]
}


/*
 *	Function toggleHotkeys
 *
 *	Start or stop hotkeys on ActiveMapping
 *
 *	Returns:
 *		An object containing the hotkey strings as keys, and th values:
 *			true: if hotkey pertaining to the hotkey string is successfully toggled
 *			false: otherwise
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


/*
 *	Function: setHotkeyMapping
 *
 *	Maps the hotkey string `hkString` to the `slotNum`
 *
 *	Returns:
 *		true if mapping is changed successfully
 *		false if 
 *			- `W3_HOTKEYS_ACTIVE` is true,
 *			- `slotNum` is invalid
 *			- no change, i.e new mapping is the same as old mapping
 */
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


/*
 *	Function: constructActiveMapping
 *	
 *	Fetches configuration from CONFIG_PATH, and adds missing values with
 *	the default if necessary.
 *
 *	Returns:
 *		an object that maps the ORIG_KEYS to their hotkeys
 */
constructActiveMapping(){
	global
	local mapping := loadConfig(CONFIG_PATH, KEYMAP_SECTION)
	return (mapping != "" ? addDefaultValues(mapping, DEFAULT_MAPPING, true) : cloneMap(DEFAULT_MAPPING))
}


/*
 *	Function: saveConfig
 *
 *	Saves the current `ActiveMapping` to CONFIG_PATH
 */
saveConfig(){
	global CONFIG_PATH, KEYMAP_SECTION, ORIG_KEYS, ActiveMapping

	configObj := {(KEYMAP_SECTION): map(reverseMap(ORIG_KEYS), ActiveMapping)}
	if(!writeINI(CONFIG_PATH, configObj)){
		throw Exception("Unable to save configuration")
	}
}


/*
 *	Function: loadConfig
 *
 *	Fetches the corresponding values for the `ORIG_KEYS`
 *
 *	Returns:
 *		if successful, mapping for the original keys
 *		otherwise, blank
 */
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


/*
 *	Function: addDefaultValues
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