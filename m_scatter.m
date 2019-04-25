function han = m_scatter(varargin)
%
% DG 2011-04-26: making a m_map compatible version of matlab's scatter function, adopted from m_plot.m
%

global MAP_PROJECTION MAP_VAR_LIST

if isempty(MAP_PROJECTION),
  disp('No Map Projection initialized - call M_PROJ first!');
  return;
end;

if nargin < 2;
  help m_scatter
  return
end

[x,y] = m_ll2xy(varargin{1},varargin{2});
varargin = varargin(:);
s = size(varargin,1);
h=scatter(x,y,varargin{3:s});

if nargout == 1
  han = h;
end

return
