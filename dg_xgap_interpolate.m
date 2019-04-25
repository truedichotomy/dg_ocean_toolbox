function yout = dg_xgap_interpolate(xin,yin,xout,xgap,flag)
% function yout = dg_xgap_interpolate(xin,yin,xout,xgap,flag)
%
% This function interpolate time series data with NaN values using interp1 but only interpolate over time intervals less than xgap, otherwise use NaN to punctuate the interpolation.
% DG 20170627

  % find y data that does not include NaN values
  nnanind = find(~isnan(yin));

  % find the time/x gaps in the y data with NaN values removed.
  dx = diff(xin(nnanind));

  % find time/x gap indices where the gap exceed the specified amount
  dxgapi = find(dx > xgap);

  % define new time/x index to include times when y values of NaN for large time/x gaps in the y data
  tgap = xin(nnanind(dxgapi))+xgap/2;
  ygap = repmat(NaN,size(tgap));

  % sort the newly constructed x and y data with NaN inserted at large gap locations
  [tin,tini] = sort([xin(nnanind); tgap]);
  yin = [yin(nnanind); ygap];
  yin = yin(tini);

  % use interp1 to interpolate the dataset
  yout = interp1(tin,yin,xout,flag);
