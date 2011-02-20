package no.olog.logtargets {
	import no.olog.Oline;
	import no.olog.Olog;
	import flash.net.LocalConnection;

	/**
	 * Forwards log messages through a LocalConnection at the ID specified by Olog.LOCAL_CONNECTION_ID, to a function called "ologTrace"
	 * @author Oyvind Nordhagen
	 * @date 22. jan. 2011
	 */
	public class LocalConnectionTarget implements ILogTarget {
		private var _conn:LocalConnection;

		public function writeLogLine ( line:Oline ):void {
			try {
				_connection.send( Olog.LOCAL_CONNECTION_ID, "ologTrace", [ line ] );
			}
			catch (e:Error) {
				Olog.trace( "External console unreacable", 2, this );
			}
		}

		private function get _connection ():LocalConnection {
			if (_conn) return _conn;
			else {
				try {
					_conn = new LocalConnection();
					_conn.connect( Olog.LOCAL_CONNECTION_ID );
					Olog.trace( "Connected to " + Olog.LOCAL_CONNECTION_ID, 0, this );
					return _conn;
				}
				catch (error:ArgumentError) {
					Olog.trace( "LocalConnection failed", 3, this );
				}
			}
			return null;
		}
	}
}
