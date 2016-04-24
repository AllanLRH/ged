function [bone, cavity, neither, distFct] = fraction3d(implant, boneMask, cavityMask, neitherMask, maxDistance)

dstMap = sgnDstFromImg(implant);
bone = zeros(size(implant,3),maxDistance);
cavity = zeros(size(bone));
neither = zeros(size(bone));
total = zeros(size(bone));
distFct = (1:length(bone));
for i = 1:length(distFct)
    dstMask = (0 < dstMap & dstMap <= distFct(i));
    bone(:,i) = squeeze(cumsum(sum(sum(boneMask & dstMask))));
    neither(:,i) = squeeze(cumsum(sum(sum(neitherMask & dstMask))));
    cavity(:,i) = squeeze(cumsum(sum(sum(cavityMask & dstMask))));
    total(:,i) = bone(:,i)+neither(:,i)+cavity(:,i);
end
%bone = diff(bone)./diff(total);
%cavity = diff(cavity)./diff(total);
%neither = diff(neither)./diff(total);
