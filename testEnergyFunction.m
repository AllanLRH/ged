% clear; home; close all

im1 = normImage(loadGed('5.05_ID1662_769_0001.vol', 1));
im2 = normImage(loadGed('5.05_ID1662_769_0001.vol', 2));

ei = energyImage(im1, im2, 255);
imsc(ei)
% maximize