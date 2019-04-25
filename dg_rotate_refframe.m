function [ur, vr] = dg_rotate_refframe(u,v,ang)
%% synopsis: [ur, vr] = dg_rotate_refframe(u,v,ang)
%%
%% this function rotates the reference frame which the input vector [u, v]
%% lays in by ang in degrees (positive counterclockwise rotation of reference frame)
%%
%% DG 20080501
%%
uv = u + i .* v;

uvr = exp(-i*ang*pi/180) .* uv;

ur = real(uvr);
vr = imag(uvr);

%u = reshape(u,1,length(u));
%v = reshape(v,1,length(v));
%uvr = [[cosd(ang), -sind(ang)]; [sind(ang) cos(ang)]] * [u;v];
%ur = uvr(1,:)';
%vr = uvr(2,:)';