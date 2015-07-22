**0.4.8 - July 24, 2009**

  * Issue where FLV ad plays sound but no image resolved. "metaData:false" must be specified in player config (see example 20)
  * FLV bug - mimeType did not work properly for ad media selection - works now
  * Red5 FLV tested - doesn't work as single ad streamer, need to split each part as separate instances across playlist
  * Volume 0 now fires mute tracking event
  * For 'Click to Website' functionality on overlays - pause video now default on click
  * Tracking events changed so that they never refire - once they've been fired, they will not fire again (e.g. if the ad is replayed)
  * Cleaned up the tracking events - for linear video, the following are now fired:
    1. => 'Started',
    1. => 'Viewed > 50%',
    1. => 'Viewed > 25%',
    1. => 'Viewed > 75%',
    1. => 'Completed',
    1. => 'Muted',
    1. => 'Unmuted',
    1. => 'Paused',
    1. => 'Resumed',
    1. => 'Fullscreen',
    1. => 'Stopped',
  * For overlays, I just fire the impression and tracking is fired on overlay click to show videos
  * Modified the "selectionCriteria" field to allow an array of values to be specified so multiple criteria can be sent
> through - can only be set at a general level - an example is
> > `selectionCriteria: [ { name:"age", value:"25" }, { name:"gender", value:"male" } ]`, (see example18)
  * New parameter added to allow file extension to be forcefully removed - "removeFileExtention: true|false" - false is default behaviour
  * Click through URL now activated when linear video played - user can click on the video to get to the advertiser website if a URL is provided in the VAST data
  * 'center' property for horizontal and vertical alignment implemented in the regions plugin (see example 20)

**0.4.7 - June 01, 2009**

  * Forced continuation of plugin through to main stream if VAST load fails (adSchedule will be ignored)
  * Stopped triggering impression tracking for companions and click-on-overlay played video ads
  * pause video on click to web - property added to adSlot definition - 'pauseOnClick: true|false'

**0.4.6 - May 22, 2009**

  * selectionCriteria: String config option added to allow specific ad selection information be passed to OpenX
  * allowAdRepetition: true|false config option added to cover the "block=0|1" param in the OpenX ad request - example 13
  * repeat: N option added to Ad Schedule definition to allow an Ad Spot to be repeated N times - example 13 added
  * adStreamType: mp4 (default) | flv config option added to allow video ad media file to be selected based on mime-type (video/x-mp4 or video/x-flv) - example 12
  * bitrate: 'n' | 'x-y' config option added to allow video ad media file to be selected based on bitrate - example 15
  * subscribe:true now supported to trigger FCSubscribe support for CDN live streams (see examples 6 and 11)
  * safety mechanism put in to stop tracking events firing within 5 seconds if repeated for any reason
  * Fix for millisecond timing issue with cuepoint firing on ad tracking events - cuepoints at values like 7750 would not fire - rounded to 7800 to fix
  * Cuepoints no longer set multiple times if stream is replayed - test added to check if already set
  * Use of single quotes in background image filenames and html fixed - replaced with {quote} in the config and fixed on reading in the JSON config
  * The OpenX URL used in the examples changed to `http://beta.bouncingminds.com/openx-2.8.1-rc7/www/delivery/fc.php`

**0.4.5 - April 26, 2009**

  * Ad scheduling for live streaming now working
  * Sponsorship configuration now working (see example with H&C bug being displayed during ads/streams)
  * Renamed "adSlots" OpenXVASTAdStreamer config item to "adSchedule"
  * Fixed all debug levels across the examples to just output 'fatal' errors
  * Removed the need to specify an "id" for an Ad Spot in the adSchedule - it is now optional - updated all examples to reflect this
  * Duration fix - if a duration is not specified (only for a live stream), indefinite is assumed
  * Relative directory path addressing fixed so stream filenames can now include a relative directory path. The path returned by OpenX is now split at the mp4: etc. marker
  * Added support for 'video/x-mp4' MIME type
  * Stop, Pause, Resume tracking implemented
  * Resolved issue where flowplayer was ignoring some cuepoints set at 500 milliseconds - extended first cuepoint timing to 1000 milliseconds minimum for BA/SS events etc.
  * Some improvement to the documentation
  * Test ads provided for download
  * The OpenX URL used in the examples changed to `http://beta.bouncingminds.com/openx/www/delivery/fc.php`

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)