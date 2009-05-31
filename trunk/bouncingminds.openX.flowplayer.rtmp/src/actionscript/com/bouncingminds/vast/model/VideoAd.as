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
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.util.NetworkResource;
	import com.bouncingminds.util.Timestamp;
	import com.bouncingminds.vast.display.VASTDisplayEvent;
	
	/**
	 * @author Paul Schulz
	 */
	public class VideoAd extends DebugObject {
		protected var _id:String;
		protected var _adSystem:String;
		protected var _adTitle:String;
		protected var _description:String;
		protected var _survey:String;
		protected var _error:String;
		protected var _impressions:Array = new Array();			
		protected var _trackingEvents:Array = new Array();		
		protected var _linearVideoAd:LinearVideoAd = null;
		protected var _nonLinearVideoAds:Array  = new Array();
		protected var _companionAds:Array  = new Array();

		public function VideoAd() {
		}
		
		public function set id(id:String):void {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set adSystem(adSystem:String):void {
			_adSystem = adSystem;
		}
		
		public function get adSystem():String {
			return _adSystem;
		}
		
		public function get duration():int {
			if(_linearVideoAd != null) {
				return Timestamp.timestampToSeconds(_linearVideoAd.duration);
			}
			else return 0;
		}
		
		public function set adTitle(adTitle:String):void {
			_adTitle = adTitle;
		}
		
		public function get adTitle():String {
			return _adTitle;
		}
		
		public function set description(description:String):void {
			_description = description;
		}
		
		public function get description():String {
			return _description;
		}
		
		public function set survey(survey:String):void {
			_survey = survey;
		}
		
		public function get survey():String {
			return _survey;
		}
		
		public function set error(error:String):void {
			_error = error;
		}
		
		public function get error():String {
			return _error;
		}
		
		public function set impressions(impressions:Array):void {
			_impressions = impressions;
		}
		
		public function get impressions():Array {
			return _impressions;
		}
		
		public function addImpression(impression:NetworkResource):void {
			_impressions.push(impression);
		}
		
		public function set trackingEvents(trackingEvents:Array):void {
			_trackingEvents = trackingEvents;
		}
		
		public function get trackingEvents():Array {
			return _trackingEvents;
		}
		
		public function addTrackingEvent(trackEvent:TrackingEvent):void {
			_trackingEvents.push(trackEvent);
		}
		
		public function set linearVideoAd(linearVideoAd:LinearVideoAd):void {
			linearVideoAd.parentAdContainer = this;
			_linearVideoAd = linearVideoAd;
		}
		
		public function get linearVideoAd():LinearVideoAd {
			return _linearVideoAd;
		}
		
		public function set nonLinearVideoAds(nonLinearVideoAds:Array):void {
			_nonLinearVideoAds = nonLinearVideoAds;
		}
		
		public function get nonLinearVideoAds():Array {
			return _nonLinearVideoAds;
		}
		
		public function addNonLinearVideoAd(nonLinearVideoAd:NonLinearVideoAd):void {
			nonLinearVideoAd.parentAdContainer = this;
			_nonLinearVideoAds.push(nonLinearVideoAd);
		}
		
		public function hasNonLinearAds():Boolean {
			return (_nonLinearVideoAds.length > 0);
		}
		
		public function hasLinearAd():Boolean {
			return (_linearVideoAd != null);
		}
		
		public function set companionAds(companionAds:Array):void {
			_companionAds = companionAds;
		}
		
		public function get companionAds():Array {
			return _companionAds;
		}
		
		public function addCompanionAd(companionAd:CompanionAd):void {
			_companionAds.push(companionAd);
		}
		
		public function hasCompanionAds():Boolean {
			return (_companionAds.length > 0);
		}

		public function isLinear():Boolean {
			return (_linearVideoAd != null);	
		}
		
		public function isNonLinear():Boolean {
			return (_linearVideoAd == null && (_nonLinearVideoAds.length > 0));	
		}
		
		public function getStreamToPlay(deliveryType:String, mimeType:String, bitrate:String=null):NetworkResource {
			if(isLinear()) {
				return _linearVideoAd.getStreamToPlay(deliveryType, mimeType, bitrate);
			}
			else return null;
		}
		
		protected function triggerTrackingEvent(eventType:String):void {
			for(var i:int = 0; i < _trackingEvents.length; i++) {
				var trackingEvent:TrackingEvent = _trackingEvents[i];
				if(trackingEvent.eventType == eventType) {
					trackingEvent.execute();
				}				
			}
		}
		
		protected function triggerImpressionConfirmations():void {
			for(var i:int = 0; i < _impressions.length; i++) {
				var impression:NetworkResource = _impressions[i];
				impression.call();
			}	
		}
		
		public function processStartAdEvent():void {
			// call the impression tracking urls
			triggerImpressionConfirmations();
			
			// now call the start click tracking urls
			triggerTrackingEvent(TrackingEvent.EVENT_START);
		}

		public function processStopAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_STOP);
		}
		
		public function processPauseAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_PAUSE);
		}

		public function processResumeAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_RESUME);
		}

		public function processFullScreenAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_FULLSCREEN);
		}

		public function processMuteAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_MUTE);
		}

		public function processReplayAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_REPLAY);
		}

		public function processHitMidpointAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_MIDPOINT);
		}

		public function processFirstQuartileCompleteAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_1STQUARTILE);
		}

		public function processThirdQuartileCompleteAdEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_3RDQUARTILE);
		}

		public function processAdCompleteEvent():void {
			triggerTrackingEvent(TrackingEvent.EVENT_COMPLETE);
		}
		
		public function processStartNonLinearOverlayAdEvent(event:VASTDisplayEvent):void {
			processStartAdEvent();
			var matched:Boolean = false;
			for(var i:int = 0; i < _nonLinearVideoAds.length; i++) {
				if(_nonLinearVideoAds[i].matchesSize(event.width, event.height)) {
					matched = true;
					_nonLinearVideoAds[i].start(event);
				}
			}
			if(!matched) doLog("No matching size found for Ad " + id + " - size required is (" + event.width + "," + event.height + ")", DebugObject.DEBUG_CUEPOINT_EVENTS);
		}
		
		public function processStopNonLinearOverlayAdEvent(event:VASTDisplayEvent):void { 
			processAdCompleteEvent();
			for(var i:int = 0; i < _nonLinearVideoAds.length; i++) {
				if(event.width > -1 && event.height > -1) {
					if(_nonLinearVideoAds[i].matchesSize(event.width, event.height)) {
						_nonLinearVideoAds[i].stop(event); 
					}					
				}
				else _nonLinearVideoAds[i].stop(event);
			}
		}
		
		public function processStartCompanionAdEvent(displayEvent:VASTDisplayEvent):void {
			if(displayEvent.controller.displayingCompanions()) {
				processStartAdEvent();
				for(var i:int = 0; i < _companionAds.length; i++) {
					_companionAds[i].start(displayEvent); 
				}
			}
			else doLog("Ignoring request to start a companion - no companions are configured on this page", DebugObject.DEBUG_CUEPOINT_EVENTS);
		}
		
		public function processStopCompanionAdEvent(displayEvent:VASTDisplayEvent):void {
			if(displayEvent.controller.displayingCompanions()) {
				processStopAdEvent();
				for(var i:int = 0; i < _companionAds.length; i++) {
					_companionAds[i].stop(displayEvent);
				}
			}
			else doLog("Ignoring request to stop a companion - no companions are configured on this page", DebugObject.DEBUG_CUEPOINT_EVENTS);
		}
	}
}