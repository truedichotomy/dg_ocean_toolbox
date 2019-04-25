function plot_shipping_lanes(gcf)   
         %%Lat/lon for the shipping lanes
         Lane1Line1Lon=[-73-49.610/60, -73-54.383/60];
         Lane1Line1Lat=[40+20.586/60, 39+45.686/60];
         Lane1Line2Lon=[-73-45.823/60, -73-37.496/60];
         Lane1Line2Lat=[40+21.261/60, 39+45.764/60];
  
         Lane2Line1Lon=[-73-44.5/60, -73-27.488/60];
         Lane2Line1Lat=[40+21.845/60, 40+2.724/60];
         Lane2Line2Lon=[-73-41.915/60, -73-15.491/60];
         Lane2Line2Lat=[40+24.023/60, 40+12.336/60];
  
         Lane3Line1Lon=[-73-41.240/60, -73-11.294/60];
         Lane3Line1Lat=[40+25.075/60, 40+19.168/60];
         Lane3Line2Lon=[-73-40.629/60, -73-11.399/60];
         Lane3Line2Lat=[40+28.021/60, 40+32.211/60];
         
         [Lane1Line1X Lane1Line1Y] = ll2merc(Lane1Line1Lon, Lane1Line1Lat, 0);
         [Lane1Line2X Lane1Line2Y] = ll2merc(Lane1Line2Lon, Lane1Line2Lat, 0);
         [Lane2Line1X Lane2Line1Y] = ll2merc(Lane2Line1Lon, Lane2Line1Lat, 0);
         [Lane2Line2X Lane2Line2Y] = ll2merc(Lane2Line2Lon, Lane2Line2Lat, 0);
         [Lane3Line1X Lane3Line1Y] = ll2merc(Lane3Line1Lon, Lane3Line1Lat, 0);
         [Lane3Line2X Lane3Line2Y] = ll2merc(Lane3Line2Lon, Lane3Line2Lat, 0);
         
         Lane1SepLon=[-73-48.323/60, -73-47.938/60, -73-44.027/60, -73-47.036/60];
         Lane1SepLat=[40+20.678/60, 39+45.738/60, 39+45.725/60, 40+20.903/60];

         Lane2SepLon=[-73-43.535/60, -73-18.184/60, -73-15.421/60, -73-42.662/60];
         Lane2SepLat=[40+22.456/60, 40+2.966/60, 40+5.277/60, 40+23.180/60];

         Lane3SepLon=[-73-40.863/60, -73-4.929/60, -73-4.999/60, -73-40.620/60];
         Lane3SepLat=[40+26.043/60, 40+24.278/60, 40+27.272/60, 40+27.032/60];
         
         [Lane1SepX Lane1SepY] = ll2merc(Lane1SepLon, Lane1SepLat, 0);
         [Lane2SepX Lane2SepY] = ll2merc(Lane2SepLon, Lane2SepLat, 0);
         [Lane3SepX Lane3SepY] = ll2merc(Lane3SepLon, Lane3SepLat, 0);

         %plot the separation zones
         Sep1=patch(Lane1SepX, Lane1SepY, [0.8 0.8 0.8]);
         set(Sep1, 'facecolor', 'none');
         hold on
         Sep2=patch(Lane2SepX, Lane2SepY, [0.8 0.8 0.8]);
         set(Sep2, 'facecolor', 'none');
         hold on
         Sep3=patch(Lane3SepX, Lane3SepY, [0.8 0.8 0.8]);
         set(Sep3, 'facecolor', 'none');
         hold on

         %plot the shipping lanes
         l1l1=plot(Lane1Line1X, Lane1Line1Y,'k--');
         l1l2=plot(Lane1Line2X, Lane1Line2Y,'k--');
         l2l1=plot(Lane2Line1X, Lane2Line1Y,'k--');
         l2l2=plot(Lane2Line2X, Lane2Line2Y,'k--');
         l3l1=plot(Lane3Line1X, Lane3Line1Y,'k--');
         l3l2=plot(Lane3Line2X, Lane3Line2Y,'k--');
 
         set(l1l1,'linewidth',[1]);
         set(l1l2,'linewidth',[1]);
         set(l2l1,'linewidth',[1]);
         set(l2l2,'linewidth',[1]);
         set(l3l1,'linewidth',[1]);
         set(l3l2,'linewidth',[1]);
         
         % Plot Moorings
         %2005 LaTTE Moorings
         %moorings_lat = [40.38 40.224 40.221 40.21 39.95]; 
         %moorings_lon = [-73.95 -73.975 -73.92 -73.87 -74.06];
         %2006 LaTTE Moorings
         %moorings_lat = [39.9101, 40.390, 40.1617, 40.3909, 40.1581, 40.1556, 40.1526];
         %moorings_lon = [-74.0645, -73.785, -73.6883, -73.9564, -74.0079, -73.9859, -73.9641];

         %[moorings_x moorings_y] = ll2merc(moorings_lon, moorings_lat, 0);
         %h_moor = scatter(moorings_x, moorings_y, 50, 'k', 'filled');

         %2006 Dye injection point
         %dye_lat =[40+14.97/60];
         %dye_lon = [-73-56.9/60];
         %[dye_x dye_y] = ll2merc(dye_lon, dye_lat, 0);
         %h_dye = scatter(dye_x, dye_y, 60, 'g', 'filled');
         %set(h_dye, 'markeredgecolor', 'k');
