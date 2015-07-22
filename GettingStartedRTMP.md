If you are using RTMP based stream deliver, to get the beta up and running, it is recommended that you systematically walk through the following steps (if you wish to use HTTP download ad delivery, please read [here](GettingStartedHTTPDownload.md)):

<img src='http://static.bouncingminds.com/images/openx-iab-vast/VideoAdsBlockDetail5.png' border='0' width='700' />

  1. Overview
    * Familiarise yourself with the key [terminology and concepts](KeyTerminology.md)
    * Review the material on this site - specifically the [examples](FlowplayerRTMPExamples.md) to get a handle on all of the options available
  1. Get a simple video playing
    * Start simple - create a test page that will request a pre-roll video ad from the Bouncing Minds demo OpenX Ad Server before playing the ad and the show streams off the same Content Delivery Network (CDN) used by the examples on this site. To complete this task [follow these steps](Step1CreatePage.md)
  1. Make your video ads available for streaming
    * Before you proceed any further, make sure that you upload a few video ads and programme streams up and running on a Flash Media Server. These need to be served via RTMP - you can either use:
      * a local install of an FMS
      * a Content Delivery Network (CDN) such as Limelight, Akamai, SimpleCDN or Influxis.
    * If you need a few example linear video ads, you can find several [here](TestAds.md)
  1. Install the Ad platform
    * install OpenX Ad platform and the openXvideoAds plugin using these  [instructions here](http://code.google.com/p/openx-iab-vast/wiki/InstallingOpenXServerVideoPlugin)
  1. Configure the Ad platform
    * Now that OpenX is running with the Video Ads plugin, and given that you have loaded up some video ads to serve, you can configure your own ad "zones" to serve.  Follow these steps to complete this activity [documented here in this site](SettingUpYourFirstOpenXCampaign.md) or [here on the OpenX site](https://developer.openx.org/wiki/display/DOCS/OpenX+Video+Plugin+Beta+--+Documentation).
  1. Setup crossdomain.xml
    * Before you can connect Flowplayer with the OpenX Ad Streamer to your new OpenX instance, you need to ensure that you have an appropriate "crossdomain.xml" file configured in the doc root of the webserver on the box running the OpenX Ad Server. If you don't do this, when the OpenX Ad Streamer makes a request to the OpenX Ad Server to obtain the VAST data, a security violation will be thrown within Flash and the request will be denied. Here's an example [crossdomain.xml](ExampleCrossdomainXML.md) file that you can use.
  1. Configure your player to call the Ad platform
    * You're almost there. Change the test page that you originally created so that it now points to your OpenX Ad Server instance and the linear video ad "zone" that you created. For:
      * Flowplayer: Follow these [instructions](Step2ChangeTestPage.md) to complete this task. Remember, in this example both the video ad and the main programme stream must be served from the same Flash Media Server location, so ensure that you have a programme stream loaded up on the same RTMP server that you are serving the video ads.
      * Longtail Video's JW Player: Follow these [instructions](JWPlayerRTMPStep2ChangeTestPage.md) to complete this task.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)