function cost = entropyCost(mv, im, im3d, nBins)
    %% entropyCost: Cost function for image registration
    % mv(1): translation in x
    % mv(2): translation in y
    % mv(3): translation in z
    % mv(4): rotation in x
    % mv(5): rotation in y
    % mv(6): rotation in z
    % im:    the static image (microscope image)
    % im3d:  the 3D image
    % nBins: number of bins to use in JPD

    % plane = getRotMat(mv(4:6))*mv(1:3);
    slice = sample3d  % STUB
    ei = energyImage(im1, slice, nBins);
    cost = sum(ei(:));

end
