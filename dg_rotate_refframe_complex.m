function uvr = dg_rotate_refframe_complex(uv,ang)
%% synopsis: uvr = dg_rotate_refframe_complex(uv,ang)
%%
%% this function rotates the reference frame which the input vector [u, v]
%% lays in by ang in degrees (positive counterclockwise rotation of reference frame)
%%
%% DG 20080501
%%

uvr = exp(-i*ang*pi/180) .* uv;
