function analyse3d(inputFilename, aBoneExample, aCavityExample, anImplantExample, avoidEdgeDistance, minSlice, maxSlice, halfEdgeSize, filterRadius, maxIter, maxDistance, SHOWRESULT, SAVERESULT, outputFilenamePrefix)

if SAVERESULT
    save([outputFilenamePrefix,'params.mat'],'inputFilename','aBoneExample','aCavityExample','anImplantExample','avoidEdgeDistance','minSlice','maxSlice','avoidEdgeDistance','filterRadius','maxIter','maxDistance');
end

% Internal variables
n = 0;

% loads newVol
load(inputFilename);

% Make mask
implantThreshold = (newVol(anImplantExample(1),anImplantExample(2),anImplantExample(3))+newVol(aBoneExample(1),aBoneExample(2),aBoneExample(3)))/2;
implant = segmentImplant3d(newVol, implantThreshold);
[circularRegionOfInterest, x3RegionOfInterest] = regionOfInterst3d(newVol, avoidEdgeDistance, minSlice, maxSlice);
mask = ~implant & circularRegionOfInterest;
if SAVERESULT
    save([outputFilenamePrefix,'masks.mat'],'implant','circularRegionOfInterest','x3RegionOfInterest','mask');
end

% We bias correct on bone, but first we need to find the bone, so we
% iterate a couple of times
boneMask = mask & x3RegionOfInterest;
[newVol, meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask] = biasCorrectNSegment3d(maxIter, boneMask, newVol, mask, filterRadius, aBoneExample, aCavityExample, halfEdgeSize);

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

if SAVERESULT
    save([outputFilenamePrefix,'segments.mat'],'meanImg','boneMask','cavityMask','neitherMask');
end

% Count the volume of bone, cavity and neither by distance from implant
[bone, cavity, neither, distances] = fraction3d(implant, mask, x3RegionOfInterest, boneMask, cavityMask, neitherMask, maxDistance);
if SAVERESULT
    save([outputFilenamePrefix,'fractions.mat'],'distances','bone','cavity','neither');
end

% Analyze the over and undershooting effects
[sumImgByBandsFromBone, sumImgByBandsFromCavity, bands] = edgeEffect3d(boneMask, cavityMask, meanImg);
if SAVERESULT
    save([outputFilenamePrefix,'edgeEffect.mat'],'bands','sumImgByBandsFromBone','sumImgByBandsFromCavity');
end

% Show result
if SHOWRESULT
    n=n+1; figure(n);
    isosurface(implant,0.5); title('Implant segment'); xlabel('x'); ylabel('y'); zlabel('z');
    
    n=n+1; figure(n);
    for i = [1:size(meanImg,3),128]
        showSlice = i;
        subplot(2,3,1); imagesc(meanImg(:,:,showSlice)); title(sprintf('Bias corrected slice %d',showSlice)); colormap(gray); axis image tight;
        subplot(2,3,2); imagesc(mask(:,:,showSlice)); title('Mask'); colormap(gray); axis image tight
        subplot(2,3,3); imagesc(cavityMask(:,:,showSlice)); title('Cavities'); colormap(gray); axis image tight
        subplot(2,3,4); imagesc(boneMask(:,:,showSlice)); title('Bone'); colormap(gray); axis image tight
        subplot(2,3,5); imagesc(neitherMask(:,:,showSlice).*meanImg(:,:,showSlice)); title('Neither'); colormap(gray); axis image tight
        subplot(2,3,6); hist(meanImg(neitherMask(:,:,showSlice)),1000); title('Histogram of neither');
        drawnow;
    end
    
    n=n+1; figure(n);
    subplot(2,3,1); plot(distances, bone); title('differential bone fraction'); xlabel('distance/voxels'); ylabel('fraction');
    subplot(2,3,2); plot(distances, cavity); title('differential cavity fraction'); xlabel('distance/voxels'); ylabel('fraction');
    subplot(2,3,3); plot(distances, neither); title('differential neither fraction'); xlabel('distance/voxels'); ylabel('fraction');
    subplot(2,3,4); b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromBone,b,'pchip')); title('Overshooting from Bone'); xlabel('distance/voxels'); ylabel('intensity');
    subplot(2,3,5); b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromCavity,b,'pchip')); title('Overshooting from Cavity'); xlabel('distance/voxels'); ylabel('intensity');
end
