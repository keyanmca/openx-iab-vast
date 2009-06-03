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
	import com.bouncingminds.util.StringUtils;
	
	import org.flowplayer.view.FlowStyleSheet;
	
	/**
	 * @author Paul Schulz
	 */
	public class BaseRegionConfig extends DebugObject {
		protected var _styleSheetFilename:String;
		protected var _styleSheet:StyleSheet;
		protected var _style:Object = null;
		protected var _id:String = null;
		protected var _border:String = "0px";
		protected var _borderRadius:int = 0;
		protected var _backgroundGradient:Array;
		protected var _backgroundTransparent:Boolean = true;
		protected var _backgroundImage:String = null;
		protected var _backgroundColor:String = "transparent";
		protected var _showCloseButton:Boolean = false;
		protected var _closeButtonImage:String = null;
		protected var _debugBorder:String = "1px solid #FFFFFF";
		protected var _debugBackgroundColor:String = "#999999";
		protected var _originalBackgroundColor:String = null;
		protected var _originalBorder:String = null;
		protected var _html:String = null;
		
		public function BaseRegionConfig(config:Object=null) {
			_styleSheet = new StyleSheet();
			setup(config);
		}

		public function flipToDebug():void {
			if(debugBackgroundColor != null) {
				originalBackgroundColor = backgroundColor;
				backgroundColor = debugBackgroundColor;
			}
			if(originalBorder != null) {
				originalBorder = border;
				border = debugBorder;
			}			
		}
		
		public function flipToOriginal():void {
			if(originalBackgroundColor != null) {
				backgroundColor = originalBackgroundColor;
				originalBackgroundColor = null;
			}
			if(originalBorder != null) {
				border = originalBorder;
				originalBorder = null;
			}			
		}
		
		public function setup(config:Object):void {
			if(config != null) {
				if(config.id) id = config.id;
				if(config.stylesheet) stylesheet = config.stylesheet;
				if(config.style) style = config.style;
				if(config.border) border = config.border;
				if(config.borderRadius) borderRadius = config.borderRadius;
				if(config.backgroundGradient) backgroundGradient = config.backgroundGradient;
				if(config.backgroundTransparent) backgroundTransparent = config.backgroundTransparent;
				if(config.backgroundImage) backgroundImage = StringUtils.revertSingleQuotes(config.backgroundImage, "%27");
				if(config.backgroundColor) backgroundColor = config.backgroundColor;
				if(config.showCloseButton != undefined) showCloseButton = config.showCloseButton;
				if(config.closeButtonImage) closeButtonImage = config.closeButtonImage;
				if(config.debugBackgroundColor) debugBackgroundColor = config.debugBackgroundColor;
				if(config.debugBorder) debugBorder = config.debugBorder;
				if(config.html) html = StringUtils.revertSingleQuotes(config.html, "'");
				updateStyleSheet();
			}
		}

		public function set id(id:String):void {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set style(style:Object):void {
			_style = style;
			reloadStyleSheet();
		}
		
		public function get style():Object {
			return _style;
		}
		
		public function set stylesheet(stylesheet:String):void {
			_styleSheetFilename = stylesheet;
			reloadStyleSheet();
		}
		
		public function get stylesheet():String {
			return _styleSheetFilename;
		}

		public function get styleSheetObject():StyleSheet {
			return _styleSheet;
		}

		protected function updateStyleSheet():void {
			if(_styleSheet != null) {
				_styleSheet.updateBaseRules(this);
			}
			else createStyleSheet();
		}
					
		protected function reloadStyleSheet():void {
			_styleSheet = null;
			createStyleSheet();
		}
		
		protected function createStyleSheet():void {
			_styleSheet = new StyleSheet(this, true, null);		
			if(_style != null) _styleSheet.addStyles(_styleSheet.stylesheet as FlowStyleSheet, _style);
		}
		
		public function set html(html:String):void {
			_html = html;
		}
		
		public function get html():String {
			return _html;
		}

		public function set borderRadius(borderRadius:int):void {
			_borderRadius = borderRadius;
			updateStyleSheet();
		}
		
		public function get borderRadius():int {
			return _borderRadius;
		}
		
		public function set border(border:String):void {
			_border = border;
			updateStyleSheet();
		}
		
		public function get border():String {
			return _border;
		}

		public function set debugBorder(debugBorder:String):void {
			_debugBorder = debugBorder;
		}
		
		public function get debugBorder():String {
			return _debugBorder;
		}
		
		public function set debugBackgroundColor(debugBackgroundColor:String):void {
			_debugBackgroundColor = debugBackgroundColor;
		}
		
		public function get debugBackgroundColor():String {
			return _debugBackgroundColor;
		}

		public function set originalBorder(border:String):void {
			_originalBorder = border;
		}
		
		public function get originalBorder():String {
			return _originalBorder;
		}
		
		public function set originalBackgroundColor(backgroundColor:String):void {
			_originalBackgroundColor = backgroundColor;
		}
		
		public function get originalBackgroundColor():String {
			return _originalBackgroundColor;
		}
		
		public function set backgroundGradient(backgroundGradient:Array):void {
			_backgroundGradient = backgroundGradient;
			updateStyleSheet();
		}
		
		public function get backgroundGradient():Array {
			return _backgroundGradient;
		}
		
		public function set backgroundTransparent(backgroundTransparent:Boolean):void {
			_backgroundTransparent = backgroundTransparent;
			updateStyleSheet();
		}
		
		public function get backgroundTransparent():Boolean {
			return _backgroundTransparent;
		}
		
		public function set backgroundImage(backgroundImage:String):void {
			_backgroundImage = backgroundImage;
			updateStyleSheet();
		}
		
		public function get backgroundImage():String {
			return _backgroundImage;
		}
		
		public function set backgroundColor(backgroundColor:String):void {
			_backgroundColor = backgroundColor;
			updateStyleSheet();
		}
		
		public function get backgroundColor():String {
			return _backgroundColor;
		}

		public function get properties():Object {
			var props:Object = new Object();
			props.id = id;
			props.border = border;
			props.borderRadius = borderRadius;
			props.backgroundGradient = backgroundGradient;
			props.backgroundTransparent = backgroundTransparent;
			props.backgroundImage = backgroundImage;
			props.backgroundColor = backgroundColor;
			props.closeButtonImage = closeButtonImage;
			props.showCloseButton = showCloseButton;
			props.stylesheet = stylesheet;
			props.style = style;
			props.debugBackgroundColor = debugBackgroundColor;
			props.debugBorder = debugBorder;
			return props;
		}

		public function set closeButtonImage(imageURL:String):void {		
			_closeButtonImage = imageURL;
		}
		
		public function get closeButtonImage():String {
			return _closeButtonImage;
		}
		
		public function set showCloseButton(showCloseButton:Boolean):void {
			_showCloseButton = showCloseButton;
		}
		
		public function get showCloseButton():Boolean {
			return _showCloseButton;
		}		
	}
}