package no.olog 
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 7. juni 2010
	 */
	public class Oassert 
	{
		internal static function getTestResults(result:*, expected:Array):Array 
		{
			var results:Array = [];
			var num:int = expected.length;
			for (var i:int = 0; i < num; i++)
			{
				results.push( _getSingleAssertResult( result , expected[i] ) );
			}
			
			return null;
		}

		private static function _getSingleAssertResult(result:*, expected:*):String 
		{
			var ret:String;
			var compareMethod:Function = _getCompateMethod( expected );
			var passed:Boolean = compareMethod( result , expected );
			if (passed)
			{
				ret = "Passed";
			}
			else
			{
				ret = "Failed";
			}
			return ret;
		}

		private static function _getCompateMethod(expected:*):Function 
		{
			var ret:Function;
			switch (Otils.getClassName( expected ))
			{
				case "String":
					ret = _getStringCompareMethod( expected );
					break;
				
				default:
					throw new Error( "switch case unsupported" );
			}
			
			return ret;
		}

		private static function _getStringCompareMethod(expected:String):Function 
		{
			var ret:Function;
			if (expected.indexOf( "<>" ))
			{
				ret = _insideRange;
			}
			else if (expected.indexOf( "><" ))
			{
				ret = _outsideRange;
			}
			else if (expected.indexOf( "<=" ))
			{
				ret = _lessThanOrEqual;
			}
			else if (expected.indexOf( ">=" ))
			{
				ret = _greaterThanOrEqual;
			}
			else if (expected.indexOf( "<" ))
			{
				ret = _lessThan;
			}
			else if (expected.indexOf( ">" ))
			{
				ret = _greaterThan;
			}
			else
			{
				ret = _isStringMatch;
			}
			return ret;
		}

		//
		//		Compare methods
		//
		private static function _insideRange(actual:Number, expected:String):Boolean
		{
			var rangeParts:Array = expected.split( "<>" );
			var lowestValue:Number = Number( rangeParts[0] );
			var highestValue:Number = Number( rangeParts[1] );
			return (lowestValue <= actual && actual <= highestValue);
		}

		private static function _outsideRange(actual:Number, expected:String):Boolean
		{
			var rangeParts:Array = expected.split( "><" );
			var lowestValue:Number = Number( rangeParts[0] );
			var highestValue:Number = Number( rangeParts[1] );
			return (actual < lowestValue && highestValue < actual);
		}

		private static function _lessThan(actual:Number, expected:String):Boolean
		{
			var threshod:Number = Number( expected.substr( 1 ) );
			return (actual < threshod);
		}

		private static function _lessThanOrEqual(actual:Number, expected:String):Boolean
		{
			var highestValue:Number = Number( expected.substr( 2 ) );
			return (actual <= highestValue);
		}

		private static function _greaterThan(actual:Number, expected:String):Boolean
		{
			var threshod:Number = Number( expected.substr( 1 ) );
			return (threshod < actual);
		}

		private static function _greaterThanOrEqual(actual:Number, expected:String):Boolean
		{
			var lowestValue:Number = Number( expected.substr( 2 ) );
			return (lowestValue <= actual);
		}

		private static function _isStringMatch(actual:String, expected:String):Boolean
		{
			return (actual == expected);
		}
	}
}
