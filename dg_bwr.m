function cm_bwr = dg_bwr(ncolor)
%% this colorbar fades from red (neg) through white to blue (pos)

%ncolor = 10;
rgbmax = 0.88;

if ncolor == 2
	cm_bwr = [[0 0 rgbmax]; [rgbmax 0 0]];
elseif ncolor == 3	
	cm_bwr = [[0 0 rgbmax];[rgbmax rgbmax rgbmax];[rgbmax 0 0]];
elseif ncolor > 3
	if mod(ncolor,2) == 1
		
		colorintv = rgbmax / ((ncolor-1)/2);
		cpos = [0:colorintv:rgbmax]';
		cneg = [rgbmax:-colorintv:0]';
		
		%% recall colormap matrix go from bottom up the colorbar
		%% the first element is color for the bottom of the colorbar
		rc = [repmat(rgbmax,size(cpos)); cneg(2:end)]; %% red channel		1 -> 1 -> 0
		gc = [cpos;cneg(2:end)]; %% green channel  0 -> 1 -> 0
		bc = [cpos;repmat(rgbmax, [size(cneg,1)-1, size(cneg,2)])]; %% blue channel  0 -> 1 -> 1
		
		cm_bwr = [rc, gc, bc];

	else
		
		colorintv = rgbmax / (ncolor/2);		
		cpos = [0:colorintv:rgbmax]';
		cneg = [rgbmax:-colorintv:0]';
		
		rc = [repmat(rgbmax,[size(cpos,1)-1,size(cpos,2)]); cneg(2:end)]; %% red channel		1 -> 1 -> 0
		gc = [cpos(1:end-1);cneg(2:end)]; %% green channel  0 -> 1 -> 0
		bc = [cpos(1:end-1);repmat(rgbmax, [size(cneg,1)-1, size(cneg,2)])]; %% blue channel  0 -> 1 -> 1		

		cm_bwr = [rc, gc, bc];
		
	end %if	
end %if