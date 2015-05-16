%% Clear and load data
clear; close all; clc

img = loadGed('5.05_ID1662_769_0001.vol', 50);
[r, c] = size(img);


%% Find circle containing image
xc = r/2;
yc = c/2;
circ = false(r, c);
for x = 1:r
    for y = 1:c
        if (x-xc)^2 + (y-yc)^2 <= xc^2
            circ(x, y) = 1;
        end
    end
end


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
bias = biasCorrect(img, mask);
biasCorrected = img.*mask - bias.*mask + img.*not(mask);

%% Plot result
ha(1) = subplot(121);
imsc(img)
ha(2) = subplot(122);
imsc(biasCorrected)
linkaxes(ha, 'xy');
maximize


