clear; close all; clc

img = normImage(loadGed('5.05_ID1662_769_0001.vol', 50));
nBands = 100;
[r, c] = size(img);
bandBorders = linspace(0, r/2, nBands+1);
boneVolumeFraction = zeros(1, nBands);

[implant, bone, cavity] = thresholdSegment(img);
load('circ.mat')

dstMap = abs(sgnDstFromImg(img));
for ii = 1:nBands
    dstMask = bandBorders(ii) < dstMap & dstMap < bandBorders(ii+1);
    boneVolumeFraction(ii) = sum(bone(dstMask))/sum(cavity(dstMask)) * 1/numel(dstMask);
end
boneVolumeFraction(isnan(boneVolumeFraction)) = 0;
plot(cumsum(boneVolumeFraction))

% Check that there's no summing going on outside the circular image

% Don't sum in the implant

% Limut summing to first half of image

% Reproduce Torstens graph
