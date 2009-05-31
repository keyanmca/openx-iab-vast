/*    
 *    Copyright (c) 2009 Bouncing Minds - Option 3 Ventures Limited
 *
 *    This file is part of the Open X VAST Plug-in for Flowplayer.
 *
 *    The Open X VAST Plug-in is free software: you can redistribute it 
 *    and/or modify it under the terms of the GNU General Public License 
 *    as published by the Free Software Foundation, either version 3 of 
 *    the License, or (at your option) any later version.
 *
 *    The Open X VAST Plug-in is distributed in the hope that it will be 
 *    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with the plug-in.  If not, see <http://www.gnu.org/licenses/>.
 */
 package com.bouncingminds.flowplayer.streamer {
    import flash.events.NetStatusEvent;
    
    import org.flowplayer.controller.ClipURLResolver;
    import org.flowplayer.controller.StreamProvider;
    import org.flowplayer.model.Clip;

	/**
	 * @author Paul Schulz
	 */
	public class OpenXClipURLResolver implements ClipURLResolver {
		protected var _url:String = null;

		public function OpenXClipURLResolver(url:String) {
			_url = url;
		}
		
		public function resolve(provider:StreamProvider, clip:Clip, successListener:Function):void {
			if (OpenXClipURLResolver.isRtmpUrl(_url)) { 
				var lastSlashPos:Number = _url.lastIndexOf("/");
				if(lastSlashPos == (_url.length-1)) {
					clip.resolvedUrl = _url.substring(0, lastSlashPos);				
				}
				else clip.resolvedUrl = _url;
			}
			else clip.resolvedUrl = _url;
            successListener(clip);
		}
		
		public function set onFailure(listener:Function):void {
		}
		
		public static function isRtmpUrl(url:String):Boolean {
			return url && url.toLowerCase().indexOf("rtmp") == 0;
		}

        public function handeNetStatusEvent(event:NetStatusEvent):Boolean {
            return true;
        }
    }
}