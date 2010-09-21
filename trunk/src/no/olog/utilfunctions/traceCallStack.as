package no.olog.utilfunctions
{
	import no.olog.Olog;

	/**
	 * @author Oyvind Nordhagen
	 * @date 13. sep. 2010
	 */
	public function traceCallStack () : void
	{
		var lineExp:RegExp = new RegExp( "(?<=\tat ).+\(\)" , "gs" );
		var replExp:RegExp = new RegExp( "::|\$?\/" , "g" );
		
		var stackLines:String = new Error().getStackTrace().match( lineExp ).join( "\n" );
		var output:String = "Call stack:\n" + stackLines;//.replace( replExp , "." );
		Olog.trace( new Error().getStackTrace().match( lineExp ) , 1 );
	}
}
