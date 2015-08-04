%% jointEntropy: Calculates the joint entropy
function je = jointEntropy(I, J)

    % Check image sizes
    if any(size(I) ~= size(J))
        error('The images I and J must be the same size')
    end


    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % Binning from                                                                                                  %
    % http://stackoverflow.com/questions/6777609/fast-2dimensional-histograming-in-matlab                           %
    % and this seems to be almost the same code                                                                     %
    % http://blogs.mathworks.com/videos/2010/01/22/advanced-making-a-2d-or-3d-histogram-to-visualize-data-density/  %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    % Bin centers (integers)
    xbins = floor(min(I(:))):ceil(max(I(:)));
    ybins = floor(min(J(:))):ceil(max(J(:)));
    xNumBins = numel(xbins);
    yNumBins = numel(ybins);

    % Map X and Y values to bin indices
    Xi = round( interp1(xbins, 1:xNumBins, I(:), 'linear', 'extrap') );
    Yi = round( interp1(ybins, 1:yNumBins, J(:), 'linear', 'extrap') );

    % Limit indices to the range [1,numBins]
    Xi = max( min(Xi,xNumBins), 1);
    Yi = max( min(Yi,yNumBins), 1);

    % Count number of elements in each bin
    hst = accumarray([Yi(:) Xi(:)], 1, [yNumBins xNumBins]);



    % Calculate Joint Entropy
    hst = hst/sum(hst(:));  % Normalize histogram
    ind = hst > 0;
    je = -sum(hst(ind).*log(hst(ind)));

end
