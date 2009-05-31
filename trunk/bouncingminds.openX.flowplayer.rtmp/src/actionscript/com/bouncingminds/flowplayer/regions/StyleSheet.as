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
	import com.bouncingminds.util.NetworkResource;
	
	import flash.events.*;
	
	import org.flowplayer.view.FlowStyleSheet;
	
	/**
	 * @author Paul Schulz
	 */
	public class StyleSheet extends NetworkResource {
		private var _onLoadCallback:Function;
		private var _styleSheet:FlowStyleSheet;
		private var _externalCssRules:String = null;
		private var _baseRules:Object = null;
		private var _baseStyle:Object = null;
		private static var _defaultCssRules:String = ".message { font-size: 12; font-weight: light; font-family: arial; } ";
		
		public function StyleSheet(config:Object=null, autoLoad:Boolean=false, onLoadCallback:Function=null) {
			_onLoadCallback = onLoadCallback;
			if(config != null) {
				_baseRules = new Object();
				_baseRules = recordRules(config, _baseRules);
				if(config.style) _baseStyle = config.style;
			}
			_styleSheet = createStyleSheet();
			if(config != null && autoLoad) {
				if(config.stylesheet != null) {
					url = config.stylesheet;
					id = config.stylesheet;
					doLog("Need to load up an external stylesheet file from " + url, DebugObject.DEBUG_STYLES);
					call();
				}
			}
		}

		private function recordRules(config:Object, o:Object):Object {
			if(config.border) o.border = config.border;
			if(config.borderRadius) o.borderRadius = config.borderRadius;
			if(config.backgroundGradient) o.backgroundGradient = config.backgroundGradient;
			if(config.backgroundTransparent) o.backgroundTransparent = config.backgroundTransparent;
			if(config.backgroundImage) o.backgroundImage = config.backgroundImage;
			if(config.backgroundColor) o.backgroundColor = config.backgroundColor;
			return o;	
		}
		
		public function updateBaseRules(config:Object):void {
			_baseRules = recordRules(config, ((_baseRules != null) ? _baseRules : new Object()));
			addStyles(_styleSheet, _baseRules);
		}
		
		public function get stylesheet():FlowStyleSheet {
			return _styleSheet;
		}
		
		protected override function loadComplete(data:String):void {
			_externalCssRules = data;
			doLogAndTrace("Stylesheet data loaded from external file - updating the stylesheet settings to include...", _externalCssRules, DebugObject.DEBUG_STYLES);
			_styleSheet = createStyleSheet();
			if(_onLoadCallback != null) _onLoadCallback();
		}
		
		public function createStyleSheet():FlowStyleSheet {
			var _baseCss:String;
			if(_externalCssRules != null) {
				_baseCss = _defaultCssRules + _externalCssRules;
			}
			else _baseCss = _defaultCssRules;
			var styleSheet:FlowStyleSheet = new FlowStyleSheet("#content", _baseCss);
			if(_baseStyle != null) addStyles(styleSheet, _baseStyle);
			if(_baseRules != null) addStyles(styleSheet, _baseRules);
			return styleSheet;
		}
				
		public function addStyles(styleSheet:FlowStyleSheet, rules:Object):void {
			var rootStyleProps:Object;
			for (var styleName:String in rules) {
				if (FlowStyleSheet.isRootStyleProperty(styleName)) {
					doLog("adding additional ROOT style rule for " + styleName + " - " + rules[styleName], DebugObject.DEBUG_STYLES);
					if (! rootStyleProps) {
						rootStyleProps = new Object();
					}
					rootStyleProps[styleName] = rules[styleName];
				} else {
					doLog("adding additional style rule for " + styleName + " - " + rules[styleName], DebugObject.DEBUG_STYLES);
					styleSheet.setStyle(styleName, rules[styleName]);
				}
			}
			styleSheet.addToRootStyle(rootStyleProps);
		}
	}
}