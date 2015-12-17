function mask = segmentImplant3d(im)
% segmentImplant: Return a mask covering the implant

% We find everything but the implant
mask = im < 1.5;
% the biggest component is what's surounds the implant
CC = bwconncomp(mask);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
% the implant is everything but what surounds the implant
mask = true(size(mask));
mask(CC.PixelIdxList{idx}) = false;
