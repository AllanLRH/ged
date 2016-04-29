function analyse3d(setup, masksSuffix, segmentsSuffix, edgeEffectSuffix, fractionsSuffix, SHOWRESULT, SAVERESULT, VERBOSE)
  
  imageFilename = setup.imageFilename;
  aBoneExample = setup.aBoneExample;
  aCavityExample = setup.aCavityExample;
  anImplantExample = setup.anImplantExample;
  avoidEdgeDistance = setup.avoidEdgeDistance;
  halfEdgeSize = setup.halfEdgeSize;
  filterRadius = setup.filterRadius;
  maxIter = setup.maxIter;
  maxDistance = setup.maxDistance;
  origo = setup.origo;
  R = setup.R;
  outputFilenamePrefix = setup.outputFilenamePrefix;
  MicroMeterPerPixel = setup.MicroMeterPerPixel;
  
  % Internal variables
  if SHOWRESULT
    n = 0;
  end
  % loads newVol
  if VERBOSE
    fprintf('  loading %s\n', imageFilename);
  end
  newVol = []; % default, mock value. Will be overwritten by load
  load(imageFilename, 'newVol');
  if SHOWRESULT
    minNewVol = min(min(min(newVol)));
    maxNewVol = max(max(max(newVol)));
    n=n+1; figure(n); clf;
    for i = [1:size(newVol, 3), 128]
      showSlice = i;
      imshow((newVol(:, :, showSlice)-minNewVol)/(maxNewVol-minNewVol)); title(sprintf('Original slice %d', showSlice)); colormap(gray); axis image tight;
      drawnow;
    end
  end
  
  % Make mask
  implantThreshold = (newVol(anImplantExample(1), anImplantExample(2), anImplantExample(3))+newVol(aBoneExample(1, 1), aBoneExample(1, 2), aBoneExample(1, 3)))/2;
  implant = segmentImplant3d(newVol, implantThreshold);
  circularRegionOfInterest = circularRegionOfInterst3d(newVol, avoidEdgeDistance);
  %x3RegionOfInterest = x3RegionOfInterst3d(newVol, minSlice, maxSlice);
  x3RegionOfInterest = false(size(newVol));
  ind = sub2ind(size(newVol), aBoneExample(:, 1), aBoneExample(:, 2), aBoneExample(:, 3));
  x3RegionOfInterest(ind) = true;
  mask = ~implant & circularRegionOfInterest;
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, masksSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'implant', 'circularRegionOfInterest', 'x3RegionOfInterest', 'mask');
  end
  if SHOWRESULT
    n=n+1; figure(n); clf;
    isosurface(implant, 0.5); title('Implant segment'); xlabel('x'); ylabel('y'); zlabel('z'); axis equal tight
    drawnow;
  end
  
  % We segment and bias-correct on bone
  dstMap = sgnDstFromImg(implant);

  boneMask = mask & x3RegionOfInterest;
  [newVol, meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask, a] = biasCorrectNSegment3d(maxIter, boneMask, newVol, mask, dstMap, filterRadius, aBoneExample(1, :), aCavityExample, halfEdgeSize, VERBOSE);
  
  neitherMask = mask & ~boneMask & ~cavityMask;
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, segmentsSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'meanImg', 'boneMask', 'cavityMask', 'neitherMask', 'thresholdAfterBiasCorrection', 'a');
  end
  if SHOWRESULT
    n=n+1; figure(n); clf;
    for i = [1:size(meanImg, 3), 128]
      showSlice = i;
      subplot(2, 3, 1); imagesc(meanImg(:, :, showSlice)); title(sprintf('Bias corrected slice %d', showSlice)); colormap(gray); axis image tight;
      subplot(2, 3, 2); imagesc(mask(:, :, showSlice)); title('Mask'); colormap(gray); axis image tight
      subplot(2, 3, 3); imagesc(cavityMask(:, :, showSlice)); title('Cavities'); colormap(gray); axis image tight
      subplot(2, 3, 4); imagesc(boneMask(:, :, showSlice)); title('Bone'); colormap(gray); axis image tight
      subplot(2, 3, 5); imagesc(neitherMask(:, :, showSlice).*meanImg(:, :, showSlice)); title('Neither'); colormap(gray); axis image tight
      subplot(2, 3, 6); hist(meanImg(neitherMask(:, :, showSlice)), 1000); title('Histogram of neither');
      drawnow;
    end
  end
  
  % Analyze the over and undershooting effects
  [sumImgByBandsFromBone, sumImgByBandsFromCavity, bands] = edgeEffect3d(boneMask, cavityMask, meanImg);
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, edgeEffectSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'bands', 'sumImgByBandsFromBone', 'sumImgByBandsFromCavity');
  end
  if SHOWRESULT
    n=n+1; figure(n); clf;
    subplot(1, 2, 1); b = linspace(min(bands), max(bands), 100); plot(b, interp1(bands, sumImgByBandsFromBone, b, 'pchip')); title('Overshooting from Bone'); xlabel('distance/voxels'); ylabel('intensity');
    subplot(1, 2, 2); b = linspace(min(bands), max(bands), 100); plot(b, interp1(bands, sumImgByBandsFromCavity, b, 'pchip')); title('Overshooting from Cavity'); xlabel('distance/voxels'); ylabel('intensity');
    drawnow;
  end
  
  % Transform to implant aligned coordinate system
  xMax = round(size(newVol)/2);
  x1 = -xMax(1):xMax(1);
  x2 = -xMax(2):xMax(2);
  x3 = -xMax(3):xMax(3);
  %rotatedImplant = sample3d(single(implant), origo, R, x1, x2, x3)>.5;
  %rotateddstMap = sgnDstFromImg(rotatedImplant);
  rotateddstMap = sample3d(single(dstMap), origo, R, x1, x2, x3)>.5;
  rotatedMeanImg = sample3d(meanImg, origo, R, x1, x2, x3);
  rotatedMask = sample3d(single(mask), origo, R, x1, x2, x3)>.5;
  rotatedBoneMask = sample3d(single(boneMask), origo, R, x1, x2, x3)>.5;
  rotatedCavityMask = sample3d(single(cavityMask), origo, R, x1, x2, x3)>.5;
  rotatedNeitherMask = sample3d(single(neitherMask), origo, R, x1, x2, x3)>.5;
  
  if SHOWRESULT
    n=n+1; figure(n); clf;
    for i = [1:size(meanImg, 3), 128]
      showSlice = i;
      subplot(2, 3, 1); imagesc(rotatedMeanImg(:, :, showSlice),'XData',x1,'YData',x2); title(sprintf('Bias corrected slice %d', showSlice)); colormap(gray); axis image tight;
      subplot(2, 3, 2); imagesc(rotatedMask(:, :, showSlice),'XData',x1,'YData',x2); title('Mask'); colormap(gray); axis image tight
      subplot(2, 3, 3); imagesc(rotatedCavityMask(:, :, showSlice),'XData',x1,'YData',x2); title('Cavities'); colormap(gray); axis image tight
      subplot(2, 3, 4); imagesc(rotatedBoneMask(:, :, showSlice),'XData',x1,'YData',x2); title('Bone'); colormap(gray); axis image tight
      subplot(2, 3, 5); imagesc(rotatedNeitherMask(:, :, showSlice).*rotatedMeanImg(:, :, showSlice),'XData',x1,'YData',x2); title('Neither'); colormap(gray); axis image tight
      subplot(2, 3, 6); hist(rotatedMeanImg(rotatedNeitherMask(:, :, showSlice)), 1000); title('Histogram of neither');
      drawnow;
    end
  end
  
  % Count the volume of bone, cavity and neither by distance from implant
  distances = (0:maxDistance)*25/MicroMeterPerPixel; % Camilla would like to be able to read the output in units of 50 mu.
  distances = distances(2:end);
  [bone, cavity, neither] = fraction3d(rotateddstMap, rotatedBoneMask, rotatedCavityMask, rotatedNeitherMask, distances);
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, fractionsSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'x1', 'x2', 'x3', 'bone', 'cavity', 'neither', 'distances');
  end
  
  if SHOWRESULT
    n=n+1; figure(n); clf;
    subplot(1,3,1); imagesc(bone); axis equal tight; colormap(gray);
    subplot(1,3,2); imagesc(cavity); axis equal tight; colormap(gray);
    subplot(1,3,3); imagesc(neither); axis equal tight; colormap(gray);
    drawnow;
  end
end