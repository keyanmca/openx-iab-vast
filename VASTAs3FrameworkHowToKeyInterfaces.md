The first thing you will notice about the JW Player plugin is that it implements three key interfaces:

```
import com.bouncingminds.vast.display.VideoAdDisplayController;
import com.bouncingminds.vast.model.TemplateLoadListener;
import com.bouncingminds.vast.tracking.TrackingEventListener;

public class OpenXAdStreamer 
       extends MovieClip 
       implements ... TemplateLoadListener, VideoAdDisplayController, TrackingEventListener {

       ....
}
```

The `TemplateLoadListener` interface provides the hooks that allows the VAST framework to call the player plugin when the VAST data has either been successfully loaded or if it's failed to load.

The `VideoAdDisplayController` interface provides a mechanism that allows the VAST framework to make a call back into the player plugin to tell it to display an ad type that requires control over the player canvas (e.g. popup an overlay style ad or push a companion banner to the webpage surrounding the player.

The `TrackingEventListener` interface ensures that the player mechanics around firing timer events can be hooked into the VAST tracking model. This interface isn't actually used by the JW Player plugin. It's only used when the video player in question supports an API that allows timed events to be individually set and fired. An example is Flowplayer's `cuepoint` API.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)