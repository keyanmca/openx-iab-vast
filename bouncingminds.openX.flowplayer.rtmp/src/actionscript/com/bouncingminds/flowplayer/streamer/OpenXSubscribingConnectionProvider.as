/*    
 *    Copyright 2008, 2009 Flowplayer Oy
 *
 *    This file was derived from the Flowplayer RTMP connection classes
 *    namely SubscribingRTMPConnectionProvider. Copyright is attributed 
 *    accordingly
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
    
    import flash.events.TimerEvent;
    import flash.net.NetConnection;
    import flash.utils.Timer;
    
    import org.flowplayer.controller.StreamProvider;
    import org.flowplayer.model.Clip;
    import org.flowplayer.model.ClipError;
    import org.flowplayer.model.ClipEvent;	

	/**
	 * @author originated from org.flowplayer.rtmp.SubscribingRTMPConnectionProvider
	 */
	public class OpenXSubscribingConnectionProvider extends OpenXConnectionProvider {

		private var _onSuccess:Function;
		private var _subscribeRepeatTimer:Timer;
		private var _clip:Clip;
		private var _failureCount:int=0;

		public function OpenXSubscribingConnectionProvider(config:OpenXConfig) {
			super(config);
		}
		
		override public function connect(provider:StreamProvider, clip:Clip, successListener:Function, objectEncoding:uint, ...rest):void {
			clip.onConnectionEvent(onConnectionEvent);
			_clip = clip;
			_onSuccess = successListener;
			super.connect(provider, clip, function(connection:NetConnection):void { subscribe(); }, objectEncoding, rest);
		}
		
		private function onConnectionEvent(event:ClipEvent):void {
            doLog("Received " + event.info, DebugObject.DEBUG_STREAM_CONNECTION);
			if (! event.info == "onFCSubscribe") return;
			if (! (event.info2 && event.info2.hasOwnProperty("code"))) return;
			
			if (event.info2.code == "NetStream.Play.Start") {
			    _subscribeRepeatTimer.stop();
				_onSuccess(_connection);
			} else if (event.info2.code == "NetStream.Play.StreamNotFound") {
				doLog("Live stream not found [" + _config.getLiveStreamName() + "]", DebugObject.DEBUG_FATAL);
				if(_failureCount < 2) {
					doLog("Letting timer retry once more", DebugObject.DEBUG_STREAM_CONNECTION);
					++_failureCount;					
				}
				else {
				    doLog("Retry count exceeded - stopping timer", DebugObject.DEBUG_STREAM_CONNECTION);
			        _subscribeRepeatTimer.stop();
					_clip.dispatchError(ClipError.STREAM_NOT_FOUND);				
				}
			}
			else {
				doLog("Unknown failure type - stopping timer", DebugObject.DEBUG_STREAM_CONNECTION);
				_subscribeRepeatTimer.stop();
			} 
		}

		private function subscribe():void {
			onSubscribeRepeat();
			_subscribeRepeatTimer = new Timer(2000);
			_subscribeRepeatTimer.addEventListener(TimerEvent.TIMER, onSubscribeRepeat);
			_subscribeRepeatTimer.start();
		}

		private function onSubscribeRepeat(event:TimerEvent = null):void {
			doLog("Calling FCSubscribe for stream [" + _config.getLiveStreamName() + "]", DebugObject.DEBUG_STREAM_CONNECTION);
			_connection.call("FCSubscribe", null, _config.getLiveStreamName());
		}
	}
}
