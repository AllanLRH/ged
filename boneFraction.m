clear; %close all; clc

% nBands = 100;
stackSize = 255;
boxsize = 5;
load('circ.mat')
circArea     = sum(circ(:));

im1 = normImage(loadGed('data/5.05_ID1662_769_0001.vol', 1));
s = size(im1, 1);  %  square image dimmensions

% Preallocate mask volumes
savedImplantMasks = false(s, s, stackSize);
savedBoneMasks = false(s, s, stackSize);

implantMask  = segmentImplant(im1);
savedImplantMasks(:, :, 1) = implantMask;
interestMask = (circ & ~implantMask);
bias         = biasCorrect(im1, interestMask);
im1          = im1 - bias;

% Load image where the initial bone and cavity areas are marked. Ignore granulate channel for now
temp          = logical(imread('firstImageInStack/5.05_ID1662_769_0001_mask.vol.png'));
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

% shadeLinker(im1, mask2, 'shadeAndMask')

% load('desiredHistogram');
% cdfAbsDiffSum = zeros([1 stackSize]);
% cdfAbsDiffSum(1) = sum(abs(desiredHistogram - img2cdf(im1)));


% [xi, yi] = find(implantMask);
% dstMap = sgnDstFromImg(implantMask);
% dstBorders = [dstMap(1:s, 1) dstMap(1:s, s) dstMap(1, 1:s)' dstMap(s, 1:s)'];
% maxRadius = floor(min(dstBorders(:)));
% bandBorders = linspace(0, maxRadius, nBands);
% boneVolume = zeros(nBands, 1);
% area = zeros(nBands, 1);

% for ii = 1:nBands
%     dstMask = (dstMap < bandBorders(ii)) & (dstMap > 0);
%     boneVolume(ii) = sum(boneMask(dstMask));
%     area(ii) = sum(dstMask(:));
%     % imsc(dstMask)
%     % pause(0.01)
% end

%% Process next image
for ii = 2:5
    disp(ii/stackSize*100)
    im2 = normImage(loadGed('5.05_ID1662_769_0001.vol', ii));
    implantMask  = segmentImplant(im2);
    interestMask = (circ & ~implantMask);
    bias         = biasCorrect(im2, interestMask);
    im2          = im2 - bias;

%     cdfAbsDiffSum(ii) = sum(abs(desiredHistogram - img2cdf(im2)));

%     if cdfAbsDiffSum(ii) > 18
%         im2 = equalizeImage(im2, interestMask);
%     end

    boneMean   = median(im2(boneMaskNextImg));
    boneStd    = median(abs(im2(boneMaskNextImg)-boneMean));
    %cavityStd  = std(im2(cavityMaskNextImg));
    %cavityMean = mean(im2(cavityMaskNextImg));
    cavityMean   = median(im2(cavityMaskNextImg));
    cavityStd    = median(abs(im2(cavityMaskNextImg)-cavityMean));

    meanImg = getMeanImage(im2, interestMask, boxsize);
    stdImg  = getVarImage(im2, interestMask, boxsize, meanImg);
    bone2   = (meanImg-boneMean).^2+(stdImg-boneStd).^2;
    cavity2 = (meanImg-cavityMean).^2+(stdImg-cavityStd).^2;
    mask3   = (bone2 > cavity2);
    boneMask   = imclose(mask3, seCleaner) & interestMask;

    boneMaskNextImg   = imerode(~mask3, seNextImg) & interestMask;  % why isn't the ~ on the cavityMaskNextImg?
    cavityMaskNextImg = imerode(mask3, seNextImg) & interestMask;

    savedImplantMasks(:, :, ii) = implantMask;
    savedBoneMasks(:, :, ii) = boneMask;


%     %%  Do statistics
%     [xi, yi] = find(implantMask);
%     dstMap = sgnDstFromImg(implantMask);
%     % dstBorders = [dstMap(1:s, 1) dstMap(1:s, s) dstMap(1, 1:s)' dstMap(s, 1:s)'];
%     % maxRadius = floor(min(dstBorders));
%     % bandBorders = linspace(0, maxRadius, floor(maxRadius/nBands));
%     % boneVolume = zeros(nBands, 1);
%     % area = zeros(nBands, 1);
%
%     for jj = 1:nBands
%         dstMask = (dstMap < bandBorders(jj)) & (dstMap > 0);
%         boneVolume(jj) = sum(boneMask(dstMask));
%         area(jj) = sum(dstMask(:));
%         % imsc(dstMask)
%         % pause(0.01)
%     end




    % imsc(im2)
    % title(num2str(ii))
    % shadeArea(boneMask, [1 0 0])
    % saveas(gcf,sprintf('segmentationOverlays/%3.3d.png', ii))


%     currentFig = figure;
%     subplot(2, 2, 1)
%     imsc(im2)
%     subplot(2, 2, 2)
%     imsc(im2)
%     shadeArea(boneMask, [1 0 0])
%     subplot(2, 2, 3)
%     imsc(boneMaskNextImg)
%     subplot(2, 2, 4)
%     imsc(cavityMaskNextImg)
%     % maximize
%     export_fig(['figureExports/overview_' num2str(ii) '.png'])
%     % close(currentFig)
%     % currentFig = figure;
%     clf;
%     imsc(im2)
%     shadeArea(boneMask, [1 0 0])
%     text(20, 70, sprintf('%3.3f', cdfAbsDiffSum(ii)), 'color', 'red')
%     export_fig(['figureExports/segmentation_' num2str(ii) '.png'])
%     close(currentFig)
%     % shadeLinker(im2, boneMask, 'shadeAndMask')
end