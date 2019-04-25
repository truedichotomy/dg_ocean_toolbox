function Q = dg_solar_insolation(yd,lat,h)
% synopsis: Qday = dg_solar_insolation(yd,lat[,h])
%
% DG 2015-03-02, 2015-03-03
% yd is year day, July 15 is yd 196 and Oct 1 is yd 274
% lat is latitude in degrees
% based on http://en.wikipedia.org/wiki/Insolation

dbstop if error

theta = mod((yd-80),365)/365*360; % turning yd in into the theta angle

% theta = 0 at vernal equinox, 90 is summer solstice, 180 is the autumnal equinox and 270 is the winter solstice.
%S0 = 1367; % W/m^2
S0 = 1000; % W/m^2
epsilon = 23.4398; % obliquity
omegabar = 282.895; % longitude of perihelion
omegabar = 0;
ecc = 0.016704; % eccentricity
%h0 = pi/2; % hour angle constant

Sdeclination = asind(sind(epsilon) .* sind(theta - omegabar));
R0overRE = 1 + ecc .* cosd(theta - omegabar);

if nargin == 2
	% Q daily averaged
	h0 = acos(-tand(lat) .* tand(Sdeclination));
	cos_zenithangle = h0 .* sind(lat) .* sind(Sdeclination) + sin(h0) .* cosd(Sdeclination) .* cosd(lat);
	Q = S0/pi .* R0overRE .^ 2 .* cos_zenithangle;
elseif nargin == 3
	% Q instanteous
	cos_zenithangle = sind(lat) .* sind(Sdeclination) + cosd(lat) .* cosd(Sdeclination) .* cosd(h);	
	Q = S0 .* R0overRE .^ 2 .* cos_zenithangle;
end %if

%dbstop
