%% boneFractionFunction: returns a cumultative sum of the positive part of a mask
% img is the mask (the segmentation)
% dstMap is the signed distance map
% R is the outermost band to be searched
function [boneVolume, volume] = boneFractionFunction(img, dstMap, R)
    boneVolume = zeros(1, R);
    volume = zeros(1, R);
    for r = 1:R
        dstMask = (dstMap < r) & (dstMap > 0);
        boneVolume(r) = sum(img(dstMask));
        volume(r) = sum(dstMask(:));
    end

end
