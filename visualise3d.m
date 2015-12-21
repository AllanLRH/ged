function visualise3d(outputFilenamePrefix)

n = 0;
bone = []; % JIT does not recognize that the bone colormap is overwritten by the load below, so we predefine it.
load([outputFilenamePrefix,'params.mat']); % 'inputFilename','aBoneExample','aCavityExample','anImplantExample','avoidEdgeDistance','minSlice','maxSlice','avoidEdgeDistance','filterRadius','maxIter','maxDistance');
load([outputFilenamePrefix,'masks.mat']); %,'implant','circularRegionOfInterest','x3RegionOfInterest');
load([outputFilenamePrefix,'segments.mat']); %'meanImg','boneMask','cavityMask');
load([outputFilenamePrefix,'fractions.mat']); %,'distances','bone','cavity','neither');
load([outputFilenamePrefix,'edgeEffect.mat']); %,'bands','sumImgByBandsFromBone','sumImgByBandsFromCavity');

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
