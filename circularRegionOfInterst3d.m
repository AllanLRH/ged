function mask = circularRegionOfInterst3d(newVol, avoidEdgeDistance)
[x1,x2,~] = ndgrid(1:size(newVol,1),1:size(newVol,2),1:size(newVol,3));
mask = (x1-(1+size(newVol,1))/2).^2 + (x2-(1+size(newVol,2))/2).^2 <= (size(newVol,1)/2-1/2-avoidEdgeDistance).^2;
