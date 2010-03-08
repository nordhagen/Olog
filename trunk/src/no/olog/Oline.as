package no.olog 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 22. feb. 2010
	 */
	internal class Oline 
	{
		internal var msg:String;
		internal var level:uint;
		internal var origin:String;
		internal var timestamp:String;
		internal var runtime:String;
		internal var index:int;
		internal var type:String;
		internal var supportedType:String;
		internal var useLineStart:Boolean;
		internal var repeatCount:int = 0;
		internal var bypassValidation:Boolean;

		public function Oline(msg:String, level:uint, origin:String, timestamp:String, runtime:String,
		index:int, type:String, supportedType:String, useLineStart:Boolean = true, bypassValidation:Boolean = false):void
		{
			this.msg = msg;
			this.level = level;
			this.origin = origin;
			this.timestamp = timestamp;
			this.runtime = runtime;
			this.index = index;
			this.type = type;
			this.supportedType = supportedType;
			this.useLineStart = useLineStart;
			this.bypassValidation = bypassValidation;
		}
	}
}
