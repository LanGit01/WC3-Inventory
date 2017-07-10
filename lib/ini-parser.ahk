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
 *	The object has the following format:
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

