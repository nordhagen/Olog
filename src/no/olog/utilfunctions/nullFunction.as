package no.olog.utilfunctions
{
	import no.olog.Olog;

	/**
	 * Function to use in place of yet to be assigned functions and callbacks.
	 * @param args Enables support for replacing calls to functions with arguments.
	 */
	public function nullFunction ( ...args ) : void
	{
		var text:String = "Null Function Reference";
		text += (args && args.length > 0) ? " with arguments " + args.join( ", " ) : "";
		Olog.trace( text , 2 , getCallee( 3 ) );
	}
}
