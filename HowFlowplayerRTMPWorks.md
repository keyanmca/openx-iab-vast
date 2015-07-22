Ad scheduling is a skilled task. The successful deployment of an effective video advertising solution requires an
efficient Ad Server that manages the task of initiating, running and reporting on a video advertising campaign
while the video player sequences and plays back the video ads identified by the Ad Server.

The video ad streaming technology provided by this project works with the open-source Ad Server and video player providers to deliver a completely open-source, free solution.


<img src='http://static.bouncingminds.com/images/openx-iab-vast/VideoAdsBasicBlock4.png' border='0' width='400' />

To deploy the solution you will need to run:

  1. [Flowplayer](http://www.flowplayer.org) 3.1 (or later) (Flowplayer is Open Source)
  1. [OpenX](http://www.openx.org) (see for [install details](http://code.google.com/p/openx-iab-vast/wiki/InstallingOpenXServerVideoPlugin)) (OpenX is Open Source)
  1. The [OpenX Video Advertising](http://code.google.com/p/openx-iab-vast/wiki/InstallingOpenXServerVideoPlugin) **server side** plugin (This code is Open Source)
  1. A **video player side** plugin for Video Advertising (known as the [Ad Streamer](FlowplayerOpenXRTMPStreamerConfig.md)) (This is code is Open Source)

To kick start a Video advertising campaign using OpenX and the [Flowplayer RTMP Ad Streamer](FlowplayerOpenXRTMPStreamerConfig.md):

  1. Setup a video advertising campaign using OpenX. Define the campaign type, how long the video campaign is to run and any other rules that are to be used to dictate when and how the campaign is to be served.
  1. Ensure that the [video ad assets](TestAds.md) required by the campaign are loaded up onto an RTMP server. Graphical assets such as accompanying banner ads, overlays etc. can be served via a standard web server. The examples in this release use an RTMP server provided by a CDN (Influxis in our case). You can use a CDN or an in-house RTMP server such as the Flash Media Server, Red5 or Wowsa to serve your video ad streams.
  1. [Configure](FlowplayerOpenXRTMPStreamerConfig.md) the OpenX player side Ad Streamer plugin:
    * Declare an "Ad Schedule" that identifies the type of video ads to be sequenced with the main programme stream(s) and when each of these ad slots is to be played  - video ad types can include pre, mid, post roll video ads, overlay and non-overlay ads, and if accompanying companion ads are to be shown
    * Identify the div block(s) on the player page where the companion ads are to be (optionally) placed.
    * Mid roll video ads, overlay and non-overlay interactive ads may all be scheduled to play at a specific time and duration during the playback sequence.
    * If overlay ads or ad messaging is to be delivered, a second Flowplayer plugin known as the [Regions](FlowplayerOpenXRegionsConfig.md) plugin must also be [configured](FlowplayerOpenXRegionsConfig.md). The Regions plugin allows a set of display "regions" to be declared on the player canvas. When the "Ad Schedule" is declared for the ad streamer, overlay ad spots must be associated with a specific "region" to be displayed when the player is in play.

When a user loads a web page that contains Flowplayer and a configured OpenX Video Ad plugin:

  1. On startup, the player plugin reviews the "Ad Schedule" that has been defined (as JSON configuration for the player) before constructing a HTTP query for the ad server which will identify the type of video advertising required along with any (optional) additional information that helps the ad server to determine which video ads are best served at this time for a given video stream
  1. The Ad Streamer then makes the request to the OpenX Ad Server obtaining in response a template specifying the details of the video ads to be played. This template is known as a Video Ad Serving Template (VAST) as defined by the IAB.
  1. The Ad Streamer then parses the template, constructing an RTMP stream to play by sequencing together (in accordance with the Ad Spot schedule) the main show segments and linear video ads identified in the VAST data. Where non-linear (interactive overlay and non-overlay) advertising is to be shown (along with companion banners), the plugin defines a series of time-based cuepoints to execute as the sequenced stream plays, triggering the required non-linear advertising to show/hide accordingly via the Regions plugin.
  1. Cuepoints are set to track the ad and show segments as they play. Ads are tracked when they are served, started, pass the first quartile point, midpoint, 3rd quartile and end points, along with any pause and resume actions thay may occur along the way. Click throughs on overlay/non-overlay and companion banners are also tracked by the player and reported by the OpenX Ad Server.

You can find a good demonstration of all of this in action [here](http://www.flowplayer.org/plugins/advertising/openx.html).

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)