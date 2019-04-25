
function sp=spice(T,S)

% SPICE   Spiciness of sea water
%========================================================
% SPICE  $Revision: 1.0 $  $Date: 2000/03/15=20
%         Copyright (C) UABC,NPS, Reginaldo Durazo
%
% USAGE:  sp = spice(T,S)
%
% DESCRIPTION:
%    Spiciness of Sea Water using Flament (1986) algorithm
%
% INPUT:  (all must have same dimensions)
%   T =3D temperature [degree C (IPTS-68)]
%   S =3D salinity    [psu      (PSS-78)]
%
% OUTPUT:
%   sp = Spiciness of salt water with properties T,S
% 
% AUTHOR:  Reginaldo Durazo, 2000-03-15  (rdurazo@faro.ens.uabc.mx)
%                                        (rdurazo@oc.nps.navy.mil)
%
% DISCLAIMER:
%   This software is provided "as is" without warranty of any kind.  
%
% REFERENCES:
%     Flament, P. (1986). Subduction and fine structure associated with
%          upwelling filaments. PhD thesis, University of California,
%          San Diego.
%
%     P. Flament wrote the original in C+ code. This version has been
%     adapted from a FORTRAN routine written by N.P. Fofonoff
%
% ===================================================================

% help when called without input arguments

if nargin == 0
    help spice
    return
end

sr=S-35;

% Define constants

b0= sr.*(7.744246e-1 + sr.*(-5.845234e-3 + sr.*(-9.843273e-4 + sr.*(-2.063847e-4))));

b1= 5.165459e-2 + sr.*(2.033976e-3 + sr.*(-2.742385e-4 + sr.*(-8.464745e-6 + sr.*(1.355293e-5))));

b2= 6.647835e-3 + sr.*(-2.468093e-4 + sr.*(-1.428048e-5 + sr.*(3.336995e-5 + sr.*(7.894118e-6))));

b3= -5.402301e-5 + sr.*(7.326079e-6 + sr.*(7.003552e-6 + sr.*(-3.041191e-6 + sr.*(-1.085288e-6))));

b4= 3.948544e-7 + sr.*(-3.029096e-8 + sr.*(-3.82091e-7 +  sr.*(1.001165e-7 + sr.*(4.713275e-8))));

b5= -6.358173e-10 + sr.*(-1.309038e-9 + sr.*(6.048335e-9 + sr.*(-1.140921e-9 + sr.*(-6.676209e-10))));

% Calculate spiciness

sp=b0+T.*(b1+T.*(b2+T.*(b3+T.*(b4+T.*b5))));

% ==========================================================================


