function [h1,h2,ax1,ax2] = dg_plotyy(x1,y1,c1,x2,y2,c2);
%% synposis: [h1,h2,ax1,ax2] = dg_plotyy(x1,y1,x2,y2,c1,c2)
%% Donglai Gong 2010-06-01
%%
if ~exist('c1')
	c1 = 'k';
end %if

if ~exist('c2')
	c2 = 'b';
end %if

h1 = line(x1,y1,'color',c1);
ax1 = gca;
set(ax1,'xcolor',c1,'ycolor',c1,'color','none');
ax2 = axes('position',get(ax1,'position'),'xaxislocation','top','yaxislocation','right','color','none','xcolor',c2,'ycolor',c2);
h2 = line(x2,y2,'color',c2,'parent',ax2);
