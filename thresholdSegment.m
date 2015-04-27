clear all; close all; clc

img = loadGed('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/data/volfloat/5.05_ID1662_769_pag0001.vol', 1);
%% Find implant
close all
imp1 = img < 0.62;
scMin = min(img(:));
scMax = max(img(:));
se = strel('disk', 18);
imp2 = ~imclose(imp1, se);
h = imshow(img, [scMin, scMax]);
shadeArea(imp2, [1 0 0]);

%% Find bone/soft tissue



