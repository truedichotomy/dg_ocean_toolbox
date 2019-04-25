function [F,A,D,Err] = eof225(X, bad, toler)
more off

% OBS: I MADE A SMALL MODIFICATION ON THE ROUTINE. I DISABLED THE COMPUTATION OF THE
% CORRELATION (BECAUSE WAS GETTING DIVISION BY ZERO). IT TRULY DOESN'T MATTER, SINCE
% THE ROUTINE IS SETUP TO USE THE COVARIANCE MATRIX TO COMPUTE THE EOF's. IF FOR SOME
% REASON THAT MATTERS, CAN USE ROUTINE EOF225_ORIGINAL.M    MODIFICATIONS WERE DONE ON
% LINE 261
%
%
% compute the EOF analysis of a data set with (potentially) missing data
% compute the eigen vectors of the covariance matrix
%
% [F,A,D,Err] = eof225(X, bad, toler)
%
% input
%    X, the data matrix, x collumns, t rows
%    bad is the flag for missing data
%           recovered from estimated temporal amplitudes
%    toler  defines acceptable upper limit of expected
%           square error in percent
%
% output
%    F is the eigen vectors, loading
%    A are the EOF time series
%    D is the variance, eigen vectors
%    Err is the expected percent square error on each amplitude estimate
%
%    [My notes:  This routine use the covariance matrix (if the mean is removed from
%    the original time series). If want to use the correlation matrix, one has to
%    divide the matrix by the standard deviation before using the routine.
%    The routine also provides the values orthogonal, but not orthonormal. If want
%    orthonormal, take the output and:
%
%    Result: F(position,mode), A(time,mode)
%
%    F=F/sqrt(number of modes);
%    A=A*sqrt(number of modes);               RMC, 06/05/02]

[N,M] = size(X);

% get the correlation matrix-- more difficult due to missing data
R = zeros(M,M);
NR = zeros(M,M);
for i = 1:M
fprintf('doing %d of %d\n', i,M)
   for j = i:M
       [ltmp, rtmp, ptmp, ntmp] = cross_corr(X(:,i), X(:,j), 0, bad);
       R(i,j) = rtmp;
       R(j,i) = rtmp;
       NR(i,j) = ntmp;
       NR(j,i) = ntmp;
   end
end

% Decompose into singular matrices:
% F are orthonormal eigen vectors
[W,D,F] = svd(R);

% get variance for each mode
D = diag(D);

% amplitude functions
% find times where there are no missing grid points
not_missing = zeros(N,1);
for i = 1:N
  if isnan(bad)
   if (sum(~isnan(X(i,:)))==M)
       not_missing(i)=1;
   end
  else
   if (sum(X(i,:)~=bad)==M)
       not_missing(i)=1;
   end
  end
end

% easy for case of no missing data
A = zeros(N,M);
Err = zeros(N,M);
found_id = find(not_missing==1);
A(found_id,:) = X(found_id,:)*F;

% not easy for the case of missing grid points at a particular time
missing_id = find(not_missing==0);
NM = length(missing_id);

% do each of these times with the Davis 1977 fix
for i = 1:NM
   t = missing_id(i);
fprintf('doing %d of %d of missing\r', i, NM);
  if isnan(bad) % check for missing values is different for NaNs
   missing_gid = find(isnan(X(t,:)));
   found_gid = find(~isnan(X(t,:)));
  else
   missing_gid = find(X(t,:)==bad);
   found_gid = find(X(t,:)~=bad);
  end
% estimate gamma (the sum over the missing gridpoints)
   G = zeros(M,M);
   for j = 1:M
       for k = j:M % use symmetry trick
           G(j,k) = sum(F(missing_gid,j).*F(missing_gid,k));
           G(k,j) = G(j,k);
       end
    end

% do each mode now
   for j = 1:M

% H is a handy vector, needed below
       H = 0;
       for k = 1:M
           if (k~=j)
               H = H + D(k)*(G(j,k)^2);
           end
       end

       beta = (1-G(j,j)) * D(j);
       beta = beta/( D(j)*((1-G(j,j))^2) +  H);

% and the estimate of the amplitude
       A(t,j) = beta*sum(F(found_gid,j).*X(t,found_gid)');

% the error of this estimate is expected to be
% look carefully and see that this is variance [units]
       Err(t,j) = (beta*beta*H) + D(j)*( (1+beta*(G(j,j)-1))^2 );

% normalize by eigen value
% now, it will be non-dimensional
               Err(t,j) = Err(t,j)/D(j);
% check if Err exceeds the upper limit definded by toler
       if Err(t,j)*100>toler
       A(t,j) = bad;
       end

   end % loop j over M
end % loop i over N

% now fix up so mean square of F are 1
% that is F'*F = M I, the identity matrix
F = F*sqrt(M);
A = A/sqrt(M);

function [lag, R_xy, P_xy, n] = cross_corr(x, y, nlags, bad_flag)

% calculate cross correlations
%
% [lag, R_xy, P_xy, n] = cross_corr(x, y, nlags, bad_flag)
%
% input:
%       x,y the data sets
%       nlags are number of lags to process
%       bad_flag is data value that indicates missing or bad data
%
% output:
%       lag is lag from -nlag to +nlag
%       R_xy are covariances.
%       P_xy are correlations
%       n is array containing the number of data points used to
%        calculate each R

% put in column format
x=x(:);
y=y(:);

% this many data points
N=length(x);

% initialize output
R_xy = zeros(2*nlags+1,1);
P_xy = zeros(2*nlags+1,1);
n = zeros(2*nlags+1,1);
% check that y is same length
if (length(y)~=N)
   fprintf('x and y different lengths\n')
   return;
end

% find means
if(isnan(bad_flag))
   bad_flag=1e35;
       id = find(isnan(x));
       x(id) = bad_flag+0*id;
       id = find(isnan(y));
       y(id) = bad_flag+0*id;
end
good_id = find(x~=bad_flag);
if(length(good_id)>0)
   mean_x = mean(x(good_id));
else
   fprintf('no data found\n')
   return;
end
good_id = find(y~=bad_flag);
if(length(good_id)>0)
   mean_y = mean(y(good_id));
else
   fprintf('no data found\n')
   return;
end

% do the lags
cnt = 0;
for l=-nlags:1:nlags,
   cnt = cnt + 1;

% check for neg./pos lag
   if (l<0)
       k=(-1)*l;
       lag2_id = [1:1:(N-k)]';
       lag1_id = lag2_id+k;

   else
       k=l;
       lag1_id = [1:1:(N-k)]';
       lag2_id = lag1_id+k;
   end

% find good data in x series
   good_id = find( (x(lag1_id)~=bad_flag) );
   Ngoodx = length(good_id);

% continue with this lag if ther are data
   if (Ngoodx>0)
       lag1_id = lag1_id(good_id);
       lag2_id = lag2_id(good_id);

% find good data in y-series where x series was good
       good_id = find( (y(lag2_id)~=bad_flag) );
       Ngood = length(good_id);

% continue only if there are data
       if (Ngood>0)
           n(cnt) = Ngood;
           lag1_id = lag1_id(good_id);
           lag2_id = lag2_id(good_id);

% calculate statistics
% dudley's method
if (1)
   mean_1 = mean(x(lag1_id));
   mean_2 = mean(y(lag2_id));
   z1=x(lag1_id)-mean_1;
   z2=y(lag2_id)-mean_2;
end

% nathaniel's method
if (0)
   z1=x(lag1_id)-mean_x;
   z2=y(lag2_id)-mean_y;
end

% get the normalizing variances
           std_1 = sqrt(z1'*z1/Ngood );
           std_2 = sqrt(z2'*z2/Ngood);

% estimate cov. and corr.
           R_xy(cnt) = z1'*z2/Ngood;
%            P_xy(cnt) = R_xy(cnt)/(std_1*std_2);
           P_xy(cnt) = 0;  % I put this. To get original Dudley's code: delete this line and use line above

       end % check for good x -data
   end % check for good y -data
end % all lags

% reproduce lags
lag = [-nlags:1:nlags]';
