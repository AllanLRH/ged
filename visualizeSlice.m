%% visualizeSlice: Visualize a slice through a volume
function visualizeSlice(theta, phi, psi, height, planePoints, volume)
    angles = [theta, phi, psi];
    [x, y, z] = meshgrid(linspace(min(min(volume, 1)), max(max(volume, 1)), size(volume, 1)),...
                         linspace(min(min(volume, 2)), max(max(volume, 2)), size(volume, 2)),...
                         linspace(min(min(volume, 3)), max(max(volume, 3)), size(volume, 3)));

    minXYZ = min(volume(:));
    maxXYZ = max(volume(:));

    % Calculate the lowest and highest corners of the tilted plane
    planeMax = maxXYZ * (1 - min(cos(angles)));
    planeMin = minXYZ * (1 - min(cos(angles)));

    % Calculate start end end heights
    % (planeMax - planeMin) is the length of the slicing plane, and
    % it's divided by two because it rotated around the center.
    % max(sin(angles)) is the (maximum) displacement of the corners of the
    % plane, caused by the rotation.
    startheight = maxXYZ + (planeMax - planeMin)*max(sin(angles))/2;
    endHeight =   minXYZ - (planeMax - planeMin)*max(sin(angles))/2;

    figure
    rotMat = getRotMat(angles);
    % Make plane points for each iteration
    for k = startheight:-0.05:endHeight
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
    end  % for k...

end  % function
