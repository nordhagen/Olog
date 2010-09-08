package no.olog.utilfunctions
{
	import no.olog.Olog;

	/**
	 * Sets a virtual break point. Code execution is not halted, but the class,
	 * function name and line number of the call to breakPoint is written to the log window
	 * along with introspection of any argument passed to it.
	 * @param args Values to inspect at break point.
	 */
	public function breakPoint ( ...args ) : void
	{
		Olog.trace( "Breakpoint reached" , 4 , getCallee( 3 ) );
		var num:int = args.length;
		for (var i:int = 0; i < num; i++)
		{
			Olog.describe( args[i] , 1 );
		}
	}
}
