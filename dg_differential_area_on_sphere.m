function dA = dg_differential_area_on_sphere(lat,dlat,dlon)
% this function calculates the differential area of a patch on Earth
% 2015-03-02
% input: lat in degrees
% 			dlat and dlon in degrees as well

if nargin == 1
	display('assuming 30 arcseconds for both dlon and dlat')
	dlat = 1/120; % 30 arc second
	dlon = 1/120; % 30 arc second
else
	display('you must specify a latitude for Earth')
	return
end %if
	
dA = (dg_geocentric_radius(lat)*1000) .^2 .* cosd(lat) .* dlat*pi/180 .* dlon*pi/180;
