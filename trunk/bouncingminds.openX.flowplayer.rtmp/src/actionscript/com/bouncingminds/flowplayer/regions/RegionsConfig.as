/*    
 *    Copyright (c) 2009 Bouncing Minds - Option 3 Ventures Limited
 *
 *    This file is part of the Regions plug-in for Flowplayer.
 *
 *    The Regions plug-in is free software: you can redistribute it 
 *    and/or modify it under the terms of the GNU General Public License 
 *    as published by the Free Software Foundation, either version 3 of 
 *    the License, or (at your option) any later version.
 *
 *    The Regions plug-in is distributed in the hope that it will be 
 *    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with the plug-in.  If not, see <http://www.gnu.org/licenses/>.
 */
 package com.bouncingminds.flowplayer.regions {
	import com.bouncingminds.util.DebugObject;
	
	/**
	 * @author Paul Schulz
	 */
	public class RegionsConfig extends BaseRegionConfig {
		private var _makeRegionsVisible:Boolean = false;
		private var _regions:Array = new Array();
		private var _originalRegionDefinitions:Array = new Array();
		
		public function RegionsConfig(config:Object=null) {
			super(config);
			id = "master";
		}
		
		public function set makeRegionsVisible(visible:Boolean):void {
			_makeRegionsVisible = visible;
		}
		
		public function get makeRegionsVisible():Boolean {
			return _makeRegionsVisible;
		}
		
		public function set regions(regions:Array):void {
			_originalRegionDefinitions = regions;
		}
	
		public function get regions():Array {
			return _regions;
		}		
		
		public function buildRegionConfigs():void {
			doLogAndTrace("Parsing individual region configurations. Using the master config as follows:", this, DebugObject.DEBUG_CONFIG);
			_regions = new Array();
			for(var i:int=0; i < _originalRegionDefinitions.length; i++) {
				var regionViewConfig:RegionViewConfig = new RegionViewConfig(properties);
				regionViewConfig.setup(_originalRegionDefinitions[i]);
				_regions.push(regionViewConfig);
			}			
		}
	}
}