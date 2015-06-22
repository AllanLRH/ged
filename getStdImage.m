function [stdImg] = getStdImage(img, mask, boxsize, varargin)
%% getMeanImage: Calculates the standard deviaton image by convolving with a box filter
% varargin is the mean image
    if nargin == 4
        meanImg = varargin{1};
    else
        meanImg = getMeanImage(img, mask, boxsize);
    end
    box = ones(boxsize)/boxsize^2;
    stdImg = (conv2((img.*mask).^2, box, 'same') - meanImg.^2) ./ conv2(double(mask), box, 'same'); % .* mask;

end
