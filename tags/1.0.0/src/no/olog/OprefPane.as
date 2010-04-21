package no.olog 
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * @author Oyvind Nordhagen
	 * @date 28. feb. 2010
	 */
	internal class OprefPane extends Sprite 
	{
		private var _bg:Shape;
		private var _saveXMLButton:Sprite;
		private var _btnFilters:Array = [new DropShadowFilter( 1, 45, 0, 0.3, 5, 5 )];
		private var _saveTextButton:Sprite;

		public function OprefPane()
		{
			_init( );
		}

		private function _init():void 
		{
			_saveXMLButton = _getButton("Save log as XML");
			_saveXMLButton.x = Oplist.PADDING;
			_saveXMLButton.y = Oplist.PADDING;
			_saveXMLButton.addEventListener(MouseEvent.MOUSE_UP, Ocore.saveLogAsXML);
			addChild(_saveXMLButton);

			_saveTextButton = _getButton("Save log as Text");
			_saveTextButton.x = _saveXMLButton.x + _saveXMLButton.width + Oplist.PADDING;
			_saveTextButton.y = Oplist.PADDING;
			_saveTextButton.addEventListener(MouseEvent.MOUSE_UP, Ocore.saveLogAsText);
			addChild(_saveTextButton);

			_bg = new Shape();
			_bg.graphics.beginFill(Oplist.PREF_PANE_BG_COLOR );
			_bg.graphics.drawRect(0, 0, Oplist.DEFAULT_WIDTH, Oplist.PADDING * 2 + _saveXMLButton.height);
			_bg.graphics.endFill();
			addChildAt(_bg, 0);
		}
		
		override public function set width(val:Number):void
		{
			_bg.width = val;
		}

		override public function set height(val:Number):void
		{
			_bg.height = val;
		}

		private function _getButton(labelText:String):Sprite
		{
			var b:Sprite = new Sprite();
			var w:int = Oplist.PREFS_BUTTON_WIDTH;
			var h:int = Oplist.PREFS_BUTTON_HEIGHT;
			var p:int = Oplist.PADDING;
			var r:int = Oplist.CORNER_RADIUS;
			var matrix:Matrix = new Matrix( );
			matrix.createGradientBox( w, h, (Math.PI / 180) * 90 );
			
			var bg:Shape = new Shape( );
			bg.graphics.beginGradientFill( GradientType.LINEAR, [Oplist.TB_COLORS[0], Oplist.TB_COLORS[1]], [Oplist.TB_ALPHAS[0], Oplist.TB_ALPHAS[1]], [0, 255], matrix );
			bg.graphics.drawRoundRect( 0, 0, w, h, r, r );
			bg.graphics.endFill( );
			bg.graphics.lineStyle(1, Oplist.BTN_LINE_COLOR, 0.4, true);
			var inset:int = 1;
			bg.graphics.drawRoundRect( inset, inset, w - inset * 2, h - inset * 3, r, r );
			bg.filters = _btnFilters;
			b.addChild( bg );
			
			var label:TextField = new TextField();
			label.defaultTextFormat = new TextFormat( Oplist.TB_FONT, Oplist.TB_FONT_SIZE - 2, 0xffffff, null, null, null, null, null, TextFormatAlign.CENTER);
			label.text = labelText;
			label.mouseEnabled = false;
			label.width = w - p * 2;
			label.height = Oplist.TB_FONT_SIZE + 4;
			label.x = p;
			label.y = (h - label.height) * 0.5;
			b.addChild(label);
			b.addEventListener(MouseEvent.MOUSE_DOWN, _onBtnDown);
			b.addEventListener(MouseEvent.MOUSE_UP, _onBtnUp);
			return b;
		}

		private function _onBtnUp(e:MouseEvent):void 
		{
			e.target.x -= 1;
			e.target.y -= 1;
			e.target.filters = _btnFilters;
		}

		private function _onBtnDown(e:MouseEvent):void 
		{
			e.target.x += 1;
			e.target.y += 1;
			e.target.filters = null;
		}
	}
}
