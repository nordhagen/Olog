package no.olog.utilfunctions {
	import no.olog.Olog;
	/**
	 * @author Oyvind Nordhagen
	 * @date 13. apr. 2011
	 */
	public function todo ( ...args ):void {
		var msg:Object = args.length == 1 ? args[0] : args.join( " " );
		Olog.trace( "TODO: " + msg, 7 );
	}
}
