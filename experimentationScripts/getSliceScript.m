clear; close; home

% [x, y, z] = ndgrid(-2:.2:2, -2:.25:2, -2:.16:2);
% volume = x.*exp(-x.^2 - y.^2 - z.^2);

% load('minivol.mat');
% volume = normImage(vol);

volume = normImage(makeCircle(128, 40, [64 64]) - makeCircle(128, 45, [64 64]));
volume = repmat(volume, 1, 1, 85);
vol = volume;

xv = (1:size(vol, 1)) - size(vol, 1)/2;
yv = (1:size(vol, 2)) - size(vol, 2)/2;
zv = (1:size(vol, 3)) - size(vol, 3)/2;
[x, y, z] = ndgrid(xv, yv, zv);

planePoints = 256;  % points along one direction, will be squared
angles = [20, 42, 68] * pi/180;

minXYZ = min(min([x(:) y(:) z(:)]));
maxXYZ = max(max([x(:) y(:) z(:)]));

% Calculate the lowest and highest corners of the tilted plane
planeMax = maxXYZ * (1 - min(cos(angles)));
planeMin = minXYZ * (1 - min(cos(angles)));

% Calculate start end end heights
% (planeMax - planeMin) is the length of the slicing plane, and
% it's divided by two because it rotated around the center.
% max(sin(angles)) is the (maximum) displacement of the corners of the
% plane, caused by the rotation.
startHeight = maxXYZ + (planeMax - planeMin)*max(sin(angles))/2;
endHeight =   minXYZ - (planeMax - planeMin)*max(sin(angles))/2;

figure
rotMat = getRotMat(angles);
% Make plane points for each iteration
for k = startHeight:-1:endHeight
    % xax = linspace(floor(2*planeMin), ceil(0.5*planeMax), planePoints);
    % yax = linspace(floor(2*planeMin), ceil(0.5*planeMax), planePoints);
    xax = linspace(-128, 128, planePoints);
    yax = linspace(-128, 128, planePoints);
    [xd, yd] = meshgrid(xax, yax);
    zd = zeros(planePoints) + k;
    % Make vectors from plane points, and apply rotation matrix
    for ii = 1:numel(xd)
        vec = [xd(ii); yd(ii); zd(ii)];
        vec = rotMat*vec;
        xd(ii) = vec(1);
        yd(ii) = vec(2);
        zd(ii) = vec(3);
    end

    imslice = interpn(x, y, z, volume, xd, yd, zd);
    imsc(imslice)
    colorbar
    caxis([0 1])
    drawnow
end
