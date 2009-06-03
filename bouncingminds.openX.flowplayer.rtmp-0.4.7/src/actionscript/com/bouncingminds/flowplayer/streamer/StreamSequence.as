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
	import com.bouncingminds.flowplayer.ads.AdSequence;
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.util.Timestamp;
	import com.bouncingminds.vast.display.VASTDisplayController;
	
	import flash.net.NetStream;
	
	import org.flowplayer.model.Clip;
	import org.flowplayer.model.ClipEvent;
	import org.flowplayer.view.Flowplayer;

	/**
	 * @author Paul Schulz
	 */
	public class StreamSequence extends DebugObject {
		protected var _sequence:Array = new Array();
		protected var _totalDuration:int = 0;
		protected var _lastPauseTime:int = 0;
		protected var _bitrate:String = null;
		
		public function StreamSequence(config:OpenXConfig=null, adSequence:AdSequence=null) {
			if(config != null && adSequence != null) {
				if(config.hasBitRate()) {
					_bitrate = config.bitrate;
				}
				_totalDuration = build(config.streams, adSequence);			
			}
		}
		
		public function get totalDuration():int {
			return _totalDuration;
		}
		
		public function hasBitRate():Boolean {
			return _bitrate != null;
		}
		
		public function get bitrate():String {
			return _bitrate;
		}

		private function createNewMetricsTracker():Object {
			var currentMetrics:Object = new Object();
			currentMetrics.usedAdDuration = 0;		
			currentMetrics.remainingActiveShowDuration = 0;	
			currentMetrics.usedActiveShowDuration = 0;
			currentMetrics.totalActiveShowDuration = 0;
			currentMetrics.associatedStreamIndex = 0;			
			return currentMetrics;
		}
		
		public function build(streams:Array, adSequence:AdSequence):int {
			doLogAndTrace("*** START BUILDING THE SEGMENT SEQUENCE FROM MULTIPLE SHOW PARTS (" + streams.length + ")", adSequence, DebugObject.DEBUG_SEGMENT_FORMATION);
			var adSlots:Array = adSequence.adSlots;
			var trackingInfo:Array = new Array();
			var totalDuration:int = 0;
			
//			if(streams.length > 0) {
				var currentMetrics:Object = createNewMetricsTracker();
				currentMetrics.associatedStreamIndex = 0;
				var previousMetrics:Object = currentMetrics;
				
				if(adSequence.hasLinearAds()) {
					for(var i:int = 0; i < adSlots.length; i++) {
						if(currentMetrics.associatedStreamIndex != adSlots[i].associatedStreamIndex) {
							trackingInfo.push(currentMetrics);
							previousMetrics = currentMetrics;
							currentMetrics = createNewMetricsTracker();
							currentMetrics.associatedStreamIndex = adSlots[i].associatedStreamIndex;
						}
						if(streams.length > 0) {
							currentMetrics.totalActiveShowDuration = Timestamp.timestampToSeconds(streams[adSlots[i].associatedStreamIndex].duration);						
						}
						if((adSlots[i].isLinear() || adSlots[i].isPopUp()) && adSlots[i].isActive()) {
							if(adSlots[i].isPreRoll()) {
								doLog("Slotting in a pre-roll ad with id: " + adSlots[i].id, DebugObject.DEBUG_SEGMENT_FORMATION);
								if(currentMetrics.associatedStreamIndex != previousMetrics.associatedStreamIndex) {
									if(previousMetrics.usedActiveShowDuration < previousMetrics.totalActiveShowDuration) {
										// we still have some of the previous show stream to schedule before we do a pre-roll ad for the next stream
										previousMetrics.remainingActiveShowDuration = previousMetrics.totalActiveShowDuration - previousMetrics.usedActiveShowDuration;
										doLog("Slotting in the remaining (previous) show segment to play before pre-roll - segment duration is " + previousMetrics.remainingActiveShowDuration + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION);
										_sequence.push(new StreamSegment(streams[previousMetrics.associatedStreamIndex].filename,
																		Timestamp.secondsToTimestamp(previousMetrics.usedActiveShowDuration),
																		new String(previousMetrics.remainingActiveShowDuration),
																		true)); //streams[previousMetrics.associatedStreamIndex].reduceLength
										previousMetrics.usedActiveShowDuration += previousMetrics.remainingActiveShowDuration;
										totalDuration += previousMetrics.remainingActiveShowDuration;
										doLog("Total stream duration is now " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);								
									}
								}
							}
							else if(adSlots[i].isPopUp()) {
							}
							else if(adSlots[i].isMidRoll()) {
								doLog("Slotting in a mid-roll ad with id: " + adSlots[i].id, DebugObject.DEBUG_SEGMENT_FORMATION);
								if(!adSlots[i].isCopy()) {
									if(previousMetrics != currentMetrics && (previousMetrics.usedActiveShowDuration < previousMetrics.totalActiveShowDuration)) {
										// we still have some of the previous show stream to schedule before we do a pre-roll ad for the next stream
										previousMetrics.remainingActiveShowDuration = previousMetrics.totalActiveShowDuration - previousMetrics.usedActiveShowDuration;
										doLog("But first we are slotting in the remaining (previous) show segment to play before mid-roll - segment duration is " + previousMetrics.remainingActiveShowDuration + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION);
										_sequence.push(new StreamSegment(streams[previousMetrics.associatedStreamIndex].filename,
																	Timestamp.secondsToTimestamp(previousMetrics.usedActiveShowDuration),
																	new String(previousMetrics.remainingActiveShowDuration),
																	true)); //streams[previousMetrics.associatedStreamIndex].reduceLength
										previousMetrics.usedActiveShowDuration += previousMetrics.remainingActiveShowDuration;
										totalDuration += previousMetrics.remainingActiveShowDuration;
										doLog("Total stream duration is now " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);								
									}

									if(streams.length > 0) {
	                                	// Slice in the portion of the current program up to the mid-roll ad
										var showSliceDuration:int = adSlots[i].getStartTimeAsSeconds() - currentMetrics.usedActiveShowDuration;
										doLog("Slicing in a segment from the show starting at " + Timestamp.secondsToTimestamp(currentMetrics.usedActiveShowDuration) + " running for " + showSliceDuration + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION);
										_sequence.push(new StreamSegment(streams[adSlots[i].associatedStreamIndex].filename, 
																Timestamp.secondsToTimestamp(currentMetrics.usedActiveShowDuration),
																new String(showSliceDuration),
																true)); //streams[adSlots[i].associatedStreamIndex].reduceLength
										currentMetrics.usedActiveShowDuration += showSliceDuration;
										totalDuration += showSliceDuration;
										doLog("Total stream duration is now " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);
									}
								}
							}
							else { // it's post-roll 
								doLog("Slotting in a post-roll ad with id: " + adSlots[i].id, DebugObject.DEBUG_SEGMENT_FORMATION);
								if(streams.length > 0) {
//									if(!adSlots[i].isCopy()) {
										currentMetrics.remainingActiveShowDuration = currentMetrics.totalActiveShowDuration - currentMetrics.usedActiveShowDuration;
										doLog("Slotting in the remaining show segment to play before post-roll - start point is " + Timestamp.secondsToTimestamp(currentMetrics.usedActiveShowDuration) + ", segment duration is " + currentMetrics.remainingActiveShowDuration + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION);
										_sequence.push(new StreamSegment(streams[adSlots[i].associatedStreamIndex].filename,
																	Timestamp.secondsToTimestamp(currentMetrics.usedActiveShowDuration),
																	new String(currentMetrics.remainingActiveShowDuration),
																	true)); //streams[adSlots[i].associatedStreamIndex].reduceLength
										currentMetrics.usedActiveShowDuration += currentMetrics.remainingActiveShowDuration;
										totalDuration += currentMetrics.remainingActiveShowDuration;
										doLog("Total stream duration is now " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);	
									}
//								}
							}

							doLog("Inserting ad to play for " + adSlots[i].duration + " seconds from " + totalDuration + " seconds into the stream", DebugObject.DEBUG_SEGMENT_FORMATION);
							adSlots[i].streamStartTime = 0;
							_sequence.push(adSlots[i]);
							currentMetrics.usedAdDuration += adSlots[i].getDurationAsInt();
							doLog("Have slotted in the ad with id " + adSlots[i].id, DebugObject.DEBUG_SEGMENT_FORMATION);
							totalDuration += adSlots[i].getDurationAsInt();
							doLog("Total stream duration is now " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);
						}
						else {
							doLog("Ad slot " + adSlots[i].id + " is not linear/pop or is not active - active is " + adSlots[i].isActive());
							adSequence.adSlots[i].associatedStreamStartTime = totalDuration;
						}					
					}
					if(currentMetrics.usedActiveShowDuration < currentMetrics.totalActiveShowDuration) { 
						// After looping through all the ads, we still have some show to play, so add it in
						currentMetrics.remainingActiveShowDuration = currentMetrics.totalActiveShowDuration - currentMetrics.usedActiveShowDuration;
						doLog("Slotting in the remaining show segment right at the end - segment duration is " + currentMetrics.remainingActiveShowDuration + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION);
			  			_sequence.push(new StreamSegment(streams[currentMetrics.associatedStreamIndex].filename,
				  					   Timestamp.secondsToTimestamp(currentMetrics.usedActiveShowDuration),
				  					   new String(currentMetrics.remainingActiveShowDuration),
				  					   true)); //streams[currentMetrics.associatedStreamIndex].reduceLength
						totalDuration += currentMetrics.remainingActiveShowDuration;
						doLog("Total stream duration is now " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);
						if(currentMetrics.associatedStreamIndex+1 < streams.length) {
							// there are still some streams to sequence after all the ads have been slotted in
							for(var x:int=currentMetrics.associatedStreamIndex+1; x < streams.length; x++) {
								doLog("Sequencing remaining stream " + streams[x].filename + " without any advertising at all", DebugObject.DEBUG_SEGMENT_FORMATION);
								_sequence.push(new StreamSegment(streams[x].filename, "00:00:00", Timestamp.timestampToSecondsString(streams[x].duration), streams[x].reduceLength));					
								totalDuration += Timestamp.timestampToSeconds(streams[x].duration);
								doLog("Total stream duration is now " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);
							}
						}
					}
				}
				else { // we don't have any ads, so just stream the main show
					doLog("No video ad streams to schedule, just scheduling the main stream(s)", DebugObject.DEBUG_SEGMENT_FORMATION);
					for(var j:int=0; j < streams.length; j++) {
						doLog("Sequencing stream " + streams[j].filename + " without any advertising at all", DebugObject.DEBUG_SEGMENT_FORMATION);
						_sequence.push(new StreamSegment(streams[j].filename, "00:00:00", Timestamp.timestampToSecondsString(streams[j].duration), streams[j].reduceLength));					
						totalDuration += Timestamp.timestampToSeconds(streams[j].duration);
					}
				}
//			}
			doLog("Total (Final) stream duration is  " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);
			doLogAndTrace("*** SEGMENT SEQUENCE BUILT - sequence follows:", _sequence, DebugObject.DEBUG_SEGMENT_FORMATION);
			return totalDuration;
		}
				
		public function markPaused(timeInSeconds:int):void {
			_lastPauseTime = timeInSeconds;
		}
		
		public function get lastPauseTime():int {
			return _lastPauseTime;
		}
		
		public function resetPauseMarker():void {
			_lastPauseTime = -1;
		}
		
		public function play(netStream:NetStream, clip:Clip, metricNonLinear:Boolean=true, metricCompanion:Boolean=true):int {
			doLog("Loading up the stream - sequence length = " + _sequence.length + " segments", DebugObject.DEBUG_SEGMENT_FORMATION);
			var reset:int = 1;
			var totalDuration:int = 0;
			var additionalDuration:int = 0;
			for(var i:int = 0; i < _sequence.length; i++) {
				_sequence[i].setCuepoints(clip, i, totalDuration, metricNonLinear, metricCompanion);
				additionalDuration = _sequence[i].schedulePlay(netStream, reset, _bitrate);
				totalDuration += additionalDuration;
				if(additionalDuration > 0) {
 					reset = 0;					
 				}
			}
			doLog("Returning TOTAL DURATION of " + totalDuration, DebugObject.DEBUG_SEGMENT_FORMATION);
			return totalDuration;	
		}
		
		public function setCuepoints(clip:Clip):void {
			var totalDuration:int = 0;
			for(var i:int = 0; i < _sequence.length; i++) {
				_sequence[i].setCuepoints(clip, i, ((totalDuration == 0) ? 1 : totalDuration));
				totalDuration += _sequence[i].getDurationAsInt();
			}			
		}
		
		public function processCuepoint(index:int, code:String, player:Flowplayer, controller:VASTDisplayController):Object { 
    		return _sequence[index].processCuepoint(code, player, controller);
		}

        public function findSegmentRunningAtTime(time:Number):StreamSegment {
        	var timeSpent:int = 0;
			for(var i:int = 0; i < _sequence.length; i++) {
				timeSpent += _sequence[i].getDurationAsInt();
				if(timeSpent > time) {
					return _sequence[i];
				}
			}
			return null; 	
        }
        
        public function processPauseEvent(time:Number, event:ClipEvent):void {
        	var segment:StreamSegment = findSegmentRunningAtTime(time);
        	if(segment != null) {
        		segment.processPauseEvent();	
        	}
        }
		
        public function processResumeEvent(time:Number, event:ClipEvent):void {
        	var segment:StreamSegment = findSegmentRunningAtTime(time);
        	if(segment != null) {
        		segment.processResumeEvent();
        	}
        }

        public function processStopEvent(time:Number, event:ClipEvent):void {
        	var segment:StreamSegment = findSegmentRunningAtTime(time);
        	if(segment != null) {
        		segment.processStopEvent();
        	}
        }

        public function processFullScreenEvent(time:Number):void {
        	var segment:StreamSegment = findSegmentRunningAtTime(time);
        	if(segment != null) {
        		segment.processFullScreenEvent();
        	}
        }

        public function processMuteEvent(time:Number):void {
        	var segment:StreamSegment = findSegmentRunningAtTime(time);
        	if(segment != null) {
        		segment.processMuteEvent();
        	}
        }
	}
}