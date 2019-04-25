function [fangle, tangle, spd] = dg_cart2windpol(u,v)
%% synopsis: [fangle, tangle, spd] = dg_cart2windpol(u,v)
%%
%% this function calculate the from direction based the u and v component of the to velocity.  north is up.  useful for wind direction calculation
%% DG 20070320
%% DG 20101107 added speed output
%%
if nargin == 0
  display('synopsis: function fangle = dg_cart2windpol(u,v)')
  return;
end %if

rad = atan(v./u);
ang = rad*180/pi;
fangle = repmat(nan,size(ang));

ne = find(u >= 0 & v >= 0);
nw = find(u < 0 & v >= 0);
se = find(u >= 0 & v < 0);
sw = find(u < 0 & v < 0);

if ~isempty(ne)
  tangle(ne) = 90-ang(ne);
  fangle(ne) = tangle(ne) + 180;
end %if

if ~isempty(nw)
  tangle(nw) = 270+abs(ang(nw));
  fangle(nw) = tangle(nw) - 180;
end %if

if ~isempty(se)
  tangle(se) = 90+abs(ang(se));
  fangle(se) = tangle(se) + 180;
end %if

if ~isempty(sw)
  tangle(sw) = 270-ang(sw);
  fangle(sw) = tangle(sw) - 180;
end %if

spd = abs(u+i*v);
