function [mercLATI, mercLONI, DEPTHI, LATI, LONI] = reshape_topoXYZ(bathdata);
% reshape_topoXYZ reshapes the gridded 3-column lon,lat,depth ascii data (GEODAS xyz)
%   into gridded matrices suitable for contouring and outputs latitude, longitude,
%   depth, and mercator coordinates from latitude and longitude.
%
% 20070412 modified by DG for use on tatooine, took out the loading and saving code


% tic
%bathdata = load(filename);
%display('Finished loading');
lon = bathdata(:,1); lat = bathdata(:,2); bath = bathdata(:,3);
lats = flipud(unique(lat));
lons = unique(lon)';

display('Reshaping data ...');
% Reshape lat/lon/depth vectors into matrices
LATI = rot90(reshape(lat, length(lons), length(lats)));
LONI = rot90(reshape(lon, length(lons), length(lats)));
DEPTHI = rot90(reshape(bath, length(lons), length(lats)));

display('Converting to mercator projection');
% Convert to mercator coordinates
[mercLONI,mercLATI] = ll2merc(lon, lat, 0);

% Reshape the vectors into gridded matrices
mercLONI = rot90(reshape(mercLONI, length(lons), length(lats)));
mercLATI = rot90(reshape(mercLATI, length(lons), length(lats)));

%disp(['Completed in: ' num2str(toc) ' seconds'])

%outfile = input('Please enter a filename to save DEPTHI LATI LONI mercLATI and mercLONI to:  ex: bigbight15sec_xy.mat');

%display('saving file as reshape_topo_output.mat');
%save reshape_topo_output DEPTHI LATI LONI mercLATI mercLONI;
