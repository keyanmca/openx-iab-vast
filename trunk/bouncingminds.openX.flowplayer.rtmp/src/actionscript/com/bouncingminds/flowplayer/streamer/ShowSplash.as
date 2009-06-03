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
	import com.bouncingminds.flowplayer.regions.Regions;
	import com.bouncingminds.util.DebugObject;
	
	import org.flowplayer.model.DisplayPluginModel;
	import org.flowplayer.view.Flowplayer;
	
	/**
	 * @author Paul Schulz
	 */
	public class ShowSplash extends DebugObject {
		protected var _show:Boolean = false;
		protected var _regionID:String = "promo";
		protected var _imageFilename:String = null;
		private static var _regionPluginHandle:Regions = null;
		private var _regionsPluginName:String = "openXRegions";
		
		public function ShowSplash(config:Object, regionsPluginName:String=null) {
			if(config.show != undefined) show = config.show;
			if(config.region != undefined) regionID = config.region;
			if(config.imageFilename != undefined) imageFilename = config.imageFilename;
			if(regionsPluginName != null) _regionsPluginName = regionsPluginName;
		}
		
		public function set show(show:Boolean):void {
			_show = show;
		}
		
		public function get show():Boolean {
			return _show;
		}
		
		public function set regionID(regionID:String):void {
			_regionID = regionID;
		}
		
		public function get regionID():String {
			return _regionID;
		}
		
		public function set imageFilename(imageFilename:String):void {
			_imageFilename = imageFilename;
		}
		
		public function get imageFilename():String {
			return _imageFilename;
		}
		
		public function deactivate(player:Flowplayer):void {
			if(_regionPluginHandle == null) {
				_regionPluginHandle = getRegionPluginHandle(player);
			}
			_regionPluginHandle.setVisibility(_regionID, false);			
		}
		
		public function activate(player:Flowplayer):void {
			if(_regionPluginHandle == null) {
				_regionPluginHandle = getRegionPluginHandle(player);
			}
			_regionPluginHandle.setVisibility(_regionID, true);
		}
		
	 	private function getRegionPluginHandle(player:Flowplayer):Regions {
	 		if(_regionPluginHandle == null) {
				var plugin:DisplayPluginModel = player.pluginRegistry.getPlugin(_regionsPluginName) as DisplayPluginModel;
				_regionPluginHandle = Regions(plugin.getDisplayObject());
	 		}
			return _regionPluginHandle;
	 	}
	}
}