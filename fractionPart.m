%% fractionSplitter: Splits the fraction from Jon's fraction3d function.
% fraction:       The fraction vector for bone, cavity or neither from fraction3d.
% distances:      The distances vector from fraction3d.
% regionBorders:  A two-element vector with region boundaries.
% scaleFactor:    This is the scale in relation to the original files. A size of
%                     0.25*0.25*0.25 is a scale factor of 4, and a size of
%                     0.5*0.5*0.5 is a scale factor of 2.
function [fracPart, dstPart] = fractionPart(fraction, distances, regionBorders)
    mask = (distances >= regionBorders(1)) & (distances < regionBorders(2));
    fracPart = fraction(mask);
    dstPart = distances(mask);
end
