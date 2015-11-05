% clear; close all; home

% load('5.05_ID1662_769_0001_masks_2_v6.mat')
% load('minvol.mat');

%%
slice90 = squeeze(vol(:, 30, :));
subplot(121)
imsc(vol(:,:,1))
subplot(122)
imsc(slice90)

%%

figure;
for ii = 10:10:120
    subplot(3, 4, ii/10)
    imsc(squeeze(vol(:, ii, :)))
    title(num2str(ii))
end
maximize

%%

figure;
for ii = 10:10:120
    subplot(3, 4, ii/10)
    imsc(squeeze(vol(ii, :, :)))
    title(num2str(ii))
end
maximize