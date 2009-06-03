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
	import com.bouncingminds.util.NetworkResource;
	
	/**
	 * @author Paul Schulz
	 */
	public class MediaFile {
		private var _url:NetworkResource;
		private var _id:String;
		private var _bandwidth:String; // high, medium, low, custom
		private var _delivery:String;  // streaming, progressive
		private var _mimeType:String;     
		private var _bitRate:String = null;
		private var _width:String;
		private var _height:String;
		
		public function MediaFile() {
		}
		
		public function set id(id:String):void {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set url(url:NetworkResource):void {
			_url = url;
		}
		
		public function get url():NetworkResource {
			return _url;
		}
		
		public function set bandwidth(bandwidth:String):void {
			_bandwidth = bandwidth;
		}
		
		public function get bandwidth():String {
			return _bandwidth;
		}
		
		public function set delivery(delivery:String):void {
			_delivery = delivery;
		}
		
		public function get delivery():String {
			return _delivery;
		}
		
		public function set mimeType(mimeType:String):void {
			_mimeType = mimeType;
		}
		
		public function get mimeType():String {
			return _mimeType;
		}
		
		public function set bitRate(bitRate:String):void {
			_bitRate = bitRate;
		}
		
		public function get bitRate():String {
			return _bitRate;
		}
		
		public function matches(bitrate:String):Boolean {
			if(_bitRate == null) {
				return  true;
			}
			else {
				var range:Array = bitrate.split("-", 2);
				
 				if(range.length == 2) {
 					var min:int = int(range[0]);
 					var max:int = int(range[1]);
 					var value:int = int(_bitRate);
 					return (min <= value && value <= max);
				}
				else return bitrate == _bitRate;
			}
		}		
		
		public function set width(width:String):void {
			_width = width;
		}
		
		public function get width():String {
			return _width;
		}
		
		public function set height(height:String):void {
			_height = height;
		}
		
		public function get height():String {
			return _height;
		}
		
		public function isMimeType(mimeType:String):Boolean {
			return (_mimeType == mimeType);
		}
		
		public function isDeliveryType(deliveryType:String):Boolean {
			return (_delivery == deliveryType);
		}
	}
}