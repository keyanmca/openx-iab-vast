# Step 2 - Change the Test Page #

To modify your test page to use the data in your newly installed OpenX instance and the zones that you defined:

  1. Edit the test HTML page
  1. Modify the OpenX server URL so that it points to your instance
```
<script language="JavaScript">
flowplayer("a.example", "dist/flowplayer-3.1.0.swf", {
    ....
        
    plugins: {
        ....
        
        openXAdStreamer: {
            ....
            
            // CHANGE HERE: this URL to point to your OpenX Ad Server instance 
                      
            vastServerURL: 'http://openx.bouncingminds.com/openx/www/delivery/fc.php',
            
            ....
        }
    }
});
</script>
```
  1. Modify netConnectionURL so that it points to the base location of your FMS/CDN server:
```
<script language="JavaScript">
flowplayer("a.example", "dist/flowplayer-3.1.0.swf", {
    ....
        
    plugins: {
        ....
        
        openXAdStreamer: {
            ....
            
            // CHANGE HERE: This is the base connection for the FMS server that hosts your 
            // ad and programme streams. Remember both must be accessible via the same base address
            
            netConnectionUrl: 'rtmp://ne7c0nwbit.rtmphost.com/videoplayer',
            
            ....
        }
    }
});
</script>
```
  1. Modify streams so that it points to the stream on your FMS/CDN server:
```
<script language="JavaScript">
flowplayer("a.example", "dist/flowplayer-3.1.0.swf", {
    ....
        
    plugins: {
        ....
        
        openXAdStreamer: {
            ....
            
            // CHANGE HERE: This identifies which main programme streams are to be played, 
            // and the duration of each. Any number of streams can be identified and ads are
            // sequenced against each. Identify your programme streams and the duration
            // of each
            
            streams: [ { file:'mp4:bbb_640x360_h264.mp4', duration:'00:09:56' } ],
            
            ....
        }
    }
});
</script>
```
  1. Ensure that the zone parameter is the zone id that matches the inline zone id you configured on your OpenX instance:
```
<script language="JavaScript">
flowplayer("a.example", "dist/flowplayer-3.1.0.swf", {
    ....
        
    plugins: {
        ....
        
        openXAdStreamer: {
            ....
            
            // CHANGE HERE: The zone id must match the inline video zone id you created in your OpenX install 
            ....
            adSchedule: [
                { zone: '22',              // A 'zone' defined in YOUR OpenX Ad server
                  position: 'pre-roll'    // Identifies that the ad is to be played pre-roll
                }
            ]
        }
    }
});
</script>
```
  1. You can check that your OpenX instance is returning the VAST response by calling the following [url format](http://yourservername/path_to_openx_install/www/delivery/fc.php?script=bannerTypeHtml:vastInlineBannerTypeHtml:vastInlineHtml&zones=name%3DZONEID&nz=1&source=&r=14730862&block=1&format=vast&charset=UTF-8). You can see   [an example OpenX VAST response here](http://openx.bouncingminds.com/openx/www/delivery/fc.php?script=bannerTypeHtml:vastInlineBannerTypeHtml:vastInlineHtml&zones=try3%3D1&nz=1&source=&r=14730862&block=1&format=vast&charset=UTF-8). Remember you need to change have the correct ZONEID in the url.
  1. Fire up your test page - you should now see a pre-roll ad served from your OpenX instance along with your main programme stream

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)