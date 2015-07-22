# OpenXAdStreamer.swf #

The **OpenX Ad Streamer** is the plugin that is responsible for making a request to the OpenX Ad Server
to obtain the VAST description of the video ads to serve for a given set of programme streams. Once it has
that data, the streamer works out precisely how to sequence the ads and show streams.

The final list of ad and show streams is specified as an XSPF Playlist that is created and managed by the ad streamer plugin.

As the plugin manages the loading and progression through the playlist, it coordinates the process of enabling/disabling the control bar and reporting on ad tracking events to the OpenX Ad Server.

## Using the Ad Streamer ##

A wide range of configuration options are available to ensure that the Ad Streamer can sequence and
schedule just about any form of VAST compliant video advertising across any number of programme
streams.

The configuration options can be specified via the `flashvars` config variable, or via an XML file that is loaded `config=_config_file_` flashvar.

For example, the configuration below instructs JW Player to load up the config from the XML file called `rtmp05.xml`:

```
<object id="ply" width="400" height="260" type="application/x-shockwave-flash" name="ply" data="../dist/4.5.swf">
    <param name="allowfullscreen" value="true"/>
    <param name="allowscriptaccess" value="always"/>
    <param name="flashvars" value="height=260&width=400&plugins=../dist/OpenXAdStreamer.swf&config=rtmp05.xml"/>
</object>
```

`rtmp05.xml` is defined as follows:

```
<config>
    <openxadstreamer.title>
        Example 05
    </openxadstreamer.title>
    <openxadstreamer.netconnectionurl>
	rtmp://ne7c0nwbit.rtmphost.com/videoplayer
    </openxadstreamer.netconnectionurl>
    <openxadstreamer.vastserverurl>
    	http://openx.bouncingminds.com/openx/www/delivery/fc.php
    </openxadstreamer.vastserverurl>
    <openxadstreamer.streams>
        [ { "file":"bbb_640x360_h264.mp4", "duration":"00:01:00", "reducedLength":true } ]
    </openxadstreamer.streams>
    <openxadstreamer.bitrate>
    	any
    </openxadstreamer.bitrate>
    <openxadstreamer.companions>
        [ { "id":"companion", "width":"150", "height":"360" } ]
    </openxadstreamer.companions>
    <openxadstreamer.adschedule>
    	[
           {
              "zone": "4",
              "position": "pre-roll",
              "playOnce": true
           },
           {
              "zone": "1",
              "position": "mid-roll",
              "startTime": "00:00:10",
              "playOnce": true
           },
           {
              "zone": "1",
              "position": "post-roll",
              "playOnce": true
           }
    	]
    </openxadstreamer.adschedule>
    <openxadstreamer.debuglevel>
    	fatal, segment_formation, playlist, vast_template
    </openxadstreamer.debuglevel>
</config>
```

In this example, a single show stream (`bbb_640x360_h264.mp4`) is scheduled to play for a duration of a minute (`00:01:00`). Three ads are scheduled to play - a pre-roll, a mid-roll and a post-roll video ad. The mid-roll video ad is to play 10 seconds into the main show stream.

The first ad - the pre-roll, is of zone type '4' which has a companion ad. That will be displayed in the `div` with an id of `companion`.

Each ad is instructed to play "only once". If the user replays the stream, the ads will not be shown a second time.

## Configuration Parameters ##

Below is a complete list of configuration options for the **Ad Streamer** plugin. Some options are only available at the general plugin level, while others are restricted to the `Ad Slot` level. General level configuration options are applied
across all `Ad Slots` unless otherwise specified.

| **Property name** | **Level** | **Description** |
|:------------------|:----------|:----------------|
| `openxadserver.streams` | General   | An array of stream definitions which identifies the main programme RTMP streams to be played by the player - ads are sequenced in accordance with the Ad Slot schedule against these streams. As the property is an array, the following format is expected `[ { stream1-name, stream1-duration }, ... { streamN-name, streamN-duration} ]`. The `stream-duration` must be declared in timestamp format `HH:MM:SS` (e.g. `01:10:15` for a duration of 1 hour 10 minutes and 15 seconds). |
| `openxadserver.vastserverurl` | General   | The url of the OpenX VAST server |
| `openxadserver.disablecontrols` | General   | Specifies whether or not the stop/scrubber is to be disabled when ads are played. The default value is `true`. Can be overriden at the `Ad Slot` level. |
| `openxadserver.companions` | General   | Identifies the companion div blocks that are to be used to display companion ads accompanying a video ad. An array of identifiers is expected in the format of `[ { id:Z, width:X, height:Y }, ... { id:Z, width:X, height:Y } ]` allowing multiple companion div blocks to be specified across the web page. The `id` value must match the div block `id` in the web page. The `width` and `height` values are used by the plugin to identify which companion (specified in the VAST template) is to be shown in each div block. |
| `openxadserver.netconnectionurl` | General   |                 |
| `openxadserver.bitrate` | General   |                 |
| `openxadserver.playonce` | General   |                 |
| `openxadserver.adSchedule` | General   | Allows a range of `ad spots` to be specified. Each `ad spot` is a unique definition of a particular type of video ad to be played against the programme stream. For example, if a `pre-roll`, `mid-roll` and `post-roll` video ad were to be scheduled when a stream plays, three individual ad spots would have to be defined - one for each video ad type. If a `pre-roll` and `overlay` were to be scheduled, 2 unique `Ad Spot` definitions are required. Ad Spot definitions can be limited to a particular "stream" or duration, and in the case of overlay/non-overlay video ads, can be scheduled to start at a particular time during a programme stream. Ad Spots are defined as an array with the format `[ { adspot1-options }, ... { adSpotN-options} ]`. Each `Ad Spot` definition must define at least a `zone`, `position` and `duration`. In addition, Overlay and Non-Overlay ads must also define a `width` and `height`. |
| `zone`            | AdSpot    | The OpenX `zone` mapping to this ad spot. Zones are special constructs in the OpenX Ad Server. Please see the OpenX ad server documentation for more details. |
| `position`        | AdSpot    | The position of this ad - can be one of the following values: for linear ads `pre-roll`,  `mid-roll`, `post-roll`, for non-linear overlay and non-overlay ads, the value must be specified as a region ID. |
| `duration`        | AdSpot    | The duration of the ad - mandatory in the case on time restricted non-linear overlay and non-overlay ads. The value is specified as a number of seconds or `'unlimited'` if the ad is to play for the entire duration of the programme stream. The default value is `'unlimited'`. |
| `notice`          | AdSpot    | Identifies whether or not a special notice is to be displayed when a video ad plays. For example, wording such as "This advertisement runs for 30 seconds" may be displayed. Notices are declared in the format `{ show: value, region: value, message: value}` where `show` is a `true` or `false` value, `region` is the `id` of the region where the message is to be shown and `message` is a HTML text block that specifies what to show. The `message` can contain a keyword `_seconds_` to allow the duration of the ad to be placed into the text when the message is shown. Any class styling defined in the `message` must be declared as available in the associated `region` declaration. |
| `applyToParts`    | AdSpot    | Allows an ad spot declaration to be restricted to a specific set of programme streams. The value is specified as an array of integers between 0 and the number of programme streams declared. For example if an Ad Spot is to be limited to only the first stream, a value of `[0]` would be declared. To limit a spot to the second and third streams `[2,3]` would be declared and so forth. |
| `width`           | AdSpot    | The width of the ad spot - applicable for non-linear overlay/non-overlay ads which are bound by strict dimensions. An ad must be found in the VAST data to match this width to ensure that it is displayed.|
| `height`          | AdSpot    | The height of the ad spot - applicable for non-linear overlay/non-overlay ads which are bound by strict dimensions. An ad must be found in the VAST data to match this width to ensure that it is displayed. |
| `startTime`       | AdSpot    | The time an ad is to start - used by mid-roll and non-linear ads to identify when an ad is to be started during the programme stream. The value must be specified in the form of a timestamp `'HH:MM:SS'` |
| `playOnce`        | AdSpot    |                 |

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)