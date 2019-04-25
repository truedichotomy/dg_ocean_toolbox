% this script loads SST data and calculate composites from NASA's PO DAAC ghrsst server using MUR SST product.
% Example: https://podaac-opendap.jpl.nasa.gov:443/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/2018/148/20180528090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc
% 4/16/2019: gong@vims.edu
% 4/25/2019: gong@vims.edu, initial load on GitHub

initflag = 1
loadflag = 1
analysisflag = 1
saveflag = 1

yrrangeall = [2003:2018];
yrrangehipinfish = [2012 2013 2015];
yrrangelopinfish = [2014 2016 2017 2018];
yrrange1 = [2019];

yearrange = yrrangeall; % change THIS to select different years!!!
%yearrange = yrrangehipinfish;
%yearrange = yrrangelopinfish;

workdir = './';

if initflag == 1
    %% setting up datapath & netcdf paths
    datapath = 'https://podaac-opendap.jpl.nasa.gov:443/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/2018/148/20180528090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc';
    ncdisp(datapath);
    datainfo = ncinfo(datapath);


    % determine the dimension of each variable
    nt = datainfo.Variables(1).Dimensions.Length;
    nlon = datainfo.Variables(3).Dimensions.Length;
    nlat = datainfo.Variables(2).Dimensions.Length;
    %sst = repmat(NaN,[nlat,nlon,nt]);

    % set boundary for lon/lat for MAB
    lon = double(ncread(datapath,'lon'));
    lat = double(ncread(datapath,'lat'));
    latind = find(lat >= 33 & lat <= 41);
    lonind = find(lon <= -69 & lon >= -80);

    % extract and download data for MAB
    lonMAB = lon(lonind)';
    latMAB = lat(latind);

    %datapath = 'https://podaac-opendap.jpl.nasa.gov:443/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/2018/148/*.nc';
    startind = [lonind(1),latind(1),1];
    countind = [length(lonind),length(latind),1];

    %sstMAB = repmat(0,[length(latMAB),length(lonMAB)]);
end %if

% load all the SST data and compute composite for MAB
if loadflag == 1
    sstMAB = repmat(0,[length(latMAB),length(lonMAB)]);
    sstMAB1yr = sstMAB;
    sstMAByr = repmat(0,[length(latMAB),length(lonMAB),length(yearrange)]);

    t0 = datenum(2002,1,152);
    tN = datenum(2019,1,105);
    ydrange = [1:366];
    leapyr =@(yr)~rem(yr,400)|rem(yr,100)&~rem(yr,4);
    yday0 = 1;
    navg = 0;

    filenametail = ['090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc'];

    yyyy1 = yearrange(1);
    yyyy2 = yearrange(end);

    for ii = 1:length(yearrange)
        yyyy = yearrange(ii)
        navg1 = 0;
        sstMAB1yr = repmat(0,[length(latMAB),length(lonMAB)]);

        if leapyr(yyyy) == 1
            yday0 = 1;
            ydayN = 366;
        else
            yday0 = 1;
            ydayN = 365;
        end %if

        switch yyyy
        case 2002
            yday0 = 152;
        case 2019
            ydayN = 105;
        end %switch

        yday1 = yday0;
        yday2 = ydayN;
        
        %yday1 = 90;
        %yday2 = 160;
        yday1 = 120;
        yday2 = 160;
        syday1 = num2str(yday1+1000); syday1 = syday1(2:end);
        syday2 = num2str(yday2+1000); syday2 = syday2(2:end);

        for yday = [yday1:yday2]
            filenamehead = datestr(datenum(yyyy,1,yday),30);
            filename = [filenamehead(1:8) filenametail]
            yday1000 = num2str(yday+1000);
            datapath = ['https://podaac-opendap.jpl.nasa.gov:443/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/' num2str(yyyy) '/' yday1000(2:end) '/' filename];
            navg = navg + 1
            navg1 = navg1 + 1;
            
            sstMABi = ncread(datapath,'analysed_sst',startind,countind)';
            sstMAB1yr = sstMAB1yr*(1.0-1.0/navg1) + sstMABi*(1.0/navg1);
            sstMAB = sstMAB*(1.0-1.0/navg) + sstMABi*(1.0/navg);
        end %if
        sstMAByr(:,:,ii) = sstMAB1yr;
    end %for
end %if loadflag 

if analysisflag == 1
    [LON,LAT] = meshgrid(lonMAB,latMAB);
    llind = find(LON >= -74.5 & LON <= -73 & LAT >= 37.5 & LAT <= 39);
    sstMABts = squeeze(nanmean(sstMAByr,[1 2]));
    tyr = yearrange;
end %if

if saveflag == 1
    save([workdir 'sstMAB_' num2str(yyyy1) '-' num2str(yyyy2) '_yd' syday1 '-' syday2 '.mat'],'sstMAB','sstMAByr','sstMABts','tyr','lonMAB','latMAB','navg')
    %save([workdir 'sstMAB_' num2str(yyyy1) '-' num2str(yyyy2) '.mat'],'sstMAB','lonMAB','latMAB','navg')
end %if
