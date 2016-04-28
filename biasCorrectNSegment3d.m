function [newVol, meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask, a] = biasCorrectNSegment3d(maxIter, boneMask, newVol, mask, dstMap, filterRadius, aBoneExample, aCavityExample, halfEdgeSize, VERBOSE)
  
  a = 0;
  oldA = 0;
  I = newVol;
  for i = 1:maxIter
    meanImg = getMeanImage3d(I, mask, filterRadius);
    thresholdAfterBiasCorrection = (meanImg(aBoneExample(1),aBoneExample(2),aBoneExample(3))+meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3)))/2;
    [boneMask, ~] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);
    
    % Bias correct
    [B,a] = biasCorrect3d(I, boneMask, 2);
    if VERBOSE
      disp([max(abs(a-oldA)),a']);
      oldA = a;
    end
    I = newVol - B;
  end
  meanImg = getMeanImage3d(I, mask, filterRadius);
  thresholdAfterBiasCorrection = (meanImg(aBoneExample(1),aBoneExample(2),aBoneExample(3))+meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3)))/2;
  [boneMask, cavityMask] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);
end