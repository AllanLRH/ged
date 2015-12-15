function [segment1, segment2] = getSegments3d(meanIm, stdIm, mask, m1, s1, m2, s2, alpha, seEdgeSize)

[x1,x2,x3] = ndgrid(-seEdgeSize:seEdgeSize);
seEdge = strel('arbitrary', x1.^2 + x2.^2 + x3.^2 < seEdgeSize.^2);

d1 = (1-alpha)*(meanIm-m1).^2 + alpha*(stdIm-s1).^2;
d2 = (1-alpha)*(meanIm-m2).^2 + alpha*(stdIm-s2).^2;
tmp = (d2 > d1);
segment1 = imerode(tmp, seEdge) & mask;
segment2 = imerode(~tmp, seEdge) & mask;
