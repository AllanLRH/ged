function mask = segmentBoneAndCavity(img, interestMask, boxsize, varargin)
    if nargin > 3
        boneMean   = 0.4331;
        boneStd    = 0.0192;
        cavityMean = 0.3954;
        cavityStd  = 0.0160;
    else
        argin      = varargin{1};
        boneMean   = argin(1);
        boneStd    = argin(2);
        cavityMean = argin(3);
        cavityStd  = argin(4);
    end

    meanImg = getMeanImage(img, interestMask, boxsize);
    stdImg  = getStdImage(img, interestMask, boxsize, meanImg);

    bone   = (meanImg-boneMean).^2 + (stdImg-boneStd).^2;
    cavity = (meanImg-cavityMean).^2 + (stdImg-cavityStd).^2;
    mask   = bone > cavity;

end
