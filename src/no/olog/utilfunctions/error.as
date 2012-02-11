package no.olog.utilfunctions
{
	import no.olog.Olog;
	/**
	 * Shorthand for calling Olog.trace() with level 3
	 * Passing a single argument will enable parsing of that argument. 
	 * Allows for passing a comma seperated list of items to trace, in which
	 * case they will be concatinated by a space and parsing of message types will be bypassed.
	 */
	public function error ( ...args ):void
	{
		var msg:Object = args.length == 1 ? args[0] : args.join( " " );
		Olog.trace( msg, 3 );
	}
}
