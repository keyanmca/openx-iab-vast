To create a test page that pulls the VAST data from the Bouncing Minds demo server while serving the
video ads from the CDN used for all examples on this site, do the following:

  1. [Download](http://openx-iab-vast.googlecode.com/files/bouncingminds.openX.flowplayer.rtmp.bin-latest.tar.gz) the OpenX Flowplayer RTMP video ad binaries (SWF) and javascript files
  1. Create a blank html page - the code examples below assume the blank page is created in the root directory of the downloaded plugin page (where `dist` is a subdirectory containing the swf and javascript files)
  1. Add the following lines to include the required javascript files. JQuery is used, the Flowplayer 3.1 base javascript file and a small javascript file for the OpenX plugin
```
<script type="text/javascript" src="dist/jquery-1.3.1.min.js"></script>
<script type="text/javascript" src="dist/flowplayer-3.1.0.min.js"></script>
<script type="text/javascript" src="dist/flowplayer-openx-0.4.3.js"></script>
```

  1. Add the following style definition - this will be used to style the container for the flowplayer instance
```
<style type="text/css">
a.example {
	display:block;
	width:640px;
	height:360px;
	text-align:center;
}
</style>
```

  1. Add in the anchor that is the container for the flowplayer instance
```
<a class="example"></a>
```

  1. Finally add in the javascript to configure the OpenXAdStreamer and Flowplayer
```
<script type="text/javascript">
flowplayer("a.example", "dist/flowplayer-3.1.0.swf", {

    // identifies that we have just 1 item to play - the configured OpenXAdStreamer
    // "main" is a pre-defined name for the URL that must be given to all instances 
    // of the OpenXAdStreamer
    
    playlist: [
        {
            url: 'main',
            provider: 'openXAdStreamer'
        }
    ],
    
    // Two plugins are required to display OpenX Ads - the AdStreamer and the Regions
    // plugins. The AdStreamer is responsible for which ads are required, making calls
    // to the OpenX Ad Server to get the VAST data defining the ads to play as well
    // as tracking the progress of the ads. The Regions plugin is used to define the
    // various "regions" on the player screen that can be used to display non-linear
    // ad content and ad messages.
    
    plugins: {
        openXRegions: {
            url: 'dist/OpenXRegions-0.4.7.swf'    		
        },

        openXAdStreamer: {
            url: 'dist/OpenXAdStreamer-0.4.7.swf',
            
            // This is the base connection to the location of our ad and programme streams
            netConnectionUrl: 'rtmp://ne7c0nwbit.rtmphost.com/videoplayer',
            
            // This identifies which main programme streams are to be played, and the
            // duration of each. Any number of streams can be identified and ads are
            // sequenced against each
            
            streams: [ { file:'mp4:bbb_640x360_h264.mp4', duration:'00:09:56' } ],
            
            // The location of our OpenX Ad Server instance
            
            vastServerURL: 'http://openx.bouncingminds.com/openx/www/delivery/fc.php',

            // A definition of the ad schedule to be applied to the programme streams.
            // An ad schedule is a definition of one or more ad spots that are to 
            // filled by the OpenX Ad Server and played by the OpenXAdStreamer.
                        
            adSchedule: [
                { zone: '1',              // A 'zone' defined in our OpenX Ad server
                  position: 'pre-roll'    // Identifies that the ad is to be played pre-roll
                }
            ]
        }
    }
});
</script>
```

You can see a working example of this page [here](http://www.bouncingminds.com/plugins/flowplayer/openx/rtmp/step1-example.html).

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)