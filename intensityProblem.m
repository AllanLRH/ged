clear; close all; clc

img = normImage(loadGed('5.05_ID1662_769_0001.vol', 60));
[r, c] = size(img);

shadeLinker(img < 0.44, img, 'imgAndMask')
