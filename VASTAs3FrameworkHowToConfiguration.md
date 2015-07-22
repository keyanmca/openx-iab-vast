When the player is initialised, the configuration data for the framework must be loaded.

Configuration information for the JW Player plugin is specified in an XML file that is identified in the `flashvars` variable set when JW player loads. For example, the following line tells JW Player to load the configuration from a file called `rtmp01.xml`

```
<param name="flashvars" value="height=260&width=400&plugins=../dist/OpenXAdStreamer.swf&config=rtmp01.xml"/>
```

`rtmp01.xml` contains the following configuration settings:

```
<config>
   <openxadstreamer.title>
        Example 01
   </openxadstreamer.title>
   <openxadstreamer.netconnectionurl>
        rtmp://ne7c0nwbit.rtmphost.com/videoplayer
   </openxadstreamer.netconnectionurl>
   <openxadstreamer.vastserverurl>
    	http://openx.bouncingminds.com/openx/www/delivery/fc.php
   </openxadstreamer.vastserverurl>
   <openxadstreamer.bitrate>
    	any
   </openxadstreamer.bitrate>
   <openxadstreamer.adschedule>
        [
             {"zone":"1", "position":"pre-roll"}
    	]
    </openxadstreamer.adschedule>
    <openxadstreamer.debuglevel>
    	all
    </openxadstreamer.debuglevel>
</config>
```

When JW Player initializes the plugin, it reads the configuration data from the XML file specified in the `flashvars` variable into a global `Object` called `config`.

`config` has been declared as follows in the JW Player plugin:

```
public var config:Object = {
   netconnectionurl: null,
   vastserverurl: null,
   streamList: null,
   bitrate: 'any',
   adschedule: null,
   debuglevel: 'fatal',
   notice: null,
   disablecontrols: null,
   streamtype: "mp4",
   deliverytype: "streaming",
   playformat: "single",
   playonce: "false",
   title: null,
   companions: null,
   displaycompanions: true
};
```

The following code creates an instance of an `OpenXConfig` object reading the configuration from the JW Player config `Object`.  The `OpenXConfig` class holds the full set of configuration data and is used throughout the framework to inform it as to how it is to behave as the ads are retrieved and played.

```
// Load up the config and configure the debugger
_openXConfig = new OpenXConfig(config);
doLogAndTrace("Configuration loaded as: ", _openXConfig);
```

Flowplayer alternatively allows configuration for it's player to be specified directly as a JSON based configuration as part of the javascript based player insertion code.

```
<script type="text/javascript">
flowplayer("a.example", "../dist/flowplayer-3.1.0.swf", {
    playlist: [
        {
            url: 'main',
            provider: 'openXAdStreamer'
        }
    ],
    
    plugins: {
        openXRegions: {
            url: '../dist/OpenXRegions-0.4.7.swf'    		
        },

        openXAdStreamer: {
            url: '../dist/OpenXAdStreamer-0.4.7.swf',
            netConnectionUrl: 'rtmp://ne7c0nwbit.rtmphost.com/videoplayer',
            vastServerURL: 'http://openx.bouncingminds.com/openx-2.8.2-rc5/www/delivery/fc.php',
            debugLevel: 'fatal, vast_template, tracking_events, http_calls',
            adSchedule: [
                { zone: '1',
                  position: 'pre-roll'
                }
            ]
        }
    }
});
</script>
```

To initialise the `OpenXConfig` class within a Flowplayer plugin, the following code segment is used:

```
override public function onConfig(model:PluginModel):void {
    _model = model;			
    _openXConfig = new PropertyBinder(new OpenXConfig(), null).copyProperties(model.config) as OpenXConfig;
    doLogAndTrace("Configuration loaded as:", _openXConfig, DebugObject.DEBUG_CONFIG);
}
```

One difference you'll notice between the way the configuration is specified for JW Player compared to Flowplayer is that the configuration variables are in different cases. For JW Player, all variables must be specified in lowercase (with the plugin name preceding them - e.g. `openxadstreamer.adschedule`) while for Flowplayer, a mixed case variable name is specified (e.g. `adSchedule`). Flowplayer is not case sensitive, while JW Player is case sensitive requiring all configuration variables to be in lowercase.

The `OpenXConfiguration` class understands that either case may be specified and recognizes the variable accordingly.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)