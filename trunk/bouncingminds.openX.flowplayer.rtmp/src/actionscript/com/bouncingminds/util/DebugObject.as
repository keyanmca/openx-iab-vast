/*    
 *    Copyright (c) 2009 Bouncing Minds - Option 3 Ventures Limited
 *
 *    This file is part of the Regions and OpenX Ad Streamer for Flowplayer.
 *
 *    The Regions/OpenX Ad Streamer plug-in is free software: you can redistribute it 
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
 package com.bouncingminds.util {
	import com.adobe.utils.StringUtil;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class DebugObject {		
		public static var DEBUG_ALL:int = 1;
		public static var DEBUG_VAST_TEMPLATE:int = 2;
		public static var DEBUG_CUEPOINT_EVENTS:int = 4;	
		public static var DEBUG_SEGMENT_FORMATION:int = 8;
		public static var DEBUG_REGION_FORMATION:int = 16;
		public static var DEBUG_CUEPOINT_FORMATION:int = 32;
		public static var DEBUG_CONFIG:int = 64;
		public static var DEBUG_CLICKTHROUGH_EVENTS:int = 128;
		public static var DEBUG_DATA_ERROR:int = 256;
		public static var DEBUG_HTTP_CALLS:int = 512;
		public static var DEBUG_FATAL:int = 1024;
		public static var DEBUG_CONTENT_ERRORS:int = 2048;
		public static var DEBUG_MOUSE_EVENTS:int = 4096;
		public static var DEBUG_POPUP_EVENTS:int = 8192;
		public static var DEBUG_JAVASCRIPT:int = 16384;
		public static var DEBUG_STYLES:int = 32768;
		public static var DEBUG_CLIPS:int = 65536;
		public static var DEBUG_PLAY_EVENTS:int = 131072;
		public static var DEBUG_STREAM_CONNECTION:int = 262144;
		public static var DEBUG_TRACKING_EVENTS:int = 524288;
		
		public static var BUILD_NUMBER:String = "0.4.6.4";
		
		private static var _level:int = 0;
					
		public static var _debugger:MonsterDebugger;
		public static var _instance:DebugObject;
 
		public function DebugObject() {
			if(_debugger == null) _debugger = new MonsterDebugger(this);
		}

		public static function getInstance():DebugObject {
			if(_instance == null) _instance = new DebugObject();
			return _instance;
		}
		
		public function set level(level:int):void {
			_level = level;
			doLog("Debug level has been set to " + _level);
		}
		
		public function setLevelFromString(levelAsString:String):void {
  			var results:Array = levelAsString.split(/,/);
  			var newLevel:int = 0;
  			for(var i:int=0; i < results.length; i++) {
  				switch((StringUtil.trim(results[i])).toUpperCase()) {
  					case "ALL":
  						newLevel = newLevel | DEBUG_ALL;
  						break;
  						
  					case "VAST_TEMPLATE":
  						newLevel = newLevel | DEBUG_VAST_TEMPLATE;
  						break;
  				
  					case "CUEPOINT_EVENTS":
  						newLevel = newLevel | DEBUG_CUEPOINT_EVENTS;
  						break;
  						
  					case "SEGMENT_FORMATION":
  						newLevel = newLevel | DEBUG_SEGMENT_FORMATION;
  						break;
  						
  					case "REGION_FORMATION":
  						newLevel = newLevel | DEBUG_REGION_FORMATION;
  						break;
  						
  					case "CUEPOINT_FORMATION":
  						newLevel = newLevel | DEBUG_CUEPOINT_FORMATION;
  						break;
  						
  					case "CONFIG":
  						newLevel = newLevel | DEBUG_CONFIG;
  						break;
  						
  					case "CLICKTHROUGH_EVENTS":
  						newLevel = newLevel | DEBUG_CLICKTHROUGH_EVENTS;
  						break;
  						
  					case "DATA_ERROR":
  						newLevel = newLevel | DEBUG_DATA_ERROR;
  						break;
  						
  					case "HTTP_CALLS":
  						newLevel = newLevel | DEBUG_HTTP_CALLS;
  						break;
  						
  					case "FATAL":
  					    newLevel = newLevel | DEBUG_FATAL;
  					    break;
  					    
  					case "CONTENT_ERRORS":
  						newLevel = newLevel | DEBUG_CONTENT_ERRORS;
  						break;
  						
  					case "MOUSE_EVENTS":
  						newLevel = newLevel | DEBUG_MOUSE_EVENTS;
  						break;

  					case "POPUP_EVENTS":
  						newLevel = newLevel | DEBUG_POPUP_EVENTS;
  						break;

  					case "JAVASCRIPT":
  						newLevel = newLevel | DEBUG_JAVASCRIPT;
  						break;

  					case "STYLES":
  						newLevel = newLevel | DEBUG_STYLES;
  						break;

  					case "CLIPS":
  						newLevel = newLevel | DEBUG_CLIPS;
  						break;
  						
  					case "PLAY_EVENTS":
  						newLevel = newLevel | DEBUG_PLAY_EVENTS;
  						break;

  					case "STREAM_CONNECTION":
  						newLevel = newLevel | DEBUG_STREAM_CONNECTION;
  						break;
  						
  					case "TRACKING_EVENTS":
  						newLevel = newLevel | DEBUG_TRACKING_EVENTS;
  						break;
  				}
  			}
			level = newLevel;
		}
		
		public function doLog(data:String, level:int=1):void {
			if(_level == DebugObject.DEBUG_ALL || level == DEBUG_ALL || (_level & level)) {
				MonsterDebugger.trace(this, data);			
			}
		}
		
		public function doTrace(o:Object, level:int=1):void {
			if(_level == DEBUG_ALL || level == DEBUG_ALL || (_level & level)) {
				MonsterDebugger.trace(this, o);
			}
		}
		
		public function doLogAndTrace(data:String, o:Object, level:int=1):void {
			doLog(data, level);
			doTrace(o, level);
		}
		
		public function dump(o:Object):void {
			for(var name:* in o) {
				doLog(name + ": " + o[name]);
				doLog(typeof(o[name]));
			}
		}
	}
}
