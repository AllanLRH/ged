filename = '../gedData/smallData/5.05_ID1662_769_v7.3_double.mat';
aBoneExample = [375,173,128];
aCavityExample = [315,153,128];

halfEdgeSize = 2;
filterRadius = 2;
avoidEdgeDistance = 10;

% loads newVol
load(filename);

% Make mask
implant = segmentImplant3d(newVol);
[x1,x2] = ndgrid(1:size(newVol,1),1:size(newVol,2));
circularRegionOfInterest = (x1-(1+size(newVol,1))/2).^2 + (x2-(1+size(newVol,2))/2).^2 <= (size(newVol,1)/2-1/2-avoidEdgeDistance).^2;
mask = ~implant & repmat(circularRegionOfInterest,[1,1,size(newVol,3)]);

% Bias correct slice by slice
newVol = biasCorrect3d(newVol, mask);

% Segment by thresholding of normalized-convoluted image
meanImg = getMeanImage3d(newVol, mask, filterRadius);
thresholdAfterBiasCorrection = (meanImg(aBoneExample(1),aBoneExample(2),aBoneExample(3))+meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3)))/2;
[boneMask, cavityMask] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);

% Show result
subplot(2,3,1); imagesc(meanImg(:,:,128)); title('Bias corrected slice'); colormap(gray); axis image tight;
subplot(2,3,2); imagesc(mask(:,:,128)); title('Mask'); colormap(gray); axis image tight
subplot(2,3,3); imagesc(cavityMask(:,:,128)); title('Cavities'); colormap(gray); axis image tight
subplot(2,3,4); imagesc(boneMask(:,:,128)); title('Bone'); colormap(gray); axis image tight
subplot(2,3,5); imagesc(mask(:,:,128).*meanImg(:,:,128).*(~boneMask(:,:,128) & ~cavityMask(:,:,128))); title('Neither'); colormap(gray); axis image tight
