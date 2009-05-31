/*    
 *    Copyright (c) 2009 Bouncing Minds - Option 3 Ventures Limited
 *
 *    This file is part of the Regions plug-in for Flowplayer.
 *
 *    The Regions plug-in is free software: you can redistribute it 
 *    and/or modify it under the terms of the GNU General Public License 
 *    as published by the Free Software Foundation, either version 3 of 
 *    the License, or (at your option) any later version.
 *
 *    The Regions plug-in is distributed in the hope that it will be 
 *    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with the plug-in.  If not, see <http://www.gnu.org/licenses/>.
 */
 package com.bouncingminds.flowplayer.regions {
	import com.bouncingminds.util.DebugObject;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.flowplayer.controller.ResourceLoaderImpl;
	import org.flowplayer.model.DisplayPluginModel;
	import org.flowplayer.model.PluginEventType;
	import org.flowplayer.view.Flowplayer;
	import org.flowplayer.view.StyleableSprite;
	
	/**
	 * @author Paul Schulz
	 */
	internal class RegionView extends StyleableSprite {
		private var _plugin:Regions;
		private var _text:TextField;
		private var _textMask:Sprite;
		private var _closeButton:CloseButton = null;
		private var _htmlText:String;
		private var _player:Flowplayer;
		private var _model:DisplayPluginModel;
		private var _originalAlpha:Number;
		private var _styleSheet:StyleSheet;
		private var _config:RegionViewConfig;
		private var _requiredHeight:*;
		private var _requiredWidth:*;
		private var _inDebugMode:Boolean = false;
		private var _originalHTML:String = "";
		private var _errorHandler:ContentDisplayErrorHandler = new ContentDisplayErrorHandler();

		private static var CONTROLS_HEIGHT:int = 25;

		public function RegionView(plugin:Regions, model:DisplayPluginModel, player:Flowplayer, regionConfig:RegionViewConfig, showCloseButton:Boolean=false, closeButton:CloseButton=null) {
			super(null, _errorHandler, new ResourceLoaderImpl(null, _errorHandler));
			visible = false;
			_plugin = plugin;
			_model = model;
			_player = player;
			_config = regionConfig;
			if(regionConfig.id) id = regionConfig.id;
			stylesheet = regionConfig.styleSheetObject;
			if(_config.showCloseButton) createCloseButton(player);
			if(_config.clickable) addListeners();
			if(_config.html) html = _config.html;
		}

		internal function addListeners():void {
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		internal function removeListeners():void {
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			removeEventListener(MouseEvent.CLICK, onClick);
		}

		public function set id(id:String):void {
			name = id;
		}
		
		public function get id():String {
			return name;
		}
		
		public function get autoShow():Boolean {
			return _config.autoShow;
		}
		
		public function setWidth():void {
			var requiredWidth:* = _config.width;
			var parentWidth:int = _plugin.width;
			if(typeof requiredWidth == "string") { // it's a percentage
				if(requiredWidth.indexOf("pct") != -1) {
					var widthPercentage:int = parseInt(requiredWidth.substring(0,requiredWidth.indexOf("pct")));
					width = ((parentWidth / 100) * widthPercentage);
					doLog("Width is to be set to a percentage of the parent - " + requiredWidth + " setting to " + width, DebugObject.DEBUG_REGION_FORMATION);
				}
				else {
					doLog("Region width is a string value " + requiredWidth + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);
					width = parseInt(requiredWidth);			
				}
			}
			else if(typeof requiredWidth == "number") {
				doLog("Region width is defined as a number " + requiredWidth + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);
				width = requiredWidth;
			}
			else doLog("Bad type " + (typeof width) + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);
		}
		
		public function setHeight():void {
			var requiredHeight:* = _config.height;	
			var parentHeight:int = _plugin.height - CONTROLS_HEIGHT;
			if(typeof requiredHeight == "string") { // it's a percentage
				if(requiredHeight.indexOf("pct") != -1) {
					var heightPercentage:int = parseInt(requiredHeight.substring(0,requiredHeight.indexOf("pct")));
					height = ((parentHeight / 100) * heightPercentage);
					doLog("Height is to be set to a percentage of the parent - " + requiredHeight + " setting to " + height, DebugObject.DEBUG_REGION_FORMATION);
				}
				else {
					doLog("Region height is a string value " + requiredHeight + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);
					height = parseInt(requiredHeight);
				}
			}
			else if(typeof requiredHeight == "number") {
				doLog("Region height is defined as a number " + requiredHeight + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);
				height = requiredHeight;
			}
			else doLog("Bad type " + (typeof width) + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);
		}
		
		public function setVerticalAlignment():void {
			var align:* = _config.verticalAlign;
			var parentHeight:int = _plugin.height - CONTROLS_HEIGHT;
			if(typeof align == "string") {
				if(align == "top") {
					y = 0;
				}
				else {
					y = parentHeight-height;
				}				
				doLog("Vertical alignment set to " + x + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);		
			}
			else if(typeof align == "number") {
				y = align;
				doLog("Vertical alignment set to " + x + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);		
			}
			else doLog("bad vertical alignment value " + align + " on region " + id, DebugObject.DEBUG_REGION_FORMATION);
		}

		public function setHorizontalAlignment():void {
			var align:* = _config.horizontalAlign;
			var parentWidth:int = _plugin.width;
			if(typeof align == "string") {
				if(align == "left") {
					x = 0;
				}
				else {
					x = parentWidth-width;
				}		
				doLog("Horizontal alignment set to " + x + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);		
			}
			else if(typeof align == "number") {
				x = align;
				doLog("Horizontal alignment set to " + x + " for region " + id, DebugObject.DEBUG_REGION_FORMATION);		
			}
			else doLog("bad horizontal alignment value " + align + " on region " + id, DebugObject.DEBUG_REGION_FORMATION);
		}
		
		public function resize():void {
			setWidth();
			setHeight();
			setVerticalAlignment();
			setHorizontalAlignment();
		}
		
		public function set stylesheet(stylesheet:StyleSheet):void {
			if(stylesheet != null) {
				_styleSheet = stylesheet;
				style = _styleSheet.stylesheet;	
				createTextField();
			}
		}

		public function set html(htmlText:String):void {
			if(_styleSheet != null) {
				style = _styleSheet.stylesheet;
			}
			_htmlText = "<body>" + ((htmlText == null) ? "" : htmlText) + "</body>";
			createTextField();
			doLog("set html to " + _htmlText, DebugObject.DEBUG_REGION_FORMATION);
		}
		
		public function get html():String {
			return _htmlText;
		}
		
		private function createTextField():void {
			if (_text) {
				removeChild(_text);
			} 
			_text = _player.createTextField();
			_text.blendMode = BlendMode.LAYER;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.wordWrap = true;
			_text.multiline = true;
			_text.antiAliasType = AntiAliasType.ADVANCED;
			_text.condenseWhite = true;
			if(style != null) {
				_text.styleSheet = style.styleSheet;
			}
			if(_htmlText != null) _text.htmlText = _htmlText;
			addChild(_text);
			_textMask = createMask();
			addChild(_textMask);
			_text.mask = _textMask;
			arrangeText();
		}
		
		private function arrangeText():void {
			if (! (_text && style)) return;
			var padding:Array = style.padding;
			// only reset values if they change, otherwise there will be visual "blinking" of text/images
			setTextProperty("y", padding[0]);
			setTextProperty("x", padding[3]);
			setTextProperty("height", height - padding[0] - padding[2]);
			setTextProperty("width", width - padding[1] - padding[3]);
		}
		
		private function setTextProperty(prop:String, value:Number):void {
			if (_text[prop] != value) {
				_text[prop] = value;
			}
		}

		override protected function onResize():void {
			arrangeCloseButton();
			if (_textMask) {
				_textMask.width = width;
				_textMask.height = height;
			}
			this.x = 0;
			this.y = 0;
		}

		override protected function onRedraw():void {
			arrangeText();
			arrangeCloseButton();
		}

		private function createCloseButton(player:Flowplayer):void {
			if(_closeButton) {
				removeChild(_closeButton);
			}
			_closeButton = new CloseButton(null, _config.closeButtonImage, player, this);
			addChild(_closeButton);
		}
		
		private function arrangeCloseButton():void {
			if (_closeButton && style) {
				_closeButton.x = width - _closeButton.width - 1 - style.borderRadius/5;
				_closeButton.y = 1 + style.borderRadius/5;
				setChildIndex(_closeButton, numChildren-1);
			}
		}

		public function onCloseClicked():void {
			removeListeners();
			_originalAlpha = _model.getDisplayObject().alpha;
			this.visible = false;
		}
		
		private function onMouseOver(event:MouseEvent):void {
			doLog("RegionView: MOUSE OVER!", DebugObject.DEBUG_MOUSE_EVENTS);
			if(_model) {
				_model.dispatch(PluginEventType.PLUGIN_EVENT, "onMouseOver");				
			}
		}

		private function onMouseOut(event:MouseEvent):void {
			doLog("RegionView: MOUSE OUT!", DebugObject.DEBUG_MOUSE_EVENTS);
			if(_model) {
				_model.dispatch(PluginEventType.PLUGIN_EVENT, "onMouseOut");			
			}
		}

		private function onClick(event:MouseEvent):void {
			doLog("RegionView: ON CLICK", DebugObject.DEBUG_MOUSE_EVENTS);
			if(_config.clickToPlay) {
				_player.play();
			}
			if(_model) {
				_model.dispatch(PluginEventType.PLUGIN_EVENT, "onClick");				
			}
		}

		public function reset():void {
			visible = false;	
			_inDebugMode = false;
			_config.flipToOriginal();
			html = _originalHTML;
			_originalHTML = "";
		}
		
		public function toggleDebug():void {
			if(_inDebugMode) {
				reset();
			}	
			else {
				_originalHTML = html;
				_inDebugMode = true;
				_config.flipToDebug();
				visible = true;
				html = "<p align='center'>This is the '" + id + "' region</p>";
			}		
		}
		
		// DEBUG METHODS
		
		protected function doLog(data:String, level:int=1):void {
			DebugObject.getInstance().doLog(data, level);
		}
		
		protected function doTrace(o:Object, level:int=1):void {
			DebugObject.getInstance().doTrace(o, level);
		}
		
		protected function doLogAndTrace(data:String, o:Object, level:int=1):void {
			DebugObject.getInstance().doLogAndTrace(data, o, level);
		}
	}
}