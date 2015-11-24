clear; close all; home

dircont = dir('../segmentations/*.mat');
dirnames = {dircont.name};

for ii = 1:length(dirnames)
    disp(dirnames{ii})
end

parfor ii = 1:length(dirnames)
    name = dirnames{ii};
    fprintf('Loading segmentation file %s\n\n', name);
    temp = load(['../segmentations/' name], 'savedImplantMasks'); savedImplantMasks = temp.savedImplantMasks;
    fprintf('Creating signed distance map for file %s\n\n', name);
    dstMap = sgnDstFromImg(savedImplantMasks);
    fprintf('Saving signed distance map for file %s\n\n', name);
    saveDstMap(dstMap, ['../segmentations/' name(1:end-4) 'sgnDstMap.mat'])
    %-%-%-%-%-%-%-%-%-%-%
    % Downsample dstMap %
    %-%-%-%-%-%-%-%-%-%-%
    [lx, ly, lz] = size(savedImplantMasks);
    [x, y, z] = ndgrid(1:lx, 1:ly, 1:lz);
    [xq, yq, zq] = ndgrid(linspace(1, size(savedImplantMasks, 3), lx/4), ...
                          linspace(1, size(savedImplantMasks, 3), ly/4), ...
                          linspace(1, size(savedImplantMasks, 3), lz/4));
    dstMap = interpn(x, y, z, savedImplantMasks, xq, yq, zq);
    saveDstMap(dstMap, ['../smallSegmentations/' name(1:end-4) 'sgnDstMap.mat'])
end
