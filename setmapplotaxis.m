function setmapplotaxis(axishandle, lonmin, lonmax, latmin, latmax)

% xmin, xmax, ymin, ymax from lat,lon
[xmin, ymin] = ll2merc(lonmin,latmin, 0);
[xmax, ymax] = ll2merc(lonmax,latmax, 0);

% Create a box matrix containing the original axes bounds
old_bounds = [xmin ymin; xmin ymax; xmax ymin; xmax ymax; xmin ymin];

xticklength = 2 * (xmax - xmin)/100; % X - The length of the major tick marks
yticklength = 2 * (ymax - ymin)/100; % Y
xmticklength = 0.75 * (xmax - xmin)/100; % X - The length of the minor tick marks
ymticklength = 0.75 * (ymax - ymin)/100; % Y
xlabelspace = 1 * (xmax - xmin)/50; % X - This is the space between the axis and the numbers
ylabelspace = 1 * (ymax - ymin)/50; % Y
set(axishandle,'XLim', [xmin xmax]); % X - Set the axis limits to the limits of the data
set(axishandle,'YLim', [ymin ymax]); % Y
poss_inters = [10 5 2 1 0.5 0.25]; % These are the possible intervals of tickmarks
poss_minordiv = [5 5 4 4 6 15]; % These are the cooresponding minor tickmark intervals

% Figure the largest possible tick mark interval that has less than
% 6 tick marks per axis.
% Firstly we build an array of possible numbers of tickmarks for
% each axis. Each element in this array cooresponds to an element
% in the poss_inters array. So poss_inters is the increments of
% the tickmarks and poss_ticks_x and poss_ticks_y are the number
% of tickmarks given the increment that would fit on each axis.
poss_ticks_x = floor((lonmax-poss_inters.*ceil(lonmin./poss_inters))./poss_inters);
poss_ticks_y = floor((latmax-poss_inters.*ceil(latmin./poss_inters))./poss_inters);
% Here we find the smallest possible interval with no more than
% six tickmarks for each axis. We also select the cooresponding minor
% tickmark interval.
for sel_inter = 1:length(poss_inters);
    if (poss_ticks_x(sel_inter) < 7)
        xlabelinter = poss_inters(sel_inter);
        xminordiv = poss_minordiv(sel_inter);
    end %if
end %for
for sel_inter = 1:length(poss_inters);
    if (poss_ticks_y(sel_inter) < 7)
        ylabelinter = poss_inters(sel_inter);
        yminordiv = poss_minordiv(sel_inter);        
    end %if
end %for
% We walk away with xlabelinter and ylabel inter that are the
% desired intervals for the major tick marks

% Here we make the x and y axis have the same tickmark interval.
% The shorter axis has the say in the interval size.
if ((xmax-xmin) < (ymax-ymin))
    ylabelinter = xlabelinter;
    yminordiv = xminordiv;
else
    xlabelinter = ylabelinter;
    xminordiv = yminordiv;
end %if

% Now we apply these intervals to find the location of the
% tickmarks. We creat an array of them. We start at the first
% point in the axis that is an even multiple of the interval and
% jump up at the interval to the max of the axis. We do this for x
% and y.
newxlabel = xlabelinter*ceil(lonmin/xlabelinter):xlabelinter:lonmax;
newylabel = ylabelinter*ceil(latmin/ylabelinter):ylabelinter:latmax;
% Now we must convert to mercator x,y from lat,lon
[newxtick,newytick] = ll2merc(-newxlabel,newylabel,0);
newxtick = -newxtick; % Take care of the fact that we are in the negative hemisphere
% Generate the major tickmarks, labels, and gridlines
for sel_tick = 1:length(newxlabel)
    x_minutes = abs(round((newxlabel(sel_tick)-ceil(newxlabel(sel_tick)))*60)); % We find the number of minutes past the last even degree
    x_htext = text(newxtick(sel_tick),ymin-xlabelspace,sprintf('%d° %d''',ceil(newxlabel(sel_tick)),x_minutes)); % We make the tickmark label
    set(x_htext,'VerticalAlignment','top','HorizontalAlignment','center','FontSize',8); %,'FontWeight','Bold');
    x_hline = line([newxtick(sel_tick) newxtick(sel_tick)], [ymin ymax]); % Draw the grid line (the one that goes across the map)
    set(x_hline,'Color', [0.1 0.1 0.1], 'LineStyle', ':'); % Set the line style
    
    x_htickline = line([newxtick(sel_tick) newxtick(sel_tick)], [ymin ymin-xticklength]); % Draw the major tickmark
    
    x_htickline = [x_htickline; line([newxtick(sel_tick) newxtick(sel_tick)], [ymax ymax+xticklength])]; % Draw the major tickmark

    
    set(x_htickline,'Color', 'k', 'clipping', 'off'); % Set the line style
end %for sel_tick
% Now do the same thing for the y
for sel_tick = 1:length(newylabel)
    y_minutes = round((newylabel(sel_tick)-floor(newylabel(sel_tick)))*60);
    y_htext = text(xmin-ylabelspace, newytick(sel_tick), sprintf('%d° %d''',floor(newylabel(sel_tick)),y_minutes));
    set(y_htext,'VerticalAlignment','middle','HorizontalAlignment','right','FontSize',8); %,'FontWeight','Bold');
    y_hline = line([xmin xmax], [newytick(sel_tick) newytick(sel_tick)]);
    set(y_hline,'Color', [0.1 0.1 0.1], 'LineStyle', ':');
    y_htickline = line([xmin xmin-yticklength], [newytick(sel_tick) newytick(sel_tick)]);
    y_htickline = [y_htickline; line([xmax xmax+yticklength], [newytick(sel_tick) newytick(sel_tick)])];
    set(y_htickline,'Color', 'k', 'clipping', 'off');
end %for sel_tick

% Now minor tickmark stuff:
% This next 3 lines do two things at once. It first composes the array
% of minor tickmarks from the first point that is an even multiple
% of the minor tick mark division to the last tickmark that can
% fit one th axis. Then the second thing it does is convert these
% to mercator x,y form lat,lon.
minorlon = xlabelinter/xminordiv*ceil(lonmin/(xlabelinter/xminordiv)):xlabelinter/xminordiv:lonmax;
minorlat = ylabelinter/yminordiv*ceil(latmin/(ylabelinter/yminordiv)):ylabelinter/yminordiv:latmax;
[minorx,minory] = ll2merc(minorlon,minorlat,0);
% Now the minor tick marks are generated
for sel_minor_tick = 1:length(minorx)
    added_length = xmticklength;
    if ((mod(minorlon(sel_minor_tick),xlabelinter/2) == 0) && (mod(xminordiv,2) == 0))
       added_length = xticklength; 
    end
    if ((mod(minorlon(sel_minor_tick),xlabelinter/3) == 0) && (xminordiv == 15))
       added_length = xticklength; 
    end
    x_hminortick = line([minorx(sel_minor_tick) minorx(sel_minor_tick)], [ymin ymin-added_length]); % Generate the tickmark
    x_hminortick = [x_hminortick; line([minorx(sel_minor_tick) minorx(sel_minor_tick)], [ymax ymax+added_length])]; % Generate the tickmark
    set(x_hminortick,'Color', 'k', 'clipping', 'off'); % Set the line style
end
% This is done again for the y
for sel_minor_tick = 1:length(minory)
    added_length = ymticklength;
    if ((mod(minorlat(sel_minor_tick),ylabelinter/2) == 0) && (mod(yminordiv,2) == 0))
       added_length = yticklength; 
    end
    if ((mod(minorlat(sel_minor_tick),ylabelinter/3) == 0) && (yminordiv == 15))
       added_length = yticklength; 
    end
    y_hminortick = line([xmin xmin-added_length], [minory(sel_minor_tick) minory(sel_minor_tick)]); % Generate the tickmark
    y_hminortick = [y_hminortick ; line([xmax xmax+added_length], [minory(sel_minor_tick) minory(sel_minor_tick)])]; % Generate the tickmark
    set(y_hminortick,'Color', 'k', 'clipping', 'off'); % Set the line style
end


set(axishandle, 'xtick', []); % X - Turn off all matlab generated tickmarks
set(axishandle, 'ytick', []); % Y
set(axishandle, 'DataAspectRatio', [1 1 1], 'DataAspectRatioMode', 'manual'); % Set the data aspect to 1 to 1
box on % Create a box around the whole map
