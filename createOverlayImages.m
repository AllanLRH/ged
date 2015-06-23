load('5.05_ID1662_769_0001_masks_median_v6.mat');

for ii = 1:255
    img = normImage(loadGed('data/5.05_ID1662_769_0001.vol', ii));
    h = figure(1);
    imagesc(img);
    colormap gray
    shadeArea(savedImplantMasks(:,:,ii), [0 1 0])
    shadeArea(savedBoneMasks(:,:,ii), [1 0 0])
    shadeArea(not(savedBoneMasks(:,:,ii)), [0 0 1])
    saveas(h, ['overlays/5.05_ID1662_769_0001.vol_' num2str(ii) '.png'], 'png')
    clf;
end
