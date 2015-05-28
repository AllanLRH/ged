function [imp4] = segmentImplant(meanStdImg)
%% segmentImplant: Return a mask covering the implant
% meanStdImg is a getMeanImgge(nm1, 5).^2 + getStdImage(img, n).^2.

    threshold = 0.33;
    imp1 = meanStdImg > threshold;
    % Remove small misclassified areas
    se = strel('disk', 25);
    imp2 = imopen(imp1, se);
    imp3 = imclose(imp2, se);
    % Fill the middle of the implant in case it's not
    imp4 = logical(bwfill(imp3, 'holes'));
end
