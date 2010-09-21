package no.olog.utilfunctions
{
	import no.olog.Olog;
	/**
	 * Shorthand for Olog.trace(). Outputs content to log. The message argument can be anything from basic strings to
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
	 * @param origin A String or object specifying where in the application the message originated. Note: This parameter
	 * should be passed as a String if Olog is to be included in the release build for optimum performance.
	 * @return void
	 */
	public function otrace ( message:* , level:uint = 1 , origin:* = null ):void
	{
		Olog.trace( message , level , origin );
	}
}
