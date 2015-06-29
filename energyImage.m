function [ei] = energyImage(im1, im2, varargin)
%% energyImage: Computes the energy image (entropi based)
% Images im1 and im2 should be normalized between ([0 1]).
% Varargin is number of bins to use, default is 100.

    % Set number of bins to use
    if nargin == 3
        nBins = varargin{1};
    else
        nBins = 100;
    end

    % Check that images are normalized
    if any(abs( [max(im1(:)) max(im2(:))] - 1)) > 1e-14 || any(abs( [min(im1(:)) min(im2(:))] )) > 1e-14
        error('Inputs im1 and im2 must be normalized ([0 1])')
    end

    if numel(im1) ~= numel(im2)
        error('im1 and im2 must be the same size')
    end

    nPixels = numel(im1);
    halfBinWidth = 1/(2*nBins);
    ip1 = zeros(size(im1));
    ip2 = zeros(size(im2));
    % Maybe use [bins, centers] = hist(imX) or histcount for speedup?
    for bin = linspace(0+halfBinWidth, 1-halfBinWidth, nBins)
        mask = (im1 > (bin - halfBinWidth)) & (im1 < (bin + halfBinWidth));
        ip1(mask) = sum(mask(:))/nPixels;
        mask = (im2 > (bin - halfBinWidth)) & (im2 < (bin + halfBinWidth));
        ip2(mask) = sum(mask(:))/nPixels;
    end

    % Reuse computation & memory
    ei = ip1.*ip2;
    ei = ei .* log(ei);
end
