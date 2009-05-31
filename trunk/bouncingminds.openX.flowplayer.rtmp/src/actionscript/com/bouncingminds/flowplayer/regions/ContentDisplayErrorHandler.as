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
	import org.flowplayer.view.ErrorHandler;
	import org.flowplayer.model.PlayerError;
	
	import com.bouncingminds.util.DebugObject;
	
	/**
	 * @author Paul Schulz
	 */
	public class ContentDisplayErrorHandler extends DebugObject implements ErrorHandler {
		public function ContentDisplayErrorHandler() {
		}
		
		public function showError(message:String):void {
			doLog(message, DebugObject.DEBUG_CONTENT_ERRORS);
		}
		
		public function handleError(error:PlayerError, info:Object = null, throwError:Boolean = true):void {
			doLog(error.message, DebugObject.DEBUG_CONTENT_ERRORS);
		}
	}
}