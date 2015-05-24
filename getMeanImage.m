function [meanImg] = getMeanImage(img, boxsize)
%% getMeanImage: Calculates the mean image by convolving with a box filter
    box = ones(boxsize)/boxsize^2;
    meanImg = conv2(img, box, 'same');

end
