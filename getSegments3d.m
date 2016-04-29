function [segment1, segment2] = getSegments3d(im, mask, thresholdFct, erodeSize)
% Threshold an image and possibly contract each segment

segment1 = (im > thresholdFct) & mask;
%segment1 = (im > threshold*1./(1+exp(-dstMap))) & mask;
segment2 = ~segment1 & mask;

if erodeSize >= 1.5
    [x1,x2,x3] = ndgrid(-ceil(erodeSize):ceil(erodeSize));
    seEdge = strel('arbitrary', x1.^2 + x2.^2 + x3.^2 < erodeSize.^2);
    segment1 = imerode(segment1, seEdge);
    segment2 = imerode(segment2, seEdge);
end