function [pah,color_bar] = m_plot_dot(X,Y,C,C_lim,dotsize,cmap,c_label,cborientation)
% m_plot_dot  Plots colored dots based on Z value
%-------------------------------------------------------
% University of South Florida, Ocean Circulation Group
% Sage's Codar Processing Toolbox v1.0
%-------------------------------------------------------
% Usage:
%   m_plot_dot(X,Y,C,C_lim,dotsize,cmap,clabel,cborientation)
% Input:
%   X,Y = Longitude/Latitude in decimal degrees
%   Z       = Depth
%   C       = Dot value
%   C_lim    = [Min Max] Limits for C
%   c_label = Colorbar label (if left undefined 
%             colorbar is not generated)
% Output: None
% Updates:
%   Written by Sage 6/25/2004
% Note:0 10 bins between the limits set in Z_lim are used
%   to detemine color values for Z.  
%   C=C_lim(1) are ignored
%   2006-07-31  DG modified to plot 3-D data, Lon->X, Lat->Y
%   2006-09-18  DG added plotting data smaller than min and larger than max
%   2006-09-28  DG readopted for 2-D plotting
%   2007-12-19  DG minor change to plot label for colorbar & return plot axis
%   2008-02-28  DG fix colorbar plotting bug
%   2010-03-10  DG added cmap function
%   2011-04-11  DG converted from plot to m_plot using the m_map toolbox
%   2011-04-26  DG make sure dotsize in array form behave properly
%-------------------------------------------------------

if ~exist('dotsize')
  dotsize = 10;
end %if

if length(dotsize) == 1
    dotsize = repmat(dotsize,size(X));
end %if 

% Set up the colormap to use
if ~exist('cmap')
  cmap  = jet(256);
end %if
%cmap = hsv(256);
%cmap  = cmap.^1.5;

%hss = scatter([min(X(1)) min(X(end))],[min(Y(1)) min(Y(end))],1,[C_lim(1) C_lim(2)]);

colormap(cmap);
caxis(C_lim);
pp = [];
k = 0;

%delete(hss);
hs =[];

m_proj('set','lambert')

%% plot anything smaller than the specified range using the first color
minind = find(C<C_lim(1));
if length(minind)>0
  k = k+1;
  pp(k)=m_plot(X(minind),Y(minind),'.','markersize',dotsize(minind)); hold on;
  set(pp(k),'color',cmap(1,:));
end %if

%% plot data according to their indexed color
ranges = [C_lim(1): (C_lim(2)-C_lim(1))/size(cmap,1) :C_lim(2)];
for ii=1:length(ranges)-1,
  ind = find(C>ranges(ii) & C<=ranges(ii+1));
  if length(ind)>0
    k = k+1;
    pp(k)=m_plot(X(ind),Y(ind),'.','markersize',dotsize(ind)); hold on;
    set(pp(k),'color',cmap(ii,:));    
  end
end

%% plot anything larger than the specified range using the last color
maxind = find(C>C_lim(2));
if length(maxind)>0
  k = k+1;
  pp(k)=m_plot(X(maxind),Y(maxind),'.','markersize',dotsize(ind)); hold on;
  set(pp(k),'color',cmap(end,:));
end %if

pah = gca;

if exist('c_label')
% 	% Plot and Configure the Colorbar
% 	caxes=gca;
        if exist('cborientation') ~= 1
          color_bar=colorbar('horz');
          hx = xlabel(color_bar,c_label);
          set(hx,'fontweight','bold','fontsize',14);
        else
          color_bar=colorbar('vert');
          hy = ylabel(color_bar,c_label);
          set(hy,'fontweight','bold','fontsize',14);
        end %if
        
	set(color_bar,'clim',[C_lim(1) C_lim(2)]);
% 	set(color_bar,'xlim',[1 64],'xtick',[1:63/10:64],'xticklabel',num2str([Z_lim(1):((Z_lim(2)-Z_lim(1))/10):Z_lim(2)]',precision));
% 	set(gcf,'currentaxes',color_bar);
% 	yla_cb = ylabel(c_label);
% 	set(yla_cb,'fontsize',10,'fontweight','bold');
% 	set(gca,'fontsize',10,'fontweight','bold');
% 	set(gcf,'currentaxes',caxes);
else
  color_bar = [];
end % c_label

axes(pah);
%dbstop
