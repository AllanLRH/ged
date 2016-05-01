function analyse3d(setup, masksSuffix, segmentsSuffix, edgeEffectSuffix, fractionsSuffix, SAVERESULT, VERBOSE)
  
  imageFilename = setup.imageFilename;
  aBoneExample = setup.aBoneExample;
  aCavityExample = setup.aCavityExample;
  anImplantExample = setup.anImplantExample;
  avoidEdgeDistance = setup.avoidEdgeDistance;
  halfEdgeSize = setup.halfEdgeSize;
  filterRadius = setup.filterRadius;
  maxIter = setup.maxIter;
  maxDistance = setup.maxDistance;
  origo = single(setup.origo);
  R = single(setup.R);
  outputFilenamePrefix = setup.outputFilenamePrefix;
  MicroMeterPerPixel = setup.MicroMeterPerPixel;
  
  tic;
  
  % loads newVol
  if VERBOSE
    fprintf('  loading %s\n', imageFilename);
  end
  newVol = []; % default, mock value. Will be overwritten by load
  load(imageFilename, 'newVol');
  if VERBOSE
    fprintf('  done (%gs)\n', toc);
    tic;
  end
  
  % Make mask
  if VERBOSE
    fprintf('  Segmenting implant\n');
  end
  implantThreshold = (newVol(anImplantExample(1), anImplantExample(2), anImplantExample(3))+newVol(aBoneExample(1, 1), aBoneExample(1, 2), aBoneExample(1, 3)))/2;
  implant = segmentImplant3d(newVol, implantThreshold);
  circularRegionOfInterest = circularRegionOfInterst3d(newVol, avoidEdgeDistance);
  %x3RegionOfInterest = x3RegionOfInterst3d(newVol, minSlice, maxSlice);
  
  %x3RegionOfInterest = false(size(newVol));
  %ind = sub2ind(size(newVol), aBoneExample(:, 1), aBoneExample(:, 2), aBoneExample(:, 3));
  %x3RegionOfInterest(ind) = true;
  mask = ~implant & circularRegionOfInterest;
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, masksSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'implant', 'mask');
  end
  if VERBOSE
    fprintf('  done (%gs)\n', toc);
    tic;
  end
  
  % Segment and bias-correct on bone
  if VERBOSE
    fprintf('  Bias correction and segmenting\n');
  end
  %boneMask = mask & x3RegionOfInterest;
  [meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask, a] = biasCorrectNSegment3d(maxIter, newVol, mask, filterRadius, aBoneExample(1, :), aCavityExample, halfEdgeSize, VERBOSE); %#ok<ASGLU>
  
  % Correct for overshooting near implant
  dstMap = sgnDstFromImg(implant);
  boneValue = meanImg(aBoneExample(1,1),aBoneExample(1,2),aBoneExample(1,3));
  cavityValue = meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3));
  sigmoidalDstMap = thresholdAfterBiasCorrection-3*abs(boneValue-cavityValue)*(1-1./(1+exp(-dstMap)));
  [boneMask, cavityMask] = getSegments3d(meanImg, mask, sigmoidalDstMap, halfEdgeSize);
  
  neitherMask = mask & ~boneMask & ~cavityMask;
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, segmentsSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'meanImg', 'boneMask', 'cavityMask', 'neitherMask', 'thresholdAfterBiasCorrection', 'a');
  end
  if VERBOSE
    fprintf('  done (%gs)\n', toc);
    tic;
  end
  
  % Analyze the over- and undershooting effects
  if VERBOSE
    fprintf('  analyzing edge effects\n');
  end
  [sumImgByBandsFromBone, sumImgByBandsFromCavity, bands] = edgeEffect3d(boneMask, cavityMask, meanImg); %#ok<ASGLU>
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, edgeEffectSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'bands', 'sumImgByBandsFromBone', 'sumImgByBandsFromCavity');
  end
  if VERBOSE
    fprintf('  done (%gs)\n', toc);
    tic;
  end
  
  % Analyzing fractions in implant's coordinate system.
  if VERBOSE
    fprintf('  analyzing fractions\n');
  end
  % Transform to implant aligned coordinate system
  xMax = round(size(newVol)/2);
  x1 = single(-xMax(1):xMax(1));
  x2 = single(-xMax(2):xMax(2));
  x3 = single(-xMax(3):xMax(3));
  %rotatedImplant = sample3d(single(implant), origo, R, x1, x2, x3)>.5;
  %rotateddstMap = sgnDstFromImg(rotatedImplant);
  rotateddstMap = sample3d(single(dstMap), origo, R, x1, x2, x3);
  %rotatedMeanImg = sample3d(meanImg, origo, R, x1, x2, x3);
  %rotatedMask = sample3d(single(mask), origo, R, x1, x2, x3)>.5;
  rotatedBoneMask = sample3d(single(boneMask), origo, R, x1, x2, x3)>.5;
  rotatedCavityMask = sample3d(single(cavityMask), origo, R, x1, x2, x3)>.5;
  rotatedNeitherMask = sample3d(single(neitherMask), origo, R, x1, x2, x3)>.5;
  
  % Count the volume of bone, cavity and neither by distance from implant
  distances = (0:maxDistance)*10/MicroMeterPerPixel; % Camilla would like to be able to read the output in units of 50 mu.
  distances = distances(2:end);
  [bone, cavity, neither] = fraction3d(rotateddstMap, rotatedBoneMask, rotatedCavityMask, rotatedNeitherMask, distances); %#ok<ASGLU>
  if SAVERESULT
    outputFilename = [outputFilenamePrefix, fractionsSuffix];
    if VERBOSE
      fprintf('  saving %s\n', outputFilename);
    end
    save(outputFilename, 'x1', 'x2', 'x3', 'bone', 'cavity', 'neither', 'distances');
  end
  if VERBOSE
    fprintf('  done (%gs)\n', toc);
    tic;
  end
end
