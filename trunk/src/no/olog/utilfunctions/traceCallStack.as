package no.olog.utilfunctions
{
	import no.olog.Olog;

	/**
	 * @author Oyvind Nordhagen
	 * @date 13. sep. 2010
	 */
	public function traceCallStack ( origin:* = null ) : void
	{
		var stackLines:Array = new Error().getStackTrace().split( "\n" );
		var output:String = "Call stack for " + stackLines[2].match( /\w+\(\)/ )[0];
		var stackLine:String;
		var classAndFunction:String;
		var lineNumberMatches:Array;
		var lineNumber:String;
		var num:int = stackLines.length;
		for (var i:int = 2; i < num; i++)
		{
			stackLine = stackLines[i];
			classAndFunction = stackLine.match( /\w+?(::|\/)?(\w| )+?\(\)/ )[0];
			lineNumberMatches = stackLine.match( /(?<=:)\d+/ );
			lineNumber = (lineNumberMatches) ? ", line " + lineNumberMatches[0] : "";
			output += "\n\t" + classAndFunction.replace( "/", "." ) + lineNumber;
		}

		Olog.trace( output, 1, origin );
	}
}
