%% boneFractionFunction: function description
function [boneVolume, volume] = boneFractionFunction(img, dstMap, R)
    boneVolume = zeros(1, R);
    volume = zeros(1, R);
    for r = 1:R
        dstMask = (dstMap < r) & (dstMap > 0);
        boneVolume(r) = sum(img(dstMask));
        volume(r) = sum(dstMask(:));
    end

end
