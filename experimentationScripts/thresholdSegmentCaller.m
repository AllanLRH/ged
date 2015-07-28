clear; close all; clc

% imgStack = loadGed('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/data/volfloat/5.05_ID1662_769_pag0001.vol', 1);
% imgStack = loadGed('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/disc_backups/disc2/volfloat/5.05_ID1662_769_0001.vol', [1 25 50]);
imgStack = loadGed('5.05_ID1662_769_0001.vol', [1 50 255]);

img = normImage(imgStack(:, :, 1));
[implant, bone, cavity] = thresholdSegment(img);
ha(1) = subplot(121);
imsc(img)
shadeArea(implant, [0 1 0])
shadeArea(bone, [1 0 0])
shadeArea(cavity, [0 0 1])
ha(2) = subplot(122);
imsc(img)
linkaxes(ha, 'xy');
maximize
