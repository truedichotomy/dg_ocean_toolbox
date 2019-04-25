function mind = dg_minind(a)
%% this function returns an array the same size as a, with 1 at the location of minimum
[amin, minind] = min(a);

mind = repmat(0,size(a));
mind(minind) = 1;