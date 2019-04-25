function [tscl, zscl] = dg_scale_t_z(tin,zin,sclfact,sclfacz,tref,zref)
% this function scales input time and depth vectors to between 0 and 1
% INPUTS:
%   tin : input time
%   zin : input depth
%   sclfact : scale factor for t
%   sclfacz : scale factor for z
%   tref : reference t vector used for scaling (instead of using tin)
%   zref : reference z vector used for scaling (instead of using zin)
%
% DG 2018-05-30

if nargin < 5
    tref = tin;
    zref = zin;
end %if

if nargin < 3
    sclfact = 1;
    sclfacz = 1;
    tref = tin;
    zref = zin;
end %if

tscl = (tin-dg_minn(tref)) ./ (dg_maxn(tref) - dg_minn(tref)) .* sclfact;
zscl = (zin) ./ (dg_maxn(abs(zref))) .* sclfacz;
