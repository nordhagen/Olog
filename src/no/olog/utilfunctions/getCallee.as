package no.olog.utilfunctions
{
	/**
	 * Returns a prettified string representation of the selected call stack index
	 * in the form MyClass.myFunction(), line [lineNumber].
	 * @param calltStackIndex the index in the call stack to return, typically 2 if you
	 * wish to return the position of the the function that called the function cointaining the call to getCalle.
	 * @return String
	 */
	public function getCallee ( calltStackIndex:int = 2 ) : String
	{
		// Full line from stack trace
		var stackLine:String = new Error().getStackTrace().split( "\n" , calltStackIndex + 1 )[calltStackIndex];
		
		// Finds a pair of parenthesis and any word characters in front of them		
		var functionName:String = stackLine.match( /\w+\(\)/ )[0];
		
		// Class name and line number depends on the function existing in a physical class file
		var className:String;
		var lineNumber:String;
		if (stackLine.indexOf( ".as" ) != -1)
		{
			className = stackLine.match( /(?<=\/)\w+?(?=.as:)/ )[0] + ".";
			lineNumber = ", line " + stackLine.match( /(?<=:)\d+/ )[0];
		}
		else
		{
			className = "";
			lineNumber = "";
		}

		if (className.substr( 0, -1 ) == functionName.substr( 0, -2))
			functionName = "constructor()";
		
		return className + functionName + lineNumber;
	}
}
