function [rho,sigma0] = dg_gsw_rho(temp,salt,z,lon,lat)
% synopsis: [rho,sigma0] = dg_gsw_rho(temp,salt,z,lon,lat)
%
% This function uses the GSW toolbox to calculate in-situ and potential density
% DG 20160322, initial version
%

if nargin <= 2
  z = 0
  lon = -147;
  lat = 71;
elseif nargin <= 3
  lon = -147;
  lat = 71;
end %if  

pres = gsw_p_from_z(z,lat);
saltA = gsw_SA_from_SP(salt,pres,lon,lat);
ctmp = gsw_CT_from_t(saltA,temp,pres);
rho = gsw_rho(saltA,ctmp,pres);
sigma0 = gsw_sigma0(saltA,ctmp);