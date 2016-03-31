function [bone, cavity, neither, distFct] = fraction3d(implant, x3RegionOfInterest, boneMask, radiiBorder, circularRegionOfInterest, cavityMask, neitherMask, maxDistance)

sumf = @(x) sum(x(:));  % sum flattened array

dstMap  = sgnDstFromImg(implant);
nPoints = 10;
bone    = zeros(1, nPoints);
cavity  = zeros(size(bone));
neither = zeros(size(bone));
total   = zeros(size(bone));
cnt = 1;
for b = linspace(0, radiiBorder, size(bone,2))
    dstMask      = (dstMap > 0 & dstMap <= b) & x3RegionOfInterest & circularRegionOfInterest;
    if ~sumf(dstMask)
        warning('Empty distance mask dstMask')
    end
    bone(cnt)    = sumf(boneMask & dstMask);
    neither(cnt) = sumf(neitherMask & dstMask);
    cavity(cnt)  = sumf(cavityMask & dstMask);
    % if non-defined values have been rotated into the image, then we
    % ignore them.
    %total(cnt)  = sumf(mask & dstMask);
    if any(isnan([bone(cnt) neither(cnt) cavity(cnt)]))
        warning('NaN in statistics!')
    end
    total(cnt)   = bone(cnt)+neither(cnt)+cavity(cnt);
    cnt = cnt + 1;
end
bone    = diff(bone)./diff(total);
cavity  = diff(cavity)./diff(total);
neither = diff(neither)./diff(total);
distFct = (1:length(bone))+1/2;
