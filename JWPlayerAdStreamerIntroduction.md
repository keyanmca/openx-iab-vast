The JW Player Ad Streamer is an implementation of an OpenX Ad Serving plugin for Longtail Video's JW Player.

The implementation uses the [generic VAST framework](VASTAs3FrameworkOverview.md).

Accordingly, the plugin is an implementation of a playlist controller that uses the generic VAST framework to request a VAST response from OpenX before forming an XSPF playlist that is fed into JW Player.

Playlist items can be either RTMP or HTTP based video streams.

View these [examples](JWPlayerOpenXExamples.md) to get a quick perspective on how to configure the JW Player Ad Streamer to deliver a variety of linear video, (overlay in development now) and companion ads.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)