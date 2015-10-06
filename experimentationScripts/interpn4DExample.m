clear; close all; home

f = @(x, y, z, t) t.*exp(-x.^2 - y.^2 - z.^2);

[x, y, z, t] = ndgrid(-1:0.2:1, -1:0.2:1, -1:0.2:1, 0:2:10);
V = f(x, y, z, t);

[xq, yq, zq, tq] = ndgrid(-1:0.05:1, -1:0.08:1, -1:0.05:1, 0:0.5:10);

Vq = interpn(x, y, z, t, V, xq, yq, zq, tq);

figure('renderer', 'zbuffer');
nframes = size(tq, 4);
for j = 1:nframes
   slice(yq(:,:,:,j), xq(:,:,:,j), zq(:,:,:,j), Vq(:,:,:,j), 0, 0, 0);
   caxis([0 10]);
   M(j) = getframe;
end
movie(M);
