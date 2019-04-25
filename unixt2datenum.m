function matlabtime = unixt2datenum(unixtime);
%% synopsis: function matlabtime = unixt2datenum(unixtime);
%%
%% convert from unix time to matlab datenum
%% unix time is defined as number of seconds from Jan 1, 1970
matlabtime = unixtime/3600./24. + datenum(1970,1,1);