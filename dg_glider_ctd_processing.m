function dg_glider_ctd_processing(datadir,datafile,saveflag)
% synoposis: function dg_glider_ctd_processing(datadir,datafile,saveflag)
%
% this function load glider CTD data stored in sldbd/slebd and gdatadbd/gdataebd formats and save the high resolution CTD data in a mat file
% Donglai Gong 20170627, 20170706, 20180530

if ~exist('datafile')
  datadir = './';
  %datadir = '/Users/gong/OneDrive/Research/gliders/data/amelia-20131017-maracoos-post/';
  %datafile = 'amelia-20131017-maracoos-post.mat';
  datafile = 'sylvia-20180501-maracoos.mat';
end %if

if ~exist('saveflag')
  saveflag = 1;
end %if

if exist('slebd') ~= 1
  datapath = [datadir datafile];
  load(datapath);
end %if

% initialize variables to load from EBD data structure
traw = []; pres = []; temp = []; cond = [];

% initialize variables to load from DBD data structure
tdbdraw = []; lonraw = []; latraw = []; gpslonraw = []; gpslatraw = [];

% load glider time, pressure, temperature, and conductivity data from EBD
% Glider pressure in unit of bar, conductivity in unit of S/m.
for ii = 1:length(gdataebd),
  if ~isempty(gdataebd{ii})
    traw = [traw;gdataebd{ii}(:,slebd.sci_m_present_time)];
    pres = [pres;gdataebd{ii}(:,slebd.sci_water_pressure)];
    temp = [temp;gdataebd{ii}(:,slebd.sci_water_temp)];
    cond = [cond;gdataebd{ii}(:,slebd.sci_water_cond)];
  end %if
end %for

%clear gdataebd;

% sort the data by time
[t,ti] = sort(traw);
pres = pres(ti);
temp = temp(ti);
cond = cond(ti);

% load glider time, lon, lat data from DBD
for ii = 1:length(gdatadbd),
  if ~isempty(gdatadbd{ii})
    tdbdraw = [tdbdraw;gdatadbd{ii}(:,sldbd.m_present_time)];
    lonraw = [lonraw;gdatadbd{ii}(:,sldbd.m_lon)];
    latraw = [latraw;gdatadbd{ii}(:,sldbd.m_lat)];
    gpslonraw = [gpslonraw;gdatadbd{ii}(:,sldbd.m_gps_lon)];
    gpslatraw = [gpslatraw;gdatadbd{ii}(:,sldbd.m_gps_lat)];
  end %if
end %for

%clear gdatadbd;

% sort the data by time
[tdbd,tidbd] = sort(tdbdraw);
lonraw = lonraw(tidbd);
latraw = latraw(tidbd);
gpslonraw = gpslonraw(tidbd);
gpslatraw = gpslatraw(tidbd);

% convert from glider lon/lat format to decimal degrees lon/lat
[lonDR,latDR] = dg_llg2lld(lonraw,latraw);

% extract not NaN GPS location fixes
nnangps = find(~isnan(gpslonraw));
[uniqtgps,uniqtgpsi] = unique(tdbd);

% extracting the good GPS lon/lat indices from the DBD variables.
goodgpsind = intersect(nnangps,uniqtgpsi);

% obtain time of GPS fixes
gpst = tdbd(goodgpsind);

% convert from glider lon/lat format to decimal degrees lon/lat
[gpslon, gpslat] = dg_llg2lld(gpslonraw(goodgpsind), gpslatraw(goodgpsind));

% interplate GPS fixes to obtain glider position
gpsll = gpslon + gpslat*i; % use complex numbers to represent GPS lon/lat
lonlat = interp1(gpst,gpsll,t); % interpolate to EBD time stamps
lonlatDBD = interp1(gpst,gpsll,tdbd); % interplate to DBD time stamps
lon = real(lonlat); % lon matched to EBD time stamps
lat = imag(lonlat); % lat matched to EBD time stamps
lonDBD = real(lonlatDBD); % lon matched to DBD time stamps
latDBD = imag(lonlatDBD); % lat matched to DBD time stamps

% CTD data QC
badind = find(cond < 0.1);
cond(badind) = NaN;
temp(badind) = NaN;

% define a fixed interval 1 sec time grid
tt = [ceil(t(1)):1:floor(t(end))]';
ttmat = unixt2datenum(tt);

% interpolate position data to the fixed interval time grid
llon = dg_xgap_interpolate(t,lon,tt,10,'linear');
llat = dg_xgap_interpolate(t,lat,tt,10,'linear');

% interpolate pressure data to the fixed interval time grid
ppres = dg_xgap_interpolate(t,pres,tt,10,'linear');
ttemp = dg_xgap_interpolate(t,temp,tt,10,'linear');
ccond = dg_xgap_interpolate(t,cond,tt,10,'linear');

% use GSW toolbox to calculate potential temperature, density, and salinity
% note GSW toolbox need pressure in unit of dbar and conductivity in unit of mS/cm
zz = gsw_z_from_p(ppres*10,llat); % depth, converting pressure from bar to dbar
ssalt = gsw_SP_from_C(ccond*10,ttemp,ppres*10); % salinity, converting pressure from bar to dbar and conductivity from S/m to mS/cm.
ssaltA = gsw_SA_from_SP(ssalt,ppres*10,llon,llat); % absolute salinity, converting pressure from bar to dbar
cttmp = gsw_CT_from_t(ssaltA,ttemp,ppres*10); % conservative temperature, converting pressure from bar to dbar
pttmp = gsw_pt_from_CT(ssaltA,cttmp); % potential temperature
rrho = gsw_rho(ssaltA,cttmp,ppres); % in-situ density
ssigma0 = gsw_sigma0(ssaltA,cttmp); % potential density anomaly

if saveflag == 1
  save([datadir datafile(1:end-4) '-hiCTD'],'tt','llon','llat','ppres','ccond','ttemp','zz','ssalt','ssaltA','cttmp','pttmp','rrho','ssigma0','-v7.3');
end %if