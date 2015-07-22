# OpenXAdStreamer.swf #

The **OpenX Ad Streamer** is the plugin that is responsible for making a request to the OpenX Ad Server
to obtain the VAST description of the video ads to serve for a given set of programme streams. Once it has
that data, the streamer works out precisely how to sequence those ads to play as the main programme
stream(s) play.

To display overlay and non-overlay video advertising, the Ad Streamer talks to the [OpenX Regions](FlowplayerOpenXRegionsConfig.md) plugin that defines a series of "regions" that control the way the HTML based graphical advertising
and related messaging is displayed.

Finally the Ad Streamer is also responsible for tracking ads and showing streams as they play, reporting
the ad related tracking events to the OpenX ad server which in turn records and reports on them.

## Using the Ad Streamer ##

A wide range of configuration options are available to ensure that the Ad Streamer can sequence and
schedule just about any form of VAST compliant video advertising across any number of programme
streams. The following example is a more complex demonstration of the range of configuration options
available.

```
    ....
    plugins: {
        ....
        openXAdStreamer: {
            // THE PLUGIN SWF FILE
            url: 'flash/OpenXAdStreamer.swf',

            // MAIN PROGRAMME STREAMS 
            netConnectionURL: 'rtmp://rtmp.flowplayer.org/fastplay',
            streams: [ { file:'mp4:HCTV004830001A' , duration:'00:01:00' },
                       { file:'mp4:HCTV004830001B' , duration:'00:01:00' }
            ],
            
            // OPENX SERVER
            vastServerURL: 'http://demo.bouncingminds.com/openx/www/delivery_dev/spc.php',

            // AD DISPLAY
            disableControls: true,
            companionDivIDs: [ { id:'companion', width:150, height:360 } ],
            enablePopupVideoAds: true,

            // AD SCHEDULE
            adSchedule: [
                { 
                  zone: '2',
                  position: 'pre-roll',
                  duration: '30',
                  notice: { show: true, 
                            region: 'message', 
                            message: '&lt;p class="message" align="right"&gt;
                                           This advertisement runs for _seconds_ seconds
                                      &lt;/p&gt;' 
                  },
                  applyToParts: [ 0 ]
                },
                { 
                  zone: '6',
                  position: 'bottom',
                  width: 600,
                  height: 50,
                  startTime: '00:00:15',
                  duration: '15',
                  applyToParts: [ 0 ],
                  companionDivIDs: [ { id:'companion', width:150, height:360 } ]
                },
                { 
                  zone: '4',
                  position: 'post-roll',
                  duration: '30',
                  notice: { show: false }
                }
            ],
            
            // JAVASCRIPT CALLBACKS
            onTemplateLoaded: function() { buttonActions.templateLoaded(); },
            onCuepointInfo: function(data) { buttonActions.onCuepoint(data); }
        }
    }
```

In this example, 2 main programme streams are to be served (`HCTV004830001A` and `HCTV004830001A`).
As those two streams are played sequentially, a `30` second `pre-roll` ad with a `notice` is
to be sequenced before the first stream only. During the playback of the first programme stream, `00:00:15` seconds into the stream an overlay ad (that is allowed to start a video advertisement mid stream) is to be served in the `'bottom'` region for `15` seconds. An accompanying companion banner with the size `150 * 360` pixels
is to be displayed in a div block on the page identified as `companion`. Following both programme streams,  a `30` second `post-roll` video ad is to be served without an ad notice.

In addition, this example illustrates how to disable the control bar during ad play (`disableControls`) and react to javascript callbacks when the VAST template is loaded (`onTemplateLoaded`) or ad event cuepoints are fired (`onCuepointInfo`).

## Configuration Parameters ##

Below is a complete list of configuration options for the **Ad Streamer** plugin. Some options are only available at the general plugin level, while others are restricted to the `Ad Slot` level. General level configuration options are applied
across all `Ad Slots` unless otherwise specified.

| **Property name** | **Level** | **Version** | **Description** |
|:------------------|:----------|:------------|:----------------|
| `url`             | General   | 0.4.5       | The url of the OpenX Ad Streamer plugin |
| `streams`         | General   | 0.4.5       |  An array of stream definitions which identifies the main programme RTMP streams to be played by the player - ads are sequenced in accordance with the Ad Slot schedule against these streams. As the property is an array, the following format is expected `[ { stream1-name, stream1-duration }, ... { streamN-name, streamN-duration} ]`. The `stream-duration` must be declared in timestamp format `HH:MM:SS` (e.g. `01:10:15` for a duration of 1 hour 10 minutes and 15 seconds). |
| `vastServerURL`   | General   | 0.4.5       |  The url of the OpenX VAST server |
| `regionsPluginName` | General   | 0.4.5       |  The identifying name given to the Regions plugin in this player configuration. The default value is `openXRegions` |
| `disableControls` | Both      | 0.4.5       |  Specifies whether or not the stop/scrubber is to be disabled when ads are played. The default value is `true`. Can be overriden at the `Ad Slot` level. |
| `companionDivIDs` | Both      | 0.4.5       |  Identifies the companion div blocks that are to be used to display companion ads accompanying a video ad. An array of identifiers is expected in the format of `[ { id:Z, width:X, height:Y }, ... { id:Z, width:X, height:Y } ]` allowing multiple companion div blocks to be specified across the web page. The `id` value must match the div block `id` in the web page. The `width` and `height` values are used by the plugin to identify which companion (specified in the VAST template) is to be shown in each div block. |
| `enablePopupVideoAds` | General   | 0.4.5       |  Specifies whether or not a video ad can be started from an overlay or non-overlay ad. Default value is `true` |
| `adSchedule`      | General   | 0.4.5       |  Allows a range of `ad spots` to be specified. Each `ad spot` is a unique definition of a particular type of video ad to be played against the programme stream. For example, if a `pre-roll`, `mid-roll` and `post-roll` video ad were to be scheduled when a stream plays, three individual ad spots would have to be defined - one for each video ad type. If a `pre-roll` and `overlay` were to be scheduled, 2 unique `Ad Spot` definitions are required. Ad Spot definitions can be limited to a particular "stream" or duration, and in the case of overlay/non-overlay video ads, can be scheduled to start at a particular time during a programme stream. Ad Spots are defined as an array with the format `[ { adspot1-options }, ... { adSpotN-options} ]`. Each `Ad Spot` definition must define at least a `zone`, `position` and `duration`. In addition, Overlay and Non-Overlay ads must also define a `width` and `height`. |
| `zone`            | AdSpot    | 0.4.5       |  The OpenX `zone` mapping to this ad spot. Zones are special constructs in the OpenX Ad Server. Please see the OpenX ad server documentation for more details. |
| `position`        | AdSpot    | 0.4.5       |  The position of this ad - can be one of the following values: for linear ads `pre-roll`, `mid-roll`, `post-roll`, for non-linear overlay and non-overlay ads, the value must be specified as a region ID. |
| `duration`        | AdSpot    | 0.4.5       |  The duration of the ad - mandatory in the case on time restricted non-linear overlay and non-overlay ads. The value is specified as a number of seconds or `'unlimited'` if the ad is to play for the entire duration of the programme stream. The default value is `'unlimited'`. |
| `notice`          | AdSpot    | 0.4.5       |  Identifies whether or not a special notice is to be displayed when a video ad plays. For example, wording such as "This advertisement runs for 30 seconds" may be displayed. Notices are declared in the format `{ show: value, region: value, message: value}` where `show` is a `true` or `false` value, `region` is the `id` of the region where the message is to be shown and `message` is a HTML text block that specifies what to show. The `message` can contain a keyword `_seconds_` to allow the duration of the ad to be placed into the text when the message is shown. Any class styling defined in the `message` must be declared as available in the associated `region` declaration. |
| `selectionCriteria` | General   | 0.4.5       |  Allows the selection of an ad to be refined by a specific selection. An example is `selectionCriteria: [ { name:"age", value:"25" }, { name:"gender", value:"male" } ]` - this definition will tell OpenX to restrict ad selection based on an age and gender value (but only if these have been configured on the openX side). The format for the `selectionCriteria` field is an array of objects with each object specifying a field `name` and `value` to pass through  |
| `applyToParts`    | AdSpot    | 0.4.5       |  Allows an ad spot declaration to be restricted to a specific set of programme streams. The value is specified as an array of integers between 0 and the number of programme streams declared. For example if an Ad Spot is to be limited to only the first stream, a value of `[0]` would be declared. To limit a spot to the second and third streams `[2,3]` would be declared and so forth. |
| `width`           | AdSpot    | 0.4.5       |  The width of the ad spot - applicable for non-linear overlay/non-overlay ads which are bound by strict dimensions. An ad must be found in the VAST data to match this width to ensure that it is displayed.|
| `height`          | AdSpot    | 0.4.5       |  The height of the ad spot - applicable for non-linear overlay/non-overlay ads which are bound by strict dimensions. An ad must be found in the VAST data to match this width to ensure that it is displayed. |
| `startTime`       | AdSpot    | 0.4.5       |  The time an ad is to start - used by mid-roll and non-linear ads to identify when an ad is to be started during the programme stream. The value must be specified in the form of a timestamp `'HH:MM:SS'` |
| `onTemplateLoaded` | General   | 0.4.5       |  The javascript callback triggered when the VAST data is loaded |
| `onStreamSequenced` | General   | 0.4.5       |  The javascript callback triggered once the programme and ad stream has been successfully formed |
| `onAdStart`       | General   | 0.4.5       |  The javascript callback triggered when a video ad starts |
| `onAdPause`       | General   | 0.4.5       |  The javascript callback triggered when a video ad is paused |
| `onAdResume`      | General   | 0.4.5       |  The javascript callback triggered when a video ad is resumed |
| `onAdStop`        | General   | 0.4.5       |  The javascript callback triggered when a video ad stops |
| `onAdEnd`         | General   | 0.4.5       |  The javascript callback triggered when a video ad completes |
| `onCuepointInfo`  | General   | 0.4.5       |  The javascript callback triggered when a tracking event triggers |
| `onAdClick`       | General   | 0.4.5       |  The javascript callback triggered when a video ad is clicked |
| `onAdClose`       | General   | 0.4.5       | The javascript callback triggered when a video ad is closed |
| `removeFileExtension` | General   | 0.4.8       | Forces removal of file extensions for video stream file names returned in the VAST data - particularly useful for ensuring that FLV streams play on an FMS |

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)