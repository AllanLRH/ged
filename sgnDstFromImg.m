function phi = sgnDstFromImg(I)
% SGNDSTFROMIMG - Signed Distance Map From Image
%   phi = sgnDstFromImg(I)
% INPUT:
%      I - Initial image, as black and white where white corresponds to object.
% RESULT:
%      phi - Signed Distance Map
%
% Henrik Dohlmann, 3DLab & Kenny Erleben, Diku.
%  3/12/04:  Corrected distances by adding and subtracting 0.5. Jon Sporring

  phi = bwdist(I) - bwdist(~I);
  ind = phi>0;
  phi(ind) = phi(ind)-0.5;
  ind = phi<0;
  phi(ind) = phi(ind)+0.5;
