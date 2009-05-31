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
	import com.bouncingminds.vast.openx.OpenXServerConfig;
	
	/**
	 * @author Paul Schulz
	 */
	public class OpenXConfig extends OpenXServerConfig {
		private var _netConnectionUrl:String;
		private var _streams:Array = new Array();
		private var _openXURL:String;
		private var _splashPromo:ShowSplash = null;
		private var _prePromo:ShowSplash = null;
		private var _postPromo:ShowSplash = null;
		private var _notice:Object = { show: true, region: 'message', message: '<p class="message" align="right">This advertisement runs for _seconds_ seconds</p>' };
		private var _disableControls:Boolean = true;
		private var _regionsPluginName:String = "openXRegions";
		private var _companionDivIDs:Array = new Array(); 
		private var _defaultLinearRegions:Array = new Array({ id: 'bottom', width: 300, height: 50 });
		private var _streamType:String = "mp4";
		private var _enablePopupVideoAds:Boolean = true;
		private var _debugLevel:String = "fatal";
		private var _bitrate:String = null;
		private var _adSchedule:Array;
		private var _subscribe:Boolean = false;
		private var _width:int;
		private var _height:int;

		public function OpenXConfig() {
		}
		
		public function get netConnectionUrl():String {
			return _netConnectionUrl;
		}
		
		public function set netConnectionUrl(netConnectionUrl:String):void {
			_netConnectionUrl = netConnectionUrl;
		}
		
		public function getLiveStreamName():String {
			if(_streams.length > 0) {
				if(_streams[0].isLive()) {
					return _streams[0].filename;
				}
			}
			return null;
		}
		
		public function set streams(streams:Array):void {
			_streams = new Array();
			for(var i:int = 0; i < streams.length; i++) {
				_streams.push(new StreamConfig(streams[i].file, 
			                                    ((streams[i].duration != undefined) ? streams[i].duration : '00:00:00'), 
			                                    ((streams[i].reduceLength != undefined) ? streams[i].reduceLength : false)));
			}
		}
		
		public function get streams():Array {
			return _streams;
		}
		
		public function get openXURL():String {
			return _openXURL;
		}
		
			public function set openXURL(openXURL:String):void {
			_openXURL = openXURL;
		}
		
		public function set adStreamType(adStreamType:String):void {
			_streamType = adStreamType;
		}
		
		public function get adStreamType():String {
			return _streamType;
		}

		public function set subscribe(subscribe:Boolean):void {
			_subscribe = subscribe;
		}		
		
		public function get subscribe():Boolean {
			return _subscribe;
		}
		
		public function set bitrate(bitrate:String):void {
			_bitrate = bitrate;
		}
		
		public function get bitrate():String {
			return _bitrate;	
		}
		
		public function hasBitRate():Boolean {
			return _bitrate != null;
		}
		
		public function set regionsPluginName(regionsPluginName:String):void {
			_regionsPluginName = regionsPluginName;
		}
		
		public function get regionsPluginName():String {
			return _regionsPluginName;
		}
		
		public function hasCompanionDivs():Boolean {
			return _companionDivIDs.length > 0;
		}
		
		public function set companionDivIDs(companionDivIDs:Array):void {
			_companionDivIDs = companionDivIDs;
		}
		
		public function get companionDivIDs():Array {
			return _companionDivIDs;
		}
		
		public function set prePromo(prePromoConfig:Object):void {
			_prePromo = new ShowSplash(prePromoConfig);
		}
		
		public function getPrePromotion():ShowSplash {
			return _prePromo;
		}
		
		public function showPrePromo():Boolean {
			if(_prePromo != null) {
				return _prePromo.show;
			}
			return false;
		}
		
		public function set postPromo(postPromoConfig:Object):void {
			_postPromo = new ShowSplash(postPromoConfig);
		}

		public function getPostPromotion():ShowSplash {
			return _postPromo;
		}

		public function showPostPromo():Boolean {
			if(_postPromo != null) {
				return _postPromo.show;
			}
			return false;
		}
				
		public function set splashPromo(splashConfig:Object):void {
			_splashPromo = new ShowSplash(splashConfig, _regionsPluginName);
		}
		
		public function showSplash():Boolean {
			if(_splashPromo != null) {
				return _splashPromo.show;
			}
			return false;
		}
		
		public function getSplashPromotion():ShowSplash {
			return _splashPromo;
		}
		
		public function set notice(notice:Object):void {
			_notice = notice;
		}
		
		public function get notice():Object {
			return _notice;
		}

		public function showNotice():Boolean {
			if(_notice != null) {
				if(notice.show) {
					return notice.show;
				}	
			}
			return false;
		}

		public function set disableControls(disableControls:Boolean):void {
			_disableControls = disableControls;
		}
		
		public function get disableControls():Boolean {
			return _disableControls;
		}
		
		public function set enablePopupVideoAds(enablePopupVideoAds:Boolean):void {
			_enablePopupVideoAds = enablePopupVideoAds;
		}
		
		public function get enablePopupVideoAds():Boolean {
			return _enablePopupVideoAds;
		}

		public function set defaultLinearRegions(defaultLinearRegions:Array):void {
			_defaultLinearRegions = defaultLinearRegions;	
		}
		
		public function get defaultLinearRegions():Array {
			return _defaultLinearRegions;
		}
		
		public function set adSchedule(adSchedule:Array):void {
			_adSchedule = adSchedule;
		}

		public function get adSchedule():Array {
			return _adSchedule;
		}
		
		public function getAdSpotsWithPosition(position:String):Array {
			var result:Array = new Array();
			for(var i:int=0; i < _adSchedule.length; i++) {
				if(_adSchedule[i].position && _adSchedule[i].position.toUpperCase() == "POPUP") {
					result.push(_adSchedule[i]);
				}
			}
			return result;
		}
		
		public function set debugLevel(debugLevel:String):void {
			_debugLevel = debugLevel;
		}
		
		public function get debugLevel():String {
			return _debugLevel;
		}
		
		public function debugLevelSpecified():Boolean {
			return (_debugLevel != null);
		}
		
		public function getPopupConfig():Object {
			var popupAdSpot:Array = getAdSpotsWithPosition("popup");
			if(popupAdSpot.length > 0) {
				return { adSchedule: popupAdSpot };
			}
			else return { adSchedule: new Array({ position: 'popup', notice: { show: true } }) };
		}
	}		
}