function y = dg_filter(b,a,x,N,nanflag)
%% synopsis: Y = dg_filter(B,A,X,N,nanflag)
%% 
%% this is a wrapper function for filter.m  this function shifts the time so that 
%% the filtered data lines up with the original time series, NaN's are placed at the ends
%% DG 20080501
%% 

y = filter(b,a,x);
y(N/2:end-N/2) = y(N:end);

if exist('nanflag') ~= 1 | nanflag == 1
	if isreal(x) ~= 1
		y(1:N/2-1) = NaN + i*NaN;
		y(end-N/2+1:end) = NaN + i*NaN;
	else
		y(1:N/2-1) = NaN;
		y(end-N/2+1:end) = NaN;
	end %if	
else
	y(1:N/2-1) = 0;
	y(end-N/2+1:end) = 0;
end %if

%nanflag