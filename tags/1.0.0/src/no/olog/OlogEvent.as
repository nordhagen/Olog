package no.olog 
{
	import flash.events.Event;
	
	/**
	 * Event class to use for loosely coupled logging. Use Olog.trace() as event handler for these events.
	 * @author Oyvind Nordhagen
	 * @see Olog.trace
	 * @date 19. feb. 2010
	 */
	public class OlogEvent extends Event
	{
		/**
		 * Equivalent to calling Olog.trace()
		 */
		public static const TRACE:String = "oout";

		/**
		 * Equivalent to calling Olog.header()
		 */
		public static const HEADER:String = "oheader";

		/**
		 * Equivalent to calling Olog.describe()
		 */
		public static const DESCRIBE:String = "odescribe";

		/**
		 * Equivalent to calling Olog.cr()
		 */
		public static const NEWLINE:String = "cr";
		
		public var message:Object;
		public var level:int;
		public var origin:Object;
		
		public function OlogEvent(type:String, message:Object, level:int = 0, origin:Object = null)
		{
			super(type, true, true);
			this.message = message;
			this.level = level;
			this.origin = origin;
		}

		/**
		 * Creates and returns a copy of the current instance.
		 * @return A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new OlogEvent(type, message, level, origin);
		}
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("OtraceEvent","type","message","level","origin","bubbles","cancelable","eventPhase");
		}
	}
}
