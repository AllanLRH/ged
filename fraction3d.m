function [bone, cavity, neither, distances] = fraction3d(dstMap, x3RegionOfInterest, boneMask, cavityMask, neitherMask, maxDistance, nRadiiRegionPoints, radiiRegion)

    sumf = @(x) sum(x(:));  % sum flattened array

    % Ignore the first point, since it's equal to radiiRegions(1), since the range radiiRegion(1):radiiRegions(1) would be empty
    distances = linspace(radiiRegion(1), radiiRegion(2), nRadiiRegionPoints + 1);
    distances = distances(2:end);
    if any(distances > maxDistance)
        error('Distance exceeds maxDistance')
    end
    dstMask = (dstMap >= radiiRegion(1)) & (dstMap < radiiRegion(2)) & x3RegionOfInterest;

    % Preallocate using nans. A bit more work needs to be done, but it's easier to spot errors in the debugger.
    % Function output is cleaned of nans, see function at the end of this file.
    total   = nan(1, length(distances));
    bone    = nan(1, length(distances));
    cavity  = nan(1, length(distances));
    neither = nan(1, length(distances));

    % Fill fraction arrays, comultative summing
    for ii = 1:length(distances)
        d = distances(ii);  % outermost point to include
        itrDstMask  = dstMask & (dstMap <= d);  % limit the mask radius in current iteration
        if sumf(itrDstMask) == 0
            warning('No elements in itrDstMask for distances in range %.4f %.4f', radiiRegion(1), d)
        end
        bone(ii)    = sumf(boneMask(itrDstMask));
        cavity(ii)  = sumf(cavityMask(itrDstMask));
        neither(ii) = sumf(neitherMask(itrDstMask));
        total(ii)   = sumf(itrDstMask);
    end
    % Convert to fraction and replace nans from zero-division
    bone = bone./total;       bone(isnan(bone)) = 0;
    cavity = cavity./total;   cavity(isnan(cavity)) = 0;
    neither = neither./total; neither(isnan(neither)) = 0;

    % Print entire bone, cavity and neither if it's the length < 30, else print
    % roughly evenly spaced sample form the vector.
    if length(bone) > 30
        printIdx = round(linspace(1, length(bone), 30));
        fprintf('INFO::\t\tbone (sample):     %s\n', mat2str(bone(printIdx), 6));
        fprintf('INFO::\t\tcavity (sample):   %s\n', mat2str(cavity(printIdx), 6));
        fprintf('INFO::\t\tneither (sample):  %s\n', mat2str(neither(printIdx), 6));
    else
        fprintf('INFO::\t\tbone:              %s\n', mat2str(bone, 6));
        fprintf('INFO::\t\tcavity:            %s\n', mat2str(cavity, 6));
        fprintf('INFO::\t\tneither:           %s\n', mat2str(neither, 6));
    end
end
