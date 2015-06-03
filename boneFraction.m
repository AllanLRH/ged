clear; %close all; clc

nBands = 100;
boxsize = 5;
load('circ.mat')
circArea     = sum(circ(:));

im1 = normImage(loadGed('5.05_ID1662_769_0001.vol', 1));
s = size(im1, 1);  %  Quadratic image

% implantMask  = segmentImplant(im1);
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
mask1        = (bone1 > cavity1);

seCleaner         = strel('disk', 4);
mask2             = imclose(mask1, seCleaner) & interestMask;

seNextImg         = strel('disk', 5);
boneMaskNextImg   = imerode(~mask1, seNextImg) & interestMask;  % why isn't the ~ on the cavityMaskNextImg?
cavityMaskNextImg = imerode(mask1, seNextImg) & interestMask;

% shadeLinker(im1, mask2, 'shadeAndMask')

load('desiredHistogram');
cdfAbsDiffSum = zeros([1 255]);
cdfAbsDiffSum(1) = sum(abs(desiredHistogram - img2cdf(im1)));


%% Process next image
for ii = 2:255

    im2 = normImage(loadGed('5.05_ID1662_769_0001.vol', ii));
    implantMask  = segmentImplant(im2);
    interestMask = (circ & ~implantMask);
    bias         = biasCorrect(im2, interestMask);
    im2          = im2 - bias;

    cdfAbsDiffSum(ii) = sum(abs(desiredHistogram - img2cdf(im2)));

%     if cdfAbsDiffSum(ii) > 18
%         im2 = equalizeImage(im2, interestMask);
%     end

    imsc(im2)
    title(num2str(ii))
    shadeArea(cavityMaskNextImg, [1 0 0])
    drawnow

    boneMean   = median(im2(boneMaskNextImg));
    boneStd    = median(abs(im2(boneMaskNextImg)-boneMean));
    %cavityStd  = std(im2(cavityMaskNextImg));
    %cavityMean = mean(im2(cavityMaskNextImg));
    cavityMean   = median(im2(cavityMaskNextImg));
    cavityStd    = median(abs(im2(cavityMaskNextImg)-cavityMean));

    meanImg = getMeanImage(im2, boxsize);
    stdImg  = getStdImage(im2, boxsize, meanImg);
    bone2   = (meanImg-boneMean).^2+(stdImg-boneStd).^2;
    cavity2 = (meanImg-cavityMean).^2+(stdImg-cavityStd).^2;
    mask3   = (bone2 > cavity2);
    mask4   = imclose(mask3, seCleaner) & interestMask;

    boneMaskNextImg   = imerode(~mask3, seNextImg) & interestMask;  % why isn't the ~ on the cavityMaskNextImg?
    cavityMaskNextImg = imerode(mask3, seNextImg) & interestMask;



%     currentFig = figure;
%     subplot(2, 2, 1)
%     imsc(im2)
%     subplot(2, 2, 2)
%     imsc(im2)
%     shadeArea(mask4, [1 0 0])
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
%     shadeArea(mask4, [1 0 0])
%     text(20, 70, sprintf('%3.3f', cdfAbsDiffSum(ii)), 'color', 'red')
%     export_fig(['figureExports/segmentation_' num2str(ii) '.png'])
%     close(currentFig)
%     % shadeLinker(im2, mask4, 'shadeAndMask')
end
% figure
% plot(cdfAbsDiffSum, 'o-')



% shadeLinker(im2, mask4, 'shadeAndMask')

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
