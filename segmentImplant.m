function [imp4] = segmentImplant(meanImg, stdImg)
%% segmentImplant: Return a mask covering the implant
% meanImg is getMeanImgge(nm1, 5).^2
% stdImg is  getStdImage(img, n).^2
    
    meanStdImg = meanImg.^2 + stdImg.^2;
    threshold = 0.33;
    imp1 = meanStdImg > threshold;
    % Remove small misclassified areas
    se = strel('disk', 25);
    imp2 = imopen(imp1, se);
    imp3 = imclose(imp2, se);
    % Fill the middle of the implant in case it's not
    imp4 = logical(bwfill(imp3, 'holes'));
end
