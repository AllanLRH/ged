clear; close; home

%% Load data
tic
load('~/minvol.mat')
toc
[x, y, z] = ndgrid(1:size(vol, 1), 1:size(vol, 2), 1:size(vol, 3));
toc


%%


volume = vol;

planePoints = 50;  % points along one direction, will be squared
angles = [20, 42, 68] * pi/180;

minXYZ = min(min([x(:) y(:) z(:)]));
maxXYZ = max(max([x(:) y(:) z(:)]));

% Calculate the lowest and highest corners of the tilted plane
planeMax = maxXYZ * (1 - min(cos(angles)))
planeMin = minXYZ * (1 - min(cos(angles)))

% Calculate start end end heights
% (planeMax - planeMin) is the length of the slicing plane, and
% it's divided by two because it rotated around the center.
% max(sin(angles)) is the (maximum) displacement of the corners of the
% plane, caused by the rotation.
startHeight = maxXYZ + (planeMax - planeMin)*max(sin(angles))/2
endHeight =   minXYZ - (planeMax - planeMin)*max(sin(angles))/2

figure
rotMat = getRotMat(angles);
% Make plane points for each iteration
for k = startHeight:-3:endHeight
    xax = linspace(floor(planeMin), ceil(planeMax), planePoints);
    yax = linspace(floor(planeMin), ceil(planeMax), planePoints);
    [xd, yd] = ndgrid(xax, yax);
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
    drawnow
end












































% %%
% planePoints = 50;  % points along one direction, will be squared
% % angles = [1, 1, 1] * pi/180;
%
% xax = linspace(size(vol, 1), size(vol, 2) , planePoints);
% yax = linspace(size(vol, 1), size(vol, 2) , planePoints);
% [xd, yd] = ndgrid(xax, yax);
% % rotMat = getRotMat(angles);
% % Make plane points for each iteration
% figure
% for k = 1:size(vol, 3)
%     zd = zeros(planePoints) + k;
%     % Make vectors from plane points, and apply rotation matrix
%     % for ii = 1:numel(xd)
%     %     vec = [xd(ii); yd(ii); zd(ii)];
%     %     vec = rotMat*vec;
%     %     xd(ii) = vec(1);
%     %     yd(ii) = vec(2);
%     %     zd(ii) = vec(3);
%     % end
%
%     % imslice = vol(:, :, k);
%     % imslice = interpn(x, y, z, vol, xd, yd, zd);
%     % imsc(imslice)
%     slice(x, y, z, vol, xd, yd, zd);
%     drawnow
% end
