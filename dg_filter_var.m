function varf = dg_filter_var(varin,res,N,Win,passtype)
% DG 2013-01-18
%
if exist('varin') ~= 1
	display('synopsis: varf = dg_filter_var(varin,res,N,Win,passtype)')
	varf = [];
	return
end %if

if exist('res') ~= 1
	res = 1; %hour
end %if

if exist('N') ~= 1
	N = 64 / res;
end %if

if exist('Win') ~= 1
%	Win = 40; % hours
	Win = 32; % hours
end %if

if exist('passtype') ~= 1
	passtype = 'low';
end %if

Win_hi = 14.5; %hours

switch passtype
case 'low'
	b = fir1(N, 2*1/Win,'low');
case 'high'
	b = fir1(N, 2*1/Win,'high');
case 'bandpass'
	b = fir1(N, [2*1/Win 2*1/Win_hi],'bandpass');
otherwise
	b = fir1(N, 2*1/Win,passtype);
end %switch	

varf = dg_filter(b,1,varin,N,1);
