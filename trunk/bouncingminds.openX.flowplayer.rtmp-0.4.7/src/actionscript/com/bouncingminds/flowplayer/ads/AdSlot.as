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
package com.bouncingminds.flowplayer.ads {
	import com.bouncingminds.flowplayer.regions.Regions;
	import com.bouncingminds.flowplayer.streamer.OpenXConfig;
	import com.bouncingminds.flowplayer.streamer.OpenXDisplayController;
	import com.bouncingminds.flowplayer.streamer.StreamSegment;
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.util.NetworkResource;
	import com.bouncingminds.vast.display.VASTDisplayController;
	import com.bouncingminds.vast.display.VASTDisplayEvent;
	import com.bouncingminds.vast.model.VideoAd;
	
	import flash.net.NetStream;
	
	import org.flowplayer.controls.Controls;
	import org.flowplayer.model.Clip;
	import org.flowplayer.model.DisplayPluginModel;
	import org.flowplayer.model.DisplayProperties;
	import org.flowplayer.view.Flowplayer;
	
	/**
	 * @author Paul Schulz
	 */
	public class AdSlot extends StreamSegment {
		protected var _key:int;
		protected var _id:String=null;
		protected var _zone:String;
		protected var _position:String;
		protected var _videoAd:VideoAd = null;
		protected var _notice:Object = { show: false };
		protected var _disableControls:Boolean = false;
		protected var _companionDivIDs:Array = new Array({ id:'companion', width:300, height:250 });
		protected var _defaultLinearRegions:Array = new Array({ id: 'bottom', width: 300, height: 50 });
		protected var _regionPluginHandle:Regions;
		protected var _applyToParts:Object = null;
		protected var _width:int;
		protected var _height:int;
		protected var _associatedStreamIndex:int = 0;
		protected var _associatedStreamStartTime:int = 0;
		protected var _vastDisplayController:OpenXDisplayController = null;
		protected var _regionsPluginName:String = "openXRegions";
		protected var _originalAdSlot:AdSlot = null;
		protected var _pauseOnClick:Boolean = false;
		
		public static const SLOT_POSITION_PRE_ROLL:String = "pre-roll";
		public static const SLOT_POSITION_MID_ROLL:String = "mid-roll";
		public static const SLOT_POSITION_POST_ROLL:String = "post-roll";
		public static const SLOT_POSITION_POPUP:String = "popup";
		
		private const EVENT_DELAY:int = 500;
				
		public function AdSlot(vastDisplayController:OpenXDisplayController, key:int=0, associatedStreamIndex:int=0, id:String=null, zone:String=null, position:String=null, applyToParts:Object=null, duration:String=null, startTime:String="00:00:00", notice:Object=null, disableControls:Boolean=true, width:int=-1, height:int=-1, defaultLinearRegions:Array=null, companionDivIDs:Array=null, regionsPluginName:String=null, streamType:String="mp4", pauseOnClick:Boolean=true) {
			super(null, startTime, duration, false, streamType);
			_vastDisplayController = vastDisplayController;
			_key = key;
			_associatedStreamIndex = associatedStreamIndex;
			_id = id;
			_zone = zone;
			_position = position;
			_applyToParts = applyToParts;
			if(notice != null) _notice = notice;
			_disableControls = disableControls;
			_width = width;
			_height = height;
			if(defaultLinearRegions != null) _defaultLinearRegions = defaultLinearRegions;
			if(companionDivIDs != null) _companionDivIDs = companionDivIDs;
			if(regionsPluginName != null) _regionsPluginName = regionsPluginName;
			_pauseOnClick = pauseOnClick;
		}
		
		public function set key(key:int):void {
			_key = key;
		}
		
		public function get key():int {
			return _key;
		}
		
		public function set id(id:String):void {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
		
		public override function get streamID():String {
			return _id;
		}

		public function set zone(zone:String):void {
			_zone = zone;
		}
		
		public function get zone():String {
			return _zone;
		}
		
		public function set position(position:String):void {
			_position = position;
		}
		
		public function get position():String {
			return _position;
		}
		
		public function set pauseOnClick(pauseOnClick:Boolean):void {
			_pauseOnClick = pauseOnClick;
		}
		
		public function get pauseOnClick():Boolean {
			return _pauseOnClick;
		}
		
		public override function get duration():String {
			if(_videoAd != null) {
				if(_duration == null) {
					return new String(_videoAd.duration);
				}
			}
			return super.duration;
		}
		
		public function set width(width:int):void {
			_width = width;
		}
		
		public function get width():int {
			return _width;
		}
		
		public function set associatedStreamIndex(associatedStreamIndex:int):void {
			_associatedStreamIndex = associatedStreamIndex;
		}
		
		public function get associatedStreamIndex():int {
			return _associatedStreamIndex;
		}
		
		public function set applyToParts(applyToParts:Object):void {
			_applyToParts = applyToParts;
		}
		
		public function get applyToParts():Object {
			return _applyToParts;
		}

		public function set associatedStreamStartTime(associatedStreamStartTime:int):void {
			_associatedStreamStartTime = associatedStreamStartTime;
		}
		
		public function get associatedStreamStartTime():int {
			return _associatedStreamStartTime;
		}
		
		public function isPreRoll():Boolean {
			return (_position == SLOT_POSITION_PRE_ROLL);
		}
		
		public function isMidRoll():Boolean {
			return (_position == SLOT_POSITION_MID_ROLL);
		}
		
		public function isPostRoll():Boolean {
			return (_position == SLOT_POSITION_POST_ROLL);
		}
		
		public function isPopUp():Boolean {
			return (_position == SLOT_POSITION_POPUP);
		}
		
		public function isActive():Boolean {
			return (_videoAd != null);
		}
		
		public function hasNonLinearAds():Boolean {
			if(_videoAd != null) {
				return _videoAd.hasNonLinearAds();
			}
			else return false;			
		}
		
		public function hasCompanionAds():Boolean {
			if(_videoAd != null) {
				return _videoAd.hasCompanionAds();
			}
			else return false;
		}
		
		public function set videoAd(videoAd:VideoAd):void {
			_videoAd = videoAd;
		}
		
		public function get videoAd():VideoAd {
			return _videoAd;
		}
		
		public function hasVideoAd():Boolean {
			return (_videoAd != null);
		}
		
		public function isLinear():Boolean {
			if(_videoAd != null) {
				return (isPreRoll() || isPostRoll() || isMidRoll() || isPopUp()) && _videoAd.isLinear();
			}
			else return false;
		}
		
		public function isNonLinear():Boolean {
			if(_videoAd != null) {
				return (!isPreRoll() && !isPostRoll() && !isMidRoll()) && _videoAd != null && _videoAd.hasNonLinearAds();
			}
			else return false;
		}
		
		public function set disableControl(disableControls:Boolean):void {
			_disableControls = disableControls;
		}
		
		public function get disableControls():Boolean {
			return _disableControls;
		}

		protected function setScrubber(player:Flowplayer, turnOn:Boolean):void {
			var controlProps:DisplayProperties = player.pluginRegistry.getPlugin("controls") as DisplayProperties;
			var controls:Controls = controlProps.getDisplayObject() as Controls;

			if(turnOn) {
				controls.enable({all: true, scrubber: true});		
			}	
			else {
				controls.enable({all: true, scrubber: false});		
			}
		}
		
		override public function schedulePlay(netStream:NetStream, reset:int=0, bitrate:String=null):int {
			var streamURL:NetworkResource = getStreamToPlay(VAST_DELIVERY_TYPE_STREAMING, mimeType, bitrate);
			if(streamURL != null) {
				var streamName:String = cleanseStreamName(streamURL.getFilename(streamType + ":"));
				if(reset == 1) {
					doLog("Loading Ad stream " + streamName + " with reset=1 starting at 0 running for entire duration: " + getDurationAsInt() + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION);
					netStream.play(streamName);
				}
				else {
					doLog("Loading Ad stream " + streamName + " (reset=" + reset + ") to start at " + streamStartTime + " seconds in, running for " + getDurationAsInt() + " seconds", DebugObject.DEBUG_SEGMENT_FORMATION); 						
					netStream.play(streamName, streamStartTime, getDurationAsInt(), reset); 
				}
				return getDurationAsInt();
			}
			else {
				doLog("Did not schedule Ad " + id + " to play as a media file could not be found in the VAST template", DebugObject.DEBUG_SEGMENT_FORMATION);
				return 0;
			}
		}

		override public function getStreamToPlay(deliveryType:String=VAST_DELIVERY_TYPE_STREAMING, mimeType:String=VAST_MIME_TYPE_MP4, bitrate:String=null):NetworkResource {
			if(_videoAd != null) {
				return _videoAd.getStreamToPlay(deliveryType, mimeType, bitrate);	
			}
			else return null;
		}
				
		public override function setCuepoints(clip:Clip, i:int, currentTimeInSeconds:int, includeNonLinear:Boolean=true, includeCompanion:Boolean=true):void {
			if(_cuepointsSet == false) {
				var streamDuration:int = getDurationAsInt();
				var startTime:int = currentTimeInSeconds + streamStartTime;
				var midpointMilliseconds:int = Math.round(((startTime * 1000) + ((streamDuration * 1000) / 2)) / 100) * 100;
				var endFirstQuartileMilliseconds:int = Math.round(((startTime * 1000) + ((streamDuration * 1000) / 4)) / 100) * 100; 
				var endThirdQuartileMilliseconds:int = Math.round(((startTime * 1000) + (((streamDuration * 1000) / 4) * 3)) / 100) * 100;
				if(startTime == 0) {
					// never fire the event at 0 time because flowplayer seems to drop the event for some reason
					setCuepoint(clip, 1000, "BA:"+i);
				}
				else setCuepoint(clip, (startTime * 1000) + EVENT_DELAY, "BA:"+i);
				setCuepoint(clip, endFirstQuartileMilliseconds, "1Q:"+i);
				setCuepoint(clip, midpointMilliseconds, "HW:" + i);
				setCuepoint(clip, endThirdQuartileMilliseconds, "3Q:"+i);
				if(noticeToBeShown()) {
					setCuepoint(clip, ((startTime + streamDuration) * 1000) - EVENT_DELAY, "HN:"+i);
				}
				setCuepoint(clip, ((startTime + streamDuration) * 1000) - EVENT_DELAY, "EA:"+i);
							
				if(hasNonLinearAds() && includeNonLinear) {
					addNonLinearAdCuepoints(key, clip, currentTimeInSeconds, false);
				}
				if(hasCompanionAds() && includeCompanion) {
					addCompanionAdCuepoints(key, clip, currentTimeInSeconds);
				}			
				markCuepointsAsSet();
			}
			else doLog("No setting Ad cuepoints - already set once", DebugObject.DEBUG_CUEPOINT_FORMATION);
		}

		protected function addCompanionAdCuepoints(adSlotIndex:int, clip:Clip, currentTimeInSeconds:int):void {
			doTrace(this, DebugObject.DEBUG_CUEPOINT_FORMATION);
			var startPoint:int = currentTimeInSeconds + streamStartTime;
			var duration:int = getDurationAsInt();
			setCuepoint(clip, (startPoint * 1000) + EVENT_DELAY, "CS:" + adSlotIndex); 

			if(duration > 0) {
				setCuepoint(clip, ((startPoint + duration) * 1000) - EVENT_DELAY, "CE:" + adSlotIndex);
				doLog("Cuepoint set at " + startPoint + " seconds and run for " + duration + " seconds for companion ad with Ad id " + id, DebugObject.DEBUG_CUEPOINT_FORMATION);				
			}
			else doLog("Cuepoint set at " + startPoint + " seconds running indefinitely - Companion Ad id " + id, DebugObject.DEBUG_CUEPOINT_FORMATION);			
		}
		
		public function addNonLinearAdCuepoints(adSlotIndex:int, clip:Clip, currentTimeInSeconds:int, checkCompanionAds:Boolean=false):void {
			doTrace(this, DebugObject.DEBUG_CUEPOINT_FORMATION);
			var startPoint:int = associatedStreamStartTime + getStartTimeAsSeconds();
			var duration:int = getDurationAsInt();
			setCuepoint(clip, startPoint * 1000, "NS:" + adSlotIndex);

			if(duration > 0) {
				setCuepoint(clip, (startPoint + duration) * 1000, "NE:" + adSlotIndex);
				doLog("Cuepoint set at " + startPoint + " seconds and run for " + duration + " seconds for non-linear ad with Ad id " + id, DebugObject.DEBUG_CUEPOINT_FORMATION);				
			}
			else doLog("Cuepoint set at " + startPoint + " seconds running indefinitely - non-linear Ad id " + id, DebugObject.DEBUG_CUEPOINT_FORMATION);

			if(checkCompanionAds && hasCompanionAds()) {
				addCompanionAdCuepoints(adSlotIndex, clip, currentTimeInSeconds);
			}
		}
		
		protected function actionStartAdStream(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				if(noticeToBeShown()) {
					showAdNotice(player);
				}
				if(disableControls) {
					setScrubber(player, false);
				}
				_videoAd.processStartAdEvent();
			}
			else doLog("cuepoint at start of stream " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
		}

		protected function actionAdStreamComplete(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				if(disableControls) {
					setScrubber(player, true);
				}
				_videoAd.processAdCompleteEvent();
			}
			else doLog("cuepoint at end of stream " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
		}
		
	 	protected function actionStopStream(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				_videoAd.processStopAdEvent();
			}
			else doLog("cuepoint for stop stream " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}
	 	
	 	protected function actionPauseStream(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				_videoAd.processPauseAdEvent();				
			}
			else doLog("cuepoint for pause stream " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}
	 	
	 	protected function actionResumeStream(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				_videoAd.processResumeAdEvent();
			}
			else doLog("cuepoint for resume stream " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}
	 	
	 	protected function actionAdMidpointComplete(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				_videoAd.processHitMidpointAdEvent();
			}
			else doLog("cuepoint for midpoint stream " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}
	 	
	 	protected function actionAdFirstQuartileComplete(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				_videoAd.processFirstQuartileCompleteAdEvent();
			}
			else doLog("cuepoint for first quartile " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}
	 	
	 	protected function actionAdThirdQuartileComplete(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				_videoAd.processThirdQuartileCompleteAdEvent();
			}
			else doLog("cuepoint for third quartile " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}

	 	protected function actionMute(player:Flowplayer=null, config:OpenXConfig=null):void {
			if(_videoAd != null) {
				_videoAd.processMuteAdEvent();
			}
			else doLog("cuepoint for mute " + streamID + " ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}

		protected function createDisplayEvent(controller:VASTDisplayController):VASTDisplayEvent {
		 	var displayEvent:VASTDisplayEvent = new VASTDisplayEvent(controller, _width, _height);
		 	displayEvent.customData.adSlotPosition = _position;
		 	displayEvent.customData.adSlotKey = _key;
		 	displayEvent.customData.adSlotAssociatedStreamIndex = associatedStreamIndex;
			return displayEvent;
		}
			 	
	 	protected function actionNonLinearAdOverlayStart(controller:VASTDisplayController):void {
	 		if(this.isLinear()) {
//	 			if(_videoAd != null) {
//		 			doLog("cuepoint for non-linear overlay start being processed - this is part of a linear ad slot", DebugObject.DEBUG_CUEPOINT_EVENTS);
//	 				_videoAd.processStartNonLinearOverlayAdEventForLinearAd(getOverlayPluginHandle(player), _defaultLinearOverlays);
//	 			}
	 			doLog("cuepoint for non-linear overlay start ignored on Linear Ad - not implemented", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 		}
	 		else {
		 		if(_videoAd != null) {
		 			doLog("cuepoint for non-linear overlay start being processed - this is for a stand alone ad slot", DebugObject.DEBUG_CUEPOINT_EVENTS);
		 			_videoAd.processStartNonLinearOverlayAdEvent(createDisplayEvent(controller)); // _position,
	 			}
	 			else doLog("cuepoint for non-linear overlay start ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 		}
	 	}

	 	protected function actionNonLinearAdOverlayEnd(controller:VASTDisplayController):void {
	 		if(this.isLinear()) {
//	 			if(_videoAd != null) { 			
//	 				doLog("cuepoint for non-linear overlay stop being processed - this is part of a linear ad slot", DebugObject.DEBUG_CUEPOINT_EVENTS);
//	 				_videoAd.processStopNonLinearOverlayAdEventForLinearAd(getOverlayPluginHandle(player), _defaultLinearOverlays);
//	 			}
	 			doLog("cuepoint for non-linear overlay stop on Linear Ad ignored - not implemented", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 		}
	 		else {
		 		if(_videoAd != null) {
		 			doLog("cuepoint for non-linear overlay stop being processed - this is for a stand alone ad slot", DebugObject.DEBUG_CUEPOINT_EVENTS);
			 		_videoAd.processStopNonLinearOverlayAdEvent(createDisplayEvent(controller)); //_position,
	 			}
	 			else doLog("cuepoint for non-linear overlay end ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 		}
	 	}
	 	
 	 	protected function actionCompanionAdStart(controller:VASTDisplayController):void {
	 		if(_videoAd != null) {
		 		var displayEvent:VASTDisplayEvent = new VASTDisplayEvent(controller, _width, _height);
	 			_videoAd.processStartCompanionAdEvent(displayEvent); //_companionDivIDs, _key
	 		}
	 		else doLog("cuepoint for companion ad end ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}

	 	protected function actionCompanionAdEnd(controller:VASTDisplayController):void { //player:Flowplayer=null
	 		if(_videoAd != null) {
		 		var displayEvent:VASTDisplayEvent = new VASTDisplayEvent(controller, _width, _height);
	 			_videoAd.processStopCompanionAdEvent(displayEvent); //_companionDivIDs
	 		}
	 		else doLog("cuepoint for companion ad end ignored", DebugObject.DEBUG_CUEPOINT_EVENTS);
	 	}
	 	
		private function noticeToBeShown():Boolean {
			if(_notice != null) {
				if(_notice.show) {
					return _notice.show;
				}		
			}
			return false;
		}
		
		override public function processPauseEvent():void {
			doLog("AdSlot " + id + " paused", DebugObject.DEBUG_PLAY_EVENTS);
		 	if(_videoAd != null) {
		 		_videoAd.processPauseAdEvent();
		 	}
		}

		override public function processResumeEvent():void {
			doLog("AdSlot " + id + " resumed", DebugObject.DEBUG_PLAY_EVENTS);
		 	if(_videoAd != null) {
		 		_videoAd.processResumeAdEvent();
		 	}
		}

		override public function processStopEvent():void {
			doLog("AdSlot " + id + " stopped", DebugObject.DEBUG_PLAY_EVENTS);
		 	if(_videoAd != null) {
		 		_videoAd.processStopAdEvent();
		 	}
		}

        override public function processFullScreenEvent():void {	
			doLog("AdSlot " + id + " full screen event", DebugObject.DEBUG_PLAY_EVENTS);        
		 	if(_videoAd != null) {
		 		_videoAd.processFullScreenAdEvent();
		 	}
        }

        override public function processMuteEvent():void {	
			doLog("AdSlot " + id + " mute event", DebugObject.DEBUG_PLAY_EVENTS);        
		 	if(_videoAd != null) {
		 		_videoAd.processMuteAdEvent();
		 	}
        }

	 	protected function showAdNotice(player:Flowplayer):void {
	 		if(noticeToBeShown()) {
	 			if(_notice.region) {
	 				if(_notice.message) {
						var thePattern:RegExp = /_seconds_/g;
						var text:String = _notice.message.replace(thePattern, ((_videoAd) ? _videoAd.duration : 0));
						getRegionsPluginHandle(player).setHtmlForRegion(_notice.region, text);
						getRegionsPluginHandle(player).setVisibility(_notice.region, true);				
	 				}
	 			}
	 		}
	 	}
	 	
	 	protected function hideAdNotice(player:Flowplayer):void {
	 		if(_notice) {
	 			if(_notice.region) {
					getRegionsPluginHandle(player).setVisibility(_notice.region, false);
	 			}
	 		}
	 	}
	 	
	 	private function getRegionsPluginHandle(player:Flowplayer):Regions {
	 		if(_regionPluginHandle == null) {		 
				var plugin:DisplayPluginModel = player.pluginRegistry.getPlugin(_regionsPluginName) as DisplayPluginModel;
				_regionPluginHandle = Regions(plugin.getDisplayObject());
	 		}
			return _regionPluginHandle;
	 	}
	 	
	 	protected override function getDebugInfo(cuepointEventType:String, description:String):Object {
	 		var info:Object = new Object();
	 		info.type = cuepointEventType;
	 		info.description = description;
	 		info.segmentType = "Ad";
	 		info.adType = ((isLinear()) ? "Linear Video Ad" : "Non Linear Video Ad");
	 		info.id = ((_id == null) ? "Not specified" : _id);
	 		info.dimension = "(" + _width + "," + _height + ")";
	 		info.startTime = _startTime;
	 		info.duration = "" + _duration + " seconds";
	 		info.displayNotice = noticeToBeShown();
	 		if(_videoAd) {
		 		info.hasNonLinearAd = _videoAd.hasNonLinearAds();
		 		info.hasCompanionAd = _videoAd.hasCompanionAds();
	 			info.cuepoint = cuepointEventType;	
	 		}
	 		return info;
	 	}
	 	
	 	public override function processCuepoint(cuepointEventType:String, player:Flowplayer, adDisplayController:OpenXDisplayController, config:OpenXConfig=null):Object {
	 		doLog("AdSlot: " + id + " received request to process cuepoint of type " + cuepointEventType, DebugObject.DEBUG_CUEPOINT_EVENTS);
	 		var description:String = "";
	 		switch(cuepointEventType) {
	 			case "BA": // start of the Ad stream
	 				description = "Begin linear video advertisement event";
	 				actionStartAdStream(player, config);
	 				break;
	 			case "EA": // end of the Ad stream
	 				description = "End linear video advertisement event";
	 				actionAdStreamComplete(player, config);
	 				break;
	 			case "SS": // stop stream
	 				description = "Stop stream event";
	 				actionStopStream(player, config);
	 				break;
	 			case "PS": // pause stream
	 				description = "Pause stream event";
	 				actionPauseStream(player, config);
	 				break;
	 			case "RS": // resume stream
	 				description = "Resume stream event";
	 				actionResumeStream(player, config);
	 				break;
	 			case "HW": // halfway midpoint
	 				description = "Halfway point tracking event";
	 				actionAdMidpointComplete(player, config);
	 				break;
	 			case "1Q": // end of first quartile
	 				description = "1st quartile tracking event";
	 				actionAdFirstQuartileComplete(player, config);
	 				break;
	 			case "3Q": // end of third quartile
	 				description = "3rd quartile tracking event";
	 				actionAdThirdQuartileComplete(player, config);
	 				break;
	 			case "HN": // hide the ad notice
	 				description = "Hide ad notice event";
	 				hideAdNotice(player);
	 				break;
	 			case "NS": // a trigger to start a non-linear overlay
	 				description = "Start non-linear ad event";
	 				actionNonLinearAdOverlayStart(adDisplayController);
	 				break;
	 			case "NE": // a trigger to stop a non-linear overlay
	 				description = "End non-linear ad event";
	 				actionNonLinearAdOverlayEnd(adDisplayController);
	 				break;
	 			case "CS": // start a companion ad
	 				description = "Companion start event";
	 				actionCompanionAdStart(adDisplayController);
	 				break;
	 			case "CE": // stop a companion ad
	 				description = "Companion end event";
	 				actionCompanionAdEnd(adDisplayController);
	 				break;
	 		}
	 		
	 		return getDebugInfo(cuepointEventType, description);
	 	}
	 	
		public function markAsCopy(originalAdSlot:AdSlot):void {
			_originalAdSlot = originalAdSlot;
		}
	
		public function isCopy():Boolean {
			return (_originalAdSlot != null);
		}
	
		public function clone(instanceNumber:int=0):AdSlot {
			var clonedAdSlot:AdSlot = new AdSlot(
		                         			_vastDisplayController, 
		                         			_key, 
		                         			_associatedStreamIndex, 
		                         			_id + '-c', 
		                         			_zone, 
		                         			_position, 
		                         			_applyToParts, 
		                         			_duration, 
		                         			_startTime, 
		                         			_notice, 
		                         			_disableControls, 
		                         			_width, 
		                         			_height, 
		                         			_defaultLinearRegions, 
		                         			_companionDivIDs, 
		                         			_regionsPluginName
		                      		  );
		    clonedAdSlot.markAsCopy(this);
		    return clonedAdSlot;
		}
	}	
}
