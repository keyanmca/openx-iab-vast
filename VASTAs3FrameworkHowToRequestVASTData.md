The following code snippet make a request to the OpenX Ad Server.

```
_openXAdServer = AdServerFactory.getAdServer(AdServerFactory.AD_SERVER_OPENX) as OpenXAdServer;
_openXAdServer.initialise(_openXConfig);
_openXAdServer.loadVideoAdData(this, this);
```

An instance of the `OpenXAdServer` class is obtained from the `AdServerFactory`. Once that is obtained, the configuration for the framework is passed into the instance via the `initialise` method. The key piece of configuration data that is extracted during initialisation is the URL of the OpenX ad server instance (identified in the configuration file as `vastServerURL`)

Ultimately, when a request is made to the OpenX Ad Server the request is of the form (where the server address is replaced by the address of your OpenX instance):

```
http://openx.bouncingminds.com/openx/www/delivery/fc.php?
                   script=bannerTypeHtml:vastInlineBannerTypeHtml:vastInlineHtml
                   &zones=pre-roll0-0%3D1%7Cbottom1-0%3D2
                   &nz=1&source=
                   &r=3615996.6606646776
                   &block=1
                   &format=vast
                   &charset=UTF_8
```

When the VAST data is loaded, two methods are made available by the `TemplateLoadListener` interface to signal completion of the task:

```
public function onTemplateLoaded():void;
public function onTemplateLoadError(event:Event):void;
```

`onTemplateLoaded` is called when the template data has been successfully loaded while `onTemplateLoadError` is called if the load fails.

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)