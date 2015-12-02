clear; close all; home

% dircont = dir('../segmentations/*.mat');
% dirnames = {dircont.name};
dirnames = {'5.05_ID1662_770_double.mat', '5.05_ID1662_771_double.mat', ...
            '5.05_ID1662_772_double.mat', '5.05_ID1662_773_double.mat', ...
            '5.05_ID1684_806_double.mat', '5.05_ID1684_809_double.mat', ...
            '5.05_ID1689_805_double.mat', '5.05_ID1689_807_double.mat', ...
            '5.05_ID1689_808_double.mat'};

for ii = 1:length(dirnames)
    disp(dirnames{ii})
end

for ii = 2:length(dirnames)
    name = dirnames{ii};
    fprintf('Loading segmentation file %s\n\n', name);

    % Used for loading in parallel
    % temp = load(['../segmentations/' name], 'savedImplantMasks');
    % savedImplantMasks = temp.savedImplantMasks;
    % clear('temp');

    load(['../segmentations/' name], 'savedImplantMasks');

    fprintf('Creating signed distance map for file %s\n\n', name);
    dstMap = sgnDstFromImg(savedImplantMasks);
    fprintf('Clearing savedImplantMasks for file %s\n\n', name);
    clear('savedImplantMasks')
    fprintf('Saving signed distance map for file %s\n\n', name);
    % For use when running in parallel
    % saveDstMap(dstMap, ['../segmentations/' name(1:end-4) 'sgnDstMap.mat'])
    save(['../segmentations/' name(1:end-4) 'sgnDstMap.mat'], 'dstMap')

    %-%-%-%-%-%-%-%-%-%-%
    % Downsample dstMap %
    %-%-%-%-%-%-%-%-%-%-%
    [lx, ly, lz] = size(dstMap);
    % [x, y, z] = ndgrid(1:lx, 1:ly, 1:lz);  % Can be omitted
    [xq, yq, zq] = ndgrid(linspace(1, size(dstMap, 3), lx/4), ...
                          linspace(1, size(dstMap, 3), ly/4), ...
                          linspace(1, size(dstMap, 3), lz/4));
    % x, y, z coordinates of original volume can be omitted can be omitted
    % dstMap = interpn(x, y, z, dstMap, xq, yq, zq);
    dstMap = interpn(dstMap, xq, yq, zq);
    clear('xq', 'yq', 'zq', 'lx', 'ly', 'lz')
    % For use when running in parallel
    % saveDstMap(dstMap, ['../smallSegmentations/' name(1:end-4) 'sgnDstMap.mat'])
    save(['../smallSegmentations/' name(1:end-4) 'sgnDstMap.mat'], 'dstMap')
    clear('dstMap')
end
