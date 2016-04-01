function [bone, cavity, neither, distances] = fraction3d(dstMap, x3RegionOfInterest, boneMask, cavityMask, neitherMask, maxDistance, voxelPointSpacing, innerBorder, outerBorder)

sumf = @(x) sum(x(:));  % sum flattened array

distances = innerBorder:voxelPointSpacing:outerBorder;  % "x-axis" in fraction-distance plot
dstMask      = (dstMap >= innerBorder) & (dstMap < outerBorder) & x3RegionOfInterest;

% Preallocate
total   =  ones(1, length(distances));
bone    = zeros(1, length(distances));
cavity  = zeros(1, length(distances));
neither = zeros(1, length(distances));

% Fill fraction arrays
for ii = 1:length(distances)
    d = distances(ii);  % outermost point to include
    itrDstMask  = dstMask & (dstMap <= d);  % limit the mask radius in current iteration

    if sumf(itrDstMask) == 0
        warning('No elements in itrDstMask!')
    end
    bone(ii)    = sumf(boneMask(itrDstMask));
    cavity(ii)  = sumf(cavityMask(itrDstMask));
    neither(ii) = sumf(neitherMask(itrDstMask));
    total(ii)   = bone(ii) + cavity(ii) + neither(ii);
end
bone = bone./total;
cavity = cavity./total;
neither = neither./total;
