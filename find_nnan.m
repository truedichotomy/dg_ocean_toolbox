function xout = find_nnan(xin)
% synopsis: function xout = find_nnan(xin)
%
% find_nnan finds all NaN values in a array and return the indices that are NOT NaN's.
% DG  2006-01-26
xout = setdiff([1:length(xin)],find(isnan(xin)));