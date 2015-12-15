filename = '../gedData/smallData/5.05_ID1662_769_v7.3_double.mat';

boneMean = 0.2;
boneStd = 0.1;
cavityMean = -0.15;
cavityStd = 0.1;

maxIter = 100;
tolerance = 0.001;
seEdgeSize = 3;
boxSize = 2;
alpha = 0.5;

% loads newVol
load(filename);

% Make mask
implantat = segmentImplant3d(newVol); % Remove screw
[x1,x2] = ndgrid(1:size(newVol,1),1:size(newVol,2));
kernel = (x1-(1+size(newVol,1))/2).^2 + (x2-(1+size(newVol,2))/2).^2 <= (size(newVol,1)/2-1/2).^2;
mask = implantat & repmat(kernel,[1,1,size(newVol,3)]);

% Bias correct slice by slice and correct means and stds
meanImg = getMeanImage3d(newVol, mask, boxSize);
stdImg = sqrt(getVarImage3d(newVol, mask, boxSize, meanImg));
[boneMask, cavityMask] = getSegments3d(meanImg, meanImg, mask, boneMean, boneStd, cavityMean, cavityStd, alpha, seEdgeSize);
newVol = biasCorrect3d(newVol, mask);
boneMean = mean(newVol(boneMask));
boneStd = std(newVol(boneMask));
cavityMean = mean(newVol(cavityMask));
cavityStd = std(newVol(cavityMask));


% Segment
[boneMask, cavityMask] = boneFraction3d(newVol, meanImg, stdImg, mask, alpha, boneMean, boneStd, cavityMean, cavityStd, seEdgeSize, tolerance, maxIter);
