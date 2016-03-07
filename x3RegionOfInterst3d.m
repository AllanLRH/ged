function mask = x3RegionOfInterst3d(newVol, minSlice, maxSlice, regionBorders)
    [~, ~, x3] = ndgrid(1:size(newVol, 1), 1:size(newVol, 2), 1:size(newVol, 3));
    if nargin == 3 || isempty(regionBorders)
        mask = (minSlice <= x3) & (x3 <= maxSlice);
    else
        regionBorders(length(regionBorders) + 1) = maxSlice;
        mask = false([size(newVol) length(regionBorders)]);
        innerBorder = minSlice;
        for ii = 1:length(regionBorders)
            outerBorder = regionBorders(ii);
            mask(:, :, :, ii) = (innerBorder <= x3) & (x3 <= outerBorder);
            innerBorder = outerBorder;
        end
    end
end
