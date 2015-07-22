# The build.sh script #

A simple build script (build.sh) is provided in the build directory to compile the release.

Before using the build script, make sure that the FLEXPATH variable is set so that it correctly points to the location of your flex 3 sdk install.

To build the release:

> `./build.sh`

from the release "build" directory.

# A Note on Debugging #

We use the [De MonsterDebugger](http://www.demonsterdebugger.com) - you'll see it included in the source and the `DebugObject` declaration. Replace this with the standard flash debugger by changing the `DebugObject` declarations for `doLog()` and `doLogAndTrace()`

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)