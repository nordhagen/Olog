package no.olog 
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * @author Oyvind Nordhagen
	 * @date 20. feb. 2010
	 */
	internal class Owindow extends Sprite 
	{
		internal static var exists:Boolean;
		private static var _i:Owindow;
		private static var _titleBarBg:Sprite;
		private static var _titleBarField:TextField;
		private static var _bg:Shape;
		private static var _field:TextField;
		private static var _dragger:Sprite;
		private static var _maximizeBtn:Sprite;
		private static var _closeBtn:Sprite;
		private static var _titlebarButtonWrapper:Sprite;
		private static var _minimizeBtn:Sprite;
		private static var _cmi:ContextMenuItem;
		private static var _isMinimized:Boolean;
		private static var _unreadCountDisplay:Sprite;
		private static var _unreadCountField:TextField;
		private static var _numUnread:int = 0;
		private static var _prefsButton:Sprite;
		private static var _prefPane:OprefPane;

		public function Owindow()
		{
			_init( );
			visible = false;
		}

		private function _init():void 
		{
			_initTitleBar( );
			_initUnread( );
			_initBg( );
			_initField( );
			_initPrefPane( );
			_initDragger( );
			filters = [new DropShadowFilter( 2, 45, 0, 0.3, 10, 10 )];
			addEventListener( Event.ADDED_TO_STAGE, Ocore.onAddedToStage );
		}

		private function _initPrefPane():void 
		{
			var bSize:Number = Oplist.TB_HEIGHT * 0.45;
			
			// PREFS BUTTON - NB NOT INSIDE BUTTON WRAPPER
			_prefsButton = _getTitleBarButton( );
			_prefsButton.graphics.beginFill( Oplist.BTN_LINE_COLOR, 1 );
			_prefsButton.graphics.drawCircle( 0, 0, bSize * 0.2 );
			_prefsButton.graphics.endFill( );
			_addTitleBarButtonMouseOver( _prefsButton );
			_prefsButton.addEventListener( MouseEvent.CLICK, _onPrefsClick );
			_prefsButton.x = Oplist.DEFAULT_WIDTH - bSize * 0.5 - Oplist.PADDING;
			_prefsButton.y = _titleBarBg.height * 0.5;
			_prefsButton.alpha = Oplist.BTN_UP_ALPHA;
			addChild( _prefsButton );
			
			_prefPane = new OprefPane( );
			_prefPane.y = _field.y + _field.height - _prefPane.height;
			_prefPane.visible = false;
			addChild( _prefPane );
		}

		internal static function get instance():Owindow
		{
			if (!_i) _i = new Owindow( );
			return _i;
		}

		internal static function getLogText():String
		{
			return _field.text;
		}

		internal static function get isOpen():Boolean
		{
			return (_i) ? _i.visible : false;
		}

		internal static function get isMinimized():Boolean
		{
			return _isMinimized;
		}

		internal static function open(e:Event = null):void
		{
			_i.visible = true;
			_updateCMI( );
			Otils.recordWindowState( );
		}

		internal static function close(e:Event = null):void
		{
			_i.visible = false;
			_updateCMI( );
			Otils.recordWindowState( );
		}

		internal static function write(str:String):void
		{
			_field.htmlText += "<p>" + str + "</p>";
			_updateUnread( );
			scrollEnd( );
		}
		
		internal static function showNewVersionMsg(msg:String):void
		{
			_titleBarField.htmlText += msg;
		}

		internal static function maximize():void
		{
			if (isMinimized) Owindow.unMinimize();
			_i.x = Oplist.PADDING;
			_i.y = Oplist.PADDING;
			var w:int = _i.stage.stageWidth - Oplist.PADDING * 2;
			var h:int = _i.stage.stageHeight - Oplist.PADDING * 2;
			_resize( w, h );
		}
		
		internal static function resizeToDefault():void
		{
			if (exists && !isMinimized)
			{
				_i.x = Oplist.x;
				_i.y = Oplist.y;
				_resize( Oplist.width, Oplist.height );
			}
		}

		internal static function updateTitleBar():void 
		{
			_titleBarField.htmlText = Ocore.getTitleBarText( );
		}

		internal static function createCMI():void 
		{
			if (_cmi) return;
			_cmi = new ContextMenuItem( Oplist.CMI_OPEN_LABEL );
			_cmi.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, Ocore.evalOpenClose );
			_i.parent.contextMenu = new ContextMenu( );
			_i.parent.contextMenu.customItems.push( _cmi );
		}

		internal static function removeCMI():void 
		{
			if (!_cmi) return;
			var cmis:Array = _i.stage.contextMenu.customItems;
			var num:int = cmis.length;
			for (var i:int = 0; i < num; i++)
			{
				if (cmis[i] == _cmi)
				{
					cmis.splice( i, 1 );
					break;
				}
			}
			
			_cmi = null;
			_i.stage.contextMenu = null;
		}

		internal static function clear():void
		{
			_field.text = "";
		}

		internal static function scrollHome():void 
		{
			_field.scrollV = 0;
		}

		internal static function scrollDown():void 
		{
			if (_field.scrollV < _field.maxScrollV) _field.scrollV++;
		}

		internal static function scrollUp():void 
		{
			if (_field.scrollV > 0) _field.scrollV--;
		}

		internal static function scrollEnd():void 
		{
			_field.scrollV = _field.maxScrollV;
		}

		internal static function minimize():void
		{
			_bg.visible = false;
			_field.visible = false;
			_dragger.visible = false;
			_isMinimized = true;
			_prefsButton.visible = false;
		}

		internal static function unMinimize():void
		{
			_bg.visible = true;
			_field.visible = true;
			_dragger.visible = true;
			_isMinimized = false;
			_hideUnread( );
			_prefsButton.visible = true;
		}

		internal static function moveToTop(e:Event = null):void 
		{
			_i.parent.setChildIndex( _i, _i.parent.numChildren - 1 );
		}

		private static function _updateCMI():void
		{
			if (_i.visible) _cmi.caption = Oplist.CMI_CLOSE_LABEL;
			else _cmi.caption = Oplist.CMI_OPEN_LABEL;
		}

		private function _initTitleBar():void 
		{
			var w:int = Oplist.DEFAULT_WIDTH;
			
			_titleBarBg = new Sprite( );
			_drawTitleBarBg( w );
			_titleBarBg.doubleClickEnabled = true;
			_titleBarBg.addEventListener( MouseEvent.MOUSE_DOWN, _onTitleBarDown );
			_titleBarBg.addEventListener( MouseEvent.MOUSE_UP, _onTitleBarUp );
			_titleBarBg.addEventListener( MouseEvent.DOUBLE_CLICK, _onMinimizeClick );
			addChild( _titleBarBg );
			
			_titleBarField = new TextField( );
			_titleBarField.mouseEnabled = false;
			_titleBarField.styleSheet = Ocore.getTitleBarCSS( );
			_titleBarField.width = Oplist.DEFAULT_WIDTH - Oplist.PADDING - 2;
			_titleBarField.htmlText = Ocore.getTitleBarText( );
			_titleBarField.x = Oplist.PADDING - 2;
			_titleBarField.y = (Oplist.TB_HEIGHT - _titleBarField.textHeight) * 0.5 - 4;
			addChild( _titleBarField );
			
			_titlebarButtonWrapper = new Sprite( );
			var bSize:Number = Oplist.TB_HEIGHT * 0.45;
			
			// CLOSE BUTTON
			_closeBtn = _getTitleBarButton( );
			_closeBtn.graphics.lineStyle( 2, 0xffffff );
			_closeBtn.graphics.moveTo( bSize * -0.15, bSize * -0.15 );
			_closeBtn.graphics.lineTo( bSize * 0.15, bSize * 0.15 );
			_closeBtn.graphics.moveTo( bSize * 0.15, bSize * -0.15 );
			_closeBtn.graphics.lineTo( bSize * -0.15, bSize * 0.15 );
			_addTitleBarButtonMouseOver( _closeBtn );
			_closeBtn.addEventListener( MouseEvent.CLICK, close );
			_closeBtn.alpha = Oplist.BTN_UP_ALPHA;
			_titlebarButtonWrapper.addChild( _closeBtn );
			
			// MAXIMIZE BUTTON
			_maximizeBtn = _getTitleBarButton( );
			_maximizeBtn.graphics.lineStyle( 2, 0xffffff );
			_maximizeBtn.graphics.moveTo( bSize * -0.2, 0 );
			_maximizeBtn.graphics.lineTo( bSize * 0.2, 0 );
			_maximizeBtn.graphics.moveTo( 0, bSize * -0.2 );
			_maximizeBtn.graphics.lineTo( 0, bSize * 0.2 );
			_addTitleBarButtonMouseOver( _maximizeBtn );
			_maximizeBtn.addEventListener( MouseEvent.CLICK, _onMaximizeClick );
			_maximizeBtn.alpha = Oplist.BTN_UP_ALPHA;
			_maximizeBtn.x = _closeBtn.x + _closeBtn.width + Oplist.PADDING * 0.5;
			_titlebarButtonWrapper.addChild( _maximizeBtn );

			// MINIMIZE BUTTON
			_minimizeBtn = _getTitleBarButton( );
			_minimizeBtn.graphics.lineStyle( 2, 0xffffff );
			_minimizeBtn.graphics.moveTo( bSize * -0.2, 0 );
			_minimizeBtn.graphics.lineTo( bSize * 0.2, 0 );
			_addTitleBarButtonMouseOver( _minimizeBtn );
			_minimizeBtn.addEventListener( MouseEvent.CLICK, _onMinimizeClick );
			_minimizeBtn.alpha = Oplist.BTN_UP_ALPHA;
			_minimizeBtn.x = _maximizeBtn.x + _maximizeBtn.width + Oplist.PADDING * 0.5;
			_titlebarButtonWrapper.addChild( _minimizeBtn );
			
			_titlebarButtonWrapper.x = Oplist.TB_PADDING;
			_titlebarButtonWrapper.y = Oplist.TB_HEIGHT * 0.5 - 1;
			addChild( _titlebarButtonWrapper );
		}

		private function _getTitleBarButton():Sprite
		{
			var r:Number = Oplist.TB_HEIGHT * 0.225;
			var b:Sprite = new Sprite( );
			b.graphics.lineStyle( 1, Oplist.BTN_LINE_COLOR );
			b.graphics.beginFill( Oplist.BTN_FILL_COLOR, 1 );
			b.graphics.drawCircle( 0, 0, r );
			b.graphics.endFill( );
			return b;
		}

		private function _addTitleBarButtonMouseOver(b:Sprite):void
		{
			b.addEventListener( MouseEvent.MOUSE_OVER, _onWindowBtnOver );
			b.addEventListener( MouseEvent.MOUSE_OUT, _onWindowBtnOut );
		}

		private function _onMouseWheel(e:MouseEvent):void 
		{
			if (e.delta < 0) scrollDown( );
			else if (e.delta > 0) scrollUp( );
		}

		private function _onPrefsClick(e:MouseEvent):void 
		{
			_prefPane.visible = !_prefPane.visible;
		}

		private function _onMinimizeClick(e:MouseEvent):void 
		{
			if (!_isMinimized) minimize( );
			else unMinimize( );
			Otils.recordWindowState( );
		}

		private function _onWindowBtnOver(e:MouseEvent):void 
		{
			e.target.alpha = Oplist.BTN_OVER_ALPHA;
		}

		private function _onWindowBtnOut(e:MouseEvent):void 
		{
			e.target.alpha = Oplist.BTN_UP_ALPHA;
		}

		private function _onMaximizeClick(e:MouseEvent):void 
		{
			maximize( );
			Otils.recordWindowState( );
		}

		private static function _updateUnread():void 
		{
			if (_isMinimized)
			{
				_numUnread++;
				_unreadCountField.text = String( _numUnread );
				_unreadCountDisplay.visible = true;
			}
		}

		private static function _hideUnread():void 
		{
			_numUnread = 0;
			_unreadCountDisplay.visible = false;
		}

		private function _initUnread():void
		{
			var bgColor:uint = uint( "0x" + Oplist.TEXT_COLORS[4].substr( 1 ) );
			var fmt:TextFormat = new TextFormat( Oplist.TB_FONT, 10, 0xffffff, true );
			fmt.align = TextFormatAlign.CENTER;
			_unreadCountField = new TextField( );
			_unreadCountField.defaultTextFormat = fmt;
			_unreadCountField.width = Oplist.TB_HEIGHT;
			_unreadCountField.height = 16;
			_unreadCountField.text = "0";
			_unreadCountField.y = (Oplist.TB_HEIGHT - _unreadCountField.height) * 0.5;
			_unreadCountField.mouseEnabled = false;
			
			_unreadCountDisplay = new Sprite( );
			_unreadCountDisplay.graphics.beginFill( bgColor, Oplist.BTN_UP_ALPHA );
			_unreadCountDisplay.graphics.drawRoundRectComplex( 0, 0, Oplist.TB_HEIGHT, Oplist.TB_HEIGHT, 0, Oplist.CORNER_RADIUS, 0, 0 );
			_unreadCountDisplay.graphics.endFill( );
			_unreadCountDisplay.addChild( _unreadCountField );
			_unreadCountDisplay.x = Oplist.DEFAULT_WIDTH - Oplist.TB_HEIGHT;
			_unreadCountDisplay.visible = false;
			addChild( _unreadCountDisplay );
		}

		private function _initField():void 
		{
			var fmt:TextFormat = new TextFormat( );
			fmt.tabStops = Oplist.TAB_STOPS;
			_field = new TextField( );
			_field.useRichTextClipboard = true;
			_field.defaultTextFormat = fmt;
			_field.selectable = true;
			_field.multiline = true;
			_field.wordWrap = true;
			_field.styleSheet = Ocore.getLogCSS( );
			_field.width = Oplist.DEFAULT_WIDTH - Oplist.PADDING * 2;
			_field.height = Oplist.DEFAULT_HEIGHT - Oplist.TB_HEIGHT - Oplist.PADDING * 2;
			_field.antiAliasType = AntiAliasType.ADVANCED;
			_field.gridFitType = GridFitType.PIXEL;
			_field.x = Oplist.PADDING;
			_field.y = Oplist.TB_HEIGHT + Oplist.PADDING; 
			_field.mouseWheelEnabled = true;
			_field.addEventListener( MouseEvent.MOUSE_WHEEL, _onMouseWheel );
			_field.addEventListener( TextEvent.LINK, Ocore.onNewVersionLink );
			addChild( _field );
		}

		internal static function onMouseOver(e:MouseEvent):void 
		{
			_i.stage.focus = _field;
		}

		private function _initDragger():void
		{
			_dragger = new Sprite( );
			_dragger.graphics.lineStyle( 1, 0xffffff, 0.5 );
			_dragger.graphics.moveTo( 10, 0 );
			_dragger.graphics.lineTo( 0, 10 );
			_dragger.graphics.moveTo( 10, 4 );
			_dragger.graphics.lineTo( 4, 10 );
			_dragger.graphics.moveTo( 10, 8 );
			_dragger.graphics.lineTo( 8, 10 );
			_dragger.graphics.lineStyle( 0, 0, 0 );
			_dragger.graphics.beginFill( 0, 0 );
			_dragger.graphics.drawRect( 0, 0, 12, 12 );
			_dragger.graphics.endFill( );
			_dragger.x = Oplist.DEFAULT_WIDTH - _dragger.width;
			_dragger.y = Oplist.DEFAULT_HEIGHT - _dragger.height;
			_dragger.addEventListener( MouseEvent.MOUSE_DOWN, _onDraggerDown );
			_dragger.addEventListener( MouseEvent.MOUSE_UP, _onDraggerUp );
			addChild( _dragger );
		}

		private function _onTitleBarDown(e:MouseEvent):void 
		{
			stage.addEventListener( MouseEvent.MOUSE_UP, _onTitleBarUp );
			_i.startDrag( );
		}

		private function _onTitleBarUp(e:MouseEvent):void 
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP, _onTitleBarUp );
			_i.stopDrag( );
			Otils.recordWindowState( );
		}

		private function _onDraggerDown(e:MouseEvent):void 
		{
			stage.addEventListener( Event.ENTER_FRAME, _onDraggerMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, _onDraggerUp );
		}

		private function _onDraggerMove(event:Event):void 
		{
			var w:int = stage.mouseX + _dragger.width * 0.5 - x;
			var h:int = stage.mouseY + _dragger.height * 0.5 - y;
			_resize( w, h );
		}

		private function _onDraggerUp(e:MouseEvent):void 
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP, _onDraggerUp );
			stage.removeEventListener( Event.ENTER_FRAME, _onDraggerMove );
			Otils.recordWindowState( );
		}

		private static function _resize(w:int, h:int):void 
		{
			if (w > Oplist.MIN_WIDTH)
			{
				_drawTitleBarBg( w );
				_titleBarBg.width = w;
				_titleBarField.width = w - Oplist.PADDING * 2;
				_unreadCountDisplay.x = w - _unreadCountDisplay.width;
				_bg.width = w;
				_field.width = w - Oplist.PADDING * 2;
				_dragger.x = w - _dragger.width;
				_prefsButton.x = w - _prefsButton.width * 0.5 - Oplist.PADDING;
				_prefPane.width = w;
			}
			
			if (h > Oplist.MIN_HEIGHT)
			{
				_bg.height = h - Oplist.TB_HEIGHT;
				_field.height = h - Oplist.TB_HEIGHT - Oplist.PADDING * 2;
				_dragger.y = h - _dragger.height;
				_prefPane.y = h - _prefPane.height;
			}
		}

		private static function _drawTitleBarBg(w:int):void 
		{
			var h:int = Oplist.TB_HEIGHT;
			var matrix:Matrix = new Matrix( );
			matrix.createGradientBox( w, h, (Math.PI / 180) * 90 );
			
			_titleBarBg.graphics.clear( );
			_titleBarBg.graphics.beginGradientFill( GradientType.LINEAR, Oplist.TB_COLORS, Oplist.TB_ALPHAS, Oplist.TB_RATIOS, matrix );
			_titleBarBg.graphics.drawRoundRectComplex( 0, 0, w, h, Oplist.CORNER_RADIUS, Oplist.CORNER_RADIUS, 0, 0 );
			_titleBarBg.graphics.endFill( );
		}

		private function _initBg():void 
		{
			_bg = new Shape( );
			_bg.graphics.beginFill( Oplist.BG_COL, Oplist.BG_ALPHA );
			_bg.graphics.drawRect( 0, 0, Oplist.DEFAULT_WIDTH, Oplist.DEFAULT_HEIGHT - Oplist.TB_HEIGHT );
			_bg.graphics.endFill( );
			_bg.y = Oplist.TB_HEIGHT;
			addChild( _bg );
		}

		internal static function replaceLastLine(text:String):void 
		{
			_field.htmlText = Owindow._field.htmlText.replace(/<p>(?!.*<p>).+$/gi, _wrapForOutput(text));
		}
		
		private static function _wrapForOutput(text:String):String
		{
			return "<p>" + text + "</p>";
		}

		internal static function setDefaultBounds():void 
		{
			var b:Rectangle = Otils.getDefaultWindowBounds( );
			_i.x = b.x;
			_i.y = b.y;
			_resize( b.width, b.height );
			
			if (Otils.getSavedMinimizedState( )) Owindow.minimize( );
			if (Otils.getSavedOpenState( )) Owindow.open( );
		}
	}
}
