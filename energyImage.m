function [ei] = energyImage(im1, im2, varargin)
%% energyImage: Computes the energy image (entropi based)
% Images im1 and im2 should be normalized between ([0 1]).
% im1 is the static image (not a requirement, but better performance).
% Varargin is number of bins to use, default is 100.

    % This handles when to clear the persistent variable pi1
    persistent pi1
    persistent im1Hash
    recompute_pi1 = false;
    if isempty(im1Hash)
        im1Hash = DataHash(im1);
    else
        if not(strcmp(im1Hash, DataHash(im1)))
            recompute_pi1 = true;  % im1 have changed since last call, recompute pi1
        end
    end

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

    % Ensure that the input images are the same size
    if any(size(im1) ~= size(im2))
        error('im1 and im2 must be the same size')
    end

    halfBinWidth = 1/(2*nBins);

    % Recompute pi1 if im1 have changed since last call
    if isempty(pi1) || recompute_pi1
        pi1 = zeros(size(im1));  % probability image
        for bin = linspace(0+halfBinWidth, 1-halfBinWidth, nBins)
            mask = (im1 > (bin - halfBinWidth)) & (im1 < (bin + halfBinWidth));
            pi1(mask) = sum(mask(:));
        end
        pi1 = pi1/sum(pi1(:));
    end

    % Maybe use [bins, centers] = hist(imX) or histcount for speedup?
    pi2 = zeros(size(im2));  % probability image
    for bin = linspace(0+halfBinWidth, 1-halfBinWidth, nBins)
        mask = (im1 > (bin - halfBinWidth)) & (im1 < (bin + halfBinWidth));
        pi1(mask) = sum(mask(:));
        mask = (im2 > (bin - halfBinWidth)) & (im2 < (bin + halfBinWidth));
        pi2(mask) = sum(mask(:));
    end
    pi2 = pi2/sum(pi2(:));



    % Probability for a given value in pixel in im1 to be in bin X and for a pixel in im2 to
    % be in bin Y is the product of the probabilities for being in bin X and Y respectively.

    % This is the Joint Propability Distribution for im1 and im2
    ei = pi1.*pi2;  % Renormalize?

    % This is the energy image, add 1e-99 to avoid NaN's from log(0)
    ei = pi1.*log(pi1+1e-99) + pi2.*log(pi2+1e-99) - ei.*log(ei+1e-99);

end
