function [boneMask, cavityMask] = boneFraction3d(im, meanImg, stdImg, mask, alpha, boneMean, boneStd, cavityMean, cavityStd, seEdgeSize, tolerance, maxIter)
% Reads original data, segments and downsamples it

stopIteration = false;
iter = 0;
while ~stopIteration
    fprintf('%d: %.3g %.3g %.3g %.3g\n', iter, cavityStd, cavityMean, boneMean, boneStd);
    iter = iter + 1;
    [boneMask, cavityMask] = getSegments3d(meanImg, stdImg, mask, boneMean, boneStd, cavityMean, cavityStd, alpha, seEdgeSize);
    
    newCavityMean = mean(im(cavityMask));
    newCavityStd = std(im(cavityMask));
    newBoneMean = mean(im(boneMask));
    newBoneStd = std(im(boneMask));
    
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
