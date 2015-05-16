function [imp4, bone5, cavity2] = thresholdSegment(img)
%% thresholdSegment: Segment x-ray image using thresholding
% img as a normalized image
% return values is
% 1) implant
% 2) bone
% 3) cavites


%% Find circle containing image
load('circ.mat')
% [r, c] = size(img);
% Just load the result from the code below
% xc = r/2;
% yc = c/2;
% circ = false(r, c);
% for x = 1:r
%     for y = 1:c
%         if (x-xc)^2 + (y-yc)^2 <= xc^2
%             circ(x, y) = 1;
%         end
%     end
% end


%% Find implant

lowThreshold = 0.6386;
highThreshold = 0.7033;
imp1 = lowThreshold < img & img < highThreshold;
% Also fill the inner part of the implant
se = strel('square', 30);
imp2 = imclose(imp1, se);  % Make implant solid
imp3 = imopen(imp2, se);  % Remote white dots inside/outside implant circle
imp4 = bwfill(imp3, 'holes');  % Fill the middle of the implant in case it's not


%% Correct bias
mask = (circ | imp4);
load('biasImg.mat');
bias = biasCorrect(biasImg, mask);
bias = imfilter(bias, fspecial('gaussian', 20, 80), 'circular');
img = normImage(img.*mask - 0.7*bias.*mask + img.*not(mask));


%% Find bone/soft tissue
lowThreshold = 0.3150;
highThreshold = 0.4400;
imgB1 = medfilt2(img, [2,2]);
bone1 = (lowThreshold < imgB1) & (imgB1 < highThreshold);
se1 = strel('disk', 3);
bone2 = imopen(bone1, se1);
se2 = strel('disk', 4);
bone3 = imclose(bone2, se2);

boneSmallelements1 = img < 0.322;
boneSmallelements2 = imdilate(boneSmallelements1, ones(2));

bone4 = bone3 | boneSmallelements2;
bone5 = logical(~imp4.*circ.*bone4);


%% Find the last region for completeness
cavity1 = not(bone5);
cavity2 = logical(cavity1.*circ.*(~imp4));

end

