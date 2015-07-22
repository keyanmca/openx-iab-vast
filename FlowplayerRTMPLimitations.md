The following limitations in functionality exist for this release:

  * All linear video ads must be deliverd via RTMP (and an Flash Media Server such as Red5, Adobe etc.) -  support for HTTP download will be available in a future release
  * Linear Interactive ads (e.g. Flash ads) are not supported at this time. To support these in a standard manner, we need to implement the Video Player-Ad Interface Definition (VPAID) - work is underway on this
  * Only 1 companion ad per video ad can be configured on the OpenX Server side at present. The player plugin supports multiple companions per page - a future version of the OpenX Server side will support multiple companions to be configured per video ad type
  * Only image and straight HTML based overlays have been tested at this time.
  * Non Linear Non Overlay Ad types have not been tested
  * The video reporting module for OpenX is being built and will be available with the public beta
  * Currently there are two plugins for the OpenX Server - a VAST plugin and a logging plugin - these are being merged into a single plugin
  * For any one instance of the OpenXAdStreamer running in Flowplayer, any ads and show steams scheduled to play in that instance must be addressable via the same base RTMP NetConnection. It is possible to serve ads and show streams from different FMS servers but they have to be scheduled in different instances of the player plugin. See [example 10](FlowplayerRTMPExamples.md) for a worked illustration of how to achieve this
  * Flowplayer 3.1.1 causes replay to fail if 'overlay click to video' used - fails when popup clip hit - need to move to the new 3.1.1 instream API to resolve the problem
  * It's not possible to have a mid-roll linear video ad on a live stream within separating the config into 3 seperate ad streams - live, mid-roll and then live. One ad streamer configuration will not work

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)