/*
 *	INI format: 
 *		https://en.wikipedia.org/wiki/INI_file
 *
 *	additional details specific to this module:
 *		- whitespace before and after a line are ignored
 *		- empty lines are ignored
 *		- allows empty value, but not empty key
 */


/**
 *	Function: readINI
 *
 *	Reads an INI file, building an object representing the contents of the INI file.
 *	The object has the following structure:
 *
 *		ObjectVar[Section][Key] = Value
 *
 *	Returns:
 *		an object representing the contents of the INI file
 */
readINI(filepath){
	IfNotExist, %filepath%
		throw Exception("File does not exist")

	iniObj := {}, currentSection := pair := linelength := ""

	Loop, read, %filepath%
	{
		line := Trim(A_LoopReadLine)
		linelength := StrLen(line)
		if(linelength != 0){
			if(SubStr(line, 1, 1) = "[" && SubStr(line, 0, 1) = "]"){
				if(linelength < 3){
					throw Exception("Invalid ini file")
				}

				currentSection := SubStr(line, 2, linelength - 2)
				iniObj[currentSection] := {}
			}else{
				pair := StrSplit(line, "=")
				if(pair.Length() != 2 || pair[1] = "" || currentSection = ""){
					throw Exception("Invalid ini file")
				}
				
				iniObj[currentSection][pair[1]] := pair[2]
			}
		}
	}

	return iniObj
}

/*
 *	Function:  writeINI
 *
 *	Creates an INI file from the provided object. The first-level keys are used as Sections.
 *	Second-level keys are used as Keys, and the value as Values. Thus, the object structure
 *	is as such:
 *
 *		ObjectVar[Section][Key] = Value
 *
 *	If a the file in `filepath` exists, it will be overwritten.
 *		
 *	Returns:
 *		Number of bytes written, if successful
 *		Blank, otherwise
 */
writeINI(filepath, configObj){
	if(!IsObject(configObj)){
		throw Exception("Parameter 2 must be an object")
	}

	iniStr := ""
	numSections := countKeys(configObj)
	numPairs := ""

	For Section, Pair in configObj{
		iniStr .= "[" . Section . "]"

		if(A_Index = numSections){
			numPairs := countKeys(configObj[Section])

			if(numPairs > 0){
				iniStr .= "`n"
			}
		}else{
			iniStr .= "`n"
		}

		For Key, Value in Pair{
			iniStr .= Key . "=" . Value

			if(numPairs = "" || A_Index < numPairs){
				iniStr .= "`n"
			}
		}
	}

	file := FileOpen(filepath, "w")
	if(file){
		return file.Write(iniStr)
	}
}


countKeys(obj){
	numKeys := 0
	For Key in obj{
		numKeys++
	}
	return numKeys
}