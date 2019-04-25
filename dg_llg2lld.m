function [lon, lat] = dg_llg2lld(longg, latgg)
% this function convert from glider lon/lat to lon/lat in decimal degrees
% DG 20121012

dbstop if error

if size(longg,2) > 1
    longg = longg';
end %if

nnanind = find(~isnan(longg) & (longg <= 36000 & longg >= -18000) & (latgg >= -9100 & latgg <= 9100));
lon = repmat(NaN,length(longg),1);
%lon = repmat(NaN,length(nnanind),1);
lat = lon;

longs = num2str(longg(nnanind),'%11.4f');
latgs = num2str(latgg(nnanind),'%9.4f');

longi = fix(longg(nnanind));
latgi = fix(latgg(nnanind));

longis = num2str(longi);
latgis = num2str(latgi);

% find locations of +/- lon/lat
plonind = find(longi >= 0);
nlonind = find(longi < 0);
platind = find(latgi >= 0);
nlatind = find(latgi < 0);

if ~isempty(plonind)
    if size(longis,2) == 5
        lon(nnanind(plonind)) = str2num(longis(plonind,1:3)) + str2num(longs(plonind,4:end))/60.0;
    elseif size(longis,2) == 4
        lon(nnanind(plonind)) = str2num(longis(plonind,1:2)) + str2num(longs(plonind,3:end))/60.0;        
    end %if
elseif ~isempty(nlonind)
    if size(longis,2) == 6
        lon(nnanind(nlonind)) = str2num(longis(nlonind,1:4)) - str2num(longs(nlonind,5:end))/60.0;
    elseif size(longis,2) == 5
        lon(nnanind(nlonind)) = str2num(longis(nlonind,1:3)) - str2num(longs(nlonind,4:end))/60.0;        
    end %if    
end %if

if ~isempty(platind)
    if size(latgis,2) == 4
        lat(nnanind(platind)) = str2num(latgis(platind,1:2)) + str2num(latgs(platind,3:end))/60.0;
    end %if
elseif ~isempty(nlatind)
    if size(latgis,2) == 5
        lat(nnanind(nlatind)) = str2num(latgis(nlatind,1:3)) - str2num(latgs(nlatind,4:end))/60.0;
    end %if    
end %if

%dbstop
