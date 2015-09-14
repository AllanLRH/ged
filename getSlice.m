function imgSlice = getSlice(vol, angles, height, planePoints)
    xax = linspace(-size(vol, 1)/sqrt(2), size(vol, 1)/sqrt(2), planePoints);
    yax = linspace(-size(vol, 2)/sqrt(2), size(vol, 2)/sqrt(2), planePoints);
    rotMat = getRotMat(angles);

    xv = (1:size(vol, 1)) - size(vol, 1)/2;
    yv = (1:size(vol, 2)) - size(vol, 2)/2;
    zv = (1:size(vol, 3)) - size(vol, 3)/2;
    [x, y, z] = ndgrid(xv, yv, zv);

    [xd, yd] = meshgrid(xax, yax);
    zd = zeros(planePoints) + height;
    for ii = 1:numel(zd)
        vec = [xd(ii); yd(ii); zd(ii)];
        % vec = rotMat*vec;
        vec = [rotMat(1,1)*vec(1) + rotMat(1,2)*vec(2) + rotMat(1,3)*vec(3)
               rotMat(2,1)*vec(1) + rotMat(2,2)*vec(2) + rotMat(2,3)*vec(3)
               rotMat(3,1)*vec(1) + rotMat(3,2)*vec(2) + rotMat(3,3)*vec(3)];
        xd(ii) = vec(1);
        yd(ii) = vec(2);
        zd(ii) = vec(3);
    end
    imgSlice = interpn(x, y, z, vol, xd, yd, zd);
end  % getslice

