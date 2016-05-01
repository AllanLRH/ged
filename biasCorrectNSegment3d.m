function [meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask, a] = biasCorrectNSegment3d(maxIter, newVol, mask, filterRadius, aBoneLocation, aCavityLocation, halfEdgeSize, VERBOSE)
  
  a = 0;
  oldA = 0;
  B = 0;
  for i = 1:maxIter
    meanImg = getMeanImage3d(newVol-B, mask, filterRadius);
    thresholdAfterBiasCorrection = (meanImg(aBoneLocation(1),aBoneLocation(2),aBoneLocation(3))+meanImg(aCavityLocation(1),aCavityLocation(2),aCavityLocation(3)))/2;
    [boneMask, ~] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);
    
    % Bias correct
    [B,a] = biasCorrect3d(newVol, boneMask, 2);
    if VERBOSE
      disp([max(abs(a-oldA)),a']);
      oldA = a;
    end
  end
  meanImg = getMeanImage3d(newVol-B, mask, filterRadius);
  thresholdAfterBiasCorrection = (meanImg(aBoneLocation(1),aBoneLocation(2),aBoneLocation(3))+meanImg(aCavityLocation(1),aCavityLocation(2),aCavityLocation(3)))/2;
  [boneMask, cavityMask] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);
end
