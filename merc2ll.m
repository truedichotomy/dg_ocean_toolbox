function [lon, lat] = merc2ll ( x, y, lon_center );
% MERC2LL:  simple mercator projection back to Lat/Lon
%
% USAGE:  [lon,lat] = merc2ll ( x, y, lon_center );
%
% PARAMETERS:
% Input:
%     x, y:  mercator projection values, probably produced via ll2merc
%     lon_center:
%         In decimal degrees.  Same value as provided to ll2merc.
% Output:
%     lon, lat:  geographic equivalents of mercator projection inputs
%
% REFERENCE:  http://mathworld.wolfram.com/MercatorProjection.html


phi = 2 * atan(exp(y)) - pi/2;
lat = phi*180/pi;

lambda0 = lon_center * pi / 180;
lambda = x + lambda0;

lon = lambda * 180 / pi;

