_**Note: The framework is in very early alpha form and as such the API is changing as overlay support is built into the JW Player plugin and the new Flowplayer plugin is developed - please use with a little caution**_

The VAST actionscript 3 framework can be used to produce custom player implementations.

To deliver OpenX video advertising to a custom player, 7 key steps need to be taken:

  * [Step 1](VASTAs3FrameworkHowToKeyInterfaces.md): Make sure that the key interface classes are integrated into your player class(es)

  * [Step 2](VASTAs3FrameworkHowToConfiguration.md): Read in the ad related configuration so that the framework knows what form of video advertising is to be delivered

  * [Step 3](VASTAs3FrameworkHowToTimeTracking.md): Hook in the player's time tracking mechanism to the framework so that the various ad related events can be fired at the right point in time

  * [Step 4](VASTAs3FrameworkHowToControlBar.md): Configure the control bar handling so that these events can be tracked via the framework and the OpenX ad server

  * [Step 5](VASTAs3FrameworkHowToDisplayCallbacks.md): Implement the required display related callback functions (declared in the `VideoAdDisplayController` interface) so that non linear video ads (e.g. overlays) and companions can be displayed

  * [Step 6](VASTAs3FrameworkHowToRequestVASTData.md): Add the code to make a request to the OpenX ad server (via the framework) to obtain the video ads for a given "ad schedule" - the result is a fully configured `StreamSequence` that splices the show and video ads together into an ordered list of streams to be played

  * [Step 7](VASTAs3FrameworkHowToPlaylists.md): Load the fully configured "stream sequence" into the player (manually through custom code or via a playlist) and play it

To illustrate how to use the VAST framework, we'll walk through the key implementation points for the JW Player plugin `OpenXAdStreamer`. Where major differences exist between the code for the JW Player and Flowplayer plugins, we'll attempt to illustrate those differences as we go.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)