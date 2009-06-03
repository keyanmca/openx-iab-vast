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
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.util.NetworkResource;
	import com.bouncingminds.util.Timestamp;
	
	import flash.net.NetStream;
	
	import org.flowplayer.model.Clip;
	import org.flowplayer.model.Cuepoint;
	import org.flowplayer.view.Flowplayer;
				
	/**
	 * @author Paul Schulz
	 */
	public class StreamSegment extends DebugObject {
		public const VAST_MIME_TYPE_FLV:String = "video/x-flv";
		public const VAST_MIME_TYPE_MP4:String = "video/x-mp4";
		public const VAST_DELIVERY_TYPE_STREAMING:String = "streaming";
		
		protected var _streamID:String;
		protected var _startTime:String = "00:00:00";
		protected var _streamStartTime:int = 0;
		protected var _duration:String = null;
		protected var _reduceLength:Boolean = false;
		protected var _streamType:String = "mp4";
		protected var _mimeType:String = VAST_MIME_TYPE_MP4;
		protected var _cuepointsSet:Boolean = false;

		public function StreamSegment(streamID:String=null, startTimestamp:String="00:00:00", duration:String=null, reducedLength:Boolean=false, streamType:String="mp4") {
			_streamID = streamID;
			startTime = startTimestamp;
			_duration = duration;
			_reduceLength = reducedLength;
			_streamType = streamType;
			setMimeType();
		}
		
		public function set streamID(streamID:String):void {
			_streamID = streamID;
		}
		
		public function get streamID():String {
			return _streamID;
		}

        public function set streamType(streamType:String):void {
        	_streamType = streamType;
        	setMimeType();
        }
        
        public function get streamType():String {
        	return _streamType;
        }
        
		private function setMimeType():void {
			if(_streamType == "flv") {
				_mimeType = VAST_MIME_TYPE_FLV;
			}
			else _mimeType = VAST_MIME_TYPE_MP4;
		}
		
		public function get mimeType():String {
			return _mimeType;
		}
				
		public function set startTime(startTime:String):void {
			_startTime = startTime;
			_streamStartTime = getStartTimeAsSeconds();
		}
		
		public function get startTime():String {
			return _startTime;
		}
		
		public function getStartTimeAsSeconds():int {
			if(_startTime != null) {
				return Timestamp.timestampToSeconds(_startTime);
			}
			return 0;
		}
		
		public function getStartTimeAsSecondsString():String {
			return new String(getStartTimeAsSeconds());
		}
		
		public function set streamStartTime(streamStartTime:int):void {
			_streamStartTime = streamStartTime;
		}
		
		public function get streamStartTime():int {
			return _streamStartTime;
		}
		
		public function hasNonZeroDuration():Boolean {
			if(_duration != null) {
				return (getDurationAsInt() > 0);
			}
			return false;
		}
		
		public function set duration(duration:String):void {
			_duration = duration;
		}
		
		public function get duration():String {
			return ((_duration == null) ? "0" : _duration);
		}
		
		public function getDurationAsInt():int {
			return parseInt(duration);		
		}
		
		public function durationToTimestamp():String {
			return Timestamp.secondsToTimestamp(parseInt(_duration));
		}
		
		public function set reduceLength(reduceLength:Boolean):void {
			_reduceLength = reduceLength;
		}
		
		public function get reduceLength():Boolean {
			return _reduceLength;
		}
		
		public function getStreamToPlay(deliveryType:String=VAST_DELIVERY_TYPE_STREAMING, mimeType:String=VAST_MIME_TYPE_MP4, bitrate:String=null):NetworkResource {
			return new NetworkResource(null, _streamID);
		}

		protected function setCuepoint(clip:Clip, milliseconds:int, callbackID:String):void {
			if(_cuepointsSet == false) {
				doLog("Cuepoint set at " + milliseconds + " milliseconds with callback ID " + callbackID, DebugObject.DEBUG_CUEPOINT_FORMATION);
				clip.addCuepoint(new Cuepoint(milliseconds, callbackID));				
			}
			else doLog("No setting StreamSegment cuepoint - already set once", DebugObject.DEBUG_CUEPOINT_FORMATION);			
		}
		
		protected function cleanseStreamName(rawName:String):String {
			// first check if there is a netConnectionURL in the rawname - if so, remove it (we use the config netConnection setting)
			if(rawName.indexOf("mp4:") != 0 || rawName.indexOf("flv:") != 0) {
				if(rawName.indexOf("mp4:") > 0) {
					rawName = rawName.substr(rawName.indexOf("mp4:"));
				}
				else if(rawName.indexOf("flv:") > 0) {
					rawName = rawName.substr(rawName.indexOf("flv:"));
				}
			}
			
			// Now check if it's an FLV file - if so, clean up the flv: tag
			if(rawName.indexOf("flv:") > -1) {
				// if it's an FLV file, remove the flv: and any .flv extension
                var pattern:RegExp = /flv:/g;  
                var cleanName:String = rawName.replace(pattern, "");
                pattern = /.flv/g;
                return cleanName.replace(pattern, "");
			}
			return rawName;	
		}
		
		public function schedulePlay(netStream:NetStream, reset:int=0, bitrate:String=null):int {
			var streamURL:NetworkResource = getStreamToPlay(VAST_DELIVERY_TYPE_STREAMING, VAST_MIME_TYPE_MP4);
			if(streamURL != null) {
				if(streamURL.isLiveURL()) {
					if(hasNonZeroDuration()) {
						doLog("Configuring live stream " + streamURL.getLiveStreamName() + " to play for " + duration, DebugObject.DEBUG_SEGMENT_FORMATION);
						netStream.play(streamURL.getLiveStreamName(), -1, getDurationAsInt());
						return getDurationAsInt();
					}
					else {
						doLog("Configuring live stream " + streamURL.getLiveStreamName() + " to play indefinitely", DebugObject.DEBUG_SEGMENT_FORMATION);
						netStream.play(streamURL.getLiveStreamName(), -1);
						return -1;
					}
				}
				else {
					var streamName:String = cleanseStreamName(streamURL.getFilename(streamType + ":"));
					if(streamStartTime == 0 && reset == 1 && reduceLength == false) {
						doLog("Loading programme stream " + streamName + " with reset=1 starting at 0 running for entire duration: " + getDurationAsInt() + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION); 
						netStream.play(streamName);
//						netStream.play(streamURL.url);
					}
					else {
						doLog("Loading programme stream " + streamName + " (reset=" + reset + ") to start at " + streamStartTime + " seconds in, running for " + getDurationAsInt() + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION); 
						netStream.play(streamName, streamStartTime, getDurationAsInt(), reset);				
//						netStream.play(streamURL.url, streamStartTime, getDurationAsInt(), reset);				
					}
					return getDurationAsInt();
				}
			}
			return 0;
		}
		
		protected function markCuepointsAsSet():void {
			_cuepointsSet = true;	
		}
		
		public function setCuepoints(clip:Clip, i:int, currentTimeInSeconds:int, includeNonLinear:Boolean=true, includeCompanion:Boolean=true):void {
			if(_cuepointsSet == false) {
				if(currentTimeInSeconds + getDurationAsInt() > 0) {
					// only fire off stream start and end events if the stream is actually longer than 0 seconds
			        if(currentTimeInSeconds == 0) { 
			            // always trigger the first 1000 milliseconds in, not 0 otherwise flowplayer seems to drop the event
			        	setCuepoint(clip, 1000, "BS:"+i);
		    	    }
					else setCuepoint(clip, currentTimeInSeconds * 1000, "BS:"+i);
					setCuepoint(clip, (currentTimeInSeconds + getDurationAsInt()) * 1000, "ES:"+i);
				}
				else doLog("Not setting cuepoints for stream with index " + i + " because of 0 duration", DebugObject.DEBUG_CUEPOINT_FORMATION);				
				markCuepointsAsSet();
			}
			else doLog("No setting StreamSegment cuepoints - already set once", DebugObject.DEBUG_CUEPOINT_FORMATION);
		}
		
	 	protected function getDebugInfo(cuepointEventType:String, description:String):Object {
	 		var info:Object = new Object();
	 		info.type = cuepointEventType;
	 		info.description = description;
	 		info.segmentType = "program";
	 		info.id = _streamID;
	 		info.startTime = _startTime;
	 		info.duration = _duration + " seconds";
	 		info.cuepoint = cuepointEventType;
	 		return info;
	 	}

		protected function actionStartStream(player:Flowplayer=null, config:OpenXConfig=null):void {
		}

		protected function actionStreamComplete(player:Flowplayer=null, config:OpenXConfig=null):void {
		}
		
		public function processPauseEvent():void {
			doLog("Segment " + _streamID + " paused", DebugObject.DEBUG_PLAY_EVENTS);
		}

		public function processResumeEvent():void {
			doLog("Segment " + _streamID + " resumed", DebugObject.DEBUG_PLAY_EVENTS);
		}

		public function processStopEvent():void {
			doLog("Segment " + _streamID + " stopped", DebugObject.DEBUG_PLAY_EVENTS);
		}

        public function processFullScreenEvent():void {	
			doLog("Segment " + _streamID + " full screen event", DebugObject.DEBUG_PLAY_EVENTS);        
        }

        public function processMuteEvent():void {	
			doLog("Segment " + _streamID + " mute event", DebugObject.DEBUG_PLAY_EVENTS);        
        }

	 	public function processCuepoint(cuepointEventType:String, player:Flowplayer, adDisplayController:OpenXDisplayController, config:OpenXConfig=null):Object {
	 		doLog("Segment: " + _streamID + " received request to process cuepoint of type " + cuepointEventType, DebugObject.DEBUG_CUEPOINT_EVENTS);
			var description:String = "";
	 		switch(cuepointEventType) {
	 			case "BS": // start of the stream
	 				description = "Begin program stream";
	 				actionStartStream(player, config);
	 				break;
	 			case "ES": // end of the stream
	 				description = "End program stream";
	 				actionStreamComplete(player, config);
	 				break;
	 		}
	 		
	 		return getDebugInfo(cuepointEventType, description);
	 	}
	}
}