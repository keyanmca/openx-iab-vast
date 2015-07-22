# Introduction #

The current release can be built using either the [Flex IDE](http://www.adobe.com/products/flex) or [Ant](http://ant.apache.org). The source package contains ant
build files that will create the required SWFs given that the required build environment is setup.

# Building with Ant #

To build the release with Ant:
  * Make sure you have a fully operational [Flex SDK](http://www.adobe.com/products/flex/) build environment
  * Download the [Flowplayer 3.10 devkit](http://www.flowplayer.org)- rebuild that - if that works, you have a good base

By default, the OpenX plugin is configured to reference the `flowplayer.devkit/plugin-build.xml` file as
`../flowplayer.devkit/plugin-build.xml` so it's generally a good idea to locate the OpenX package
root dir at the same level as the Flowplayer dev kit root dir. If the OpenX plugin base directory
is in a different location, you will need to edit both the `regions-build.xml` and `streamer-build.xml`
file in the OpenX plugin package to reference the correct location for the "devkit-dir"

Check the build.properties file in the OpenX plugin source package and make sure that the
flex3dir points to your Flex 3 SDK base directory.

Now you are ready to build the distribution. Build the regions plugin with `ant -f regions-build.xml`
and the streamer plugin with `ant -f streamer-build.xml`. If all builds successfully, you will find
`OpenXAdStreamer.swf` and `OpenXRegions.swf` in the `build/dist` directory.

# Building with the Flex IDE #

To build with the Flex 3 IDE:
  * Make sure you have defined the additional compiler arguments:
    * `-keep-as3-metadata=Value,External -define=CONFIG::skin,'true'` - the first is required for the external interfaces that are defined on the plugins, the second is for the control bar
  * Include the `flowplayer.swc` and the control bar libraries (default etc.) as additional libraries.

# A Note on Debugging #

We use the [De MonsterDebugger](http://www.demonsterdebugger.com) - you'll see it included in the source and the `DebugObject` declaration. Replace this with the standard flash debugger by changing the `DebugObject` declarations for `doLog()` and `doLogAndTrace()`

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)