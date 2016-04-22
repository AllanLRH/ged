function [newVol, meanImg, thresholdAfterBiasCorrection, boneMask, cavityMask] = biasCorrectNSegment3d(maxIter, boneMask, newVol, mask, filterRadius, aBoneExample, aCavityExample, halfEdgeSize, VERBOSE)

for i = 1:maxIter
    meanImg = getMeanImage3d(newVol, mask, filterRadius);
    thresholdAfterBiasCorrection = (meanImg(aBoneExample(1),aBoneExample(2),aBoneExample(3))+meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3)))/2;
    [boneMask, ~] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);

    % Bias correct
    [B,a] = biasCorrect3d(newVol, boneMask, 2);
    if VERBOSE
        disp([max(abs(a)),a']);
    end
    newVol = newVol-B;
    % Segment by thresholding of normalized-convoluted image
end
meanImg = getMeanImage3d(newVol, mask, filterRadius);
thresholdAfterBiasCorrection = (meanImg(aBoneExample(1),aBoneExample(2),aBoneExample(3))+meanImg(aCavityExample(1),aCavityExample(2),aCavityExample(3)))/2;
[boneMask, cavityMask] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, halfEdgeSize);
