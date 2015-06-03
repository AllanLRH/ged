function [imp5] = segmentImplant(img)
%% segmentImplant: Return a mask covering the implant
    
    im2 = conv2(img, ones(10), 'same');
    im3 = medfilt2(im2, 'symmetric');
    circCoords = makeCircle(2048, 320, [1024, 1024]);
    implantSlice = im3(circCoords);
    % Assume that the implant is the most common value around
    % the center of the image
    implantValue = mode(median(implantSlice));
    
    imp1 = (im3 > 0.9*implantValue) & (im3 < 1.1*implantValue);
    se = strel('disk', 10);
    imp2 = imclose(imp1, se);
    imp3 = imopen(imp2, se);
    se = strel('disk', 15);
    imp4 = imopen(imp3, se);
    imp5 = logical(bwfill(imp4, 'holes'));
end
