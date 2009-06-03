/*    
 *    Copyright 2008, 2009 Flowplayer Oy, 
 *    Copyright 2009 Bouncing Minds - Option 3 Ventures Limited
 *
 *    This file was derived from the Flowplayer RTMP connection classes
 *    namely DefaultRTMPConnectionProvider and RTMPConnectionProvider.
 *    Copyright is attributed accordingly
 *
 *    FlowPlayer is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    FlowPlayer is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with FlowPlayer.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.bouncingminds.flowplayer.streamer {
    import com.bouncingminds.util.DebugObject;
    
    import flash.events.NetStatusEvent;
    import flash.net.NetConnection;
    
    import org.flowplayer.controller.ConnectionProvider;
    import org.flowplayer.controller.StreamProvider;
    import org.flowplayer.model.Clip;
    import org.flowplayer.util.Log;		

	/**
	 * @author Paul Schulz
	 */
	public class OpenXConnectionProvider extends DebugObject implements ConnectionProvider {
		protected var _config:OpenXConfig;
		
//		protected var log:Log = new Log(this);
		protected var _connection:NetConnection;
		protected var _successListener:Function;
		protected var _failureListener:Function;
		protected var _connectionClient:Object;
        protected var _provider:OpenXConnectionProvider;

		public function OpenXConnectionProvider(config:OpenXConfig) {
			_config = config;
		} 

		public function connect(provider:StreamProvider, clip:Clip, successListener:Function, objectEncoding:uint, ...rest):void {
            _provider = provider as OpenXConnectionProvider;
			_successListener = successListener;
			_connection = new NetConnection();
			_connection.proxyType = "best";
            _connection.objectEncoding = objectEncoding;
			
			if (_connectionClient) {
				_connection.client = _connectionClient;
			}
			_connection.addEventListener(NetStatusEvent.NET_STATUS, _onConnectionStatus);

            var connectionUrl:String = getNetConnectionUrl(clip);
            doLog("Connecting on " + _config.netConnectionUrl, DebugObject.DEBUG_STREAM_CONNECTION);

			if (rest.length > 0) {
				_connection.connect(connectionUrl, rest);
			} else {
				_connection.connect(connectionUrl);
			}
		}

		private function _onConnectionStatus(event:NetStatusEvent):void {
			if (event.info.code == "NetConnection.Connect.Success" && _successListener != null) {
				if(_successListener != null) _successListener(_connection);
			} else if (["NetConnection.Connect.Failed", "NetConnection.Connect.Rejected", "NetConnection.Connect.AppShutdown", "NetConnection.Connect.InvalidApp"].indexOf(event.info.code) >= 0) {	
				if (_failureListener != null) {
					_failureListener();
				}
			}	
		}

		public function set connectionClient(client:Object):void {
			if (_connection) {
				_connection.client = client;
			}
			_connectionClient = client;
		}
	
		protected function getNetConnectionUrl(clip:Clip):String {
			if (OpenXClipURLResolver.isRtmpUrl(_config.netConnectionUrl)) { 
                doLog("Have an RTMP connection " + _config.netConnectionUrl, DebugObject.DEBUG_STREAM_CONNECTION);
				var url:String = _config.netConnectionUrl; 
				var lastSlashPos:Number = url.lastIndexOf("/");
				if(lastSlashPos == (url.length-1)) {
					return url.substring(0, lastSlashPos);				
				}
				else return url;
			}
			return _config.netConnectionUrl;
		}
		
		public function set onFailure(listener:Function):void {
			_failureListener = listener;
		}
		
        public function handeNetStatusEvent(event:NetStatusEvent):Boolean {
            return true;
        }

        protected function get provider():OpenXConnectionProvider {
           return _provider;
        }

        protected function get failureListener():Function {
            return _failureListener;
        }

        protected function get successListener():Function {
            return _successListener;
        }
	}
}