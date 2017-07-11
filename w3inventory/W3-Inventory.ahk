#SingleInstance, force
#NoEnv

; Inventory item slots' shortcut keys. Index corresponds to slot number.
origHotkeys := ["{Numpad7}", "{Numpad8}", "{Numpad4}", "{Numpad5}", "{Numpad1}", "{Numpad2}"]
defaultHotkeys := ["!q", "!w", "!a", "!s", "!z", "!c"]

MsgBox, % deepPrintObject(buildRemapObject(defaultHotkeys, origHotkeys))


Exit

;==========================================
;				Functions
;==========================================

; create an object where newKeys[key]: origKeys[key]
buildRemapObject(newKeys, origKeys){
	remap := {}

	For key, value in origKeys{
		if(newKeys.HasKey(key)){
			remap[newKeys[key]] := value 
		}
	}

	return remap
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