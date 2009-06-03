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
package com.bouncingminds.vast.openx {
	
	/**
	 * @author Paul Schulz
	 */
	public class OpenXVASTAdRequest extends OpenXServerConfig {
		public function OpenXVASTAdRequest(config:OpenXServerConfig=null) {
			if(config != null) configure(config);
		}
		
		private function formZoneParameters():String {
			var zoneIDs:String = "";
			for(var i:int = 0; i < _zones.length; i++) {
				if(_zones[i].zone.toUpperCase() != 'STATIC') {
					if(zoneIDs.length > 0) {
						zoneIDs += "%7C";
					}
					zoneIDs += _zones[i].id + "%3D" + _zones[i].zone;
				}		
			}
			return zoneIDs;			
		}
		
		public function formRequest(zones:Array=null):String {
			if(zones != null) _zones = zones;
			return vastServerURL + "?" +
			       "script=" + script +
			       "&zones=" + formZoneParameters() +
			       ((hasSelectionCriteria()) ? "&" + selectionCriteria : "") + 
			       "&nz=" + nz +
			       "&source=" + source +
			       "&r=" + r + 
			       "&block=" + ((allowAdRepetition) ? "0" : "1") +
			       "&format=" + format +
			       "&charset=" + charset;
		}
	}
}