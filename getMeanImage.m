function [meanImg] = getMeanImage(img, mask, boxsize)
%% getMeanImage: Calculates the mean image by convolving with a box filter
    box     = ones(boxsize)/numel(boxsize)^2;
    meanImg = normConv(img, mask, box);
end
