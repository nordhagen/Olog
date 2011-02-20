package no.olog.logtargets {
	import no.olog.Oline;

	/**
	 * Forwards log messages to the Flash Output panel/Flex console
	 * @author Oyvind Nordhagen
	 * @date 19. feb. 2011
	 */
	public class TraceTarget implements ILogTarget {
		public function writeLogLine ( line:Oline ):void {
			var msg:String = line.msg.replace( /<\/?.+?>/gi, "" ).replace( /\t/g, " " );
			trace( _getLogLevelString( line.level ) + msg + " ~ " + line.origin );
		}

		private function _getLogLevelString ( level:int ):String {
			switch (level) {
				case 1:
					return "[info] ";
					break;
				case 2:
					return "[warning] ";
					break;
				case 3:
					return "[error] ";
					break;
				case 3:
					return "[success] ";
					break;
				default:
					return "[debug] ";
			}
		}
	}
}
