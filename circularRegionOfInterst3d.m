function mask = circularRegionOfInterst3d(newVol, implant, avoidEdgeDistance, radiiRegionBorders)
    [x1, x2, ~] = ndgrid(1:size(newVol, 1), 1:size(newVol, 2), 1:size(newVol, 3));
    implantDistanceMap = sgnDstFromImg(implant);
    maxDst = (size(newVol,1)/2 - 1/2 - avoidEdgeDistance);  % max distance from x3 (axis through implant)
    if nargin == 2 || isempty(radiiRegionBorders)
        mask = implantDistanceMap <= maxDst;
    else
        radiiRegionBorders(length(radiiRegionBorders) + 1) = maxDst;  % make the perimeter of the implant the last region boundary
        mask = false([size(newVol) length(radiiRegionBorders)]);  % preallocate
        if any(radiiRegionBorders > maxDst)
            error('Elements %s in radiiRegionBorders is too large, radiiRegionBorders = %s', mat2str(find(radiiRegionBorders > maxDst)), mat2str(radiiRegionBorders))
        end
        innerBorder = 0;
        for ii = 1:length(radiiRegionBorders)
            outerBorder = radiiRegionBorders(ii);
            mask(:,:,:,ii) = (implantDistanceMap > innerBorder) & (implantDistanceMap <= outerBorder);
            innerBorder = outerBorder;
        end
    end
end
