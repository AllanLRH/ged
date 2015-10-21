clear; close all; clc;
%% Check texture for dark and light areas (make bar graphs)

img = normImage(loadGed('../data/5.05_ID1662_769_0001.vol', 1));
load('circ.mat');
implantMask  = thresholdSegment(img);
interestMask = (circ & ~implantMask);
bias         = biasCorrect(img, interestMask);
img          = normImage(img - bias);

s = size(img, 1);  % Square image

lightMask = logical(mean(imread('lightMask.tiff'), 3));
darkMask = logical(mean(imread('darkMask.tiff'), 3));

imsc(img)
shadeArea(lightMask, [1 0 0], 0.2)
shadeArea(darkMask, [0 0 1], 0.2)

disp('Light area number of pixels:')
disp(sum(lightMask(:)))

disp('Dark area number of pixels:')
disp(sum(darkMask(:)))

nBins = 30;

% figure
% hist(reshape(img(lightMask), [1 sum(lightMask(:))]), nBins)
% title('Light area')
%
% figure
% hist(reshape(img(darkMask), [1 sum(darkMask(:))]), nBins)
% title('Dark area')

figure
hist(reshape(img(lightMask), [1 sum(lightMask(:))]), nBins)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','w','facealpha',0.75)
hold on
hist(reshape(img(darkMask), [1 sum(darkMask(:))]), nBins)
h = findobj(gca,'Type','patch');
set(h,'facealpha',0.75);
legend('Light','Dark')


%% Do some plots of the mean, std and log amplitude images

% funMean = @(x) mean(x(:));
% meanImg = nlfilter(img, [5 5], funMean);


% funStd = @(x) std(x(:));
% stdImg = nlfilter(img, [5 5], funStd);

% load('meanAndStdImages.mat')

load('circ.mat')
implantMask = segmentImplant(img);
interestMask = (circ | implantMask);

stdImg = getVarImage(img, interestMask, 5);
meanImg = getMeanImage(img, interestMask, 5);

figure; subplot(1,2,1); imagesc(meanImg); colormap(gray); subplot(1,2,2); imagesc(stdImg); colormap(gray)
title('Mean and std image')

lightI = img(lightMask);
lightV = [mean(lightI(:)),std(lightI(:))];
darkI = img(darkMask);
darkV = [mean(darkI(:)),std(darkI(:))];

lightD = (meanImg-lightV(1)).^2+(stdImg-lightV(2)).^2;
darkD = (meanImg-darkV(1)).^2+(stdImg-darkV(2)).^2;

D = (lightD < darkD);
shadeLinker(img, D, 'maskAndImg')
title('mask')

% D = (lightD > darkD);
% shadeLinker(img, D, 'maskAndImg')

[imgx,imgy] = gradient(meanImg);
imgg = log(log(1+imgx.^2+imgy.^2));
shadeLinker(img, imgg, 'maskAndImg')
title('gradiendt magnitude (log(log))')














