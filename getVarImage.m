function [stdImg] = getVarImage(img, mask, boxsize, varargin)
%% getMeanImage: Calculates the standard deviaton image by convolving with a box filter
% varargin is the mean image
    if nargin == 4
        meanImg = varargin{1};
    else
        meanImg = getMeanImage(img, mask, boxsize);
    end
    box    = ones(boxsize)/numel(boxsize)^2;
    temp   = normConv(img.^2, mask.^2, box);
    stdImg = temp - meanImg.^2;
end
