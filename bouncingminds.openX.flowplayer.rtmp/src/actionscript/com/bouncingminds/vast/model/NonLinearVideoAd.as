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
	import com.bouncingminds.vast.display.VASTDisplayEvent;

	/**
	 * @author Paul Schulz
	 */
	public class NonLinearVideoAd extends TrackedVideoAd {
		protected var _width:int=-1;
		protected var _height:int=-1;
		protected var _resourceType:String;
		protected var _creativeType:String;
		protected var _apiFramework:String;
		protected var _url:NetworkResource;
		protected var _codeBlock:String;
		
		public function NonLinearVideoAd() {
			super();
		}
		
		public function set width(width:*):void {
			if(typeof width == 'string') {
				_width = parseInt(width);
			}
			else _width = width;
		}
		
		public function get width():int {
			return _width;
		}
		
		public function set height(height:*):void {
			if(typeof height == 'string') {
				_height = parseInt(height);
			}
			else _height = height;
		}
		
		public function get height():int {
			return _height;
		}
		
		public function set resourceType(resourceType:String):void {
			_resourceType = resourceType.toUpperCase();
		}
		
		public function get resourceType():String {
			return _resourceType;
		}
		
		public function set creativeType(creativeType:String):void {
			_creativeType = creativeType.toUpperCase();
		}
		
		public function get creativeType():String {
			return _creativeType;
		}
		
		public function set apiFramework(apiFramework:String):void {
			_apiFramework = apiFramework;
		}
		
		public function get apiFramework():String {
			return apiFramework;
		}
		
		public function set url(url:NetworkResource):void {
			_url = url;
		}
		
		public function get url():NetworkResource {
			return _url;
		}
		
		public function set codeBlock(codeBlock:String):void {
			_codeBlock = codeBlock;
		}
		
		public function get codeBlock():String {
			return _codeBlock;
		}
		
		public function isHtmlCodeBlock():Boolean {
			if(_resourceType != null) {
				return (_resourceType.toUpperCase()	== "HTML");		
			}
			else return false;
		}
		
		public function isImage():Boolean {
			return (creativeType == "JPEG" || creativeType == "GIF");
		}
		
		public function hasAccompanyingVideoAd():Boolean {
			if(parentAdContainer != null) {
				return parentAdContainer.hasLinearAd();
			}
			return false;
		}
		
		public function matchesSize(width:int, height:int):Boolean {
			if(width == -1 && height == -1) {
				return true;
			}
			else {
				if(width == -1) { // just check the height
					return (height == _height);
				}
				else {
					if(width == _width) {
						return (height == _height);						
					}
					else return false;
				}
			}
		}
		
		public function start(displayEvent:VASTDisplayEvent):void {
			displayEvent.ad = this;
			displayEvent.controller.displayNonLinearOverlayAd(displayEvent);		
		}
		
		public function stop(displayEvent:VASTDisplayEvent):void {
			displayEvent.ad = this;
			displayEvent.controller.hideNonLinearOverlayAd(displayEvent);
		}
	}
}