function mask = circularRegionOfInterst3d(newVol, implant, avoidEdgeDistance, regionBorders)
    [x1, x2, ~] = ndgrid(1:size(newVol, 1), 1:size(newVol, 2), 1:size(newVol, 3));
    implantDistanceMap = sgnDstFromImg(implant);
    maxDst = (size(newVol,1)/2 - 1/2 - avoidEdgeDistance);  % max distance from x3 (axis through implant)
    if nargin == 2 || isempty(regionBorders)
        mask = implantDistanceMap <= maxDst;
    else
        regionBorders(length(regionBorders) + 1) = maxDst;  % make the perimeter of the implant the last region boundary
        mask = false([size(newVol) length(regionBorders)]);  % preallocate
        if any(regionBorders > maxDst)
            error('Elements %s in regionBorders is too large, regionBorders = %s', mat2str(find(regionBorders > maxDst)), mat2str(regionBorders))
        end
        innerBorder = 0;
        for ii = 1:length(regionBorders)
            outerBorder = regionBorders(ii);
            mask(:,:,:,ii) = (implantDistanceMap > innerBorder) & (implantDistanceMap <= outerBorder);
            innerBorder = outerBorder;
        end
    end
end
