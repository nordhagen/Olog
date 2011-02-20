package no.olog.logtargets {
	import no.olog.Oline;
	import flash.external.ExternalInterface;

	/**
	 * Forwards log messages to the JavaScript console/Firebug
	 * @author Oyvind Nordhagen
	 * @date 19. feb. 2011
	 */
	public class ConsoleTarget implements ILogTarget {
		public function writeLogLine ( line:Oline ):void {
			if (ExternalInterface.available) {
				switch (line.level) {
					case 2:
						ExternalInterface.call( "console.warn", line.msg );
						break;
					case 3:
						ExternalInterface.call( "console.error", line.msg );
						break;
					default:
						ExternalInterface.call( "console.log", line.msg );
				}
			}
		}
	}
}
