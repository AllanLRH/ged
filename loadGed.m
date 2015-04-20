clear all; close all; clc;

h = fopen('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/data/volfloat/5.05_ID1662_769_pag0001.vol', 'r');
% dims = [2048 2048 256];
dims = [2048 2048 1];
img = fread(h, prod(dims), 'float32');
img = reshape(img, dims);
%% Show image

imagesc(img(:, :, 1))
colormap gray



