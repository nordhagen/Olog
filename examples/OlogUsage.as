package 
{
	import no.olog.Olog;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * This class simply lists all the avalable properties and methods
	 * of Olog with some minimal documentation. This file is not meant to 
	 * be run, but more as a backhand reference.
	 * 
	 * @author Oyvind Nordhagen
	 * @date 20. feb. 2010
	 */
	public class OlogUsage extends Sprite 
	{
		public function OlogUsage()
		{
			/*
			 * BASIC
			 */
			
			// Minimum required to display Olog
			addChild( Olog.window );
			
			// Enables standard trace output in addition to log window 
			Olog.enableRegularTraceOutput = true;
			
			// Display some output
			Olog.trace( "Hello world" );
			
			// Output can be any type. Certain types are automatically color coded.
			Olog.trace( new Error( "Ooops!" ) );
			
			/*
			 * USAGE WHILE RUNNING
			 * 
			 * While window hidden:
			 * Press SHIFT + Enter to open log window. If a password is set, a prompt will display first.
			 * The password prompt will close and window will open as soon as the correct password is entered.
			 * Alternatively, press ESC to close the password prompt.
			 * 
			 * While window open:
			 * Title bar displays current version of Olog and newer version if one is available, as well as time of movie start.
			 * Scrolling works with the up/down arrows as well as home/end and the mouse wheel as of Flash Player 10.1.
			 * Minimize/maximize/close window with the buttons in the top left.
			 * 
			 * While minimized:
			 * Title bar displays number of new log lines since window was minimized in a green field on the right.
			 */

			/*
			 * CONTROL
			 */
			 
			// Close the window from code
			Olog.close( );
			
			// Open the window from code
			Olog.open( );
			
			// Minimize to title bar Mac OS 9-style
			Olog.minimize( );
			
			// Fit to stage
			Olog.maximize( );
			
			// Set default bounds on stage
			Olog.resize( /* x, y, width, height */ );
			
			// Performs checks the Olog website for a new version and displays the results in the window
			Olog.checkForUpdates( );
			
			// Empty log window
			Olog.clear( );
			
			
			/*
			 * CUSTOMIZING OUTPUT
			 */
			
			// Dimmed output
			Olog.trace( "An unimportant line" , 0 );

			// Default output explicitly (white)
			Olog.trace( "A reglar line" , 1 );

			// Yellow output (e.g. warning)
			Olog.trace( "This might be a problem" , 2 );

			// Red output (e.g. error)
			Olog.trace( "This is bad" , 3 );

			// Green output (e.g. success)
			Olog.trace( "Well done!" , 4 );

			// Blue output (e.g. notable event)
			Olog.trace( "Mode change" , 5 );

			// Output with origin, pass in a this reference
			Olog.trace( "Hello world" , 0 , this );
			
			// Display line numbers for each line
			Olog.lineNumbers = true;
			
			// Display time since movie start for each line
			Olog.runTime = true;
			
			// Display clock time of message for each line
			Olog.timeStamp = false;


			
			/*
			 * OTHER OUTPUT
			 */
			
			// Displays basic information about current runtime
			Olog.traceRuntimeInfo( );
			
			// Creates a point-in-time start reference for an operation that you want to time the duration of
			var testMarker:int = Olog.newTimeMarker( "My test marker" );
			
			// Completes the previously created marker and displays its name and duration
			Olog.completeTimeMarker( testMarker );
			
			// Prints all available information about an object
			Olog.describe( root.loaderInfo );

			
			/*
			 * SETTINGS
			 */
			
			// Setting a password will display a password prompt before opening log window
			Olog.password = "pass";

			// Setting an empty password effectively disble the password prompt
			Olog.password = "";
			
			// Prevents window from being shadowed by other display objects
			Olog.alwaysOnTop = true;
			
			// Open/close window from context menu
			Olog.contextMenuItem = true;
			
			// Remember window position, size, open/closed state, minimized and maximized state
			Olog.rememberWindowState = true;
			

			// Outputs mouse position with a random severity level for demonstration
			stage.addEventListener( MouseEvent.CLICK , _onStageClick );
		}

		private function _onStageClick(event:MouseEvent):void 
		{
			Olog.trace( "x:" + mouseX + " y:" + mouseY , Math.random( ) * 6 );
		}
	}
}
