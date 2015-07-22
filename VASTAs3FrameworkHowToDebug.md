The framework can output a range of debug information as it runs.

To identify the debug information to output, a range of options can be specified in the `debugLevel` configuration parameter.

The following table identifies the various debug information categories that can be output:

| **parameter**  | **description** |
|:---------------|:----------------|
|  `all`         |  Prints all debug messages |
|  `vast_template` | Prints debug messages generated during requesting and parsing the VAST ad data |
|  `cuepoint_events` |  Prints all debug messages fired when cuepoints are triggered |
|  `segment_formation` |  Prints all debug messages generated when the stream sequence is formed |
|  `region_formation` |  Prints all debug messages associated with the construction of regions |
|  `cuepoint_formation` |  Prints all debug messages associated with establishing cuepoints |
|  `config`      |  Prints all debug messages generated as the config data is read |
|  `clickthrough_events` |  Prints debug messages associated with click through events |
|  `http_calls`  |  Prints all debug messages generated as HTTP calls are made |
|  `fatal`       |  Prints all debug messages marked as fatal |
|  `mouse_events` |  Prints all debug messages associated with mouse events |
|  `playlist`    |  Prints all debug messages generated as playlists are manipulated |
| `tracking_table` | Prints all debug messages tied to the tracking table |
| `display_events` | Prints all debug messages associated with non-linear ad display events |
| `tracking_events` | Prints all debug messages tied to tracking events |

By default, the framework uses the DeMonster debugger.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)