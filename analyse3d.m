function analyse3d(inputFilename, aBoneExample, aCavityExample, anImplantExample, avoidEdgeDistance, minSlice, maxSlice, radiiRegionBorders, halfEdgeSize, filterRadius, maxIter, maxDistance, SHOWRESULT, SAVERESULT, origo, R, marks, outputFilenamePrefix)

if SAVERESULT
    save([outputFilenamePrefix,'params.mat'],'inputFilename','aBoneExample','aCavityExample','anImplantExample','avoidEdgeDistance','avoidEdgeDistance','filterRadius','maxIter','maxDistance','origo','R','marks');
end

% Internal variables
n = 0;

% loads newVol
load(inputFilename);
minNewVol = min(min(min(newVol)));
maxNewVol = max(max(max(newVol)));
if SHOWRESULT
    n=n+1; figure(n); clf;
    for ii = [1:size(newVol,3),128]
        showSlice = ii;
        imshow((newVol(:,:,showSlice)-minNewVol)/(maxNewVol-minNewVol)); title(sprintf('Original slice %d',showSlice)); colormap(gray); axis image tight;
        drawnow;
    end
end

% Make mask
implantThreshold         = (newVol(anImplantExample(1), anImplantExample(2), anImplantExample(3))+newVol(aBoneExample(1,1), aBoneExample(1,2), aBoneExample(1,3)))/2;
implant                  = segmentImplant3d(newVol, implantThreshold);
circularRegionOfInterest = circularRegionOfInterst3d(newVol, implant, avoidEdgeDistance, []);
x3RegionOfInterest       = x3RegionOfInterst3d(newVol, minSlice, maxSlice);
% x3RegionOfInterest       = false(size(newVol));
ind                      = sub2ind(size(newVol), aBoneExample(:,1), aBoneExample(:,2), aBoneExample(:,3));
x3RegionOfInterest(ind)  = true;

mask = ~implant & circularRegionOfInterest;
if SAVERESULT
    save([outputFilenamePrefix,'masks.mat'],'implant','circularRegionOfInterest','x3RegionOfInterest','mask');
end
if false %SHOWRESULT
    n=n+1; figure(n); clf;
    isosurface(implant,0.5); title('Implant segment'); xlabel('x'); ylabel('y'); zlabel('z'); axis equal tight
    drawnow;
end

% We bias correct on bone, but first we need to find the bone, so we
% iterate a couple of times
%{
boneMask = false(size(mask));
n=n+1; figure(n); clf;
for ii = [50,100,150,200]
    imagesc(newVol(:,:,ii).*mask(:,:,ii)); title('Saggital slice'); colormap(gray); axis image tight;
    hold on;
    for j = 1:5
        x = ginput(1);
        plot(x(1),x(2),'g+');
        boneMask(round(x(2)),round(x(1)),ii) = true;
    end
     hold off
end
[newVol, meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask] = biasCorrectNSegment3d(1, boneMask, newVol, mask, filterRadius, aBoneExample, aCavityExample, halfEdgeSize);
%}
boneMask = mask & x3RegionOfInterest;
[newVol, meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask] = biasCorrectNSegment3d(maxIter, boneMask, newVol, mask, filterRadius, aBoneExample(1,:), aCavityExample, halfEdgeSize);

neitherMask = mask & ~boneMask & ~cavityMask;
if SAVERESULT
    save([outputFilenamePrefix,'segments.mat'],'meanImg','boneMask','cavityMask','neitherMask');
end
if SHOWRESULT
    n=n+1; figure(n); clf;
    for ii = [1:size(meanImg,3),128]
        showSlice = ii;
        subplot(2,3,1); imagesc(meanImg(:,:,showSlice)); title(sprintf('Bias corrected slice %d',showSlice)); colormap(gray); axis image tight;
        subplot(2,3,2); imagesc(mask(:,:,showSlice)); title('Mask'); colormap(gray); axis image tight
        subplot(2,3,3); imagesc(cavityMask(:,:,showSlice)); title('Cavities'); colormap(gray); axis image tight
        subplot(2,3,4); imagesc(boneMask(:,:,showSlice)); title('Bone'); colormap(gray); axis image tight
        subplot(2,3,5); imagesc(neitherMask(:,:,showSlice).*meanImg(:,:,showSlice)); title('Neither'); colormap(gray); axis image tight
        subplot(2,3,6); hist(meanImg(neitherMask(:,:,showSlice)),1000); title('Histogram of neither');
        drawnow;
    end
end

% Transform to implant aligned coordinate system
xMax = round(size(newVol)/2);
x1 = -(xMax(1)-1):xMax(1);
x2 = -(xMax(2)-1):xMax(2);
x3 = -(xMax(3)-1):xMax(3);
rotatedMeanImg = sample3d(meanImg,origo,R,x1,x2,x3);
rotatedImplant = sample3d(single(implant),origo,R,x1,x2,x3)>.5;
rotatedMask = sample3d(single(mask),origo,R,x1,x2,x3)>.5;
rotatedBoneMask = sample3d(single(boneMask),origo,R,x1,x2,x3)>.5;
rotatedCavityMask = sample3d(single(cavityMask),origo,R,x1,x2,x3)>.5;
rotatedNeitherMask = sample3d(single(neitherMask),origo,R,x1,x2,x3)>.5;

if SHOWRESULT
    n=n+1; figure(n); clf;
    for ii = [1:size(meanImg,3),128]
        showSlice = ii;
        subplot(2,3,1); imagesc(rotatedMeanImg(:,:,showSlice)); title(sprintf('Bias corrected slice %d',showSlice)); colormap(gray); axis image tight;
        subplot(2,3,2); imagesc(rotatedMask(:,:,showSlice)); title('Mask'); colormap(gray); axis image tight
        subplot(2,3,3); imagesc(rotatedCavityMask(:,:,showSlice)); title('Cavities'); colormap(gray); axis image tight
        subplot(2,3,4); imagesc(rotatedBoneMask(:,:,showSlice)); title('Bone'); colormap(gray); axis image tight
        subplot(2,3,5); imagesc(rotatedNeitherMask(:,:,showSlice).*rotatedMeanImg(:,:,showSlice)); title('Neither'); colormap(gray); axis image tight
        subplot(2,3,6); hist(rotatedMeanImg(rotatedNeitherMask(:,:,showSlice)),1000); title('Histogram of neither');
        drawnow;
    end
end

% Analyze the over and undershooting effects
[sumImgByBandsFromBone, sumImgByBandsFromCavity, bands] = edgeEffect3d(boneMask, cavityMask, meanImg);
if SAVERESULT
    save([outputFilenamePrefix,'edgeEffect.mat'],'bands','sumImgByBandsFromBone','sumImgByBandsFromCavity');
end
if SHOWRESULT
    n=n+1; figure(n); clf;
    subplot(1,2,1); b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromBone,b,'pchip')); title('Overshooting from Bone'); xlabel('distance/voxels'); ylabel('intensity');
    subplot(1,2,2); b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromCavity,b,'pchip')); title('Overshooting from Cavity'); xlabel('distance/voxels'); ylabel('intensity');
    drawnow;
end

% Count the volume of bone, cavity and neither by distance from implant
fractions                     = cell(size(marks,1), nRegions);
circularRegionOfInterestMulti = circularRegionOfInterst3d(newVol, rotatedImplant, avoidEdgeDistance, radiiRegionBorders);
% Set number of regions, used in loop below
if ndims(circularRegionOfInterest) == 4
    nRegions = size(circularRegionOfInterest, 4);
else
    nRegions = 1;
end
for nR = 1:nRegions
    for ii = 1:size(marks,1)-1
        minSlice                           = min(marks(ii,3), marks(ii+1,3));
        maxSlice                           = max(marks(ii,3), marks(ii+1,3));
        circularRegionOfInterest           = circularRegionOfInterestMulti(:,:,:,nR);
        x3RegionOfInterest                 = x3RegionOfInterst3d(newVol, minSlice, maxSlice);
        [bone, cavity, neither, distances] = fraction3d(rotatedImplant, x3RegionOfInterest, circularRegionOfInterest, rotatedBoneMask, rotatedCavityMask, rotatedNeitherMask, maxDistance);
        fractions{ii, nR}                  = {x3RegionOfInterest,minSlice, maxSlice, bone, cavity, neither, distances};
    end
    minSlice                           = min(marks(1,3), marks(end,3));
    maxSlice                           = max(marks(1,3), marks(end,3));
    x3RegionOfInterest                 = x3RegionOfInterst3d(newVol, minSlice, maxSlice);
    [bone, cavity, neither, distances] = fraction3d(rotatedImplant, x3RegionOfInterest, circularRegionOfInterest, rotatedBoneMask, rotatedCavityMask, rotatedNeitherMask, maxDistance);
    fractions{end, nR}                 = {x3RegionOfInterest, minSlice, maxSlice, bone, cavity, neither, distances};

    if SHOWRESULT
        n=n+1; figure(n); clf;
        for ii = 1:length(fractions)
            minSlice  = round(fractions{ii, nR}{1});
            maxSlice  = round(fractions{ii, nR}{2});
            bone      = fractions{ii, nR}{3};
            cavity    = fractions{ii, nR}{4};
            neither   = fractions{ii, nR}{5};
            distances = fractions{ii, nR}{6};

            m0 = (ii-1)*3;
            subplot(length(fractions),3,m0+1); plot(distances, bone); title(sprintf('Bone fraction %d:%d',ii,maxSlice-minSlice)); xlabel('distance/voxels'); ylabel('fraction');
            subplot(length(fractions),3,m0+2); plot(distances, cavity); title(sprintf('Cavity fraction %d:%d',ii,maxSlice-minSlice)); xlabel('distance/voxels'); ylabel('fraction');
            subplot(length(fractions),3,m0+3); plot(distances, neither); title(sprintf('Neither fraction %d:%d',ii,maxSlice-minSlice)); xlabel('distance/voxels'); ylabel('fraction');
        end  % for length(fractions)
        drawnow;
    end  % if SHOWRESULT
end  % for nRegions
if SAVERESULT
    save([outputFilenamePrefix,'fractions.mat'], 'fractions');
end
