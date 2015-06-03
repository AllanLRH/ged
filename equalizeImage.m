function [ equalizedImage ] = equalizeImage( inImg, interestMask )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    load('desiredHistogram.mat');
    equalizedImage = 0.5*inImg + 0.5*histeq(inImg, desiredHistogram);
    equalizedImage = equalizedImage.*interestMask;
    equalizedImage = medfilt2(equalizedImage, [5,5]);


end

