A range of player events need to be tracked as linear video ads play. These include:

  1. MUTE - when the sound is turned off
  1. PLAY - when the play button is hit
  1. STOP - when the stop button is hit
  1. FULLSCREEN - when the player is put into fullscreen mode during an ad play

Other events such as REPLAY, PAUSE, RESUME etc. can also be tracked.

The `StreamSequence` class provides a range of methods that can be called when these events occur:

```
public function processPauseEventForStream(streamIndex:int):void;
public function processResumeEventForStream(streamIndex:int):void;
public function processStopEventForStream(streamIndex:int):void;
public function processFullScreenEventForStream(streamIndex:int):void;
public function processMuteEventForStream(streamIndex:int):void;
```

So it's just a case of wiring these methods to the event triggers in the player. The following code segment illustrates how this is done in JW Player. View listeners are added to the player for each of the relevant events.

```
_view.addViewListener(ViewEvent.MUTE, onMuteEvent);		
_view.addViewListener(ViewEvent.PLAY, onPlayEvent);		
_view.addViewListener(ViewEvent.STOP, onStopEvent);		
_view.addViewListener(ViewEvent.FULLSCREEN, onResizeEvent);
```

For example, when the user hits the stop button, the `onStopEvent` method is called. This method is declared as follows:

```
private function onStopEvent(evt:ViewEvent):void {
    _streamSequence.processStopEventForStream(_activeStreamIndex);
}
```

All the method does is call the `processStopEventForStream` method on the `StreamSequence` passing the `_activeStreamIndex` in play so that the stream sequence can determine what stream in the playlist the action is occurring within. If it's a linear ad, the appropriate tracking data will be sent to OpenX so that the fact that the stop button was hit will appear in the OpenX event tracking reports.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)