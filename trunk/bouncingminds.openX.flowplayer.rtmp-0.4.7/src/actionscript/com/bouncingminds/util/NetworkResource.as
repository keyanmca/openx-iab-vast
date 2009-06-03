/*    
 *    Copyright (c) 2009 Bouncing Minds - Option 3 Ventures Limited
 *
 *    This file is part of the Regions and OpenX Ad Streamer for Flowplayer.
 *
 *    The Regions/OpenX Ad Streamer plug-in is free software: you can redistribute it 
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
 package com.bouncingminds.util {
	import flash.events.*;
	import flash.net.*;
		
	public class NetworkResource extends DebugObject {
		private var _id:String = null;
		private var _url:String = null;
		private	var _loader:URLLoader = new URLLoader();
		
		public function NetworkResource(id:String = null, url:String = null) {
			_id = id;
			_url = url;
		}
		
		public function set id(id:String):void {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set url(url:String):void {
			_url = url;
		}
		
		public function get url():String {
			return _url;
		}
		
		public function get data():String {
			return _loader.data;
		}
		
		public function getFilename(fileMarker:String=null):String {
			if(_url != null) {
				if(fileMarker != null) {
					var firstMarkerIndex:int = _url.indexOf(fileMarker);
					if(firstMarkerIndex == -1) {
						return _url;
					}
					else return _url.substr(firstMarkerIndex);
				}
				else {
					var lastSlashIndex:int = _url.lastIndexOf("/");
					if(lastSlashIndex == -1) {
						return _url;
					}
					else { // strip out the URI
						return _url.substr(lastSlashIndex+1);
					}
				}
			}
			else return null;
		}
		
		public function getURI():String {
			if(_url != null) {
				var lastSlashIndex:int = _url.lastIndexOf("/");
				if(lastSlashIndex == -1) {
					return null;
				}
				else { // strip out the filename
					return _url.substr(0, lastSlashIndex+1);
				}			
			}
			else return null;
		}
		
		public function isLiveURL():Boolean {
			var filename:String = getFilename();
			if(filename != null) {
				return (filename.indexOf("(live)") > -1);
			}
			return false;
		}
		
		public function getLiveStreamName():String {
			if(isLiveURL()) {
				var filename:String = getFilename();
				return filename.substr(filename.lastIndexOf("(live)") + 6);
			}
			else return null;					
		}
		
		public function call():void {
			if(_url != null) {
				doLog("Making HTTP call to " + _url, DebugObject.DEBUG_HTTP_CALLS);
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, callComplete);
				_loader.addEventListener(ErrorEvent.ERROR, errorHandler)
				_loader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_loader.load(new URLRequest(_url));
			}
			else doLog("HTTP call cannot be made - no URL set", DebugObject.DEBUG_HTTP_CALLS);
		}

		protected function callComplete(e:Event):void {
			doLog("HTTP call complete (to " + id + ") - " + _loader.bytesLoaded + " bytes loaded", DebugObject.DEBUG_HTTP_CALLS);
			loadComplete(_loader.data);
		}
		
		protected function errorHandler(e:Event):void {
			doLog("HTTP ERROR: " + e.toString(), DebugObject.DEBUG_HTTP_CALLS);
		}		
		
		protected function loadComplete(data:String):void {
		}
	}
}