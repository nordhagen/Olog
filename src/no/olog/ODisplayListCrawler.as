package no.olog
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Oyvind Nordhagen
	 * @date 21. sep. 2010
	 */
	internal class ODisplayListCrawler
	{
		private static const TAB:String = " . ";
		private static var _numInstances:uint;

		internal static function getTree ( root:DisplayObjectContainer, currentDepth:uint = 0, maxDepth:uint = 10, property:String = null, rootsChildIndex:int = -1 ):String
		{
			var tabs:String = "", tree:String = "", child:DisplayObject, numChildren:int = root.numChildren;

			if (currentDepth == 0)
			{
				_numInstances = 1;
			}

			for (var j:int = currentDepth; j > 0; --j)
			{
				tabs += TAB;
			}

			var rootsChildIndexString:String;
			if (rootsChildIndex != -1)
			{
				rootsChildIndexString = rootsChildIndex + ".";
			}
			else
			{
				if (root.parent)
				{
					rootsChildIndexString = root.parent.getChildIndex( root ) + ".";
				}
				else
				{
					rootsChildIndexString = "X.";
				}
			}

			tree += "\n" + tabs + rootsChildIndexString + root.toString().match( /(?<=\s|\.)\w+(?=\]|$)/ )[0] + _getPropertyValue( root, property );
			tabs += TAB;

			for (var i:int = numChildren - 1; i > -1 ; --i)
			{
				_numInstances++;
				child = root.getChildAt( i );
				if (child is DisplayObjectContainer && currentDepth < maxDepth - 1)
				{
					tree += getTree( child as DisplayObjectContainer, currentDepth + 1, maxDepth, property, i );
				}
				else
				{
					tree += "\n" + tabs + i + "." + child.toString().match( /(?<=\s|\.)\w+(?=\]|$)/ )[0] + _getPropertyValue( child, property );
				}
			}

			return tree;
		}

		private static function _getPropertyValue ( child:DisplayObject, property:String = null ):String
		{
			if (!property)
			{
				return "";
			}

			var result:String = "";
			var isFunction:Boolean = false;

			if (property.indexOf( "(" ) != -1)
			{
				property = property.substr( 0, property.indexOf( "(" ) );
				isFunction = true;
			}
			if (property && child.hasOwnProperty( property ))
			{
				if (!isFunction)
				{
					result = "." + property + " = " + child[property];
				}
				else
				{
					try
					{
						result = "." + property + "() returned " + String( child[property]() );
					}
					catch (e:Error)
					{
						result = " ERROR " + property + "() expects arguments";
					}
				}
			}
			return result;
		}

		static public function get numInstances () : uint
		{
			return _numInstances;
		}
	}
}
