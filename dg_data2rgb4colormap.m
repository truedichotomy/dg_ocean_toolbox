function datac = dg_data2rgb4colormap(data,colormap,crange)
% synopsis: function datac = dg_data2rgb4colormap(data,colormap,crange)
%
% DG 2011-04-26  this function calculate the rgb values for input data given custom colormap and specified crange
%
datac = repmat(NaN,[size(data,1),3]);
cres = (max(crange) - min(crange)) / size(colormap,1);

minind = find(data <= min(crange));
datac(minind,:) = repmat(colormap(1,:),length(minind),1);

maxind = find(data >= max(crange));
datac(maxind,:) = repmat(colormap(end,:),length(maxind),1);

for ii = 1:size(colormap,1)
  %crange1 = [crange(1) + (ii-1)*cres crange(1) + ii*cres]
  ind = find(data < crange(1) + ii*cres & data >= crange(1) + (ii-1)*cres)
  if ~isempty(ind)
    datac(ind,:) = repmat(colormap(ii,:),length(ind),1);
  end %if
end %for
