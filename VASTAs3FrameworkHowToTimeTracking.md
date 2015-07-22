Once the configuration data has been successfully loaded, the next step that must be taken is to setup the mechanism that will be used by the framework to track time based events as the stream(s) play.

Timed events are used by the VAST framework to identify when mid roll and non-linear ads (e.g. overlays) are to be displayed. They are also used to identify when tracking events (`start`, `1st quartile`, `mid point`, `3rd quartile` and ad `complete`) are to be dispatched by the framework to be logged by the OpenX server.

When the VAST framework loads the ad data from the OpenX server it creates a time tracking table that lists all of the ad related events that are to be tracked as the streams are played. When a call is made to the VAST framework to `processTimeEvent`, this tracking table is reviewed to see if the point in time matches anything that is listed in that table. If the time matches the related VAST event is fired and this may result in a related interface callback method being called (for instance `VideoAdDisplayController.displayCompanionAd` if it's time to display a companion ad).

Different players allow time based events to be tracked and processed in different ways. For example:

  * JW Player allows a listener interface to be registered to receive callbacks every 10th of a second - these callbacks are fired every 10th of a second and it is up to the VAST framework to determine if they map to a point in time that is relevant for the streams and ads being played
  * Flowplayer alternatively allows "cuepoints" to be set on a clip at a precision of 1000th of a second - when the specified point in time occurs the Flowplayer "cuepoint" API is called so that the event can be processed - in this model, the VAST framework only receives a callback at specific points in time that actually map to specifically defined events

### Tracking Time in JW Player ###

In JW Player, to forward time based events to the VAST framework to be analysed and actioned (where required), a model listener for the `TIME` event must be registered:

```
_view.addModelListener(ModelEvent.TIME, timeHandler);
```

This listener above uses a method called `timeHandler` which is declared as follows:

```
private function timeHandler(evt:ModelEvent):void {
    if(_streamSequence != null) {
       _streamSequence.processTimeEvent(_activeStreamIndex, new TimeEvent(evt.data.position * 1000, evt.data.duration));
    }
}
```

The `timeHandler` method identifies whether or not a VAST stream sequence (`StreamSequence`) has been loaded. If it has, it forwards the time event to the sequence to be processed.

The `StreamSequence` class is a key class in the framework. When a VAST response is processed by the framework, it produces a `StreamSequence`. A `StreamSequence` is a sequenced set of video streams (both show and ad streams) that are ordered based on the AdSchedule defined in the configuration data loaded into the player.

Playlists can be derived from the `StreamSequence` and loaded into the player. As those streams play, time based events are forwarded to the `StreamSequence` to be processed and actioned.

A `StreamSequence` has an public method called `processTimeEvent`. This method takes two parameters:

  1. The index of the stream (`_activeStreamIndex`) against which the time event is to be applied
  1. A `TimeEvent` which holds two values - the actual time (in milliseconds) and the duration of the time event

Keeping track of the active stream index as the playlist is processed is critical to ensuring that timed events are appropriately processed.

In JW Player, time is reported relative to each clip in the playlist - so when a new clip is started, time is reset to 0.

So, when a time event is passed to the VAST framework, the index of the stream against which that event is to be assessed must be provided.

To keep track of the active stream index for a playlist, the following listener is activated:

```
_view.addControllerListener(ControllerEvent.ITEM, playlistSelectionHandler);	
```

`playlistSelectionHandler` is called whenever a `change item event` occurs on the playlist. The function then explicitly saves the active clip index from the playlist as `_activeStreamIndex`. This value is then passed to `StreamSequence.processTimeEvent()` when a time event occurs in JW Player every 10th of a second.

```
private function playlistSelectionHandler(evt:ControllerEvent):void {
    _activeStreamIndex = evt.data.index;
    doLog("Active playlist stream index changed to " + _activeStreamIndex, DebugObject.DEBUG_PLAYLIST);
}
```

### Tracking Time in Flowplayer ###

_To be completed when the Flowplayer HTTP plugin is released_

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)