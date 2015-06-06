clear;
load('5.05_ID1662_769_0001_masks_v6.mat', 'savedImplantMasks')
s = 2048;
rad = 600;
imc = savedImplantMasks(s/2-rad:s/2+rad, s/2-rad:s/2+rad, :);
clear savedImplantMasks
% se = strel('disk', 2);
% imEroded = imerode(imc, se);
% imc = imc - imEroded;
% clear imEroded
%%
img = zeros(1200, size(imc, 3));
for ii = 1:size(imc, 3)
    [x, y] = find(imc(:, :, ii));
    minX = min(x);
    maxX = max(x);
    img(minX:maxX, ii) = 1;
end
imsc(img')
