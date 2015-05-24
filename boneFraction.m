clear; close all; clc

img = normImage(loadGed('5.05_ID1662_769_0001.vol', 50));
nBands = 100;
[r, c] = size(img);
bandBorders = linspace(0, r/2, nBands+1);
boneVolumeFraction = zeros(1, nBands);

[implant, bone, cavity] = thresholdSegment(img);
load('circ.mat')

dstMap = sgnDstFromImg(implant);
for ii = 1:nBands
    dstMask = (bandBorders(ii) > dstMap) & (dstMap > 0);
    boneVolumeFraction(ii) = sum(bone(dstMask))/(pi*bandBorders(ii)^2);% * 1/numel(dstMask);
    % imsc(dstMask)
    % pause(0.01)
end
plot(boneVolumeFraction)

% Check that there's no summing going on outside the circular image

% Don't sum in the implant

% Limut summing to first half of image

% Reproduce Torstens graph
