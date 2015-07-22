This is an **early access beta release** of the OpenX Video Advertising technology.

This release runs video ads over RTMP using [OpenX](http://www.openx.org) and [Flowplayer](http://www.flowplayer.org).

An early access version for [Longtail's JW Player](http://www.longtailvideo.com) is also available. The JW Player version supports both RTMP and HTTP Download based ad delivery.

The release includes:

  * The source code for the Video Ad streaming and regions plugins
  * The Flash binaries (swf) for the plugin(s)
  * An initial set of documentation covering how to use the plugin to deliver Video Advertising
  * A set of worked examples that illustrate some of the different configuration options for the [Flowplayer](FlowplayerRTMPExamples.md) and [JW Player](JWPlayerOpenXExamples.md) video advertising plugin(s)

To use this release:

  * Download and install the latest version of [OpenX](http://code.google.com/p/openx-iab-vast/wiki/InstallingOpenXServerVideoPlugin) and follow the video plugin [installation](InstallingOpenXServerVideoPlugin.md) instructions to enable OpenX to serve video ads.

  * Download and install the video player that you wish to use:
    * [Flowplayer 3.1 or later](http://www.flowplayer.org/download/index.html)
    * [Longtail Video's JW Player 4.5 or later](http://www.longtailvideo.com)

If you want to build the release you'll need to download and install the [Flex 3 SDK](http://opensource.adobe.com/wiki/display/flexsdk) and the appropriate video player SDK before following the appropriate build notes for the [Flowplayer](FlowplayerRTMPBuildHowTo.md) or the [JW Player](JWPlayerBuildHowTo.md) Ad Streamer.

You can find:
  * The Flowplayer SDK [here](http://www.flowplayer.org/documentation/developer/writing-flash-plugins.html)
  * The Longtail Video JW Player Plugin SDK [here](http://developer.longtailvideo.com/trac/)

On the Flowplayer side, this release relies on the delivery of video advertising using RTMP on a Flash Media Server. As such, you'll need an operational FMS to host to serve the video ads. The examples provided in the release use an account with [Influxis](http://www.influxis.com).

For the Longtail Video plugin you can use your standard web server to serve the HTTP Download based video ads. If you choose to use RTMP with the Longtail plugin, you will require a Flash Media Server.

We will be resolving other defects that have been found in beta testing and considerably
improving the documentation as we go. At the moment, we're aiming to release an improved
version every 4 days or so.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)