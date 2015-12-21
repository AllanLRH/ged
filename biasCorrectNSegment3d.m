function [newVol, meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask] = biasCorrectNSegment3d(maxIter, boneMask, newVol, mask, filterRadius, aBoneExample, aCavityExample, halfEdgeSize)

for i = 1:maxIter
    % Bias correct
    newVol = newVol-biasCorrect3d(newVol, boneMask);
    % Segment by thresholding of normalized-convoluted image
    meanImg = getMeanImage3d(newVol, mask, filterRadius);
    thresholdAfterBiasCorrection = (meanImg(aBoneExample(1),aBoneExample(2),aBoneExample(3))+meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3)))/2;
    [boneMask, cavityMask] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);
end
