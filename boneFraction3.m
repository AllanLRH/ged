filename = '../gedData/smallData/5.05_ID1662_769_v7.3_double.mat';
aBoneExample = [375,173,128];
aCavityExample = [315,153,128];
anImplantExample = [301,204,128];

avoidEdgeDistance = 10;
minSlice = 1;
maxSlice = 150;

halfEdgeSize = 0;
filterRadius = 2;

maxIter = 3;

maxDistance = 100;

SHOWRESULT = true;

% loads newVol
load(filename);

% Make mask
implantThreshold = (newVol(anImplantExample(1),anImplantExample(2),anImplantExample(3))+newVol(aBoneExample(1),aBoneExample(2),aBoneExample(3)))/2;
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

% Doubtful volumes
neitherMask = mask & ~boneMask & ~cavityMask;
%{
if any(neitherMask(:))
    neitherThreshold = mean(newVol(neitherMask));
    boneMask(neitherMask & (meanImg > neitherThreshold)) = true;
    cavityMask(neitherMask & (meanImg <= neitherThreshold)) = true;
    %      neitherMask = false(size(mask));
end
%}

% Count the volume of bone, cavity and neither by distance from implant
dstMap = sgnDstFromImg(implant);
bone = zeros(1,maxDistance);
cavity = zeros(size(bone));
neither = zeros(size(bone));
total = zeros(size(bone));
for i = 1:size(bone,2)
    dstMask = (dstMap > 0 & dstMap <= i) & x3RegionOfInterest;
    total(i) = sum(sum(sum(mask & dstMask)));
    bone(i) = sum(sum(sum(boneMask & dstMask)));
    neither(i) = sum(sum(sum(neitherMask & dstMask)));
    cavity(i) = sum(sum(sum(cavityMask & dstMask)));
end
distFct = (1:length(bone)-1)+1/2;
bone = diff(bone)./diff(total);
cavity = diff(cavity)./diff(total);
neither = diff(neither)./diff(total);


% Analyze the over and undershooting effects
boneDst = sgnDstFromImg(boneMask);
cavityDst = sgnDstFromImg(cavityMask);
bands = -8:8;
sumImgByBandsFromBone = zeros(1,length(bands)-1);
sumFromBone = zeros(1,length(bands)-1);
sumImgByBandsFromCavity = zeros(1,length(bands)-1);
sumFromCavity = zeros(1,length(bands)-1);
for i = 2:(length(bands)); 
    band = bands(1) < boneDst & boneDst <= bands(i); 
    sumImgByBandsFromBone(i) = sum(meanImg(band));
    sumFromBone(i) = sum(band(:));

    band = bands(1) < cavityDst & cavityDst <= bands(i); 
    sumImgByBandsFromCavity(i) = sum(meanImg(band));
    sumFromCavity(i) = sum(band(:));
end
sumImgByBandsFromBone = diff(sumImgByBandsFromBone)./diff(sumFromBone);
sumImgByBandsFromCavity = diff(sumImgByBandsFromCavity)./diff(sumFromCavity);
bands = bands(2:end)-1/2;

% Show result
if SHOWRESULT
    figure(1);
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
    figure(2);
    subplot(2,3,1); plot(distFct, bone); title('differential bone fraction'); xlabel('distance/voxels'); ylabel('fraction');
    subplot(2,3,2); plot(distFct, cavity); title('differential cavity fraction'); xlabel('distance/voxels'); ylabel('fraction');
    subplot(2,3,3); plot(distFct, neither); title('differential neither fraction'); xlabel('distance/voxels'); ylabel('fraction');
    subplot(2,3,4); b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromBone,b,'pchip')); title('Overshooting from Bone'); xlabel('distance/voxels'); ylabel('intensity');
    subplot(2,3,5); b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromCavity,b,'pchip')); title('Overshooting from Cavity'); xlabel('distance/voxels'); ylabel('intensity');
end
