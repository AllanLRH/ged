function [meanGuessBone, stdGuessBone, meanGuessCavity, stdGuessCavity] = statsFromPrevMask(currentImg, previousMask, interestMask)
%% statsFromPrevMask: Get mean and std guess by median sampling from previous image mask.

    nDraws            = 10;
    se                = strel('disk', 7);
    boneMaskNextImg   = logical(imopen(not(previousMask).*interestMask, se));
    cavityMaskNextImg = logical(imopen(previousMask.*interestMask, se));
    boneImg           = currentImg(boneMaskNextImg);
    cavityImg         = currentImg(cavityMaskNextImg);
    boneImgNumel      = numel(boneImg);
    cavityImgNumel    = numel(cavityImg);

    boneMeans   = zeros(nDraws, 1)*NaN;
    boneStds    = zeros(nDraws, 1)*NaN;
    cavityMeans = zeros(nDraws, 1)*NaN;
    cavityStds  = zeros(nDraws, 1)*NaN;
    for ii = 1:nDraws
        boneIndexes     = randi(boneImgNumel, [floor(boneImgNumel/nDraws) 1]);
        cavityIndexes   = randi(cavityImgNumel, [floor(cavityImgNumel/nDraws) 1]);
        boneDraw        = boneImg(boneIndexes);
        cavityDraw      = cavityImg(cavityIndexes);
        boneMeans(ii)   = mean(boneDraw);
        cavityMeans(ii) = mean(cavityDraw);
        boneStds(ii)    = std(boneDraw);
        cavityStds(ii)  = std(cavityDraw);
    end

    meanGuessBone   = median(boneMeans);
    stdGuessBone    = median(boneStds);
    meanGuessCavity = median(cavityMeans);
    stdGuessCavity  = median(cavityStds);

end
