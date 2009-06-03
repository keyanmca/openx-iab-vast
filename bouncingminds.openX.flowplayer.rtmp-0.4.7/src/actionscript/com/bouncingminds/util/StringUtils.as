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
	public class StringUtils {
		public function StringUtils() {
		}

        public static function removeControlChars(string:String):String {
            var result:String = string;
            var resultArray:Array;
            // convert tabs to spaces
            result = result.split("\t").join(" ");
            // convert returns to spaces
            result = result.split("\r").join(" ");
            // convert newlines to spaces
            result = result.split("\n").join(" ");
            return result;
        }

        public static function compressWhitespace(string:String):String {
            var result:String = string;
            var resultArray:Array;
            resultArray = result.split(" ");
            for(var idx:uint = 0; idx < resultArray.length; idx++) {
                if(resultArray[idx] == "") {
                   resultArray.splice(idx,1);
                   idx--;
                }
            }
            result = resultArray.join(" ");
            return result;
        }
        
        public static function revertSingleQuotes(string:String, replacement:String):String {
			var quotePattern:RegExp = /{quote}/g;  
 			return string.replace(quotePattern, replacement);         	
        }
    }
}
