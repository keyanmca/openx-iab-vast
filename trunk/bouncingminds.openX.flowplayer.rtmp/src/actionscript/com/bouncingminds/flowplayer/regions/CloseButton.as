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
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flowplayer.controller.ResourceLoader;
	import org.flowplayer.view.Flowplayer;

	/**
	 * @author Paul Schulz
	 */
	internal class CloseButton extends Sprite {
		private var _id:String;
		private var _icon:DisplayObject;
		private var _imageURL:String;
		private var _view:RegionView=null;
		
		public function CloseButton(id:String=null, imageURL:String=null, player:Flowplayer=null, view:RegionView=null) {
			_id = id;
			if(imageURL != null) {
				loadImage(imageURL, player);
			}
			_view = view;
		}
		
		public function loadImage(imageURL:String, player:Flowplayer):void {
			if(imageURL) {
				_imageURL = imageURL;
				var loader:ResourceLoader = player.createLoader();
				DebugObject.getInstance().doLog("loading closeImage from file " + imageURL, DebugObject.DEBUG_REGION_FORMATION);
				loader.addBinaryResourceUrl(imageURL);
				loader.load(null, onImageLoaded);			
			}
		}
		
		private function onImageLoaded(loader:ResourceLoader):void {
			icon = loader.getContent(_imageURL) as DisplayObject;	
		}
		
		public function set icon(icon:DisplayObject):void  {
			_icon = icon; 
			_icon.width = 10;
			_icon.height = 10;
			addChild(_icon);
			addListeners();
			onMouseOut();
			buttonMode = true;
		}
		
		private function addListeners():void {
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);	
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);			
		}
		
		private function removeListeners():void {
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseOut(event:MouseEvent = null):void {
			_icon.alpha = 0.7;
		}

		private function onMouseOver(event:MouseEvent):void {
			_icon.alpha = 1;
		}
		
		private function onMouseClick(event:MouseEvent):void {
			removeListeners();
			_view.onCloseClicked();
		}
	}
}