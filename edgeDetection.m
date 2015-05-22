clear; close all; clc;

img = normImage(loadGed('5.05_ID1662_769_0001.vol', [1]));
s = size(img, 1);  % Quadratic image
ift = fftshift(fft2(img));
% imsc(abs(ift.^ift), 'colormap', 'parula', 'colorbar')

%% Gaussian "ring" filter

x = -s/2:s/2-1;
y = -s/2:s/2-1;
[x, y] = meshgrid(x, y);
rd = sqrt(x.^2 + y.^2);
sigma = 20;
bandwidth = 2;
figure
maximize
pause(0.5)
gFilt = fspecial('gaussian', sigma, sigma*5);
for mu = (s/2+s/64 : s/128 : s-s/64) - s/2
    % pause(0.02)
    disp(mu)
    % band = (rd < mu+s/128) & (rd > mu-s/128);
    band = double((rd < mu+bandwidth/2) & (rd > mu-bandwidth/2));
    gsn = imfilter(band, gFilt);
    % gsn = gaus(x, y, mu, sigma);
    toShow = abs(ifft2(ift .* gsn));
    % cannyEdge = edge(toShow, 'canny', 0.075);
    subplot(121)
    imsc(gsn)
    subplot(122)
    imsc(toShow)
    waitforbuttonpress;
end




%% Mexican hat

% x/y axes
% x = -s/2:s/2;
% y = -s/2:s/2;
% [x, y] = meshgrid(x, y);
%
% % Receptive field
% sig1 = 300;
% sig2 = sig1 * 1.2;
% r2 = x.^2 + y.^2;
% z = (exp(-r2/(2*sig1.^2))/sig1 - exp(-r2/(2*sig2.^2))/sig2)/sqrt(2*pi);
%
% surf(x, y, z)
