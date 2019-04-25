function dg_caxis(crange, cint, cmaptype)
%% synopsis: function dg_caxis([cmin cmax], cint, cmaptype)
%%
%% This function changes the caxis using range and color interval specified.  cmaptype is the standard argument for colormap.
%%
%% when no argument or only if crange is given, it sets the colormap to 'jet' and use 2001 colors ranging from RGB [0 0 0.5] to [0.5 0 0]
%%
%% DG 20090710
%%

if nargin == 0
	colormap([[0 0 0.5]; colormap(jet(2000))]);
elseif nargin == 1
	colormap([[0 0 0.5]; colormap(jet(2000))]);
	if length(crange) == 2
		caxis([crange(1) crange(2)]);
	else
		display('dg_caxis error: please specify crange in the format [cmin cmax].');
	end %if
else
	ncolor = (crange(2)-crange(1))/cint;

	if exist('cmaptype') ~= 1
		colormap(jet(ncolor));
	else
		eval(['colormap(' cmaptype '(' num2str(ncolor) ')' ')']);
	end %if
end %if
%colorbar