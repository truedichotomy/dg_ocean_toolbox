function [DEPTHI, LATI, LONI] = reshape_topoXYZ_noMERC(bathydata);
% reshape_topoXYZ reshapes the gridded 3-column lon,lat,depth ascii data (GEODAS xyz)
%   into gridded matrices suitable for contouring and outputs latitude, longitude,
%   depth, and mercator coordinates from latitude and longitude.
%
% 20070412 modified by DG for use on tatooine, took out the loading and saving code
% 20081128 took out Mercator coordinate code, DG

display('reshape_topoXYZ_noMERC...')

% tic
%bathdata = load(filename);
%display('Finished loading');

%% solution below too memory intensive
%lon = bathdata(:,1); lat = bathdata(:,2); bath = bathdata(:,3);
%lats = flipud(unique(lat));
%lons = unique(lon)';

%% less memory intensive solution
lats = flipud(unique(bathydata(:,2)));
lons = unique(bathydata(:,1))';

llons = length(lons);
llats = length(lats);
clear lats lons

display('Reshaping data ...');
% Reshape lat/lon/depth vectors into matrices
LATI = rot90(reshape(bathydata(:,2), llons, llats));
LONI = rot90(reshape(bathydata(:,1), llons, llats));
DEPTHI = rot90(reshape(bathydata(:,3), llons, llats));

%display('Converting to mercator projection');
% Convert to mercator coordinates
%[mercLONI,mercLATI] = ll2merc(lon, lat, 0);

% Reshape the vectors into gridded matrices
%mercLONI = rot90(reshape(mercLONI, length(lons), length(lats)));
%mercLATI = rot90(reshape(mercLATI, length(lons), length(lats)));

%disp(['Completed in: ' num2str(toc) ' seconds'])

%outfile = input('Please enter a filename to save DEPTHI LATI LONI mercLATI and mercLONI to:  ex: bigbight15sec_xy.mat');

%display('saving file as reshape_topo_output.mat');
%save reshape_topo_output DEPTHI LATI LONI mercLATI mercLONI;

display('Finished reshape_topoXYZ_noMERC.');