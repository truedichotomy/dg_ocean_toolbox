function unixtime = datenum2unixt(matlabtime)
%% synopsis: function unixtime = unixt2datenum(matlabtime)
%%
%% convert from matlab datenum (days since 0 AD UTC) to unix time (seconds since Jan 1, 1970 UTC)

unixtime = (matlabtime - datenum(1970,1,1)) * 3600 * 24.0;
%matlabtime = unixtime/3600./24. + datenum(1970,1,1);
