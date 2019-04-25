function minval = dg_minn(x)
    % this function finds the absolute min of x regardless of the dimensions of x
    % DG 20180530
    minval = min(x,[],'omitnan');
    while length(minval) ~= 1
        minval = min(minval,[],'omitnan');
    end