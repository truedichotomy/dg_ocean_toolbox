function R = dg_geocentric_radius(lat)
% this function calculates the geoconcentric radius (in km) for an ellipsoid according to http://en.wikipedia.org/wiki/Earth_radius#Equatorial_radius
% 2015-03-02

%if nargin == 1
	a = 6378.137; %km
	b = 6356.7523; %km
%else
%	display('you must specify a latitude for Earth')
%	return
%end %if
	
R = sqrt( ((a^2 * cosd(lat)).^2 + (b^2 * sind(lat)).^2) ./ ((a*cosd(lat)).^2 + (b*sind(lat)).^2) ); % in km
