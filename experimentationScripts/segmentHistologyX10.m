clear; close all; home

i0 = imread('/../histologyImages/783/makro højrex10/Image.png');

R = double(i0(:, :, 1));
G = double(i0(:, :, 2));
B = double(i0(:, :, 3));
[h, s, v] = rgb2hsv(i0);
h = double(h);
s = double(s);
v = double(v);
lab = rgb2lab(i0);
l = double(lab(:, :, 1));
a = double(lab(:, :, 2));
b = double(lab(:, :, 3));

subplot(3, 3, 1)
imsc(R)
title('R')
subplot(3, 3, 2)
imsc(G)
title('G')
subplot(3, 3, 3)
imsc(B)
title('B')
subplot(3, 3, 4)
imsc(h)
title('h')
subplot(3, 3, 5)
imsc(s)
title('s')
subplot(3, 3, 6)
imsc(v)
title('v')
subplot(3, 3, 7)
imsc(l)
title('l')
subplot(3, 3, 8)
imsc(a)
title('a')
subplot(3, 3, 9)
imsc(b)
title('b')

%%

implant1 = B.^2.4 < 0.5;
implant2 = imopen(implant1, strel('disk', 30));
implant3 = imclose(implant2, strel('disk', 30));
% imsc(i0)
% shadeArea(not(implant3), [1 0 0], 0.3)
%%
figure
cav1 = b > 0.57;
cav2 = imopen(cav1, strel('disk', 10));
subplot(121); imsc(cav2); subplot(122); imsc(cav1)





% b1 = normImage(double(b));

















