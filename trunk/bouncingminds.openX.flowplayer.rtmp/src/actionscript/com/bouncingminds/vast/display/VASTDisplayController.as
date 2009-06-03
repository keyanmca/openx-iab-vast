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
 package com.bouncingminds.vast.display {
	import com.bouncingminds.vast.model.CompanionAd;
	import com.bouncingminds.vast.model.NonLinearVideoAd;
	import com.bouncingminds.vast.display.VASTDisplayEvent;
	import flash.external.ExternalInterface;
	
	/**
	 * @author Paul Schulz
	 */
	public interface VASTDisplayController {
		function displayCompanionAd(displayEvent:VASTDisplayEvent):void;
		function hideCompanionAd(displayEvent:VASTDisplayEvent):void;
		function displayNonLinearOverlayAd(displayEvent:VASTDisplayEvent):void;
		function hideNonLinearOverlayAd(displayEvent:VASTDisplayEvent):void;
		function displayNonLinearNonOverlayAd(displayEvent:VASTDisplayEvent):void;
		function hideNonLinearNonOverlayAd(displayEvent:VASTDisplayEvent):void;
		function displayingCompanions():Boolean;
	}
}