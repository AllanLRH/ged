function [imp4] = segmentImplant(img)
%% segmentImplant: Return a mask covering the implant
% img is a normalized image.

    lowThreshold = 0.6386;
    highThreshold = 0.7033;
    imp1 = (lowThreshold < img) & (img < highThreshold);
    % Also fill the inner part of the implant
    se = strel('square', 30);
    imp2 = imclose(imp1, se);  % Make implant solid
    imp3 = imopen(imp2, se);  % Remote white dots inside/outside implant circle
    imp4 = logical(bwfill(imp3, 'holes'));  % Fill the middle of the implant in case it's not

end
