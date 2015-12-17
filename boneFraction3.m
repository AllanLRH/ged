filename = '../gedData/smallData/5.05_ID1662_769_v7.3_double.mat';
aBoneExample = [375,173,128];
aCavityExample = [315,153,128];
implantThreshold = 1.5;

avoidEdgeDistance = 10;
minSlice = 1;
maxSlice = 150;

halfEdgeSize = 2;
filterRadius = 2;

maxIter = 3;

SHOWRESULT = false;

% loads newVol
load(filename);

% Make mask
implant = segmentImplant3d(newVol, implantThreshold);
[circularRegionOfInterest, x3RegionOfInterest] = regionOfInterst3d(newVol, avoidEdgeDistance, minSlice, maxSlice);
mask = ~implant & circularRegionOfInterest;

% We bias correct on bone, but first we need to find the bone, so we
% iterate a couple of times
boneMask = mask & x3RegionOfInterest;
for i = 1:maxIter
    % Bias correct
    newVol = newVol-biasCorrect3d(newVol, boneMask);
    % Segment by thresholding of normalized-convoluted image
    meanImg = getMeanImage3d(newVol, mask, filterRadius);
    thresholdAfterBiasCorrection = (meanImg(aBoneExample(1),aBoneExample(2),aBoneExample(3))+meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3)))/2;
    [boneMask, cavityMask] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);
end

% Show result
if SHOWRESULT
    neitherMask = mask & ~boneMask & ~cavityMask;
    for i = 1:size(meanImg,3)
        showSlice = i;
        subplot(2,3,1); imagesc(meanImg(:,:,showSlice)); title(sprintf('Bias corrected slice %d',showSlice)); colormap(gray); axis image tight;
        subplot(2,3,2); imagesc(mask(:,:,showSlice)); title('Mask'); colormap(gray); axis image tight
        subplot(2,3,3); imagesc(cavityMask(:,:,showSlice)); title('Cavities'); colormap(gray); axis image tight
        subplot(2,3,4); imagesc(boneMask(:,:,showSlice)); title('Bone'); colormap(gray); axis image tight
        subplot(2,3,5); imagesc(neitherMask(:,:,showSlice).*meanImg(:,:,showSlice)); title('Neither'); colormap(gray); axis image tight
        subplot(2,3,6); hist(meanImg(neitherMask(:,:,showSlice)),1000); title('Histogram of neither');
        drawnow;
    end
end
