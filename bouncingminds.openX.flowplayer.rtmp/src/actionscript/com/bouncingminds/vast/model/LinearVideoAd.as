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
	public class LinearVideoAd extends TrackedVideoAd {
		private var _duration:String; // hh:mm:ss
		private var _mediaFiles:Array = new Array();

		public function LinearVideoAd() {
			super();
		}

		public function set duration(duration:String):void {
			_duration = duration;
		}
		
		public function get duration():String {
			return _duration;
		}
		
		public function set mediaFiles(mediaFiles:Array):void {
			_mediaFiles = mediaFiles;
		}
		
		public function get mediaFiles():Array {
			return _mediaFiles;
		}
		
		public function addMediaFile(mediaFile:MediaFile):void {
			_mediaFiles.push(mediaFile);
		}
		
		public function getStreamToPlay(deliveryType:String, mimeType:String, bitrate:String=null):NetworkResource {
			if(_mediaFiles != null && _mediaFiles.length > 0) {
				for(var i:int = 0; i < _mediaFiles.length; i++) {
					if(_mediaFiles[i].isDeliveryType(deliveryType) && _mediaFiles[i].isMimeType(mimeType)) {
						if(bitrate != null) {
							if(_mediaFiles[i].matches(bitrate)) {
								return _mediaFiles[i].url;
							}	
						}
						else return _mediaFiles[i].url;
					}
				}
			}
			return null;
		}
	}
}