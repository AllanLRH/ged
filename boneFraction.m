clear; close all; clc

nBands = 100;
boxsize = 5;
load('circ.mat')
circArea     = sum(circ(:));

im1 = normImage(loadGed('5.05_ID1662_769_0001.vol', 1));
s = size(im1, 1);  %  Quadratic image

implantMask  = thresholdSegment(im1);
interestMask = (circ & ~implantMask);
bias         = biasCorrect(im1, interestMask);
im1          = im1 - bias;

boneMask     = logical(mean(imread('darkMask.tiff'), 3));
cavityMask   = logical(mean(imread('lightMask.tiff'), 3));

boneStd      = std(im1(boneMask));
boneMean     = mean(im1(boneMask));
cavityStd    = std(im1(cavityMask));
cavityMean   = mean(im1(cavityMask));

meanImg      = getMeanImage(im1, boxsize);
stdImg       = getStdImage(im1, boxsize, meanImg);

bone1        = (meanImg-boneMean).^2+(stdImg-boneStd).^2;
cavity1      = (meanImg-cavityMean).^2+(stdImg-cavityStd).^2;
mask1        = (bone1 > cavity1).*interestMask;

seCleaner         = strel('disk', 4);
mask2             = imclose(mask1, seCleaner);

seNextImg         = strel('disk', 7);
boneMaskNextImg   = logical(imopen(mask1, seNextImg));
cavityMaskNextImg = logical(imopen((bone1 < cavity1).*interestMask, seNextImg));

shadeLinker(im1, mask2, 'shadeAndMask')

%% Process next image
for ii = 2:10

    im2 = normImage(loadGed('5.05_ID1662_769_0001.vol', ii));

    boneStdSimple    = std(im2(boneMaskNextImg));
    boneMeanSimple   = mean(im2(boneMaskNextImg));
    cavityStdSimple  = std(im2(cavityMaskNextImg));
    cavityMeanSimple = mean(im2(cavityMaskNextImg));
    mask4 = mask2;
    [boneStd, boneMean, cavityStd, cavityMean] = statsFromPrevMask(im2, mask4, interestMask);

    disp('boneStd')
    disp(boneStdSimple - boneStd)
    disp('boneMean')
    disp(boneMeanSimple - boneMean)
    disp('cavityStd')
    disp(cavityStdSimple - cavityStd)
    disp('cavityMean')
    disp(cavityMeanSimple - cavityMean)

    meanImg    = getMeanImage(im2, boxsize);
    stdImg     = getStdImage(im2, boxsize, meanImg);

    bone2      = (meanImg-boneMean).^2+(stdImg-boneStd).^2;
    cavity2    = (meanImg-cavityMean).^2+(stdImg-cavityStd).^2;
    mask3      = (bone2 > cavity2).*interestMask;

    mask4             = imclose(mask3, seCleaner);
    boneMaskNextImg   = logical(imopen(mask4, seNextImg));
    cavityMaskNextImg = logical(imopen((bone2 < cavity2).*interestMask, seNextImg));

%     shadeLinker(im2, mask4, 'shadeAndMask')

end


%%  De statistics
% [xi, yi] = find(implantMask);
% dstX = min(min(xi), s-max(xi));
% dstY = min(min(yi), s-max(yi));
% maxRadius = min(dstX, dstY);
% % centroid = regionprops(implantMask, 'centroid');
% % centroid = round(centroid.Centroid);
% % maxRadius = min(abs([centroid centroid - s]));
% % bandBorders = round(maxRadius/nBands : maxRadius/nBands : maxRadius*(1 - 1/nBands));
% bandBorders = floor(maxRadius/nBands*(1:nBands));
% boneVolumeFraction = zeros(1, nBands)*NaN;
%
%
% dstMap = sgnDstFromImg(implantMask);
% for ii = 1:nBands
%     dstMask = (bandBorders(ii) > dstMap) & (dstMap > 0);
%     if sum(sum(dstMask|circ)) > circArea
%         warning('Circle outside image bounds for the %d''th iteration. Halting execution.', ii)
%         break
%     end
%     boneVolumeFraction(ii) = sum(boneMask(dstMask))/(pi*bandBorders(ii)^2);% * 1/numel(dstMask);
%     % imsc(dstMask)
%     % pause(0.01)
% end
%
% plot(boneVolumeFraction)
%
% % Check that there's no summing going on outside the circular image
%
% % Don't sum in the implant
%
% % Limut summing to first half of image
%
% % Reproduce Torstens graph
