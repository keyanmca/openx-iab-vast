package com.bouncingminds.flowplayer.streamer {
	import com.bouncingminds.vast.display.VASTDisplayController;
	import com.bouncingminds.vast.display.VASTDisplayEvent;
	
	public interface OpenXDisplayController extends VASTDisplayController {
		function displayStaticAd(displayEvent:VASTDisplayEvent):void;
		function hideStaticAd(displayEvent:VASTDisplayEvent):void;
	}
}