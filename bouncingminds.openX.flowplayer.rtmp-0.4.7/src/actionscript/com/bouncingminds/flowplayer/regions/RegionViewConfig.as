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
	
	/**
	 * @author Paul Schulz
	 */
	public class RegionViewConfig extends BaseRegionConfig {
		protected var _verticalAlign:String = "top";
		protected var _horizontalAlign:String = "left";
		protected var _width:*;
		protected var _height:*;
		protected var _autoShow:Boolean = false;
		protected var _clickable:Boolean = true;
		protected var _clickToPlay:Boolean = false;
		
		public function RegionViewConfig(config:Object=null) {
			super(config);
		}
		
		public override function setup(config:Object):void {
			if(config != null) {
				super.setup(config);
				if(config.verticalAlign) verticalAlign = config.verticalAlign;
				if(config.horizontalAlign) horizontalAlign = config.horizontalAlign;
				if(config.width) width = config.width;
				if(config.height) height = config.height;
				if(config.autoShow) autoShow = config.autoShow;
				if(config.clickable) clickable = config.clickable;
				if(config.clickToPlay) clickToPlay = config.clickToPlay;
			}
		}
		
		public function set width(width:*):void {
			_width = width;
		}
		
		public function get width():* {
			return _width;
		}
		
		public function set height(height:*):void {
			_height = height;
		}
		
		public function get height():* {
			return _height;
		}
		
		public function set autoShow(autoShow:Boolean):void {
			_autoShow = autoShow;
		}
		
		public function get autoShow():Boolean {
			return _autoShow;
		}
		
		public function set verticalAlign(verticalAlign:String):void {
			_verticalAlign = verticalAlign;
		}
		
		public function get verticalAlign():String {
			return _verticalAlign;
		}
		
		public function set horizontalAlign(horizontalAlign:String):void {
			_horizontalAlign = horizontalAlign;
		}
		
		public function get horizontalAlign():String {
			return _horizontalAlign;
		}
		
		public function set clickable(clickable:Boolean):void {
			_clickable = clickable;
		}
		
		public function get clickable():Boolean {
			return _clickable;
		}
		
		public function set clickToPlay(clickToPlay:Boolean):void {
			_clickToPlay = clickToPlay;
		}
		
		public function get clickToPlay():Boolean {
			return _clickToPlay;
		}
	}
}