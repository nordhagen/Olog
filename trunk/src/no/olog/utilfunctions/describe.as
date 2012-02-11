package no.olog.utilfunctions
{
	import no.olog.Olog;

	/**
	 * Calls describeType on the supplied object and outputs the results in a friendly format 
	 * @param object Any type object to describe
	 * @param level Severity level @see Olog.trace for explaination the level argument
	 * @param origin A String or object specifying where in the application the message originated
	 * @return void
	 */
	public function describe ( object:*, level:uint = 1, origin:* = null ):void
	{
		Olog.describe( object, level, origin );
	}
}
