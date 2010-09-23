package no.olog 
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * @author Oyvind Nordhagen
	 * @date 22. feb. 2010
	 */
	internal class OpwPrompt extends Sprite 
	{
		private var _tf:TextField;

		public function OpwPrompt()
		{
			_init( );
		}

		private function _init():void 
		{
			var w:int = Oplist.PW_BOX_WIDTH;
			var h:int = Oplist.PW_BOX_HEIGHT;
			var p:int = Oplist.PADDING;
			var r:int = Oplist.CORNER_RADIUS;
			var matrix:Matrix = new Matrix( );
			matrix.createGradientBox( w, h, (Math.PI / 180) * 90 );
			
			var bg:Shape = new Shape( );
			var g:Graphics = bg.graphics;
			g.beginGradientFill( GradientType.LINEAR, Oplist.TB_COLORS, Oplist.TB_ALPHAS, Oplist.TB_RATIOS, matrix );
			g.drawRoundRect( 0, 0, w, h, r, r );
			g.endFill( );
			addChild( bg );
			
			var label:TextField = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = new TextFormat( Oplist.TB_FONT, Oplist.TB_FONT_SIZE, 0xffffff);
			label.text = Oplist.PWPROMPT_LABEL;
			label.x = p;
			label.y = (h - label.height) * 0.5;
			addChild(label);
			
			_tf = new TextField( );
			_tf.defaultTextFormat = new TextFormat( Oplist.FONT, 12, 0xffffff);
			_tf.type = TextFieldType.INPUT;
			_tf.border = true;
			_tf.borderColor = Oplist.BTN_LINE_COLOR;
			_tf.backgroundColor = 0;
			_tf.background = true;
			_tf.displayAsPassword = true;
			_tf.width = w - p * 3 - label.width;
			_tf.height = h - p * 2;
			_tf.x = label.x + label.width + p;
			_tf.y = (h - _tf.height) * 0.5 - 1;
			_tf.addEventListener(Event.CHANGE, Ocore.validatePassword);
			_tf.setSelection(0, _tf.text.length - 1);
			addChild( _tf );
		}
		
		internal function get field():TextField
		{
			return _tf;
		}
	}
}
