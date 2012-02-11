package no.olog.logtargets {
	import no.olog.Oline;
	import no.olog.Olog;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	/**
	 * @author Oyvind Nordhagen
	 * @date 21. feb. 2011
	 */
	public class OlogAppTarget implements ILogTarget {
		private static const APP_CONNECTION_ID:String = "app#OlogConsole:Olog";
		private static const FUNCTION_NAME:String = "writeLogLine";
		public static var applicationName:String = "";
		private var _conn:LocalConnection;
		private var _errorReported:Boolean;

		public function writeLogLine ( line:Oline ):void {
			if (applicationName) line.msg = "[" + applicationName + "] " + line.msg;
			try {
				_connection.send( APP_CONNECTION_ID, FUNCTION_NAME, line );
			}
			catch (e:Error) {
				Olog.trace( "LocalConnection.send failed: " + e.message, 2, "Olog" );
			}
		}

		private function get _connection ():LocalConnection {
			if (_conn) return _conn;
			else {
				try {
					_conn = new LocalConnection();
					_conn.addEventListener( StatusEvent.STATUS, _statusHandler );
					Olog.trace( "== Session ==", 6 );
					return _conn;
				}
				catch (error:ArgumentError) {
					Olog.trace( "No active LocalConnection reciever found at " + APP_CONNECTION_ID, 3, "Olog" );
				}
			}
			return null;
		}

		private function _statusHandler ( event:StatusEvent ):void {
			if (event.level == "error" && !_errorReported) {
				Olog.trace( "Send to OlogConsole failed", 3, "Olog" );
				_errorReported = true;
			}
		}
	}
}
