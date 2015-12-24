function mask = x3RegionOfInterst3d(newVol, minSlice, maxSlice)
[~,~,x3] = ndgrid(1:size(newVol,1),1:size(newVol,2),1:size(newVol,3));
mask = (minSlice <= x3) & (x3 <= maxSlice);
