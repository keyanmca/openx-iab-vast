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
	import org.flowplayer.model.PluginFactory;
	import flash.display.Sprite;
	import com.bouncingminds.flowplayer.streamer.OpenXVastAdStreamProvider;
	
	/**
	 * @author Paul Schulz
	 */
	public class OpenXVastAdStreaming extends Sprite implements PluginFactory {
		public function OpenXVastAdStreaming() {
		}

		/**
		 * A factory method to create the provider.
		 */
		public function newPlugin():Object {
			return new OpenXVastAdStreamProvider();
		}
	}
}