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