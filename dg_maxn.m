function maxval = dg_maxn(x)
    % this function finds the absolute max of x regardless of the dimensions of x
    % DG 20180530
    maxval = max(x,[],'omitnan');
    while length(maxval) ~= 1
        maxval = max(maxval,[],'omitnan');
    end