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
package com.bouncingminds.vast.model {
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.util.NetworkResource;

	/**
	 * @author Paul Schulz
	 */
	public class TrackedVideoAd extends DebugObject {
		protected var _id:String;
		protected var _adID:String;
		protected var _clickThroughs:Array = new Array();
		protected var _clickTracking:Array = new Array();
		protected var _customClicks:Array = new Array();
		protected var _parentAdContainer:VideoAd = null;

		public function TrackedVideoAd() {
			super();
		}
		
		public function set id(id:String):void {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set adID(adID:String):void {
			_adID = adID;
		}
		
		public function get adID():String {
			return _adID;
		}
		
		public function set parentAdContainer(parentAdContainer:VideoAd):void {
			_parentAdContainer = parentAdContainer;
		}
		
		public function get parentAdContainer():VideoAd {
			return _parentAdContainer;
		}
		
		public function set clickThroughs(clickThroughs:Array):void {
			_clickThroughs = clickThroughs;
		}
		
		public function get clickThroughs():Array {
			return _clickThroughs;
		}
		
		public function addClickThrough(clickThrough:NetworkResource):void {
			_clickThroughs.push(clickThrough);
		}
		
		public function set clickTracking(clickTracking:Array):void {
			_clickTracking = clickTracking;
		}
		
		public function get clickTracking():Array {
			return _clickTracking;
		}
		
		public function addClickTrack(clickURL:NetworkResource):void {
			_clickTracking.push(clickURL);
		}
		
		public function set customClicks(customClicks:Array):void {
			_customClicks = customClicks;
		}
		
		public function get customClicks():Array {
			return _customClicks;
		}
		
		public function addCustomClick(customClick:NetworkResource):void {
			_customClicks.push(customClick);
		}
		
		public function hasClickThroughURL():Boolean {
			return (_clickThroughs.length > 0);
		}
	}
}