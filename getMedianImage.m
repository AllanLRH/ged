%% getMedianImage: Compute median image
function [medImg] = getMedianImage(img, mask, boxsize)
    medImg = medfilt2(img.*mask, [boxsize boxsize]);
end
