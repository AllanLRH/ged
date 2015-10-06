function [meanImg] = getMeanImage(img, mask, boxsize)
%% getMeanImage: Calculates the mean image by convolving with a box filter
    box            = ones(boxsize)/numel(boxsize)^2;
    meanImg        = conv2(img.*mask, box, 'same') ./ conv2(double(mask), box, 'same');
    meanImg(~mask) = 0;  % Remove NaN's caused by dividing with 0
end
