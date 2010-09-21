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

		internal static function getTree ( root:DisplayObjectContainer , numIterations:uint = 0, maxDepth:uint = 10 ):String
		{
			var tabs:String = "", tree:String = "", child:DisplayObject, numChildren:int = root.numChildren;

			for (var j:int = numIterations; j > 0; --j)
			{
				tabs += TAB;
			}

			tree += "\n" + tabs + root.toString().match(/(?<=\s)\w+/)[0];

			for (var i:int = 0; i < numChildren ; ++i)
			{
				child = root.getChildAt( i );
				if (child is DisplayObjectContainer && numIterations < maxDepth - 1)
				{
					tree += getTree( child as DisplayObjectContainer , ++numIterations , maxDepth );
				}
				else
				{
					tree += "\n" + tabs + child.toString().match(/(?<=\s)\w+/)[0];
				}
			}

			return tree;
		}
	}
}
