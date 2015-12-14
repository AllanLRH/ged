function [implantMask, boneMask, boneGuessNext, cavityGuessNext, boneCavityFraction, cavityFraction] = ...
         boneFractionInnerFunction(im, cavityGuess, boneGuess, circ, seNextImg, seCleaner, boxsize, ii)
    %% boneFractionInnerFunction: Perform the segmentation part for the script boneFraction.m
    %
    %                   # # #   INPUTS   # # #
    % im:           Image slice to be segmentet
    % cavityGuess:  Guess on cavity locations for current image
    % boneGuess:    Guess on bone locations for current image
    % circ:         A mask to select the round part of the image with the real data.
    % seNextImg:    Strel-element used to create the guesses for the next image in the stack
    % ii:           A counter keeping track of the progress of the stack
    %
    %                   # # #   OUTPUTS   # # #
    % implantMask:         Mask for the implant
    % boneMask:            Mask for the bone
    % boneGuessNext:       See boneGuess in INPUTS
    % cavityGuessNext:     See cavityGuess in INPUTS
    % boneCavityFraction:  The fraction of bone and cavity for the slice,
    %                      meant to be logged for debugging purposes.
    implantMask  = segmentImplant(im, ii);
    if all(not(implantMask(:)))
        warning('No implantMask returned for slice %d', ii)
    end
    interestMask = (circ & ~implantMask);
    bias         = biasCorrect(im, interestMask);
    im           = im - bias;
    boneMean     = median(im(boneGuess));
    boneStd      = median(abs(im(boneGuess)-boneMean));
    cavityStd    = std(im(cavityGuess));
    cavityMean   = mean(im(cavityGuess));

    meanImg      = getMeanImage(im, interestMask, boxsize);
    stdImg       = getVarImage(im, interestMask, boxsize, meanImg);
    bone2        = (meanImg-boneMean).^2 + (stdImg-boneStd).^2;
    cavity2      = (meanImg-cavityMean).^2 + (stdImg-cavityStd).^2;
    segmentation = (bone2 > cavity2);
    boneMask     = imclose(segmentation, seCleaner) & interestMask;

    boneGuessNext   = imerode(~segmentation, seNextImg) & interestMask;  % why isn't the ~ on the cavityGuessNext?
    cavityGuessNext = imerode(segmentation, seNextImg) & interestMask;

    tempBoneMask       = (~segmentation & interestMask);
    tempCavityMask     = (segmentation & interestMask);
    boneCavityFraction = sum(tempBoneMask(:))/sum(tempCavityMask(:));
    cavityFraction     = sum(tempCavityMask(:))/sum(interestMask(:));
end
