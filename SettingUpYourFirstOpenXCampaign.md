The following instructions assume you have a basic understanding of the OpenX processes and admin console. For a detailed introduction to OpenX, please read [here](http://www.openx.org).

Once you are ready to go:

  * Log into openX as a manager

  * Make sure that you have a website created - if not, create one

> <br />
> <a href='http://static.bouncingminds.com/images/openx-iab-vast/step-create-website.png'>
<blockquote><img src='http://static.bouncingminds.com/images/openx-iab-vast/step-create-website.png' border='0' width='400' />
</a>
<br />
<br /></blockquote>

  * Create the various video "zones" that you want to have advertising on your website:
    * When you create a new video zone, if you want pre/mid/post roll adverting, add a zone of type "Inline Video Ad"
    * If you want an overlay video ad, create a zone of type "Overlay video ad"

> <br />
> <a href='http://static.bouncingminds.com/images/openx-iab-vast/step-create-zones.png'>
<blockquote><img src='http://static.bouncingminds.com/images/openx-iab-vast/step-create-zones.png' border='0' width='700' />
</a>
<br />
<br /></blockquote>

  * Now that you have your website and zones recorded, create an advertiser

> <br />
> <a href='http://static.bouncingminds.com/images/openx-iab-vast/step-create-advertiser.png'>
<blockquote><img src='http://static.bouncingminds.com/images/openx-iab-vast/step-create-advertiser.png' border='0' width='400' />
</a>
<br />
<br /></blockquote>


  * Add a campaign for your advertiser

> <br />
> <a href='http://static.bouncingminds.com/images/openx-iab-vast/step-create-campaign.png'>
<blockquote><img src='http://static.bouncingminds.com/images/openx-iab-vast/step-create-campaign.png' border='0' width='700' />
</a>
<br />
<br /></blockquote>


  * Now the fun starts. Create a new video ad banner for that campaign:
    * Two types of banner may be created (a) "OpenX VAST Inline Video Banner (pre/mid/post-roll)" and (b) "OpenX VAST Video Overlay Banner"  - if you want to create a pre, mid or post-roll ad use type (a). Overlay banners are type (b)
    * When creating an Inline Video Banner:
      * Enter a name for the banner
      * Enter a internal ID that you want to use to represent the banner (it can be anything that makes sense to you)
      * Specify the outgoing stream URL for the video ad. For example, `rtmp://ne7c0nwbit.rtmphost.com/videoplayer/mp4:ads/30secs/country_life_butter.mp4`
      * Enter the duration for the video ad - it is very important to get the number of seconds correct
    * Save the new banner ad
    * Next time you go back into that banner, the video ad will play - check it out


> <br />
> <a href='http://static.bouncingminds.com/images/openx-iab-vast/step-create-banner-detail.png'>
<blockquote><img src='http://static.bouncingminds.com/images/openx-iab-vast/step-create-banner-detail.png' border='0' width='700' />
</a>
<br />
<br /></blockquote>


  * One final step is required to activate the banner - you need to link the new banner back to the "zones" that you created initially. To do this go into the banner, click on "Linked Zones" and then make sure the appropriate "zone" is ticked at the bottom of the page. When you configure the player, you must specify the corresponding zone ID (in the table at the bottom of the "linked zones") as the "zone ID"


> <br />
> <a href='http://static.bouncingminds.com/images/openx-iab-vast/step-link-zones.png'>
<blockquote><img src='http://static.bouncingminds.com/images/openx-iab-vast/step-link-zones.png' border='0' width='700' />
</a>
<br />
<br /></blockquote>


Now you're done - the ad is set to be served

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)