clear; close all; home

N = 10;
vol = zeros(N, N, N);
[x, y] = ndgrid(1:N, 1:N);
plane = ones(N, N, 3);
plane(:, :, 1) = x;
plane(:, :, 2) = y;
plane(:, :, 3) = N/2;
[x, y, z] = ndgrid(1:N, 1:N, 1:N);

vol(plane(:,:,1), plane(:,:,2), plane(:,:,3)) = 1;

% vIntp = interpn(x, y, z, vol, plane(:, :, 1), plane(:, :, 2), plane(:, :, 3));


rotMat = getRotMat([10 0 0]);
for ii = 1:size(plane, 1)
    for jj = 1:size(plane, 2)
        vec = squeeze(plane(ii, ii, :));
        plane2(ii, jj, :) = round(rotMat*vec);
    end
end
plane2(plane2<1) = 1;
vol(plane2(:,:,1), plane2(:,:,2), plane2(:,:,3)) = 2;

figure
colorbar
axis image
for ii = 1:N
    pcolor(vol(:,:,ii))
    drawnow
    title(ii)
    pause(0.3)
    
end

% isosurface(vol, 0.5)