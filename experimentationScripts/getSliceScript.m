clear; close; home

% [x, y, z] = ndgrid(-2:.2:2, -2:.25:2, -2:.16:2);
% volume = x.*exp(-x.^2 - y.^2 - z.^2);

% load('minivol.mat');
% volume = normImage(vol);

sideLength = 128;
volume = normImage(makeCircle(sideLength, 40, [sideLength/2 sideLength/2]) - makeCircle(sideLength, 45, [sideLength/2 sideLength/2]));
volume = repmat(volume, 1, 1, 85);
vol = volume;

xv = (1:size(vol, 1)) - size(vol, 1)/2;
yv = (1:size(vol, 2)) - size(vol, 2)/2;
zv = (1:size(vol, 3)) - size(vol, 3)/2;
[x, y, z] = ndgrid(xv, yv, zv);

planePoints = 256;  % points along one direction, will be squared
angles = [35, 10, -10] * pi/180;

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
xax = linspace(-sideLength, sideLength, planePoints);
yax = linspace(-sideLength, sideLength, planePoints);
for k = startHeight:-1:endHeight
    % xax = linspace(floor(2*planeMin), ceil(0.5*planeMax), planePoints);
    % yax = linspace(floor(2*planeMin), ceil(0.5*planeMax), planePoints);
    [xd, yd] = meshgrid(xax, yax);
    zd = zeros(planePoints) + k;
    % Make vectors from plane points, and apply rotation matrix
    for ii = 1:numel(xd)
        vec = [xd(ii); yd(ii); zd(ii)];
        % vec = rotMat*vec;
        vec = [rotMat(1,1)*vec(1) + rotMat(1,2)*vec(2) + rotMat(1,3)*vec(3)
               rotMat(2,1)*vec(1) + rotMat(2,2)*vec(2) + rotMat(2,3)*vec(3)
               rotMat(3,1)*vec(1) + rotMat(3,2)*vec(2) + rotMat(3,3)*vec(3)];
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
