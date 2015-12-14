clear; %close all; clc
%%

timeRightNow = @() sprintf('%s:    ', datestr(datetime('now')));
fid = fopen('logfile_boneFraction.txt', 'a');

nBands = 100;
stackSize = 1000;
boxsize = 5;
load('circ.mat')
circArea     = sum(circ(:));

boneVolume  = NaN*ones(stackSize, nBands);
area        = NaN*ones(stackSize, nBands);

fileCell = {'5.05_ID1662_769_0001.vol', '5.05_ID1662_770_0001.vol', '5.05_ID1662_771_0001.vol',...
            '5.05_ID1662_772_0001.vol', '5.05_ID1662_773_0001.vol', '5.05_ID1684_806_0001.vol',...
            '5.05_ID1684_809_0001.vol', '5.05_ID1689_805_0001.vol', '5.05_ID1689_807_0001.vol',...
            '5.05_ID1689_808_0001.vol'};
%%
for fn = 1:length(fileCell)
    msg = sprintf('%sProcessing dataset containing file %s\n', timeRightNow(), fileCell{fn});
    fprintf(msg);
    fprintf(fid, msg);
    dataset = ['data/' fileCell{fn}];
    im1 = normImage(loadDataset(dataset, 1));
    s = size(im1, 1);  %  square image dimmensions

    % Preallocate mask volumes -- logicals takes up 8 bits anyway, and initalizing to 2 makes error checking easier
    savedImplantMasks = zeros(s, s, stackSize, 'uint8') + 2;
    savedBoneMasks = zeros(s, s, stackSize, 'uint8') + 2;

    implantMask  = segmentImplant(im1, 1);
    savedImplantMasks(:, :, 1) = implantMask;
    interestMask = (circ & ~implantMask);
    bias         = biasCorrect(im1, interestMask);
    im1          = im1 - bias;

    % Load image where the initial bone and cavity areas are marked. Ignore granulate channel for now
    tempName = fileCell{fn};
    tempName = tempName(1:(length(tempName)-4));
    temp          = logical(imread(['firstImageInStack/' tempName '_mask.vol.png']));
    boneMask      = temp(:,:,3);
    cavityMask    = temp(:,:,1);
    % granulateMask = temp(:,:,2);

    % Get estimates fo the mean and the standard deviation for canity and bone, using the masks loaded above
    boneStd      = std(im1(boneMask));
    boneMean     = mean(im1(boneMask));
    cavityStd    = std(im1(cavityMask));
    cavityMean   = mean(im1(cavityMask));
    % granulateStd    = std(im1(granulateMask));
    % granulateMean   = mean(im1(granulateMask));

    % Calculate the mean and std image
    meanImg      = getMeanImage(im1, interestMask, boxsize);
    stdImg       = getVarImage(im1, interestMask, boxsize, meanImg);

    % First center the mean and std images around 0, using the estimates from the loaded masks
    % The square the values and compare them to get a bone-mask and cavity-mask
    bone1        = (meanImg-boneMean).^2 + (stdImg-boneStd).^2;
    cavity1      = (meanImg-cavityMean).^2 + (stdImg-cavityStd).^2;
    mask1        = (bone1 > cavity1);

    % Clean up the mask a bit, save the result
    seCleaner         = strel('disk', 4);
    mask2             = imclose(mask1, seCleaner) & interestMask;
    savedBoneMasks(:, :, 1) = mask2;

    % Shrink the "selected" areas in the masks, and use theese new masks for estimating the
    % mean and standard deviation for the next image in the stack
    seNextImg         = strel('disk', 5);
    boneMaskNextImg   = imerode(~mask1, seNextImg) & interestMask;  % why isn't the ~ on the cavityMaskNextImg?
    cavityMaskNextImg = imerode(mask1, seNextImg) & interestMask;

    % Do statistics
    dstMap                = sgnDstFromImg(implantMask);
    dstBorders            = [dstMap(1:s, 1) dstMap(1:s, s) dstMap(1, 1:s)' dstMap(s, 1:s)'];
    maxRadius             = floor(min(dstBorders(:)));
    bandBorders           = linspace(0, maxRadius, nBands);
    tempBoneMask          = (~mask1 & interestMask);
    tempCavityMask        = (mask1 & interestMask);
    boneCavityFraction    = NaN*ones(stackSize, 1);
    boneCavityFraction(1) = sum(tempBoneMask(:))/sum(tempCavityMask(:));

    for ii = 1:nBands
        dstMask = (dstMap < bandBorders(ii)) & (dstMap > 0);
        boneVolume(fn, ii) = sum(boneMask(dstMask));
        area(fn, ii) = sum(dstMask(:));
    end

    %% Process next image
    for ii = 2:stackSize
        if mod(ii, 50) == 0
            msg = sprintf('%sProcessing image %d of %d in stack\n', timeRightNow(), ii, stackSize);
            fprintf(msg)
            fprintf(fid, msg)
        end
        im2 = normImage(loadDataset('5.05_ID1662_769_0001.vol', ii));
        implantMask  = segmentImplant(im2, ii);
        interestMask = (circ & ~implantMask);
        bias         = biasCorrect(im2, interestMask);
        im2          = im2 - bias;

        boneMean     = median(im2(boneMaskNextImg));
        boneStd      = median(abs(im2(boneMaskNextImg)-boneMean));
        cavityStd    = std(im2(cavityMaskNextImg));
        cavityMean   = mean(im2(cavityMaskNextImg));
        % Using median for a "mean-ness" measure, becaus of it's robustness for
        % (unskewed) noise and certainly from "hot pixels" (Jon's proposal)
        % cavityMean = median(im2(cavityMaskNextImg));
        % cavityStd  = median(abs(im2(cavityMaskNextImg)-cavityMean));

        meanImg  = getMeanImage(im2, interestMask, boxsize);
        stdImg   = getVarImage(im2, interestMask, boxsize, meanImg);
        bone2    = (meanImg-boneMean).^2+(stdImg-boneStd).^2;
        cavity2  = (meanImg-cavityMean).^2+(stdImg-cavityStd).^2;
        mask3    = (bone2 > cavity2);
        boneMask = imclose(mask3, seCleaner) & interestMask;

        boneMaskNextImg   = imerode(~mask3, seNextImg) & interestMask;  % why isn't the ~ on the cavityMaskNextImg?
        cavityMaskNextImg = imerode(mask3, seNextImg) & interestMask;

        savedImplantMasks(:, :, ii) = implantMask;
        savedBoneMasks(:, :, ii) = boneMask;

        tempBoneMask = (~mask3 & interestMask);
        tempCavityMask = (mask3 & interestMask);
        boneCavityFraction(ii) = sum(tempBoneMask(:))/sum(tempCavityMask(:));

        %%  Do statistics
        dstMap        = sgnDstFromImg(implantMask);
        dstBorders    = [dstMap(1:s, 1) dstMap(1:s, s) dstMap(1, 1:s)' dstMap(s, 1:s)'];
        maxRadius     = floor(min(dstBorders(:)));
        % bandBorders = linspace(0, maxRadius, floor(maxRadius/nBands));
        bandBorders   = linspace(0, maxRadius, nBands);
        boneVolume    = NaN*ones(nBands, 1);
        area          = NaN*ones(nBands, 1);


        for jj = 1:nBands
            dstMask = (dstMap < bandBorders(jj)) & (dstMap > 0);
            boneVolume(fn, jj) = sum(boneMask(dstMask));
            area(fn, jj) = sum(dstMask(:));
        end

    end
    datasetName = fileCell{fn};
    datasetName = datasetName(1:(length(datasetName)-9));
    save(['segmentations/' datasetName '_double.mat'], 'savedImplantMasks', 'savedBoneMasks', '-v7.3')
    save(['stats/' datasetName '_double.mat'], 'boneVolume', 'area', '-v7.3')

    % plot(boneCavityFraction, 'o-');
    % saveas(gca, 'boneCavityFraction.eps', 'epsc');
end
