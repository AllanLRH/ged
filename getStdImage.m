function [stdImg] = getStdImage(img, boxsize, varargin)
%% getMeanImage: Calculates the standard deviaton image by convolving with a box filter
% varargin is the mean image
    if nargin == 3
        meanImg = varargin{1};
    else
        meanImg = getMeanImage(img, boxsize);
    end
    box = ones(boxsize)/boxsize^2;
    stdImg = conv2(img.^2, box, 'same') - meanImg.^2;

end
