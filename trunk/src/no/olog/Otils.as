package no.olog {
	import no.olog.utilfunctions.getCallee;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Oyvind Nordhagen
	 * @date 19. feb. 2010
	 */
	internal class Otils {
		private static var _so:SharedObject;
		private static var _memUsageUpdater:Timer;

		public function Otils ():void {
		}

		internal static function parseMsgType ( message:Object ):String {
			var className:String = getClassName( message );
			var classNameSupported:String = getClassName( message, true );
			var result:String;
			switch (classNameSupported) {
				case "String":
					result = (message != "") ? String( message ) : Oplist.EMPTY_MSG_STRING;
					break;
				case "null":
					result = "null";
					break;
				case "Number":
				case "int":
					result = _parseNumberMessage( message );
					break;
				case "XML":
				case "XMLList":
					result = parseMsgType( message.toXMLString() );
					break;
				case "Array":
				case "Vector":
					result = _parseArrayType( message );
					break;
				case "Sprite":
					result = classNameSupported + " (type:" + className + ", name:" + message.name + ")";
					break;
				case "MovieClip":
					result = classNameSupported + " (type:" + className + ", name:" + message.name + ", frames:" + message.totalFrames + ")";
					break;
				case "UncaughtErrorEvent":
					result = "[UNCAUHGT] " + parseMsgType( message.error );
					break;
				case "ErrorEvent":
					result = "";
					var urlPos:int = message.text.indexOf( "URL:" );
					if (urlPos != -1)
						result += "File not found: " + message.text.substr( urlPos + 5 );
					else
						result += message.text;
					result += " (" + _styleEventType( message.type ) + ")";
					if (message.target)
						result += Oplist.ORIGIN_DELIMITER + getClassName( message.target );
					if (message.target != message.currentTarget)
						result += " (via " + getClassName( message.currentTarget ) + ")";
					break;
				case "Event":
					result = className + "." + _styleEventType( message.type );
					if (message.target)
						result += " from " + message.target;
					if (message.target != message.currentTarget)
						result += " (via " + message.currentTarget + "): ";
					else
						result += ": ";
					result += _parseProperties( message );
					break;
				case "Error":
					result = className + _getClosestStackMethod( message ) + ": " + message.message + " (id=" + message.errorID + ")";
					break;
				default:
					result = String( message );
			}
			
			return result.replace( /</g, "&lt;" ).replace( /\>/g, "&gt;" ) || result;
		}

		private static function _parseArrayType ( message:Object ):String {
			if (!Oplist.expandArrayItems) {
				return message.join( ", " ) + " (" + message.length + " items)";
			}
			else {
				var result:String = "[";
				var num:int = message.length;
				for (var i:int = 0; i < num; i++) {
					if (message [i]) {
						result += parseMsgType( message [i] );
						if (i < num - 1) {
							result += ", ";
						}						
					}
				}

				return result += "]";
			}
		}

		private static function _parseNumberMessage ( message:Object ):String {
			if (!isNaN( uint( message ) ) && uint( message ).toString( 16 ).length == 6) {
				return "0x" + uint( message ).toString( 16 );
			}
			else {
				return String( message );
			}
		}

		private static function _getClosestStackMethod ( message:Object ):String {
			return message.getStackTrace().split( "\n" )[1].replace( "\t", " " );
		}

		private static function _styleEventType ( type:String ):String {
			return type.replace( /[A-Z]/, "_$&" ).toUpperCase();
		}

		private static function _parseProperties ( message:Object, includeType:Boolean = false ):String {
			var result:String = "";
			var props:XMLList = describeType( message ).accessor;
			var num:int = props.length();
			for (var i:int = 0; i < num; i++) {
				var p:XML = props[i];
				result += p.@name;
				if (includeType)
					result += ":" + p.@type;
				result += "=" + message[p.@name];
				if (i < num - 1)
					result += ", ";
			}
			return result;
		}

		internal static function parseOrigin ( origin:Object = null ):String {
			var result:String = (origin is String) ? String( origin ) : getClassName( origin );
			return (result != "null") ? result : "";
		}

		internal static function getClassName ( o:Object, supported:Boolean = false ):String {
			if (o == null)
				return "null";

			var result:String;
			var info:XML = describeType( o );
			var className:String = _extractClassOnly( info.@name );

			if (!supported || _isSupportedClass( className )) {
				result = className;
			}
			else {
				var inheritanceTree:XMLList = info.extendsClass;
				var num:int = inheritanceTree.length();
				for (var i:int = 0; i < num; i++) {
					result = extractClassNameFromPackage( inheritanceTree[i].@type );
					if (_isSupportedClass( result ))
						break;
				}
			}
			return result;
		}

		private static function extractClassNameFromPackage ( packageString:String ):String {
			if (packageString.indexOf( "::" ) != -1) {
				return packageString.split( "::" )[1];
			}
			else {
				return packageString;
			}
		}

		private static function _isSupportedClass ( name:String ):Boolean {
			var result:Boolean = false;
			var num:int = Oplist.SUPPORTED_TYPES.length;
			for (var i:int = 0; i < num; i++) {
				if (Oplist.SUPPORTED_TYPES[i] == name) {
					result = true;
					break;
				}
			}
			return result;
		}

		private static function _extractClassOnly ( className:String ):String {
			if (className.indexOf( ":" ) != -1)
				return className.split( "::" )[1];
			else
				return className;
		}

		internal static function validateLevel ( level:int ):int {
			return Math.min( Math.max( level, 0 ), Oplist.TEXT_COLOR_LAST_INDEX );
		}

		internal static function getDefaultWindowBounds ():Rectangle {
			var padding:int = Oplist.PADDING;
			var paddingX2:int = padding * 2;
			var b:Rectangle = new Rectangle();
			_so = SharedObject.getLocal( "OlogSettings" );
			if (_so) {
				var fillScreenWidth:int = Owindow.instance.stage.stageWidth - paddingX2;
				var fillScreenHeight:int = Owindow.instance.stage.stageHeight - paddingX2;
				var restoredWidth:int = uint( _so.data.width );
				var restoredHeight:int = uint( _so.data.height );
				b.x = Math.max( uint( _so.data.x ), padding );
				b.y = Math.max( uint( _so.data.y ), padding );
				b.width = Math.min( restoredWidth, fillScreenWidth );
				b.height = Math.min( restoredHeight, fillScreenHeight );
			}
			else {
				b.x = Math.max( Oplist.x, padding );
				b.y = Math.max( Oplist.y, padding );
				b.width = (Oplist.width != -1) ? Oplist.width : Oplist.DEFAULT_WIDTH;
				b.height = (Oplist.height != -1) ? Oplist.height : Oplist.DEFAULT_HEIGHT;
			}

			return b;
		}

		internal static function getDaysSinceVersionCheck ():int {
			_so = SharedObject.getLocal( "OlogSettings" );
			if (_so) {
				var now:int = new Date().getTime();
				var then:int = int( _so.data.lastVersionCheck );
				return (then > 0) ? Math.floor( (now - then) / Oplist.DAY_IN_MS ) : Oplist.VERSION_CHECK_INTERVAL_DAYS;
			}
			else {
				return Oplist.VERSION_CHECK_INTERVAL_DAYS;
			}
		}

		internal static function getSavedMinimizedState ():Boolean {
			_so = SharedObject.getLocal( "OlogSettings" );
			return (_so) ? Boolean( _so.data.isMinimized ) : false;
		}

		internal static function getSavedOpenState ():Boolean {
			_so = SharedObject.getLocal( "OlogSettings" );
			return (_so) ? Boolean( _so.data.isOpen ) : true;
		}

		internal static function recordWindowState ():void {
			if (!Oplist.rememberWindowState)
				return;
			if (!_so)
				_so = SharedObject.getLocal( "OlogSettings" );
			_so.data.x = Math.min( Math.max( 0, Owindow.instance.x ), Owindow.instance.stage.stageWidth );
			_so.data.y = Math.min( Math.max( 0, Owindow.instance.y ), Owindow.instance.stage.stageHeight );
			_so.data.width = Owindow.instance.width;
			_so.data.height = Owindow.instance.height;
			_so.data.isMinimized = Owindow.isMinimized;
			_so.data.isOpen = Owindow.isOpen;
			_so.data.showMemoryUsage = Oplist.showMemoryUsage;
			_savePersistentData();
		}

		internal static function recordVersionCheckTime ():void {
			if (!_so)
				_so = SharedObject.getLocal( "OlogSettings" );
			_so.data.lastVersionCheck = new Date().getTime();
			_savePersistentData();
		}

		private static function _savePersistentData ():void {
			var flushStatus:String = null;
			try {
				flushStatus = _so.flush();
			}
			catch (e:Error) {
				Olog.trace( e );
			}
		}

		internal static function formatTime ( ms:int ):String {
			var d:Date = new Date( ms );
			var strms:String = addLeadingZeroes( String( d.getMilliseconds() ), 3 );
			var strsec:String = addLeadingZeroes( String( d.getSeconds() ), 2 );
			var strmin:String = addLeadingZeroes( String( d.getMinutes() ), 2 );
			var strhrs:String = String( d.getHours() - 1 );
			return strhrs + ":" + strmin + ":" + strsec + "'" + strms;
		}

		internal static function addLeadingZeroes ( numString:String, numZeroes:int = 2 ):String {
			while (numString.length < numZeroes)
				numString = "0" + numString;
			return numString;
		}

		internal static function parseTypeAndLevel ( supportedType:String, level:uint ):int {
			switch (supportedType) {
				case "Error":
				case "ErrorEvent":
					return 3;
					break;
				case "Event":
					return 5;
					break;
				default:
					return validateLevel( level );
			}
		}

		internal static function getLevelColorAsUint ( level:uint ):uint {
			return uint( "0x" + String( Oplist.TEXT_COLORS_HEX[level] ).substr( 1 ) );
		}

		internal static function getDescriptionOf ( o:Object, limitProperties:Array = null ):String {
			var newLine:String = "\n" + Oplist.LINE_START_TABS;
			var separator:String = newLine + Ocore.colorTextLevel( "-", 0 );
			var result:String = "";

			var d:XML = describeType( o );
			var type:String = getClassName( o );
			var propsArr:Array = new Array();
			if (d.@isDynamic)
				propsArr.push( "dynamic" );
			if (d.@isStatic)
				propsArr.push( "static" );
			if (d.@isFinal)
				propsArr.push( "final" );
			var objectName:String;

			if (o.hasOwnProperty( "name" ) && o.name != null)
				objectName = " (" + o.name + ")";
			else
				objectName = "";

			result += Ocore.colorTextLevel( "Description of " + type + objectName, 1 );

			if (propsArr.length > 0)
				result += Ocore.colorTextLevel( " (" + propsArr.join( ", " ) + ")", 0 );

			var baseList:XMLList = d.extendsClass;
			var heritage:String = "";
			var numClasses:int = baseList.length();
			for (var curClass:int = 0; curClass < numClasses; curClass++) {
				heritage += extractClassNameFromPackage( baseList[curClass].@type );
				if (curClass < numClasses - 1)
					heritage += "-";
			}

			result += newLine + newLine + Ocore.colorTextLevel( "Inheritance tree: " + heritage, 0 );

			var parsedVars:Dictionary = new Dictionary( true );

			var varList:XMLList = d.variable;
			var accessorList:XMLList = d.accessor.(@access == "readwrite" || @access == "readonly");
			if (varList.length() > 0) varList.appendChild( accessorList );
			else varList = accessorList;
			var variables:String = "";
			var numParsedVars:int = varList.length();
			var varsTotal:int = varList.length();
			var varName:String;
			for (var curVar:int = 0; curVar < numParsedVars; curVar++) {
				var v:XML = varList[curVar];
				varName = v.@name;
				if (!limitProperties || limitProperties.indexOf( varName ) != -1) {
					parsedVars[v.@name] = { name:v.@name, type:v.@type };
				}
			}

			for (var p:String in o) {
				if (!parsedVars[p]) {
					varsTotal++;
					if (!limitProperties || limitProperties.indexOf( p ) != -1) {
						var className:String = getQualifiedClassName( o[p] );
						parsedVars[p] = { name:p, type:className };
						numParsedVars++;
					}
				}
			}

			for each (var item:Object in parsedVars) {
				variables += newLine + "var " + item.name + Ocore.colorTextLevel( ":" + extractClassNameFromPackage( item.type ), 0 ) + "\t= " + o[item.name];
			}

			if (numParsedVars > 0)
				result += separator + Ocore.colorTextLevel( variables, 1 );

			var constList:XMLList = d.constant;
			var constants:String = "";
			var numConst:int = constList.length();
			for (var curConst:int = 0; curConst < numConst; curConst++) {
				varsTotal++;
				var c:XML = constList[curConst];
				if (!limitProperties || limitProperties.indexOf( String( c.@name ) ) != -1)
					constants += "\n\tconst " + c.@name + Ocore.colorTextLevel( ":" + extractClassNameFromPackage( c.@type ), 0 ) + "\t= " + o[c.@name];
			}

			if (numConst > 0)
				result += separator + "\n\t" + Ocore.colorTextLevel( constants, 1 );

			result += separator + newLine + Ocore.colorTextLevel( numParsedVars + " value(s) shown of total " + varsTotal + " found", 0 ) + "\n";
			return result;
		}

		internal static function getLineStart ( index:int, timestamp:String, runtime:String ):String {
			if (!Oplist.enableTimeStamp && !Oplist.enableLineNumbers && !Oplist.enableRunTime)
				return "";
			var result:String = "[";
			if (Oplist.enableLineNumbers)
				result += Otils.addLeadingZeroes( String( index ), 3 );
			if (Oplist.enableTimeStamp)
				result += (Oplist.enableLineNumbers) ? Oplist.LINE_START_DELIMITER + timestamp : timestamp;
			if (Oplist.enableRunTime)
				result += (Oplist.enableTimeStamp || Oplist.enableLineNumbers) ? Oplist.LINE_START_DELIMITER + runtime : runtime;
			result += "]" + Oplist.AFTER_LINE_START;
			return result;
		}

		internal static function stopMemoryUsageUpdater ():void {
			if (_memUsageUpdater) {
				_memUsageUpdater.stop();
				_memUsageUpdater.removeEventListener( TimerEvent.TIMER, _updateMemoryUsage );
				_memUsageUpdater = null;
			}
		}

		internal static function startMemoryUsageUpdater ():void {
			if (Oplist.showMemoryUsage && !_memUsageUpdater) {
				_memUsageUpdater = new Timer( 1000 );
				_memUsageUpdater.addEventListener( TimerEvent.TIMER, _updateMemoryUsage );
				_memUsageUpdater.start();
			}
		}

		internal static function isPrimitive ( value:* ):Boolean {
			return value is String || value is Number || value is int || value is uint;
		}

		internal static function breakPoint ( ...args ):void {
			var level:uint = Oplist.MARKER_COLOR_INDEX;
			var msg:String = "Breakpoint reached: " + getCallee( 7 );
			var numArgs:int = args.length;
			if (numArgs == 0) {
				Ocore.trace( msg, level );
			}
			else if (numArgs == 1) {
				if (isPrimitive( args[0] )) {
					msg += ", " + parseMsgType( args[i] );
					Ocore.trace( msg, level );
				}
				else {
					Ocore.trace( msg, level );
					Ocore.describe( args[0], level );
				}
			}
			else {
				var restArgsAllStrings:Boolean = true;
				for (var restArgIndex:int = 1; restArgIndex < numArgs; restArgIndex++) {
					if (!(args[restArgIndex] is String)) {
						restArgsAllStrings = false;
						break;
					}
				}
				if (!isPrimitive( args[0] ) && restArgsAllStrings) {
					Ocore.trace( msg, level );
					Ocore.describe( args[0], level, null, args.slice( 1 ) );
				}
				else {
					for (var i:int = 0; i < numArgs; i++) {
						msg += ", " + parseMsgType( args[i] );
					}
					Ocore.trace( msg, level );
				}
			}
		}

		private static function _updateMemoryUsage ( e:TimerEvent ):void {
			Owindow.displayMemoryUsage( Number( (System.totalMemory * 0.000000954).toFixed( 1 ) ) );
		}
	}
}
