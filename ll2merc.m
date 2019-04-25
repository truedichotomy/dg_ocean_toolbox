function [x,y] = ll2merc ( lon, lat, lon_center )
% LL2MERC:  transform lonlat pairs to mercator
%
% USAGE:  [x,y] = ll2merc ( lon, lat, lon_center );
%
% PARAMETERS:
% Input:
%    lon,lat:
%       vectors of equal size of longitude, latitude in decimal degrees
%    lon_center:
%       center of projection
% Output:
%    x, y:
%       transformed coordinates in Mercator
%


lambda0 = lon_center * pi / 180;


%
% transform to mercator
x = lon*pi/180 - lambda0;
phi = lat * pi / 180;
y = log ( tan(phi) + sec(phi) );




return


