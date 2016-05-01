function [meanImg] = getMeanImage3d(img, mask, boxsize)
% getMeanImage: Calculates the mean image by convolving with a box filter
[x1,x2,x3] = ndgrid(-ceil(boxsize):ceil(boxsize));
kernel = x1.^2 + x2.^2 + x3.^2 <= boxsize.^2;
meanImg = single(convn(img.*mask, kernel, 'same') ./ (0.00001+convn(single(mask), kernel, 'same')));
meanImg(~mask) = 0;  % Remove NaN's caused by dividing with 0
