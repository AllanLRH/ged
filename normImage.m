function [ outIm ] = normImage( inIm, varargin )
    if ~isempty(varargin)
        imNormMax = varargin{1};
    else
        imNormMax = 1;
    end

    imMin = min(inIm(:));
    outIm = inIm + sign(imMin)*imMin;
    imMax = max(outIm(:));
    outIm = imNormMax * outIm/imMax;
end

