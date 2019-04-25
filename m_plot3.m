function han = m_plot3(varargin)

% M_PLOT Plot objects on an M_MAP plot.   All of the normal
% Matlab plot options are available.  NOTE - this isn't exactly
% like plot as only the first two arguments are actually converted
% to map coords, i.e.:
%
% USAGE: M_PLOT3(LON,LAT,Z,[OPTIONS]) 
%

% Deirdre Byrne, dbyrne@umeoce.maine.edu 00/07/27 (v1.1)
% DG 2011-04-22: created m_plot3.m from m_plot.m
%
% This software is provided "as is" without warranty of any kind.

global MAP_PROJECTION MAP_VAR_LIST

if isempty(MAP_PROJECTION),
  disp('No Map Projection initialized - call M_PROJ first!');
  return;
end;

if nargin < 2;
  help m_plot3
  return
end

[x,y] = m_ll2xy(varargin{1},varargin{2});
z = varargin{3};
varargin = varargin(:);
s = size(varargin,1);
h=plot3(x,y,z,varargin{4:s});

if nargout == 1
  han = h;
end

return
