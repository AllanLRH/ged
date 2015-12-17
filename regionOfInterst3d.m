function [circularRegionOfInterest, x3RegionOfInterest] = regionOfInterst3d(newVol, avoidEdgeDistance, minSlice, maxSlice)
[x1,x2,x3] = ndgrid(1:size(newVol,1),1:size(newVol,2),1:size(newVol,3));
circularRegionOfInterest = (x1-(1+size(newVol,1))/2).^2 + (x2-(1+size(newVol,2))/2).^2 <= (size(newVol,1)/2-1/2-avoidEdgeDistance).^2;
x3RegionOfInterest = (minSlice <= x3) & (x3 <= maxSlice);
