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
	
	import org.flowplayer.model.DisplayPluginModel;
	import org.flowplayer.model.Plugin;
	import org.flowplayer.model.PluginModel;
	import org.flowplayer.util.PropertyBinder;
	import org.flowplayer.view.AbstractSprite;
	import org.flowplayer.view.Flowplayer;
	import org.flowplayer.view.Styleable;
	
	/**
	 * @author Paul Schulz
	 */
	public class Regions extends AbstractSprite implements Plugin, Styleable {
		private var _player:Flowplayer;
		private var _model:PluginModel;
		private var _regionViews:Array = new Array();
		private var _regionsConfig:RegionsConfig;
		private var _showCloseButton:Boolean = false;
		private var _closeButtonSettings:Object = null;
		
		public function Regions() {
		}
		
		override protected function onResize():void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					_regionViews[i].resize();
				}
			}	
		}

		/**
		 * Sets the plugin model. This gets called before the plugin
		 * has been added to the display list and before the player is set.
		 * @param plugin
		 */
		public function onConfig(model:PluginModel):void {
			_model = model;
			_regionsConfig = new PropertyBinder(new RegionsConfig(), null).copyProperties(_model.config) as RegionsConfig;
			doLogAndTrace("Region config has been read. Trace follows:", _regionsConfig, DebugObject.DEBUG_CONFIG);
			_regionsConfig.buildRegionConfigs();
		}
				
		/**
		 * Sets the Flowplayer interface. The interface is immediately ready to use, all
		 * other plugins have been loaded an initialized also.
		 * @param player
		 */
		public function onLoad(player:Flowplayer):void {
			_player = player;
			createRegionViews(_regionsConfig.regions);
			showAutoShowViews();
            _model.dispatchOnLoad();
		}
		
		protected function showAutoShowViews():void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					if(_regionViews[i].autoShow) {
						_regionViews[i].visible = true;
					}
				}
			}							
		}
		
		[External]
		public function setHtmlForRegion(regionID:String, html:String):void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					if(_regionViews[i].id == regionID) {
						_regionViews[i].html = html;
						return;
					}
				}
			}				
		}
		
		[External]
		public function toggleAll():void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					_regionViews[i].visible = !_regionViews[i].visible;
				}
			}
		}
		
		[External]
		public function toggleRegion(regionID:String):void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					if(_regionViews[i].id == regionID) {
						_regionViews[i].visible = !_regionViews[i].visible;
						return;
					}
				}
			}
		}
		
		[External]
		public function resetRegion(regionID:String):void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					if(_regionViews[i].id == regionID) {
						_regionViews[i].reset();
						return;
					}
				}
			}
		}
		
		[External]
		public function toggleDebugOnRegion(regionID:String):void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					if(_regionViews[i].id == regionID) {
						_regionViews[i].toggleDebug();
						return;
					}
				}
			}
		}
		
		[External]
		public function setVisibility(regionID:String, visibility:Boolean=true):void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					if(_regionViews[i].id == regionID) {
						_regionViews[i].visible = visibility;
						return;
					}
				}
			}	
		}

		[External]
		public function setVisibilityAll(visible:Boolean=true):void {
			if(_regionViews.length > 0) {
				for(var i:int = 0; i < _regionViews.length; i++) {
					_regionViews[i].visible = visible;
				}
			}
		}
		
		[External]
		public function getInfo(regionID:String):Object {
			return null;
		}
		
		[External]
		public function getInfoAll():Array {
			return new Array();
		}
		
		public function createRegionViews(viewConfig:Array):void {
			if(viewConfig != null && viewConfig.length > 0) {
				// setup the regions
				for(var i:int=0; i < viewConfig.length; i++) {
					doLogAndTrace("The following config has been used to create RegionView (" + i + ")", viewConfig[i], DebugObject.DEBUG_CONFIG);
					createRegionView(viewConfig[i]);
				}
			}
			else { 
			    // setup a default region for the bottom, one for the top and a fullscreen region
				createRegionView(new RegionViewConfig({ id: 'message', verticalAlign: 'bottom', horizontalAlign: 'left', width: '100pct', height: '20' }));
				createRegionView(new RegionViewConfig({ id: 'top', verticalAlign: 'top', width: '100pct', height: '50' }));
				createRegionView(new RegionViewConfig({ id: 'bottom', verticalAlign: 'bottom', width: '100pct', height: '50' }));
				createRegionView(new RegionViewConfig({ id: 'fullscreen', verticalAlign: 0, horizontalAlign: 0, width: '100pct', height: '100pct' }));
			}
			doLogAndTrace("Regions created - " + _regionViews.length + " in total. Trace follows:", _regionViews, DebugObject.DEBUG_CONFIG);
		}
		
		public function createRegionView(regionConfig:RegionViewConfig):void {
			doLogAndTrace("Creating region with ID " + regionConfig.id, regionConfig, DebugObject.DEBUG_REGION_FORMATION);
			var newView:RegionView = new RegionView(this, _model as DisplayPluginModel, _player, regionConfig, _showCloseButton);
			doLogAndTrace("Pushing new view onto the stack. Trace follows:", newView, DebugObject.DEBUG_REGION_FORMATION);
			_regionViews.push(newView);
			addChild(newView);
			setChildIndex(newView, 0);
		}
		
		public function config():RegionsConfig {
			return _regionsConfig;
		}
		
		public function pluginName():String {
			return _model.name;
		}
		
		public function css(styleProps:Object = null):Object {
			return null; // NOT IMPLEMENTED
		}

		public override function set alpha(value:Number):void {
			super.alpha = value;
		}

		public function getDefaultConfig():Object {
			return { top: 0, left: 0, width: '100%', height: '100%', opacity: 0.9, borderRadius: 10, backgroundGradient: 'low' };
		}
		
		public function animate(styleProps:Object):Object {
			return null;
		}

		// DEBUG METHODS
	
		protected function doLog(data:String, level:int=1):void {
			DebugObject.getInstance().doLog(data, level);
		}
		
		protected function doTrace(o:Object, level:int=1):void {
			DebugObject.getInstance().doTrace(o, level);
		}
		
		protected function doLogAndTrace(data:String, o:Object, level:int=1):void {
			DebugObject.getInstance().doLogAndTrace(data, o, level);
		}
	}
}