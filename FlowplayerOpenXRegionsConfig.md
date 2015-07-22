# OpenXRegions.swf #

The _Regions_ plugin is an extended form of the standard Flowplayer _Content_ plugin that allows multiple HTML "regions" to be defined on the player canvas.

Use the Regions plugin to define a series of "regions" on the player that can be used to display overlay and non-overlay advertising. Given that a region is basically a HTML block, it can also be used to display messaging to accompany a video ad such as sponsorship messaging or "this is an advert" type messaging.

## Declaring Regions ##

By default, 4 regions are automatically declared - a **"top"** region that occupies the width of the player 50 pixels deep, a **"bottom"** region that is also the width of the player and 50 pixels height, a region that covers the **"full screen"**, and a thin region (20px high) at the base of the screen to be used for general ad messaging (tagged **"message"**).

Any number of customised regions can be declared. To illustrate how this is done, review the following example that illustrates the options that are declared for the default "message" region:

```
    ....
    plugins: {
        openXRegions: {
            url: 'flash/OpenXVastRegions-0.4.1.swf',
            regions: [
               { id: 'message',
                 verticalAlign: 'bottom',
                 horizontalAlign: 'right',
                 width: '100%',
                 height: 20
               }
            ]
        }
     ....
```

A "region" can be configured in much the same way as the Content plugin is configured.

Here is an example configuration for the Regions plugin:
```
    ....
    plugins: {
        openXRegions: {
            url: 'flash/OpenXVastRegions-0.4.1.swf',
            stylesheet: 'css/region-general.css',
            borderRadius: 1,
            border: '0px', 
            backgroundTransparent: true,
            backgroundColor: 'transparent',
            onClick: function() {},
            regions: [
               { id: 'message',
                 verticalAlign: 'bottom',
                 horizontalAlign: 'right',
                 width: '100%',
                 height: 20,
                 stylesheet: 'css/region-message.css',                 
                 backgroundColor: '#ffffff',
                 showCloseButton: true,
                 closeButtonImage: 'images/closebutton.gif',
                 html: '&lt;p class="warning" align="right"&gt;This is an advertisement&lt;/p&gt;',
               }
            ]
        }
     ....
```
The example above illustrates how options are defined at general and region specific levels. In this example, a stylesheet is attached to the plugin (`region-general.css`) - the styles defined in this stylesheet are available to be used in all regions. Several other options are defined at a general level - the border, background color and transparency, and a radius for the border. Unless these values are overridden by a specific region, they will automatically be applied at the region level.

The "message" region specifically defines an additional stylesheet to pull in and an overriding background color (`#ffffff`). It also specifies that a close button is to be displayed for this region and that the attached image is to be shown when the region is visible on the player.

HTML text to be displayed by the regions can be defined at a general or regions specific level. In the example above, a general warning message is configured as the standard body for the "message" region. The html definition references a style class ('warning')  that is defined in the `region-message.css` stylesheet.

Javascript callbacks are also available at a general level. In the example above, the `onClick()` callback is defined - when a region is clicked, this callback will be executed allowing you to define custom behaviour to occur outside of the player when the user clicks on advertising region.

## Configuration Parameters ##

A wide range of configuration options are available, allowing you to define regions of pretty much any shape and style. Below is a complete list of options:

| **Property name** | **Level** | **Description** |
|:------------------|:----------|:----------------|
| `url`             | General   | The url of the Regions swf file |
| `regions`         | General   | An array based option that supports the configuration of 1 more or more custom properties. Declare the custom regions as `regions: [ { region1-options }, ... { regionN-options } ]` |
| `id`              | Region    | Every region that is declared using the `regions` tag must be identified by a unique name. This `id` is used by the Ad Streamer to identify which region is to be used to display a specific overlay or non-overlay `AdSlot` |
| `width`           | Region    | Specifies the width of the region - the values can either be numeric (the number of pixels) or a percentage of the screen width (e.g. `'100%'`) |
| `height`          | Region    | Specifies the height of the region - the values can either be numeric (the number of pixels) or a percentage of the screen width (e.g. `'100%'`) |
| `verticalAlign`   | Region    | Specifies the vertical alignment of the region - values can be `'top'`, `'bottom'` or a numeric value representing the Y coordination (in pixels). |
| `horizontalAlign` | Region    | Specifies the horizonal alignment of the region - values can be `'left'`, `'right'` or a numeric value representing the X coordination (in pixels).|
| `clickable`       | Region    | Identifies whether or not the region is to be clickable. This value does not override any click action properties that may be defined on at the HTML level for the objects shown in the region. This value enables or stops the `onClick()` javascript callback from firing. |
| `clickToPlay`     | Region    | Identifies whether or not clicking on the region is to invoke a `player.play()` call. |
| `html`            | Both      | Specifies the initial HTML content to be loaded by default for the region |
| `stylesheet`      | Both      | Path to the stylesheet file which specifies how each tag in the content is styled. You can find more information about styling <a href='#css'>here</a>. |
| `style`           | Both      | A styling object that is specified directly in the configuration. If an external stylesheet is in use, these settings override those external settings. You can find more information about styling <a href='#css'>here</a>.|
| `backgroundColor` | Both      | Background color as a hexadecimal value. For example: `#ffcccc`. The length of the value is 6 characters and the prefix # is optional. |
| `backgroundImage` | Both      | The absolute or relative path to the image that should be used as the background to this plugin. Supported formats are GIF, JPEG and PNG. The syntax is similar to CSS in that you must enclose your path inside a `url()` wrapper. See example above. |
| `background`      | Both      | A shorthand way of setting all background properties at once. Similar to CSS. The format is as follows: `backgroundImage backgroundRepeat left top`. For example: `url(/my/image.jpg) no-repeat 100 30`. The last two numbers specify the background image positioning. |
| `backgroundGradient` | Both      | Defines a region's background gradient (ie, the way the background is faded in and out vertically). The value can be one of the predefined values "low", "medium" or "high", or you can supply an array of values, each one representing how much transparency is applied at a particular point. For example, the array `[0.2, 1.0]` means that the background will be 80% visible at the top edge and 0% visible at the bottom, and there will be a linear gradient of transparency between the two edges. You can supply any number of  point definitions in your array and they will be placed so that there is equal distance between them. For example, passing the array `[0.4, 0.6, 1.0]` will result in points at the top, middle and bottom of the background.|
| `backgroundTransparent` | Both      | Defines whether or not a region is to be transparent. Values are `true` or `false` - the default is `false` |
| `border`          | Both      | Draws a border around a region's edges. The syntax follows the CSS standard: `width style color`. For example: `"1px solid #cccccc"`. The only supported style currently is "solid", but the width and colour can be set to any valid value. |
| `borderRadius`    | Both      | Specifies the amount of rounding for each corner. Larger values mean more rounding.|
| `debugBackground` | Both      | Specifies the background properties to apply when the regions are being shown in "debug" mode. Follows the same convention as the `background` option. |
| `debugBorder`     | Both      | Specifies the border properties to apply when the regions are being shown in "debug" mode. Follows the same convention as the `border` option.|
| `showCloseButton` | Both      | `true` displays a closing button at the top right corner of all regions. The default is `false` |
| `closeImage`      | Both      | A URL pointing to the image that is used as the close button. Example: `closeImage: url('close.png')`. By default an X-like image is shown. |
| `onClick`         | General   | A javascript function that is called when a region is clicked. |
| `onMouseOver`     | General   | A javascript function that is called when the mouse is positioned over the plugin. |
| `onMouseOut`      | General   | A javascript function that is called when the mouse moves outside of the plugin. |

**Update:** This project has moved to [Open Video Ads](http://code.google.com/p/open-video-ads)