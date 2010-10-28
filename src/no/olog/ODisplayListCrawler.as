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

		internal static function getTree ( root:DisplayObjectContainer, currentDepth:uint = 0, maxDepth:uint = 10, property:String = null ):String
		{
			var tabs:String = "", tree:String = "", child:DisplayObject, numChildren:int = root.numChildren;

			for (var j:int = currentDepth; j > -1; --j)
			{
				tabs += TAB;
			}

			// propertyValue = (property && root.hasOwnProperty( property )) ? "." + property + " = " + root[property] : "";
			tree += "\n" + tabs + root.toString().match( /(?<=\s|\.)\w+(?=\]|$)/ )[0] + _getPropertyValue( root, property );
			tabs += TAB;

			for (var i:int = 0; i < numChildren ; ++i)
			{
				child = root.getChildAt( i );
				if (child is DisplayObjectContainer && currentDepth < maxDepth - 1)
				{
					tree += getTree( child as DisplayObjectContainer, currentDepth + 1, maxDepth, property );
				}
				else
				{
					// propertyValue = (property && child.hasOwnProperty( property )) ? "." + property + " = " + child[property] : "";
					tree += "\n" + tabs + child.toString().match( /(?<=\s|\.)\w+(?=\]|$)/ )[0] + _getPropertyValue( child, property );
				}
			}

			return tree;
		}

		private static function _getPropertyValue ( child:DisplayObject, property:String = null ):String
		{
			var result:String = "";
			var isFunction:Boolean = false;
			
			if (property.indexOf("(") != -1)
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
	}
}
