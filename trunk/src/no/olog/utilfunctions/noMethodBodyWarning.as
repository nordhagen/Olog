package no.olog.utilfunctions
{
	import no.olog.Olog;

	/**
	 * Sends a warning to the log window indicating a method without a body and its location.
	 */
	public function noMethodBodyWarning () : void
	{
		Olog.trace( "Methond has no body" , 3 , getCallee( 3 ) );
	}
}
