function [meanImg] = getMeanImage(img, mask, boxsize)
%% getMeanImage: Calculates the mean image by convolving with a box filter
    box = ones(boxsize)/boxsize^2;
    meanImg = conv2(img.*mask, box, 'same') ./ conv2(double(mask), box, 'same');% .* mask;

end
