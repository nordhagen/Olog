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
		var stackLine:String = new Error().getStackTrace().split( "\n" , calltStackIndex + 1 )[calltStackIndex];
		var functionName:String = stackLine.match( /\w+\(\)/ )[0];
		var className:String = stackLine.match( /(?<=\/)\w+?(?=.as:)/ )[0];
		var lineNumber:String = stackLine.match( /(?<=:)\d+/ )[0];
		return className + "." + functionName + ", line " + lineNumber;
	}
}
