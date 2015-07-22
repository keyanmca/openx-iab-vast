# Installing a crossdomain.xml #

If you are serving your ads from a different domain name than the flash player, you need to install a crossdomain.xml file in the docroot on your openX ad server to allow flash to communicate to it.

Please take care installing this file. The example below allows "all" domains to talk to your server within Flash - you may want to restrict this.

```
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
<allow-access-from domain="*"/>
</cross-domain-policy>
```

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)