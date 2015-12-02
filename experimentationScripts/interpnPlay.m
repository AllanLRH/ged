clear; close; format short g; home

disp('Running interpnPlay.m')

lx = 10;
ly = 12;
lz = 14;
v = 1:lx*ly*lz;
v = reshape(v, [lx ly lz]);

[x, y, z] = ndgrid(linspace(1, size(v, 1), lx), linspace(1, size(v, 2), ly),...
                   linspace(1, size(v, 3), lz));
[xq, yq, zq] = ndgrid(linspace(1, size(v, 1), 3), linspace(1, size(v, 2), 3),...
                      linspace(1, size(v, 3), 3));
vq = interpn(x, y, z, v, xq, yq, zq);

disp(all(all(all(vq == interpn(v, xq, yq, zq)))))

disp(size(vq))
disp(vq)
% dv = v - vq;
% disp(all(dv(:) < 1e-15))

