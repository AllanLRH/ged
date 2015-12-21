function [sumImgByBandsFromBone, sumImgByBandsFromCavity, bands] = edgeEffect3d(boneMask, cavityMask, meanImg)

boneDst = sgnDstFromImg(boneMask);
cavityDst = sgnDstFromImg(cavityMask);
bands = -8:8;
sumImgByBandsFromBone = zeros(1,length(bands)-1);
sumFromBone = zeros(1,length(bands)-1);
sumImgByBandsFromCavity = zeros(1,length(bands)-1);
sumFromCavity = zeros(1,length(bands)-1);
for i = 2:(length(bands));
    band = bands(1) < boneDst & boneDst <= bands(i);
    sumImgByBandsFromBone(i) = sum(meanImg(band));
    sumFromBone(i) = sum(band(:));
    
    band = bands(1) < cavityDst & cavityDst <= bands(i);
    sumImgByBandsFromCavity(i) = sum(meanImg(band));
    sumFromCavity(i) = sum(band(:));
end
sumImgByBandsFromBone = diff(sumImgByBandsFromBone)./diff(sumFromBone);
sumImgByBandsFromCavity = diff(sumImgByBandsFromCavity)./diff(sumFromCavity);
bands = bands(2:end)-1/2;
