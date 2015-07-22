Ad scheduling is a skilled task. The successful deployment of an effective video advertising solution requires an
efficient Ad Server that manages the task of initiating, running and reporting on a video advertising campaign
while the video player sequences and plays back the video ads identified by the Ad Server.

The video ad streaming technology provided by this project works with the open-source Ad Server and video player providers to deliver a completely open-source, free solution.

{insert diagram here}

To deploy the solution you will need to run:

  1. [Longtail Video's JW Player](http://www.longtailvideo.com) 4.5 (or later) (JW Player is Open Source)
  1. [OpenX](http://www.openx.org) (see for [install details](http://code.google.com/p/openx-iab-vast/wiki/InstallingOpenXServerVideoPlugin)) (OpenX is Open Source)
  1. The [OpenX Video Advertising](http://code.google.com/p/openx-iab-vast/wiki/InstallingOpenXServerVideoPlugin) **server side** plugin (This code is Open Source)
  1. A **video player side** plugin to serve the Video Advertising (known as the [Ad Streamer](JWPlayerOpenXAdStreamerConfig.md)) (This is code is Open Source)

To kick start a Video advertising campaign using OpenX and the [JW Player Ad Streamer](JWPlayerOpenXAdStreamerConfig.md):

  1. Setup a video advertising campaign using OpenX. Define the campaign type, how long the video campaign is to run and any other rules that are to be used to dictate when and how the campaign is to be served.
  1. Ensure that the [video ad assets](TestAds.md) required by the campaign are loaded up onto an RTMP or HTTP server. The JW Player Ad Streamer supports both RTMP and HTTP download based delivery of the video files. Graphical assets such as accompanying banner ads, overlays etc. can be served via a standard web server. The examples in this release use an RTMP server provided by a CDN (Influxis in our case). You can use a CDN or an in-house RTMP server such as the Flash Media Server or Wowsa to serve your video ad streams.
  1. [Configure](JWPlayerOpenXAdStreamerConfig.md) the OpenX video player side Ad Streamer plugin:
    * Declare an "Ad Schedule" that identifies the type of video ads to be sequenced with the main programme stream(s) and when each of these ad slots is to be played  - video ad types can include pre, mid, post roll video ads, overlay and non-overlay ads, and if accompanying companion ads are to be shown
    * Identify the div block(s) on the player page where the companion ads are to be (optionally) placed.
    * Mid roll video ads may be scheduled to play at a specific time and duration during the playback sequence.

When a user loads a web page that contains JW Player and a configured OpenX Video Ad Streamer plugin:

  1. On startup, the player plugin reviews the "Ad Schedule" that has been defined (as JSON configuration for the player) before constructing a HTTP query for the ad server which will identify the type of video advertising required along with any (optional) additional information that helps the ad server to determine which video ads are best served at this time for a given video stream
  1. The Ad Streamer then makes the request to the OpenX Ad Server obtaining in response a template specifying the details of the video ads to be played. This template is known as a Video Ad Serving Template (VAST) as defined by the IAB.
  1. The Ad Streamer then parses the template, constructing a XSPF playlist in accordance with the Ad Spot schedule.   # Cuepoints are set to track the ad and show segments as they play. Ads are tracked when they are served, started, pass the first quartile point, midpoint, 3rd quartile and end points, along with any pause and resume actions thay may occur along the way.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)