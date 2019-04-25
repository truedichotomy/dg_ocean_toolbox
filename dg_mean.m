function [mval, fracnnan] = dg_mean(data,dim)
%% DG 20091217
%%
%% This script calculate the mean value for an array but ignores NaN's.
%%
nnan = find(~isnan(data));

if length(nnan) > 0
	mval = mean(data(nnan));
	fracnn = length(nnan)/length(data);
else
	mval = NaN;
	fracnn = 0;
end %if