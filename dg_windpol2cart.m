function [u, v] = dg_windpol2cart(compassdir, mag)
% synopsis: function [u, v] = dg_windpol2cart(compassdir, mag)
%
% This function converts wind compass (from) direction in degrees and the
% magnitude, to the cartesian u & v components.
%
% DG 20091216

dbstop if error

%display('[u, v] = dg_windpol2cart(compassdir, mag)')

%% convert from compass direction to u, v
thetaDeg = mod(360-compassdir+90, 360);

%% adjust from the meteological convention that wind is always measured as the FROM direction
thetaDeg = mod((thetaDeg + 180), 360);

thetaRad = thetaDeg * pi/180;

%% determine u and v, direction that the wind is pointing TO
[u, v] = pol2cart(thetaRad, mag);
