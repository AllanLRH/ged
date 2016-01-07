clear; close all; home

im = rgb2gray(imread('../769hele implantatetx1.tif'));
imsc(im)
% [x, y] = ginput(2);
% x = [776.08 3587];
% y = [944.24 1536.5];
x = [3587 776.08];
y = [1536.5 944.24];
% Sort points, upperleft first.
% NOTE: Ensure that it's enough to check the length!
[~, i] = sort([sqrt(x(1)^2 + y(1)^2) sqrt(x(2)^2 + y(2)^2)]);
x = x(i); y = y(i);
hold on
for ii = 1:2
    plot(x(ii), y(ii), 'ro')
end
%% Logic part
[r, c] = ndgrid(1:size(im, 1), 1:size(im, 2));
maskX1 = x(1) > c;
maskX2 = x(2) < c;
% shadeArea(maskX1, [1 0 0])
% shadeArea(maskX2, [1 0 0])

maskY1 = y(1) > r;
maskY2 = y(2) < r;
% shadeArea(maskY1, [1 0 0])
% shadeArea(maskY2, [1 0 0])

maskFinal = maskX1 | maskX2 | maskY1 | maskY2;
shadeArea(maskFinal, [1 0 0])

