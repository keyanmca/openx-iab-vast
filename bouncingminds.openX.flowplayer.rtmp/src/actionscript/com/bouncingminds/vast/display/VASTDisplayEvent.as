/*    
 *    Copyright (c) 2009 Bouncing Minds - Option 3 Ventures Limited
 *
 *    This file is part of the VAST Actionscript Framework.
 *
 *    The VAST AS framework is free software: you can redistribute it 
 *    and/or modify it under the terms of the GNU General Public License 
 *    as published by the Free Software Foundation, either version 3 of 
 *    the License, or (at your option) any later version.
 *
 *    The VAST AS framework is distributed in the hope that it will be 
 *    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with the plug-in.  If not, see <http://www.gnu.org/licenses/>.
 */
 package com.bouncingminds.vast.display {
	import com.bouncingminds.vast.display.VASTDisplayController;
	import com.bouncingminds.vast.model.NonLinearVideoAd;
	
	/**
	 * @author Paul Schulz
	 */
	public class VASTDisplayEvent {
		private var _nonLinearAd:NonLinearVideoAd = null;
		private var _customData:Object = new Object();
		private var _controller:VASTDisplayController = null;
		private var _width:int = -1;
		private var _height:int = -1;
		
		public function VASTDisplayEvent(controller:VASTDisplayController, width:int=-1, height:int=-1) {
			_controller = controller;
			_width = width;
			_height = height;
		}

		public function set controller(controller:VASTDisplayController):void {
			_controller = controller;
		}
		
		public function get controller():VASTDisplayController {
			return _controller;
		}
		
		public function set width(width:int):void {
			_width = width;
		}
		
		public function get width():int {
			return _width;
		}
		
		public function set height(height:int):void {
			_height = height;
		}
		
		public function get height():int {
			return _height;
		}
		
		public function hasAd():Boolean {
			return (_nonLinearAd != null);
		}
		
		public function set ad(nonLinearAd:NonLinearVideoAd):void {
			_nonLinearAd = nonLinearAd;
		}
		
		public function get ad():NonLinearVideoAd {
			return _nonLinearAd;
		}

		public function set customData(customData:Object):void {
			_customData = customData;	
		}
		
		public function get customData():Object {
			return _customData;
		}		
	}
}