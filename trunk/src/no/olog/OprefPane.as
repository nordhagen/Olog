package no.olog {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Oyvind Nordhagen
	 * @date 28. feb. 2010
	 */
	internal class OprefPane extends Sprite {
		private static const DELIMITER:String = "  |  ";
		private var _bg:Shape;
		private var _field:TextField;
		private var _menu:String = "";

		public function OprefPane () {
			_init();
		}

		private function _init ():void {
			var p:uint = Oplist.PADDING;

			_bg = new Shape();
			_bg.graphics.beginFill( Oplist.PREF_PANE_BG_COLOR );
			_bg.graphics.drawRect( 0, 0, Oplist.DEFAULT_WIDTH, 20 );
			_bg.graphics.endFill();
			addChild( _bg );

			_field = new TextField();
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.multiline = true;
			_field.selectable = false;
			_field.wordWrap = true;
			_field.width = Oplist.DEFAULT_WIDTH;
			_field.styleSheet = _getStyleSheet();
			_field.addEventListener( TextEvent.LINK, _onTextLink );
			_field.x = p;
			_field.y = p;
			addChild( _field );

			_menu += "<menu>";
			_menu += "<header>Utilities</header>";
			_menu += "<a href=\"event:saveXml\">Save as XML</a>" + DELIMITER;
			_menu += "<a href=\"event:saveText\">Save as Text</a>" + DELIMITER;
			_menu += "<a href=\"event:updateCheck\">Check for update</a>" + DELIMITER;
			_menu += "<a href=\"event:clear\">Clear</a>";
			_menu += "</menu>";

			_field.htmlText = _menu;
			_bg.height = _field.height + p * 2;
		}

		private function _onTextLink ( event:TextEvent ):void {
			switch (event.text) {
				case "saveXml":
					Ocore.saveLogAsXML();
					break;
				case "saveText":
					Ocore.saveLogAsText();
					break;
				case "clear":
					Owindow.clear();
					break;
				case "updateCheck":
					Ocore.checkForUpdates();
					break;
				default:
					throw new Error( "switch case unsupported" );
			}
		}

		private function _getStyleSheet ():StyleSheet {
			var style:StyleSheet = new StyleSheet();
			style.setStyle( "menu", { fontFamily:"_sans", fontSize:14, leading:4 } );
			style.setStyle( "header", { fontSize:12, color:"#666666" } );
			style.setStyle( "a", { fontFamily:"_typewriter" } );
			style.setStyle( "a:hover", { color:"#000000" } );
			style.setStyle( "a:link", { color:"#444444" } );
			return style;
		}

		override public function set width ( val:Number ):void {
			_field.width = val;
			_bg.width = val;
			_bg.height = _field.height + Oplist.PADDING * 2;
		}
	}
}
