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
	import com.bouncingminds.flowplayer.regions.Regions;
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.util.StringUtils;
	import com.bouncingminds.vast.display.VASTDisplayEvent;
	import com.bouncingminds.vast.model.VASTLoadListener;
	import com.bouncingminds.vast.model.NonLinearVideoAd;
	import com.bouncingminds.vast.model.VideoAdServingTemplate;
	import com.bouncingminds.vast.model.CompanionAd;
	import com.bouncingminds.vast.openx.OpenXVASTAdRequest;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.NetStream;
	
	import org.flowplayer.controller.ClipURLResolver;
	import org.flowplayer.controller.ConnectionProvider;
	import org.flowplayer.controller.NetStreamControllingStreamProvider;
	import org.flowplayer.model.Clip;
	import org.flowplayer.model.ClipEvent;
	import org.flowplayer.model.Cuepoint;
	import org.flowplayer.model.DisplayPluginModel;
	import org.flowplayer.model.PlayerEvent;
	import org.flowplayer.model.Plugin;
	import org.flowplayer.model.PluginEventType;
	import org.flowplayer.model.PluginModel;
	import org.flowplayer.util.PropertyBinder;
	import org.flowplayer.view.Flowplayer;
		
	/**
	 * @author Paul Schulz
	 */
	public class OpenXVastAdStreamProvider extends NetStreamControllingStreamProvider implements Plugin, VASTLoadListener, OpenXDisplayController {
		private var _player:Flowplayer;
		private var _openXConfig:OpenXConfig;
		private var _regionPluginHandle:Regions;
		private var _model:PluginModel;
		private var _bufferStart:Number = 0;
		private var _vastData:VideoAdServingTemplate;
		private var _streamSequence:StreamSequence;
		private var _popupStreamSequence:StreamSequence;
		private var _adSequence:AdSequence;
		private var _popupVideoAdNetStream:NetStream;
		private var _mainClipSetup:Boolean = false;
		private var _pendingPopupAdIndex:int=-1;
		private var _streamComplete:Boolean = false;
		private var _previousDivContent:Array = new Array();
				
		public function OpenXVastAdStreamProvider() {
			doLog("OpenXPlayer plug-in constructed - build " + DebugObject.BUILD_NUMBER, DebugObject.DEBUG_ALL);
		}
		
		override public function onConfig(model:PluginModel):void {
			_model = model;			
			_openXConfig = new PropertyBinder(new OpenXConfig(), null).copyProperties(model.config) as OpenXConfig;
			if(_openXConfig.debugLevelSpecified()) DebugObject.getInstance().setLevelFromString(_openXConfig.debugLevel);
			_adSequence = new AdSequence(this, _openXConfig);
			loadVideoAdServingTemplate();
			doTrace(_openXConfig, DebugObject.DEBUG_CONFIG);
		}

		override public function onLoad(player:Flowplayer):void {
			_player = player;
			if(_openXConfig.showPrePromo()) {
				_openXConfig.getPrePromotion().activate(player);
			}
			player.onFullscreen(processFullScreenEvent);
			player.onMute(processMuteEvent);
		}

		override protected function getDefaultClipURLResolver():ClipURLResolver {
			return new OpenXClipURLResolver(_openXConfig.netConnectionUrl);
		}

		override protected function getDefaultConnectionProvider():ConnectionProvider {
			if (_openXConfig.subscribe === true) {
				doLog("using FCSubscribe mechanism to connect to stream", DebugObject.DEBUG_SEGMENT_FORMATION);
				return new OpenXSubscribingConnectionProvider(_openXConfig);
			}
			else return new OpenXConnectionProvider(_openXConfig);
		}
		
		override public function get allowRandomSeek():Boolean {
			return true;
		}

        protected function processPauseEvent(event:ClipEvent):void {
        	if(_streamSequence != null) {
        		_streamSequence.processPauseEvent(time, event);
        	}
        }

        protected function processStopEvent(event:ClipEvent):void {	
        	if(_streamSequence != null) {
        		_streamSequence.processStopEvent(time, event);
        	}
        }

        protected function processResumeEvent(event:ClipEvent):void {	
        	if(_streamSequence != null) {
        		_streamSequence.processResumeEvent(time, event);
        	}
        }

        protected function processFullScreenEvent(playerEvent:PlayerEvent):void {	
        	if(_streamSequence != null) {
        		_streamSequence.processFullScreenEvent(time);
        	}
        }

        protected function processMuteEvent(playerEvent:PlayerEvent):void {	
        	if(_streamSequence != null) {
        		_streamSequence.processMuteEvent(time);
        	}
        }
        
		override protected function doLoad(event:ClipEvent, netStream:NetStream, clip:Clip):void {
			doLog("doLoad(clip) called for clip " + clip.url + " in plugin " + model.name, DebugObject.DEBUG_CLIPS);
			clip.onPause(processPauseEvent);
			clip.onStop(processStopEvent);
			clip.onResume(processResumeEvent);
			if(_vastData.dataLoaded || _vastData.loadFailed) {
				if(_openXConfig.showPrePromo()) {
					_openXConfig.getPrePromotion().deactivate(_player);
				}
				clip.onCuepoint(processCuepoint);
				if(!playingPopupAd()) {
					doLog("Not playing a popup", DebugObject.DEBUG_CLIPS);
					if(clip.url.toUpperCase() == "MAIN") {
						doLog("In MAIN clip", DebugObject.DEBUG_CLIPS);
						_streamComplete = false;
						_adSequence.mapVASTDataToAdSlots(_vastData);
						if(_streamSequence == null) {
							_streamSequence = new StreamSequence(_openXConfig, _adSequence); 
							_adSequence.setCuepoints(clip);
						}
						else {
//							_streamSequence.setCuepoints(clip);
//							_adSequence.setCuepoints(clip);
						}
						clip.duration = _streamSequence.play(netStream, clip);
						if(_streamSequence.lastPauseTime > 0) {
							_player.seek(_streamSequence.lastPauseTime);
							_streamSequence.resetPauseMarker();
						}
						else {
							_player.seek(0);
						}
					}
					else {
						doLog("In POPUP clip", DebugObject.DEBUG_CLIPS);
						if(_streamComplete) {
							// popup ad is complete, go back to the previous "main" stream
							doLog("_streamComplete == TRUE - skipping to previous clip then playing", DebugObject.DEBUG_CLIPS);
							var c:Clip = _player.previous();
							if(c.url.toUpperCase() == "POPUP") _player.previous();
							_player.play();
						}
						else {
							// skipping over the popup clip as we're not playing it
							doLog("Clip index = " + clip.index + " playlist length = " + _player.playlist.length, DebugObject.DEBUG_CLIPS);
                            if(clip.index == (_player.playlist.length - 1)) {
								doLog("_streamComplete == FALSE - STOPPING", DebugObject.DEBUG_CLIPS);
								_player.stop();                            	
                            }
                            else {
								doLog("_streamComplete == FALSE - skipping to next", DebugObject.DEBUG_CLIPS);
                            	_player.next();
                            }
							_streamComplete = true;
							clip.duration = 0;
						}
					}
				}
				else { // it's a popup video ad
					doLog("Playing a popup", DebugObject.DEBUG_CLIPS);
					var adToPopupID:String = _adSequence.adSlots[_pendingPopupAdIndex].id + "-" + _adSequence.adSlots[_pendingPopupAdIndex].associatedStreamIndex;
					doLog("Loading POPUP video ad at index " + _pendingPopupAdIndex + " AD ID = " + adToPopupID, DebugObject.DEBUG_POPUP_EVENTS);
					var popupAdSequence:AdSequence = new AdSequence();
					popupAdSequence.build(this, _openXConfig.getPopupConfig(), 1, 1, false);				
					popupAdSequence.setAdSlotIDAtIndex(0, adToPopupID);
					popupAdSequence.mapVastDataForAdToAllAdSlots(_vastData, adToPopupID);
					_popupStreamSequence = new StreamSequence();
					_popupStreamSequence.build(new Array(), popupAdSequence);
					clip.duration = _popupStreamSequence.play(netStream, clip, false, false);
				}
			}
			else {
				doLog("FATAL ERROR - ignoring doLoad event - VAST template data not fully loaded yet!", DebugObject.DEBUG_FATAL);
			}
		}
		
		private function playingPopupAd():Boolean {
			return (_pendingPopupAdIndex > -1);
		}
		
		private function showPopupLinearVideoAd(event:Object): void {
			if(event.slotId != undefined) {
				if(_adSequence.hasSlot(event.slotId)) {
					_pendingPopupAdIndex = event.slotId;
					// close the region showing the original non-linear ad
					_adSequence.processCuepoint(event.slotId, "NE", _player, this); 
					// now pause the main sequence and then play the popup ad
					_streamSequence.markPaused(time);
					_player.next();
				}
			}	
			else doLogAndTrace("Cannot process an region click event - no index value provided", event);
		}
				
		// EXTERNAL API
		
		[External]
		public function getHtmlFriendlyTemplateData():String {
			if(_vastData.dataLoaded) {
				return _vastData.getHtmlFriendlyTemplateData();
			}
			else return "No data currently available";			
		}
		
		[External]
		public function getRawTemplateData():String {
			if(_vastData.dataLoaded) {
				return _vastData.rawTemplateData;
			}
			else return "No data currently available";	
		}
		
		[External]
		public function setDebugLevel(level:int):void {
			DebugObject.getInstance().level = level;	
		}
		
		[External]
		public function triggerEvent(event:Object):void {
			doLogAndTrace("Event triggered by external API - event follows:", event, DebugObject.DEBUG_MOUSE_EVENTS);
			if(event != null) {
				switch(event.type) {
					case "trackClickThrough":
					    break;
					    
					case "showLinearAd":
						if(_openXConfig.enablePopupVideoAds) {
							showPopupLinearVideoAd(event);
						}
						break;
						
					default:
						doLogAndTrace("Cannot process unknown click event type " + event.type, event, DebugObject.DEBUG_MOUSE_EVENTS);
				}
			}
			else doLog("Cannot process triggerEvent - no event specification provided");
		}
				
		// VAST AD METHODS
		
		public function onTemplateLoaded(data:String):void {
			_model.dispatchOnLoad();			
			dispatchTemplateDataToExternalCallback(data);
		}
		
		public function onTemplateLoadError(event:Event):void {
			doLog("FAILURE loading VAST template - " + event.toString(), DebugObject.DEBUG_FATAL);
			_model.dispatchOnLoad();
		}
				
		private function dispatchTemplateDataToExternalCallback(data:String):void {
			if(_model) {
				doLog("Dispatching onTemplateLoaded callback...", DebugObject.DEBUG_JAVASCRIPT);
			    var xmlData:XML = new XML(data);
				var thePattern:RegExp = /\n/g;
				var encodedString:String = xmlData.toXMLString().replace(thePattern, "\\n");
				_model.dispatch(PluginEventType.PLUGIN_EVENT, "onTemplateLoaded");
			}
		}
		
		private function loadVideoAdServingTemplate():void {
			if(_adSequence.haveAdSlotsToSchedule()) {
				doLog("Requesting a template with " + _adSequence.adSlots.length + " ads...", DebugObject.DEBUG_VAST_TEMPLATE);
				var openXRequest:OpenXVASTAdRequest = new OpenXVASTAdRequest(_openXConfig);
				openXRequest.zones = _adSequence.zones;
				_vastData = new VideoAdServingTemplate(this, openXRequest);
			}
			else {
				doLog("No ad spots to schedule for this stream so no request made to OpenX", DebugObject.DEBUG_VAST_TEMPLATE);
				_vastData = new VideoAdServingTemplate();
				_vastData.dataLoaded = true;
				_model.dispatchOnLoad();
			}
		}

        private function replaceSingleWithDoubleQuotes(data:String):String {
			var pattern:RegExp = /'/g;
			return data.replace(pattern, '"');
        }
        
		// VAST DISPLAY METHODS

		public function displayCompanionAd(displayEvent:VASTDisplayEvent):void {
			var companionAd:CompanionAd = displayEvent.ad as CompanionAd;
			if(_openXConfig.hasCompanionDivs()) {
				var companionDivIDs:Array = _openXConfig.companionDivIDs;
				doLog("Event trigger received by companion Ad with ID " + companionAd.id + " - looking for a div to match the sizing (" + companionAd.width + "," + companionAd.height + ")", DebugObject.DEBUG_CUEPOINT_EVENTS);
				_previousDivContent = new Array();
				var matchFound:Boolean = false;
				for(var i:int=0; i < companionDivIDs.length; i++) {
					if(companionAd.matchesSize(companionDivIDs[i].width, companionDivIDs[i].height)) {
						matchFound = true;
						doLog("Found a match for that size - id of matching DIV is " + companionDivIDs[i].id, DebugObject.DEBUG_CUEPOINT_EVENTS);
						var newHtml:String = null;
						if(companionAd.isHtmlCodeBlock()) {
							doLog("Inserting a HTML codeblock into the DIV for a companion banner... " + companionAd.clickThroughs.length + " click through URL described", DebugObject.DEBUG_CUEPOINT_EVENTS);
							doTrace(companionAd.codeBlock, DebugObject.DEBUG_CUEPOINT_EVENTS);
							if(companionAd.hasClickThroughURL()) {
								newHtml = "<a href=\"" + companionAd.clickThroughs[0].url + "\" target=_blank>";
								newHtml += companionAd.codeBlock;
								newHtml += "</a>";
							}
							else newHtml = companionAd.codeBlock;
						}
						else {
							if(companionAd.isImage()) {
								doLog("Inserting a <IMG> into the DIV for a companion banner..." + companionAd.clickThroughs.length + " click through URL described", DebugObject.DEBUG_CUEPOINT_EVENTS);
								if(companionAd.hasClickThroughURL()) {
									newHtml = "<a href=\"" + companionAd.clickThroughs[0].url + "\" target=_blank>";
									newHtml += "<img src=\"" + companionAd.url.url + "\" border=\"0\"/>";
									newHtml += "</a>";
								}
								else {
									newHtml += "<img src=\"" + companionAd.url.url + "\" border=\"0\"/>";								
								}
							}		
							else doLog("Unknown resource type " + companionAd.resourceType);
						}
						if(newHtml != null) {
							var previousContent:String = ExternalInterface.call("function(){ return document.getElementById('" + companionDivIDs[i].id + "').innerHTML; }");
							_previousDivContent.push({ divId: companionDivIDs[i].id, content: previousContent } );
							ExternalInterface.call("function(){ document.getElementById('" + companionDivIDs[i].id + "').innerHTML='" + replaceSingleWithDoubleQuotes(newHtml) + "'; }");
							newHtml = null;
						}
					}
				}
				if(!matchFound) doLog("No DIV match found for sizing (" + companionAd.width + "," + companionAd.height + ")!", DebugObject.DEBUG_CUEPOINT_EVENTS);				
			}
			else doLog("No DIVS specified for companion ads to be displayed", DebugObject.DEBUG_CUEPOINT_EVENTS);
		}

		public function hideCompanionAd(displayEvent:VASTDisplayEvent):void {
			var companionAd:CompanionAd = displayEvent.ad as CompanionAd;
			doLog("Event trigger received to hide the companion Ad with ID " + companionAd.id, DebugObject.DEBUG_CUEPOINT_EVENTS);
			for(var i:int=0; i < _previousDivContent.length; i++) {
				ExternalInterface.call("function(){ document.getElementById('" + _previousDivContent[i].divId + "').innerHTML='" + StringUtils.removeControlChars(_previousDivContent[i].content) + "'; }");				
			}
			_previousDivContent = new Array();
		}
		
	 	private function get regionPlugin():Regions {
	 		if(_regionPluginHandle == null) {		 
				var plugin:DisplayPluginModel = _player.pluginRegistry.getPlugin(_openXConfig.regionsPluginName) as DisplayPluginModel;
				_regionPluginHandle = Regions(plugin.getDisplayObject());
	 		}
			return _regionPluginHandle;
	 	}

		public function displayNonLinearOverlayAd(displayEvent:VASTDisplayEvent):void {
			doLog("Attempting to display overlay ad " + displayEvent.customData.adSlotPosition, DebugObject.DEBUG_CUEPOINT_EVENTS);
			var nonLinearVideoAd:NonLinearVideoAd = displayEvent.ad as NonLinearVideoAd;

			if(displayEvent.customData.adSlotPosition != undefined) {
				var oid:String = displayEvent.customData.adSlotPosition;
				doLog("Attempting to send HTML to region with ID " + oid, DebugObject.DEBUG_CUEPOINT_EVENTS);
				var html:String = null;
				if(nonLinearVideoAd.isHtmlCodeBlock()) {
					if(nonLinearVideoAd.hasAccompanyingVideoAd()) {
						html = "<p align='left'><a href=\"javascript:openx.triggerEvent('" + _model.name + "', { type:'showLinearAd', slotId: " + displayEvent.customData.adSlotKey + ", adIndex:" + displayEvent.customData.adSlotAssociatedStreamIndex + " }, true);\">";
						html += nonLinearVideoAd.codeBlock + "</a></p>";
					}
					else if(nonLinearVideoAd.hasClickThroughURL()) {
//						html = "<a href=\"javascript:openx.triggerEvent('" + _model.name + "', { type:'trackClickThrough', slotId: " + displayEvent.customData.adSlotKey + ", adIndex:" + displayEvent.customData.adSlotAssociatedStreamIndex + " }, '" + nonLinearVideoAd.clickThroughs[0].url + "');\" target=\"_blank\">";
//						html += nonLinearVideoAd.codeBlock + "</a>";
						html = "<a href=\"" + nonLinearVideoAd.clickThroughs[0].url + "\" target=\"_blank\">" + nonLinearVideoAd.codeBlock + "</a>";
					}
					else html = nonLinearVideoAd.codeBlock;
				}
				else if(nonLinearVideoAd.isImage()) {
					if(nonLinearVideoAd.hasAccompanyingVideoAd()) {
						html = "<a href=\"javascript:openx.triggerEvent('" + _model.name + "', { type:'showLinearAd', slotId: " + displayEvent.customData.adSlotKey + ", adIndex:" + displayEvent.customData.adSlotAssociatedStreamIndex + " }, true);\">";
						html += "<img src=\"" + nonLinearVideoAd.url.url + "\" border=\"0\"/>";
						html += "</a>";
					}
					else if(nonLinearVideoAd.hasClickThroughURL()) {
//						html = "<a href=\"javascript:openx.triggerEvent('" + _model.name + "', { type:'trackClickThrough', slotId: " + displayEvent.customData.adSlotKey + ", adIndex:" + displayEvent.customData.adSlotAssociatedStreamIndex + " }, '" + nonLinearVideoAd.clickThroughs[0].url + "');\" target=\"_blank\">";
						html = "<a href=\"" + nonLinearVideoAd.clickThroughs[0].url + "\" target=\"_blank\">" + nonLinearVideoAd.codeBlock + "</a>";
						html += "<img src=\"" + nonLinearVideoAd.url.url + "\" border=\"0\"/>";
						html += "</a>";
					}
					else html = "<img src=\"" + nonLinearVideoAd.url.url + "\" border=\"0\"/>";
				}
				else {
					doLog("Could not work out how to place content into region " + oid + "", DebugObject.DEBUG_CUEPOINT_EVENTS);	
				}
				if(html != null) {
					regionPlugin.setVisibility(oid, false);
					regionPlugin.setPauseOnClick(oid, _adSequence.getSlot(displayEvent.customData.adSlotKey).pauseOnClick);
					regionPlugin.setHtmlForRegion(oid, html);
					regionPlugin.setVisibility(oid, true);			
				}
			}
			else doLog("Cannot show the non linear ad - no regionID specified!", DebugObject.DEBUG_CUEPOINT_EVENTS);
		}
		
		public function hideNonLinearOverlayAd(displayEvent:VASTDisplayEvent):void {
			if(displayEvent.customData.adSlotPosition != undefined) {
				var oid:String = displayEvent.customData.adSlotPosition;
				doLog("Attempting to hide region with ID " + oid, DebugObject.DEBUG_CUEPOINT_EVENTS);
				regionPlugin.setVisibility(oid, false);				
			}
			else doLog("Cannot hide the non linear ad - no regionID specified!", DebugObject.DEBUG_DATA_ERROR);
		}

		public function displayNonLinearNonOverlayAd(displayEvent:VASTDisplayEvent):void {
		}
		
		public function hideNonLinearNonOverlayAd(displayEvent:VASTDisplayEvent):void {
		}

		public function displayStaticAd(displayEvent:VASTDisplayEvent):void {
			doLog("Configuring static ad to display in region " + displayEvent.customData.staticAdSlot.position);
			regionPlugin.setHtmlForRegion(displayEvent.customData.staticAdSlot.position, displayEvent.customData.staticAdSlot.html);
			regionPlugin.setVisibility(displayEvent.customData.staticAdSlot.position, true);
		}

		public function hideStaticAd(displayEvent:VASTDisplayEvent):void {
			doLog("Hiding static ad in region " + displayEvent.customData.staticAdSlot.position);
			regionPlugin.setVisibility(displayEvent.customData.staticAdSlot.position, false);
		}
		
		public function displayingCompanions():Boolean {
			return _openXConfig.hasCompanionDivs();
		}
		

		// CUEPOINT PROCESSING 
		
		private function processCuepoint(clipevent:ClipEvent):void { 
			var cuepoint:Cuepoint = clipevent.info as Cuepoint;
			doLog("Cuepoint triggered " + clipevent.toString() + " - id: " + cuepoint.callbackId, DebugObject.DEBUG_CUEPOINT_EVENTS);

    		var index:int = parseInt(cuepoint.callbackId.substr(3));
    		var info:Object;
    		if(cuepoint.callbackId.substr(0,1) == "N" || cuepoint.callbackId.substr(0,1) == "C" || cuepoint.callbackId.substr(0,1) == "R") {
    			// it's a trigger for a non-interactive video ad, a companion or a static html ad
    			info = _adSequence.processCuepoint(index, cuepoint.callbackId.substr(0,2), _player, this);
    			info.timestamp = clipevent.info.time;
				if(_model) _model.dispatch(PluginEventType.PLUGIN_EVENT, "onCuepointInfo", info);				
    		}
    		else {
    			if(playingPopupAd()) {
    				info = _popupStreamSequence.processCuepoint(index, cuepoint.callbackId.substr(0,2), _player, this);
    			}
				else info = _streamSequence.processCuepoint(index, cuepoint.callbackId.substr(0,2), _player, this);
    			info.timestamp = clipevent.info.time;
				if(_model) _model.dispatch(PluginEventType.PLUGIN_EVENT, "onCuepointInfo", info);				
				if(cuepoint.callbackId.substr(0,2) == "EA" && playingPopupAd()) {
					_pendingPopupAdIndex = -1;
					_player.previous();
				}
    		}
		}			
				
		public function getDefaultConfig():Object {
			return null;
		}
				
		// DEBUG METHODS
		
		protected static function doLog(data:String, level:int=1):void {
			DebugObject.getInstance().doLog(data, level);
		}
		
		protected static function doTrace(o:Object, level:int=1):void {
			DebugObject.getInstance().doTrace(o, level);
		}
		
		protected static function doLogAndTrace(data:String, o:Object, level:int=1):void {
			DebugObject.getInstance().doLogAndTrace(data, o, level);
		}
	}
}