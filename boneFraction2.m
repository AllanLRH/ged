clear; %close all; clc
%%

timeRightNow = @() sprintf('%s:    ', datestr(datetime('now')));
fid          = fopen('logfile_boneFraction.txt', 'a');

stackSize = 1000;
seNextImg = strel('disk', 5);
seCleaner = strel('disk', 4);
boxsize   = 5;
load('circ.mat')  % Loads variable 'circ'
circArea  = sum(circ(:));

fileCell = {'5.05_ID1662_769_0001.vol', '5.05_ID1662_770_0001.vol', '5.05_ID1662_771_0001.vol',...
            '5.05_ID1662_772_0001.vol', '5.05_ID1662_773_0001.vol', '5.05_ID1684_806_0001.vol',...
            '5.05_ID1684_809_0001.vol', '5.05_ID1689_805_0001.vol', '5.05_ID1689_807_0001.vol',...
            '5.05_ID1689_808_0001.vol'};
%%
for fn = 2:length(fileCell)
    msg = sprintf('%sProcessing dataset containing file %s\n', timeRightNow(), fileCell{fn});
    fprintf(msg);
    fprintf(fid, msg);
    dataset = ['data/' fileCell{fn}];
    im      = normImage(loadDataset(dataset, 1));
    s       = size(im, 1);  %  square image dimmensions

    % Preallocate mask volumes -- logicals takes up 8 bits anyway, and initalizing to 2 makes error checking easier
    savedImplantMasks = zeros(s, s, stackSize, 'uint8') + 2;
    savedBoneMasks    = zeros(s, s, stackSize, 'uint8') + 2;

    % Load image where the initial bone and cavity areas are marked. Ignore granulate channel for now
    tempName    = fileCell{fn};
    tempName    = tempName(1:end-4);
    temp        = logical(imread(['firstImageInStack/' tempName '_mask.vol.png']));
    boneGuess   = temp(:,:,3);
    cavityGuess = temp(:,:,1);
    % granulateGuess = temp(:,:,2);

    [implantMask, boneMask, boneGuess, cavityGuess, boneCavityFraction, cavityFraction] = ...
    boneFractionInnerFunction(im, cavityGuess, boneGuess, circ, seNextImg, seCleaner, boxsize, 1);
    if all(not(implantMask(:)))
        msg = sprintf('No implantMask returned for slice %d\n', 1);
        warning(msg)
        fprintf(fid, msg);
    end
    savedImplantMasks(:, :, 1) = implantMask;
    savedBoneMasks(:, :, 1) = boneMask;

    fprintf(fid, 'boneCavityFraction for slice %d = %.8f\n', 1, boneCavityFraction);
    fprintf(fid, 'cavityFraction for slice %d = %.8f\n', 1, cavityFraction);

    %% Process the rest of the images in the dataset
    for ii = 2:stackSize
        msg = sprintf('%sProcessing image %d of %d in stack\n', timeRightNow(), ii, stackSize);
        fprintf(fid, msg);
        if mod(ii, 25) == 0
            fprintf(msg)
        end
        im = normImage(loadDataset(['data/' fileCell{fn}], ii));
        [implantMask, boneMask, boneGuess, cavityGuess, boneCavityFraction, cavityFraction] = ...
        boneFractionInnerFunction(im, cavityGuess, boneGuess, circ, seNextImg, seCleaner, boxsize, ii);
        if all(not(implantMask(:)))
            msg = sprintf('No implantMask returned for slice %d\n', ii);
            warning(msg)
            fprintf(fid, msg);
        end
        savedImplantMasks(:, :, ii) = implantMask;
        savedBoneMasks(:, :, ii) = boneMask;

        fprintf(fid, 'boneCavityFraction for slice %d = %.8f\n', ii, boneCavityFraction);
        fprintf(fid, 'cavityFraction for slice %d = %.8f\n', ii, cavityFraction);
    end
    if any(savedBoneMasks(:)) > 1
        msg = 'There are slices in savedBoneMasks which are not segmentet properly!\n';
        warning(msg)
        fprintf(fid, msg);
        msg = 'The following indices are affected';
        fprintf(msg)
        fprintf(fid, msg)
        [i, j, k] = ind2sub(size(savedBoneMasks), find(savedBoneMasks > 1));
        msg = sprintf('%d, %d, %d\n', i, j, k);
        fprintf(fid, msg)
    end
    if any(savedImplantMasks(:)) > 1
        msg = 'There are slices in savedImplantMasks which are not segmentet properly!\n';
        warning(msg)
        fprintf(fid, msg);
        msg = 'The following indices are affected';
        fprintf(msg)
        fprintf(fid, msg)
        [i, j, k] = ind2sub(size(savedImplantMasks), find(savedImplantMasks > 1));
        msg = sprintf('%d, %d, %d\n', i, j, k);
        fprintf(fid, msg)
    end
    datasetName = fileCell{fn};
    datasetName = datasetName(1:end-9);
    save(['segmentations2/' datasetName '.mat'], 'savedImplantMasks', 'savedBoneMasks')
    savedBoneMasks    = double(savedBoneMasks);
    savedImplantMasks = double(savedImplantMasks);
    save(['segmentations2/' datasetName '_double.mat'], 'savedImplantMasks', 'savedBoneMasks')

    % Create signed distance map
    try
        dstMap = sgnDstFromImg(savedImplantMasks);
        save(['segmentations2/' name(1:end-4) 'sgnDstMap.mat'], 'dstMap')
    catch
        exception = getReport(MException.last);
        errorMessage = sprintf(['Exception thrown in filename %s during signed distance '...
                                'map operation:\n%s'], fileCell{fn}, exception);
        warning(errorMessage)
        fprintf(fid, errorMessage);
        continue;
    end

    %% Create and save scaled down version of segmentations
    try
        [lx, ly, lz] = size(savedBoneMasks);
        [xq, yq, zq] = ndgrid(linspace(1, size(savedBoneMasks, 3), lx/4), ...
                              linspace(1, size(savedBoneMasks, 3), ly/4), ...
                              linspace(1, size(savedBoneMasks, 3), lz/4));
        savedBoneMasks = interpn(savedBoneMasks, xq, yq, zq);
        savedImplantMasks = interpn(savedImplantMasks, xq, yq, zq);
        save(['smallSegmentations2/' datasetName '_double.mat'], 'savedBoneMasks', 'savedImplantMasks')
        savedBoneMasks    = logical(savedBoneMasks);
        savedImplantMasks = logical(savedImplantMasks);
        save(['smallSegmentations2/' datasetName '.mat'], 'savedBoneMasks', 'savedImplantMasks')
        clear('savedBoneMasks')
        clear('savedImplantMasks')
    catch
        exception = getReport(MException.last);
        errorMessage = sprintf(['Exception thrown in filename %s during dataset scaling '...
                                'operation:\n%s'], fileCell{fn}, exception);
        warning(errorMessage)
        fprintf(fid, errorMessage);
        continue;
    end

    % Scale signed distance map
    try
        dstMap = interpn(dstMap, xq, yq, zq);
        save(['smallSegmentations2/' name(1:end-4) 'sgnDstMap.mat'], 'dstMap')
        clear('xq', 'yq', 'zq', 'lx', 'ly', 'lz')
        clear('dstmap')
    catch
        exception = getReport(MException.last);
        errorMessage = sprintf(['Exception thrown in filename %s during signed distance '...
                                'map scaling operation:\n%s'], fileCell{fn}, exception);
        warning(errorMessage)
        fprintf(fid, errorMessage);
        continue;
    end
end
