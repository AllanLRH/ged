function [boneMask, cavityMask] = boneFraction3d(newVol, meanImg, mask, thresholdAfterBiasCorrection, seEdgeSize, tolerance, maxIter)
% Reads original data, segments and downsamples it

stopIteration = false;
iter = 0;
while ~stopIteration
    fprintf('%d\n', iter);
    %    fprintf('%d: %.3g %.3g %.3g %.3g\n', iter, cavityStd, cavityMean, boneMean, boneStd);
    iter = iter + 1;
    [boneMask, cavityMask] = getSegments3d(meanImg, mask, thresholdAfterBiasCorrection, seEdgeSize);
    
    newCavityMean = mean(newVol(cavityMask));
    newCavityStd = std(newVol(cavityMask));
    newBoneMean = mean(newVol(boneMask));
    newBoneStd = std(newVol(boneMask));
    
    if (iter > maxIter) ...
            || (all(abs([newCavityMean,newCavityStd,newBoneMean,newBoneStd] - [cavityStd, cavityMean, boneMean, boneStd]) < tolerance))
        stopIteration = true;
    else
        cavityStd = newCavityMean;
        cavityMean = newCavityStd;
        boneMean= newBoneMean;
        boneStd = newBoneStd;
    end
end
