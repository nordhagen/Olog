package no.olog 
{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	/**
	 * <h1>Olog</h1>
	 * <p>Logging utility for Flash based applications. All properties and methods
	 * are static. Call addChild(Olog.window) to get started. Then call Olog.trace() to
	 * output messages to the log window.</p>
	 * 
	 * <h2>Usage while running</h2>
	 * 
	 * <h3>While window hidden</h3>
	 * <p>Press SHIFT + Enter to open log window. If a password is set, a prompt will display first.
	 * The password prompt will close and window will open as soon as the correct password is entered.
	 * Alternatively, press ESC to close the password prompt.</p>
	 * 
	 * <h3>While window open</h3>
	 * <p>Title bar displays current version of Olog and newer version if one is available, as well as time of movie start.
	 * Scrolling works with the up/down arrows as well as home/end and the mouse wheel as of Flash Player 10.1.
	 * Minimize/maximize/close window with the buttons in the top left. You can also toggle minimize by
	 * duble clicking on the title bar.</p>
	 * 
	 * <h3>Filtering</h3>
	 * <p>You can filter the log output by pressing the number keys equivalent to log levels 0 through 5.
	 * Doing so will reveal only lines of that level/color. Press ESC to reset filtering.</p>
	 * 
 	 * <h3>Prefs pane</h3>
	 * <p>The circular button rightmost in the title bar will toggle the preferences pane. It contains
	 * buttons for saving the log output as UTF-8 text or XML.</p>
	 * 
	 * <h3>While minimized</h3>
	 * <p>Title bar displays number of new log lines since window was minimized in a green field on the right.</p>
	 * 
	 * @author Oyvind Nordhagen
	 * @date 19. feb. 2010
	 */
	public class Olog extends Sprite 
	{
		/**
		 * Constructor. Do not use. Use addChild(Olog.window) instead.
		 * @throws IllegalOperationError
		 */
		public function Olog():void
		{
			throw new IllegalOperationError( "Use static methods" );
		}
		
		/**
		 * Outputs content to log. The message argument can be anything from basic strings to
		 * complext objects. Some objects types will be parsed further to display informal output
		 * about them. Use the level argument to specify a severity level with corresponding text color.
		 * @param message Any type object to display as message in log
		 * @param level Severity level
		 * <ul>
		 * <li>0: Dimmed, use for unimportant/highly repetative content</li>
		 * <li>1: Default, white</li>
		 * <li>2: Orange, typicaly used for warnings</li>
		 * <li>3: Red, typically used for errors. Olog uses this level automatically when message argument is Error or ErrorEvent</li>
		 * <li>4: Green, typically indicates success of some sort </li>
		 * <li>5: Blue, for notable events and default when message argument is of type Event</li>
		 * </ul>
		 * @param origin A String or object specifying where in the application the message originated
		 * @return void
		 */
		public static function trace(message:*, level:uint = 1, origin:* = null):void
		{
			Ocore.trace( message, level, origin );
		}

		/**
		 * Calls describeType on the supplied object and outputs the results in a friendly format 
		 * @param object Any type object to describe
		 * @param level Severity level @see Olog.trace for explaination the level argument
		 * @param origin A String or object specifying where in the application the message originated
		 * @return void
		 */
		public static function describe(object:*, level:uint = 1, origin:* = null):void
		{
			Ocore.describe( object, level, origin );
		}

		/**
		 * Outputs an uppercase section headline  
		 * @param headerText Headline text as String
		 * @param level Severity level @see Olog.trace for explaination the level argument
		 * @return void
		 */
		public static function header(headerText:String, level:uint = 1):void
		{
			Ocore.writeHeader( headerText, level );
		}

		/**
		 * Outputs an empty lines  
		 * @param numLines Number of empty lines to write 
		 * @return void
		 */
		public static function cr(numLines:int = 1):void
		{
			Ocore.writeNewline( numLines );
		}

		/**
		 * Outputs basic information about current runtime, such as Flash Player version, platform an size  
		 * @return void
		 */
		public static function traceRuntimeInfo():void
		{
			Ocore.traceRuntimeInfo( );
		}
		
		/**
		 * Checks the Olog website for a newer version. Outputs the results to the log window.  
		 * @return void
		 */
		public static function checkForUpdates():void
		{
			Ocore.evalVersionCheck(true);
		}
		
		/**
		 * Creates a timing marker that you can later complete by calling completeTimeMarker() to 
		 * output the time in between.
		 * @param name String reference to use when the marker completes an results are displayed.
		 * @return An integer ID to use as argument when calling completeTimeMarker(). 
		 * @see completeTimeMarker()
		 */
		public static function newTimeMarker(name:String = null, origin:Object = null):int
		{
			return Ocore.newTimeMarker( name, origin );
		}
		
		/**
		 * Completes a previously created time marker and outputs the duration.
		 * @param id integer id of time marker to complete
		 * @return void
		 */
		public static function completeTimeMarker(id:int):void
		{
			Ocore.completeTimeMarker( id );
		}
		
		/**
		 * Returns the window instance to add to the display list
		 * @return Owindow singleton instance
		 */
		public static function get window():Owindow
		{
			return Owindow.instance;
		}
		
		/**
		 * Empties the log contents
		 * @return void
		 */
		public static function clear():void
		{
			Owindow.clear( );
		}

		/**
		 * Opens log window, bypassing password validation
		 * @return void
		 */
		public static function open():void
		{
			Owindow.open( );
		}

		/**
		 * Closes log window
		 * @return void
		 */
		public static function close():void
		{
			Owindow.close( );
		}

		/**
		 * Maximizes log window
		 * @return void
		 */
		public static function maximize():void
		{
			Owindow.maximize( );
		}

		/**
		 * Minimizes log window
		 * @return void
		 */
		public static function minimize():void
		{
			Owindow.minimize( );
		}
		
		/**
		 * Sets a password for opening log window. An empty string effectively disables the password prompt.
		 */
		public static function set password(val:String):void
		{
			Ocore.setPassword( val );
		}

		public static function get password():String
		{
			return Ocore.getPassword( );
		}

		/**
		 * Toggles whether consecutive identical messages are stacked (shown with counts) or displayed separately.
		 * NOTE: This change only applies to messages recieved after the call point. Previously stacked/repeated
		 * messages will remain as-is after this setting is changed.
		 */
		public static function set stackRepeatedMessages(val:Boolean):void
		{
			Oplist.stackRepeatedMessages = val;
		}
		
		public static function get stackRepeatedMessages():Boolean
		{
			return Oplist.stackRepeatedMessages;
		}
		
		/**
		 * Toggles keybard control over opening, closing, scrolling and filtering
		 */
		public static function set keyboardEnabled(val:Boolean):void
		{
			Ocore.setKeyboardEnabled( val );
		}
		
		public static function get keyboardEnabled():Boolean
		{
			return Oplist.keyBoardEnabled;
		}
		
		/**
		 * Toggles The context menu item for opening/closing window on or off
		 */
		public static function set contextMenuItem(val:Boolean):void
		{
			Ocore.setCMI( val );
		}

		public static function get contextMenuItem():Boolean
		{
			return Ocore.hasCMI;
		}

		/**
		 * Toggles persistent window state between application launches by means of SharedObject
		 */
		public static function set rememberWindowState(val:Boolean):void
		{
			Oplist.rememberWindowState = val;
		}

		public static function get rememberWindowState():Boolean
		{
			return Oplist.rememberWindowState;
		}

		/**
		 * Toggles the automatic weekly update check on/off
		 */
		public static function set updateCheckEnabled(val:Boolean):void
		{
			Oplist.enableVersionCheck = val;
			if (val) Ocore.evalVersionCheck( );
		}

		public static function get updateCheckEnabled():Boolean
		{
			return Oplist.checkForNewVersion;
		}
		
		/**
		 * Toggles always on top
		 */
		public static function set alwaysOnTop(val:Boolean):void
		{
			Oplist.alwaysOnTop = val;
			Ocore.evalAlwaysOnTop( );
		}

		public static function get alwaysOnTop():Boolean
		{
			return Oplist.alwaysOnTop;
		}
		
		/**
		 * Sets the default bounds of the log window
		 * @param x X position
		 * @param w Y position
		 * @param w Width
		 * @param h Height
		 * @return void
		 */
		public static function resize(x:int = 0, y:int = 0, width:int = 0, height:int = 0):void
		{
			Oplist.x = x;
			Oplist.y = y;
			Oplist.width = width;
			Oplist.height = height;
			Owindow.resizeToDefault();
		}
		
		/**
		 * Toggles clock time for each line on/off
		 */
		public static function set timeStamp(val:Boolean):void
		{
			Oplist.enableTimeStamp = val;
			Ocore.refreshLog( );
		}

		public static function get timeStamp():Boolean
		{
			return Oplist.enableTimeStamp;
		}

		/**
		 * Toggles time since launch for each line on/off
		 */
		public static function set runTime(val:Boolean):void
		{
			Oplist.enableRunTime = val;
			Ocore.refreshLog( );
		}

		public static function get runTime():Boolean
		{
			return Oplist.enableRunTime;
		}

		/**
		 * Toggles line number for each line on/off
		 */
		public static function set lineNumbers(val:Boolean):void
		{
			Oplist.enableLineNumbers = val;
			Ocore.refreshLog( );
		}

		public static function get lineNumbers():Boolean
		{
			return Oplist.enableLineNumbers;
		}
	}
}
