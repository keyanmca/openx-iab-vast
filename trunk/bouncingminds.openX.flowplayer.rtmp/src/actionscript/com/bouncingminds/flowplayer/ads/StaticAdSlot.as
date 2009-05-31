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
	import com.bouncingminds.util.DebugObject;
	import com.bouncingminds.flowplayer.streamer.OpenXDisplayController;
	import com.bouncingminds.vast.display.VASTDisplayController;
	import com.bouncingminds.vast.display.VASTDisplayEvent;
	
	import org.flowplayer.model.Clip;
	import org.flowplayer.view.Flowplayer;

	/**
	 * @author Paul Schulz
	 */
	public class StaticAdSlot extends AdSlot {
		protected var _html:String = null;
		protected var _startPoint:String = "relative";

		public function StaticAdSlot(vastDisplayController:OpenXDisplayController, key:int=0, associatedStreamIndex:int=0, id:String=null, zone:String=null, position:String=null, applyToParts:Array=null, duration:String=null, startTime:String="00:00:00", notice:Object=null, disableControls:Boolean=true, width:int=-1, height:int=-1, defaultLinearRegions:Array=null, companionDivIDs:Array=null, regionsPluginName:String=null, startPoint:String=null, html:String=null) {
			super(vastDisplayController, key, associatedStreamIndex, id, zone, position, applyToParts, duration, startTime, notice, disableControls, width, height, defaultLinearRegions, companionDivIDs, regionsPluginName);
			_html = html;
			if(_startPoint != null) _startPoint = startPoint;
		}

		public function set html(html:String):void {
			_html = html;
		}
		
		public function get html():String {
			return _html;
		}
		
		public function set startPoint(startPoint:String):void {
			_startPoint = startPoint;
		}		
		
		public function get startPoint():String {
			return _startPoint;
		}
		
		public function startPointIsRelative():Boolean {
			return (_startPoint.toUpperCase() == "RELATIVE");
		}

		override protected function createDisplayEvent(controller:VASTDisplayController):VASTDisplayEvent {
		 	var displayEvent:VASTDisplayEvent = super.createDisplayEvent(controller);
		 	displayEvent.customData.staticAdSlot = this;
			return displayEvent;
		}

		override public function hasVideoAd():Boolean {
			return false;
		}
		
		override public function isNonLinear():Boolean {
			return true;
		}
		
		override public function addNonLinearAdCuepoints(adSlotIndex:int, clip:Clip, currentTimeInSeconds:int, checkCompanionAds:Boolean=false):void {
			doTrace(this, DebugObject.DEBUG_CUEPOINT_FORMATION);
			var startPoint:int = 0;
			if(startPointIsRelative()) {
				startPoint = associatedStreamStartTime + getStartTimeAsSeconds();
			}
			else {
				startPoint = getStartTimeAsSeconds();				
			}
			setCuepoint(clip, startPoint * 1000, "RS:" + adSlotIndex);
			var duration:int = getDurationAsInt();

			if(duration > 0) {
				setCuepoint(clip, (startPoint + duration) * 1000, "RE:" + adSlotIndex);
				doLog("Cuepoint set at " + startPoint + " seconds and run for " + duration + " seconds for static ad with Ad id " + id, DebugObject.DEBUG_CUEPOINT_FORMATION);				
			}
			else doLog("Cuepoint set at " + startPoint + " seconds running indefinitely - static Ad id " + id, DebugObject.DEBUG_CUEPOINT_FORMATION);
		}
		
	 	override protected function getDebugInfo(cuepointEventType:String, description:String):Object {
	 		var info:Object = new Object();
	 		info.type = cuepointEventType;
	 		info.description = description;
	 		info.segmentType = "StaticAd";
	 		info.adType = "static region";
	 		info.id = ((_id == null) ? "Not specified" : _id);
	 		info.dimension = "(" + _width + "," + _height + ")";
	 		info.startTime = _startTime;
	 		info.startPoint = _startPoint;
	 		info.duration = "" + _duration + " seconds";
	 		return info;
	 	}
		
	 	protected function actionStartStaticAd(player:Flowplayer=null, config:OpenXConfig=null):void {
			_vastDisplayController.displayStaticAd(createDisplayEvent(_vastDisplayController));
	 	}

	 	protected function actionStopStaticAd(player:Flowplayer=null, config:OpenXConfig=null):void {	 		
			_vastDisplayController.hideStaticAd(createDisplayEvent(_vastDisplayController));
	 	}

	 	override public function processCuepoint(cuepointEventType:String, player:Flowplayer, adDisplayController:OpenXDisplayController, config:OpenXConfig=null):Object {
	 		doLog("StaticAdSlot: " + id + " received request to process cuepoint of type " + cuepointEventType, DebugObject.DEBUG_CUEPOINT_EVENTS);
	 		var description:String = "";
	 		
	 		switch(cuepointEventType) {
	 			case "RS":
	 			    description = "Start static (region) ad event";
	 				actionStartStaticAd(player, config);
	 				break; 
	 			case "RE":
	 			    description = "Stop static (region) ad event";
	 				actionStopStaticAd(player, config);
	 				break; 
	 		}

	 		return getDebugInfo(cuepointEventType, description);
	 	}
	}
}