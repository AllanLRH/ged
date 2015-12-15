function mask = segmentImplant(im)
%% segmentImplant: Return a mask covering the implant
mask = im < 1.5;
