When the VAST data has been successfully returned from the Ad Server and loaded by the framework, the `onTemplateLoaded` method is called.

The VAST data is held in the `OpenXAdServer` instance as an `AdSequence`. An `AdSequence` is a series of `VideoAd` objects that map to the AdSchedule specified in the framework config.

An `AdSequence` can be turned into a `StreamSequence` by constructing a new `StreamSequence` passing the `AdSequence` to it along with the streams defined in the framework config to play along with the ads.

The following code segment illustrates how this is done:

```
private function loadPlaylist():Playlist {
    _streamSequence = new StreamSequence(this, 
                                         this, 
                                         _openXConfig.streams, 
                                         _openXAdServer.adSequence, 
                                         _openXConfig.bitrate, 
                                         _openXConfig.netConnectionURL, 
                                         100);
    var playlist:Playlist = PlaylistController.createPlaylist(_streamSequence, PlaylistController.PLAYLIST_FORMAT_XSPF);
    doLogAndTrace("XSPF playlist loaded: ", playlist.toString(), DebugObject.DEBUG_PLAYLIST);
    return playlist;
}

public function onTemplateLoaded():void {
    doLogAndTrace("VAST data loaded - ", _openXAdServer.template, DebugObject.DEBUG_FATAL);
    _playlist = loadPlaylist();
    _view.sendEvent(ViewEvent.LOAD, XSPFParser.parse(_playlist.nextTrackAsPlaylistXML()));
}
```

Once a `StreamSequence` has been constructed, a playlist can be derived and loaded into the player. The framework allows a number of different types of playlist to be constructed. At present, only the XSPF playlist format has been tested.

The `PlaylistController` class exists to take a `StreamSequence` and playlist format and return a `Playlist` instance of that type.

Playlists can be loaded into a player in full via the `Playlist.toXML()` method, or one clip at a time via the 'Playlist.nextTrackAsPlaylistXML()` which keeps track of the current playlist clip in play so that the player can iterate through the list loading a playlist with one clip in it at time.

Should the request to obtain the VAST data fail, the `onTemplateLoadError` method is called by the framework.

```
public function onTemplateLoadError(event:Event):void {
    doLog("FAILURE loading VAST template - " + event.toString(), DebugObject.DEBUG_FATAL);
}
```

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)