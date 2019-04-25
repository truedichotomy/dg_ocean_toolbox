function [u, v] = dg_pol2cart(compassdir, mag)
% synopsis: [u, v] = dg_pol2cart(compassdir, mag)
%
% This function converts compass direction degrees and vector
% magnitude in polar to cartesian.
%
% DG

theta = mod(360-compassdir+90, 360) * pi/180;
[u, v] = pol2cart(theta, mag);