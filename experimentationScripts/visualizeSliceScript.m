clear; close; home

[x, y, z] = meshgrid(-2:.2:2, -2:.25:2, -2:.16:2);
volume = x.*exp(-x.^2 - y.^2 - z.^2);

planePoints = 16;  % points along one direction, will be squared
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
for k = startHeight:-0.05:endHeight
    xax = linspace(floor(planeMin), ceil(planeMax), planePoints);
    yax = linspace(floor(planeMin), ceil(planeMax), planePoints);
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

    % Draw some volume boundaries
    slice(x, y, z, volume, [min(x(:)), max(x(:))], max(y(:)), min(z(:)))
    hold on
    % Draw slicing plane
    slice(x, y, z, volume, xd, yd, zd)
    hold off
    view(-5, 10)
    axis([-2.5 2.5 -2 2 -2 4])
    drawnow
    disp(k)    
end
