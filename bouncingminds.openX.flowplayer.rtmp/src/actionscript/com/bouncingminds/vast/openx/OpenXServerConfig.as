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
	import com.bouncingminds.util.DebugObject;
	
	/**
	 * @author Paul Schulz
	 */
	public class OpenXServerConfig extends DebugObject {
		public static var DEFAULT_NZ:String = "1";
		public static var DEFAULT_SOURCE:String = "";
		public static var DEFAULT_R:String = "21752080";
		public static var DEFAULT_BLOCK:String = "1";
		public static var DEFAULT_FORMAT:String = "vast";
		public static var DEFAULT_CHARSET_UTF8:String = "UTF_8";
		public static var DEFAULT_CHARSET_ISO8859:String = "ISO-8859-1";
		public static var DEFAULT_VAST_SERVER_URL:String = "http://localhost/vast";
		public static var DEFAULT_SCRIPT:String = "bannerTypeHtml:vastInlineBannerTypeHtml:vastInlineHtml";
		
		protected var _nz:String = DEFAULT_NZ;
		protected var _source:String = DEFAULT_SOURCE;
		protected var _r:String = DEFAULT_R;
//		protected var _block:String = null;
		protected var _format:String = DEFAULT_FORMAT;
		protected var _charset:String = DEFAULT_CHARSET_UTF8;
		protected var _zones:Array = new Array();
		protected var _vastServerURL:String = DEFAULT_VAST_SERVER_URL;
		protected var _script:String = DEFAULT_SCRIPT;
		protected var _referrer:String = null;
		protected var _selectionCriteria:String = null;
		protected var _allowAdRepetition:Boolean = false;
		
		public function OpenXServerConfig(vastServerURL:String=null,
		                                  script:String=null,
										  source:String=null, 
										  r:String=null, 
//										  block:String=null, 
										  format:String=null, 
										  charset:String=null, 
										  zones:Array=null,
										  referrer:String=null,
										  selectionCriteria:String=null,
										  allowAdRepetition:Boolean = false) {
			if(vastServerURL != null) _vastServerURL = vastServerURL;
			if(script != null) _script = script;
			if(source != null) _source = source;
			if(r != null) {
				_r = r;
			}
			else allocateR();
//			if(block != null) _block = block;
			if(format != null) _format = format;
			if(charset != null) _charset = charset;
			if(zones != null) _zones = zones;
			if(referrer != null) _referrer = referrer;
			if(selectionCriteria != null) _selectionCriteria = selectionCriteria;
			_allowAdRepetition = allowAdRepetition;
		}
		
		public function configure(config:OpenXServerConfig):void {
			if(config != null) {
				vastServerURL = config.vastServerURL;
				script = config.script;
				source = config.source;
				r = config.r;
//				block = config.block;
				format = config.format;
				charset = config.charset;
				referrer = config.referrer;
				if(config.selectionCriteria != null) _selectionCriteria = config.selectionCriteria;
				allowAdRepetition = config.allowAdRepetition;
			}
		}
		
		public function set script(script:String):void {
			_script = script;
		}
		
		public function get script():String {
			return _script;
		}
		
		public function set nz(nz:String):void {
			_nz = nz;
		}
		
		public function get nz():String {
			return _nz;
		}

		public function hasSelectionCriteria():Boolean {
			return (_selectionCriteria != null);	
		}
		
		public function set selectionCriteria(selectionCriteria:String):void {
			_selectionCriteria = selectionCriteria;	
		}

		public function get selectionCriteria():String {
			return _selectionCriteria;	
		}
		
		public function set allowAdRepetition(allowAdRepetition:Boolean):void {
			_allowAdRepetition = allowAdRepetition;
		}
		
		public function get allowAdRepetition():Boolean {
			return _allowAdRepetition;
		}
				
		public function set source(source:String):void {
			_source = source;
		}
		
		public function get source():String {
			return _source;
		}
		
		public function set r(r:String):void {
			_r = r;
		}
		
		public function get r():String {
			return _r;
		}
		
		public function allocateR():void {
			_r = new String(Math.random() * 10000000);			
		}

/*		
		public function set block(block:String):void {
			_block = block;
		}
		
		public function get block():String {
			return _block;
		}
*/
		
		public function set format(format:String):void {
			_format = format;
		}
		
		public function get format():String {
			return _format;
		}
		
		public function set charset(charset:String):void {
			_charset = charset;
		}
		
		public function get charset():String {
			return _charset;
		}
		
		public function set zones(zones:Array):void {
			_zones = zones;
		}
		
		public function get zones():Array {
			return _zones;
		}
		
		public function set referrer(referrer:String):void {
			_referrer = referrer;
		}
		
		public function get referrer():String {
			return _referrer;
		}
		
		public function set vastServerURL(vastServerURL:String):void {
			_vastServerURL = vastServerURL;
		}
		
		public function get vastServerURL():String {
			return _vastServerURL;
		}
	}
}