<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <script type="text/javascript">
    //<![CDATA[
    var map; 
    var pushpins = [];
    var ikony = [];

    //]]>
  </script>  
    <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAFM_p2f45ezse590chMkz9xQuxaBJ5wgSNftBrcOWVm2nL8RGBRRaGOqOnyV8Dtgv85GWoRrNWxXW2Q"
      type="text/javascript"></script>
    <script type="text/javascript">

    //<![CDATA[

    function getIcon(icon)
    {
        if(!ikony[icon])
        {
            var ikona = new GIcon(G_DEFAULT_ICON, icon);
            ikona.shadow = "";
            if((icon == "http://tednet.man.pl/images/p.png") ||
               (icon == "http://tednet.man.pl/images/k.png"))
            {
                ikona.iconSize.width = 16;
                ikona.iconSize.height = 16;
                ikona.iconAnchor.x = 8;
                ikona.iconAnchor.y = 8;
            }
            else
            if(icon == "http://tednet.man.pl/images/car.png")
            {
                ikona.iconSize.width = 26;
                ikona.iconSize.height = 12;
                ikona.iconAnchor.x = 13;
                ikona.iconAnchor.y = 6;
            }
            else
            if((icon == "http://tednet.man.pl/images/Car_run1.png") ||
               (icon == "http://tednet.man.pl/images/Car_stand1.png") ||
               (icon == "http://tednet.man.pl/images/Car_start1.png") ||
               (icon == "http://tednet.man.pl/images/Car_stop1.png") ||
               (icon == "http://tednet.man.pl/images/Car_v1.png"))
            {
                ikona.iconSize.width = 26;
                ikona.iconSize.height = 26;
                ikona.iconAnchor.x = 13;
                ikona.iconAnchor.y = 13;
            }
            else
            {
                ikona.iconSize.width = 8;
                ikona.iconSize.height = 16;
                ikona.iconAnchor.x = 4;
                ikona.iconAnchor.y = 8;
            }
            ikony[icon] = ikona;
        }
        return ikony[icon];
    }

    function pushpin(longitude, latitude, icon)
    {
        this.longitude = longitude;
        this.latitude = latitude;
        this.icon = icon;
        this.marker = new GMarker(new GLatLng(latitude, longitude), getIcon(icon));
        map.addOverlay(this.marker);
    }
    function pushpin_add(longitude, latitude, icon)
    {
        pushpins.push(new pushpin(longitude, latitude, icon));
    }
    function pushpin_clear()
    {
        while (pushpins.length > 0)
            pushpins.pop();
        map.clearOverlays();
    }
    function pushpin_change_icon(pushpin_index, icon)
    {
        var longitude = pushpins[pushpin_index].longitude;
        var latitude = pushpins[pushpin_index].latitude;
        delete pushpins[pushpin_index].marker;
        pushpins[pushpin_index] = new pushpin(longitude, latitude, icon);

        var bounds = map.getBounds();
        var pozycja = new GLatLng(pushpins[pushpin_index].latitude, pushpins[pushpin_index].longitude);
        if(!bounds.contains(pozycja))
            map.setCenter(pozycja, map.getZoom());
    }
    function fit_to_view(sw_lat, sw_lon, ne_lat, ne_lon, first)
    {
        var bounds = map.getBounds();
        var bounds2 = new GLatLngBounds(new GLatLng(sw_lat, sw_lon), new GLatLng(ne_lat, ne_lon));
        var i;
        var contains = true;
        if(!first)
        {
            for(i = 0; i < pushpins.length; i++)
            {
                var pozycja = new GLatLng(pushpins[i].latitude, pushpins[i].longitude);
                if(!bounds.contains(pozycja))
                {
                    contains = false;
                    break;
                }
            }
        }

        if(!contains  || first)
            map.setCenter(bounds2.getCenter(), map.getBoundsZoomLevel(bounds2));
    }

    function load() {
        if (GBrowserIsCompatible())
        {
            map = new GMap2(document.getElementById("map"));
            map.enableScrollWheelZoom();
            map.enableContinuousZoom();
                map.addControl(new GLargeMapControl());
                map.addControl(new GMapTypeControl());
            map.setCenter(new GLatLng(49.796, 18.785), 16);


            GEvent.addListener(map, "click", function(marker, point) {
              if (marker) {

              }
            });
         }
    }

    //]]>
    </script>
  </head>
  <body onload="load()" onunload="GUnload()" style="height:100%;margin:0">
    <div id="map" <?php echo "style=\"width: 100%; height: " . $height . "px\""; ?> ></div>
  </body>
</html>
