The `VideoAdDisplayController` interface offers a range of methods that allow a player to hook into the framework so that it can appropriately display:

  * Non-linear overlay ads
  * Non-linear non-overlay ads
  * Ad notices such as "this is an advertisement"
  * Turn the seeker (scrubber) on/off

_Note: A general framework is being created now to allow overlays to be displayed on a flash player canvas. You will be able to use this framework shortly to display non-linear advertising and notices in a standard manner in your custom player_

### Displaying Overlay Ads ###

Two methods are declared by the `VideoAdDisplayController` to control the display of overlay ads:

```
function displayNonLinearOverlayAd(displayEvent:VideoAdDisplayEvent):void;
function hideNonLinearOverlayAd(displayEvent:VideoAdDisplayEvent):void;
```

When an overlay ad is to be displayed, `displayNonLinearOverlayAd` is called.

When an overlay ad is to be hidden, `hideNonLinearOverlayAd` is called.

The actual `ad` can be extracted from the event via the `VideoAdDisplayEvent.ad` attribute. For example:

```
var overlayAd:NonLinearVideoAd = displayEvent.ad as NonLinearVideoAd;
```

### Displaying Non-Overlay Ads ###

Two methods are declared by the `VideoAdDisplayController` to control the display of overlay ads:

```
function displayNonLinearNonOverlayAd(displayEvent:VideoAdDisplayEvent):void;
function hideNonLinearNonOverlayAd(displayEvent:VideoAdDisplayEvent):void;
```

When a non-overlay ad is to be displayed, `displayNonLinearNonOverlayAd` is called.

When a non-overlay ad is to be hidden, `hideNonLinearNonOverlayAd` is called.

The actual `ad` can be extracted from the event via the `VideoAdDisplayEvent.ad` attribute. For example:

```
var nonOverlayAd:NonLinearVideoAd = displayEvent.ad as NonLinearVideoAd;
```

### Displaying Ad Notices ###

```
function showAdNotice(displayEvent:VideoAdDisplayEvent):void;
function hideAdNotice(displayEvent:VideoAdDisplayEvent):void;
```

### Displaying Companion Ads ###

Two methods are declared by the `VideoAdDisplayController` to control the display of companion ads:

```
function displayCompanionAd(displayEvent:VideoAdDisplayEvent):void;
function hideCompanionAd(displayEvent:VideoAdDisplayEvent):void;
```

When a companion ad is to be displayed, `displayCompanionAd` is called.

When a non-overlay ad is to be hidden, `hideCompanionAd` is called.

The actual `ad` can be extracted from the event via the `VideoAdDisplayEvent.ad` attribute. For example:

```
var companionAd:CompanionAd = displayEvent.ad as CompanionAd;
```

To obtain the markup to insert into the page containing the player, the following code snippet can be used:

```
var htmlToInsert:String = companionAd.getMarkup();
```

### Turning the Seeker Bar On/Off ###

When linear ads are played, the seeker bar (or scrubber as it is also referred too) should be disabled. When an ad starts playing, the `VideoAdDisplayController.toggleSeekerBar()` interface is called to allow player specific code to be implemented to turn the seeker bar on and off.

The following code snippet illustrates how this is done in the JW Player plugin:

```
public function toggleSeekerBar(enable:Boolean):void {
    if(_openXConfig.disableControls) {
        var controlbar:Object = _view.getPlugin('controlbar');
        controlbar.block(!enable);
    }
}
```

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)