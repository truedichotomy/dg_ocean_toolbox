function theDateNum = julian2datenum(theJulian)

% julian2datenum -- Convert Julian Day to Matlab datenum.
%  julian2datenum(theJulian) converts theJulian decimal
%   day to its equivalent Matlab datenum.  The Julian
%   day is referenced to midnight, not noon.
 
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 26-Oct-1998 15:49:22.

if nargin < 1, help(mfilename), return, end

t0 = datenum(1968, 5, 23) - 2440000;   % May 23, 1968.

result = theJulian + t0;

if nargout > 0
	theDateNum = result;
else
	disp(result)
end
