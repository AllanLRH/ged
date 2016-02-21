function [bone, cavity, neither, distFct] = fraction3d(implant, mask, x3RegionOfInterest, boneMask, cavityMask, neitherMask, maxDistance)

dstMap = sgnDstFromImg(implant);
bone = zeros(1,maxDistance);
cavity = zeros(size(bone));
neither = zeros(size(bone));
total = zeros(size(bone));
for i = 1:size(bone,2)
    dstMask = (dstMap > 0 & dstMap <= i) & x3RegionOfInterest;
    bone(i) = sum(sum(sum(boneMask & dstMask)));
    neither(i) = sum(sum(sum(neitherMask & dstMask)));
    cavity(i) = sum(sum(sum(cavityMask & dstMask)));
    % if non-defined values have been rotated into the image, then we
    % ignore them.
    %total(i) = sum(sum(sum(mask & dstMask)));
    total(i) = bone(i)+neither(i)+cavity(i);
end
bone = diff(bone)./diff(total);
cavity = diff(cavity)./diff(total);
neither = diff(neither)./diff(total);
distFct = (1:length(bone))+1/2;
