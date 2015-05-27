function [mask] = segmentBoneAndCavity(img, boxsize)
    boneMean   = 0.4331;
    boneStd    = 0.0192;
    cavityMean = 0.3954;
    cavityStd  = 0.0160;

    meanImg = getMeanImage(img, boxsize);
    stdImg = getStdImage(img, boxsize, meanImg);

    bone = (meanImg-boneMean).^2+(stdImg-boneStd).^2;
    cavity = (meanImg-cavityMean).^2+(stdImg-cavityStd).^2;
    mask = bone > cavity;

end
