function [stdImg] = getVarImage3d(img, mask, boxsize, varargin)
%% getMeanImage: Calculates the standard deviaton image by convolving with a box filter
% varargin is the mean image
if nargin == 4
    meanImg = varargin{1};
else
    meanImg = getMeanImage3d(img, mask, boxsize);
end
stdImg = getMeanImage3d(img.^2, mask, boxsize) - meanImg.^2;
stdImg(~mask) = 0;  % Remove NaN's caused by dividing with 0
