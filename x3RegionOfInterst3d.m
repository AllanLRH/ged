function mask = x3RegionOfInterst3d(newVol, minSlice, maxSlice, x3RegionBorders)
    [~, ~, x3] = ndgrid(1:size(newVol, 1), 1:size(newVol, 2), 1:size(newVol, 3));
    if isempty(x3RegionBorders)
        mask = (minSlice <= x3) & (x3 <= maxSlice);
    else
        x3RegionBorders(length(x3RegionBorders) + 1) = maxSlice;
        mask = false([size(newVol) length(x3RegionBorders)]);
        innerBorder = minSlice;
        for ii = 1:length(x3RegionBorders)
            outerBorder = x3RegionBorders(ii);
            mask(:, :, :, ii) = (innerBorder <= x3) & (x3 <= outerBorder);
            innerBorder = outerBorder;
        end
    end
end
