The VAST framework is an actionscript 3.0 implementation of a series of classes that:

  * Control calls to the OpenX ad server to request and retrieve any number of VAST compliant video ads
  * Manage the process of tracking timing events as ads play, triggering the appropriate action at the required time
  * Translation of a VAST ad request into an appropriate playlist format that can be loaded into a player and played

The framework is housed under the package:

> `com.bouncingminds.vast.*`

The following diagram illustrates the package structure of the framework:

<img src='http://static.bouncingminds.com/images/openx-iab-vast/vast-framework-architecture.png' border='0' width='500'>

There are 6 key packages that work together to request, parse and manipulate a VAST response from a VAST complaint ad server:<br>
<br>
<ol><li>The VAST <b>model</b>
</li><li>Ad <b>Schedule</b>
</li><li>Ad <b>Tracking</b>
</li><li><b>Playlist</b> management<br>
</li><li><b>Server</b> control<br>
</li><li><b>Display</b> management</li></ol>

<h3>1. The VAST Model Package</h3>

The Model package contains a series of classes that define the VAST data model. The VAST data returned by the VAST complaint ad server is parsed and a traversable model of the ad(s) is formed. This package forms the heart of the VAST framework:<br>
<br>
<ul><li><code>VideoAdServingTemplate</code> - the controller class that coordinates calls to and parsing of responses back from VAST compliant ad servers<br>
</li><li><code>VideoAd</code> - The high level grouping object that represents one video ad to play at some point within a stream. The grouping may contain a linear video ad and an associated companion ad(s), or a non-linear ad (e.g. overlay), optional associated linear ad (triggered when the overlay is clicked) and associated companion ad(s)<br>
<ul><li><code>TrackedVideoAd</code> - an individual video ad element that is to be tracked as it plays - there are three types of tracked video ad:<br>
<ul><li><code>LinearVideoAd</code> - represents the notion of a linear video ad (which is a <code>TrackedVideoAd</code>)<br>
<ul><li><code>MediaFile</code> - encapsulates the definition of the "media file" that is to be played as the linear video ad<br>
</li></ul></li><li><code>CompanionAd</code> - defines an associated display ad that is to be shown outside of the player (on the web page) as a linear or non-linear ad is played<br>
</li><li><code>NonLinearVideoAd</code> - encapsulates the notion of an overlay style (non-linear) video ad (that is also of type <code>TrackedVideoAd</code>)<br>
</li></ul></li><li><code>TemplateLoadListener</code> - the interface that must be implemented by a player to be notified when the VAST data has been loaded or a failure to load has occurred</li></ul></li></ul>

<h3>2. The Ad Schedule Package</h3>

When an ad schedule is declared it results in a sequence of ad slots being defined and sequenced. That sequence of ad slots is then spliced together with a sequence of show streams to play to form a list of streams (shows and ads) that are to be played. This package provides the classes to manage streams, ad slots and sequences of both:<br>
<br>
<ul><li><code>StreamConfig</code> - The configuration controller for a stream. Covers the storage and manipulation of the stream filename, location and where appropriate, the netconnection URL. Also covers properties such as the duration of the stream, the start time and whether or not it is only to be played once<br>
</li><li><code>StreamSequence</code> - a sequence of streams that are to run in order from position 0 to the last position. May hold either standard show streams or ad slots<br>
</li><li><code>Stream</code> - The base class that encapulates a video stream that is to be played<br>
</li><li>Ad specific stream classes:<br>
<ul><li><code>AdSlot</code> - a specific type of stream that holds a VAST compliant video ad<br>
</li><li><code>AdSequence</code> - a sequence of ad slots that are to be played in the order stored. Equates to the "ad schedule" that is declared in the player configuration</li></ul></li></ul>

<h3>3. The Ad Tracking Package</h3>

The play progress of a VAST ad is tracked via the framework. The tracking data is reported to the VAST compliant ad server according to the tracking URLs that it provides.<br>
<br>
The following events are tracked by the framework:<br>
<br>
<ul><li>The start and end of a linear video ad<br>
</li><li>Progression part the 1st, midpoint and third quartile of a linear video ad<br>
</li><li>Impressions are served for linear and non-linear video ads<br>
</li><li>User controlled actions such as mute, fullscreen and pause</li></ul>

The tracking package provides a series of classes that help manage the way these events are identified and tracked as the streams are played by the player.<br>
<br>
<ul><li>The <code>TrackingTable</code> holds a series of registered <code>TrackingPoint</code>(s) which are scheduled to occur as the stream plays<br>
</li><li>A <code>TrackingPoint</code> is a particular point in time that is held in the tracking table to identify a specific type of event which is expected to occur at that time (e.g. the time at which a video passes the 1st quartile point)<br>
</li><li>The <code>TrackingPointListener</code> is the interface to be implemented by the player where the player supports a mechanism to record tracking points and fire them at specific times (e.g. the cuepoint API in Flowplayer)<br>
</li><li>A <code>TimeEvent</code> occurs at a specific point in time and is passed into the TrackingTable to determine if there is a TrackingEvent scheduled to occur at that point in time</li></ul>

<h3>4. The Playlist Management Package</h3>

Ultimately the framework attempts to convert a VAST ad response into a viable playlist that can be loaded into the player.<br>
<br>
The Playlist Management Package provides a series of classes that control the construction and manipulation of playlists. These classes include:<br>
<br>
<ul><li><code>Playlist</code> - the interface for all Playlist type instances. The framework generates the following playlist types:<br>
<ul><li><code>MediaRSSPlaylist</code>
</li><li><code>XSPFPlaylist</code>
</li><li><code>RSSPlaylist</code>
</li><li><code> SMILPlaylist</code>
</li><li><code>XMLPlaylist</code>
</li></ul></li><li><code>PlaylistController</code> - the key controller class that manages the process of constructing a playlist of a specified type given a <code>StreamSequence</code></li></ul>

<h3>5. The Server Control Package</h3>

The Server Control Package provides the classes needed to make requests to the OpenX Ad Server.<br>
<br>
A factory class <code>AdServerFactory</code> is provided to facilitate the construction of an <code>OpenXAdServer</code> instance. Eventually other VAST compliant ad servers will be supported by the framework.<br>
<br>
The <code>OpenXAdServer</code> requires an instance of the <code>OpenXConfig</code> class when initialising to ensure that the appropriate URLs and settings can be applied when the calls are made to the OpenX ad server.<br>
<br>
<h3>6. The Display Management Package</h3>

Non-Linear and companion ads must be displayed by the player on or around the player canvas. The Display Management Package provides two classes to facilitate callbacks to the specific player implementation when a non-linear or companion ad is to be displayed.<br>
<br>
These two classes are <code>VideoAdDisplayController</code> (a key interface to implement in your custom player) and <code>VideoAdDisplayEvent</code> which describes the type of video ad to display/hide.<br>
<br>
<b>Update:</b> This project has moved to <a href='http://code.google.com/p/open-video-ads'>Open Video Ads</a>