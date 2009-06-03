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
	import com.bouncingminds.flowplayer.streamer.OpenXConfig;
	import com.bouncingminds.flowplayer.streamer.OpenXDisplayController;
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.vast.model.VideoAdServingTemplate;
	
	import org.flowplayer.model.Clip;
	import org.flowplayer.view.Flowplayer;	
	
	/**
	 * @author Paul Schulz
	 */
	public class AdSequence extends DebugObject {
		private var _adSlots:Array = new Array(); 
		
		public function AdSequence(vastDisplayController:OpenXDisplayController=null, config:OpenXConfig=null, vastData:VideoAdServingTemplate=null) {
			if(config != null) {
				build(vastDisplayController, config, -1, config.streams.length, true);
				if(vastData) mapVASTDataToAdSlots(vastData);
			}
		}
		
		public function get adSlots():Array {
			return _adSlots;
		}
		
		public function set adSlots(adSlots:Array):void {
			_adSlots = adSlots;
		}
		
		public function addAdSlot(adSlot:AdSlot):void {
			_adSlots.push(adSlot);
		}
		
		public function hasAdSlots():Boolean {
			return (_adSlots && _adSlots.length > 0);
		}
		
		public function haveAdSlotsToSchedule():Boolean {
			return (_adSlots.length > 0);
		}
		
		public function hasLinearAds():Boolean {
			if(haveAdSlotsToSchedule()) {
				for(var i:int = 0; i < _adSlots.length; i++) {
					if(_adSlots[i].isLinear()) {
						return true;
					}
				}
			}	
			return false;	
		}

		public function hasSlot(index:int):Boolean {
			return (index < length);	
		}
		
		public function getSlot(index:int):AdSlot {
			if(hasSlot(index)) {
				return _adSlots[index];
			}
			return null; 
		}
		
		public function setAdSlotIDAtIndex(index:int, id:String):void {
			if(hasAdSlots() && index < _adSlots.length) {
				_adSlots[index].id = id;
			}
		}
		
		public function get length():int {
			return _adSlots.length;
		}
		
		private function getNoticeConfig(defaultNoticeConfig:Object, overridingConfig:Object):Object {
			var result:Object = new Object();
			if(defaultNoticeConfig != null) {
				if(defaultNoticeConfig.show != undefined) result.show = defaultNoticeConfig.show;
				if(defaultNoticeConfig.region != undefined) result.region = defaultNoticeConfig.region;
				if(defaultNoticeConfig.message != undefined) result.message = defaultNoticeConfig.message;
			}
			if(overridingConfig != null) {
				if(overridingConfig.show != undefined) result.show = overridingConfig.show;
				if(overridingConfig.region != undefined) result.region = overridingConfig.region;
				if(overridingConfig.message != undefined) result.message = overridingConfig.message;
			}
			return result;
		}
		
		private function getDisableControls(defaultSetting:*, overridingSetting:*):Boolean {
			if(overridingSetting != undefined) {
				return overridingSetting;
			}
			else if(defaultSetting != undefined) {
				return defaultSetting;
			}
			return false;
		}
		
		private function checkApplicability(adSpot:Object, currentPart:int, excludePopupPosition:Boolean=false, streamCount:int=1):Boolean {
			if(adSpot.applyToParts != undefined) {
				if(adSpot.applyToParts is String) {
					if(adSpot.applyToParts.toUpperCase() == "LAST") {
						return ((currentPart + 1) == streamCount);
					}
					else return false;
				}
				else if(adSpot.applyToParts is Array) {
					return (adSpot.applyToParts.indexOf(currentPart) > -1);
				}
				else return false;
			}
			else return true; 
		}
		
		public function createAdSpotID(overridingID:String, position:String, uniqueTag:int):String {
			if(overridingID != null) {
				return overridingID;
			}	
			else return position + uniqueTag;
		}
		
		public function build(vastDisplayController:OpenXDisplayController, config:Object, maxSpots:int=-1, repeats:int=1, excludePopupPosition:Boolean=false):void {
			if(config.adSchedule) {
				if(repeats == 0) repeats = 1; // we need to ensure that we cover the ad spots if there are no streams
				for(var j:int = 0; j < repeats; j++) {
					if(maxSpots == -1) maxSpots = config.adSchedule.length;
					for(var i:int = 0; i < config.adSchedule.length && i <= maxSpots; i++) {
						if(checkApplicability(config.adSchedule[i], j, excludePopupPosition, repeats)) {
							var adSpot:Object = config.adSchedule[i];
							var originalAdSlot:AdSlot;
							if(adSpot.zone && adSpot.zone.toUpperCase() == "STATIC") {
								originalAdSlot = new StaticAdSlot(vastDisplayController,
														 _adSlots.length,
														 j,
														 createAdSpotID(adSpot.id, adSpot.position, i),
														 adSpot.zone,
													  	 adSpot.position,
													  	 ((adSpot.applyToParts == undefined) ? null : adSpot.applyToParts),
														 adSpot.duration, 
														 ((adSpot.startTime == undefined) ? "00:00:00" : adSpot.startTime),
														 getNoticeConfig(config.notice, adSpot.notice),
														 getDisableControls(config.disableControls, adSpot.disableControls),
														 adSpot.width,
														 adSpot.height,
														 config.defaultLinearRegions,	
														 ((adSpot.companionDivIDs == undefined) ? 
													 			config.companionDivIDs : 
										  					    adSpot.companionDivIDs),
											  	 		config.regionsPluginName,
											  	 		((adSpot.startPoint == undefined) ? null : adSpot.startPoint),
											  	 		((adSpot.html == undefined) ? null : adSpot.html));
							}
							else {
								originalAdSlot = new AdSlot(vastDisplayController,
													 _adSlots.length,
													 j,
												     createAdSpotID(adSpot.id, adSpot.position, i),
													 adSpot.zone,
												  	 adSpot.position,
												  	 ((adSpot.applyToParts == undefined) ? null : adSpot.applyToParts),
													 adSpot.duration, 
													 ((adSpot.startTime == undefined) ? "00:00:00" : adSpot.startTime),
													 getNoticeConfig(config.notice, adSpot.notice),
													 getDisableControls(config.disableControls, adSpot.disableControls),	
													 adSpot.width,
													 adSpot.height,
													 config.defaultLinearRegions,	
													 ((adSpot.companionDivIDs == undefined) ? 
												 			config.companionDivIDs : 
									  					    adSpot.companionDivIDs),
										  	 		 config.regionsPluginName,
										  	 		 config.adStreamType,
										  	 		 ((adSpot.pauseOnClick == undefined) ? false : adSpot.pauseOnClick));
							}
							var repeatCount:int = ((adSpot.repeat == undefined) ? 1 : adSpot.repeat);
							var adSlot:AdSlot = originalAdSlot;
							for(var r:int=0; r < repeatCount; r++) {
								addAdSlot(adSlot);
								adSlot = adSlot.clone();
								adSlot.key = _adSlots.length;
							}
//							adSpot.used = true;
						}
					}		
				}
			}
		}
		
		public function setCuepoints(clip:Clip):void {
			doTrace(_adSlots, DebugObject.DEBUG_CUEPOINT_FORMATION);
			if(hasAdSlots()) {
				for(var i:int; i < _adSlots.length; i++) {
					if(_adSlots[i].isNonLinear()) {
						_adSlots[i].addNonLinearAdCuepoints(i, clip, 0, true); 
					}
				}
			}
		}
		
		public function get zones():Array {
			var zones:Array = new Array();
			for(var i:int = 0; i < _adSlots.length; i++) {
				if(_adSlots[i].id && _adSlots[i].id != "popup") {
					var zone:Object = new Object();
					zone.id = _adSlots[i].id + "-" + _adSlots[i].associatedStreamIndex;
					zone.zone = _adSlots[i].zone;
					zones.push(zone);
				}
			}		
			return zones;	
		}
		
		public function mapVASTDataToAdSlots(vast:VideoAdServingTemplate):void {
			if(hasAdSlots()) {
				for(var i:int = 0; i < adSlots.length; i++) {
					if(_adSlots[i].id != null) { 
						_adSlots[i].videoAd = vast.getVideoAdWithID(_adSlots[i].id + "-" + _adSlots[i].associatedStreamIndex);
					}
				}
			}
		}
			
		public function mapVastDataForAdToAllAdSlots(vast:VideoAdServingTemplate, adId:String):void {
			if(hasAdSlots()) {
				for(var i:int = 0; i < _adSlots.length; i++) {
					_adSlots[i].videoAd = vast.getVideoAdWithID(adId);
				}
			}			
		}
		
		public function recordCompanionClickThrough(adSlotIndex:int, companionID:int):void {
			if(_adSlots.length < adSlotIndex) {
				_adSlots[adSlotIndex].registerCompanionClickThrough(companionID);
			}
		}
		
		public function processCuepoint(index:int, code:String, player:Flowplayer, controller:OpenXDisplayController):Object { 
    		return _adSlots[index].processCuepoint(code, player, controller);
		}
	}
}