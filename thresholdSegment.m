clear; close all; clc

% imgStack = loadGed('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/data/volfloat/5.05_ID1662_769_pag0001.vol', 1);
% imgStack = loadGed('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/disc_backups/disc2/volfloat/5.05_ID1662_769_0001.vol', [1 25 50]);
imgStack = loadGed('5.05_ID1662_769_0001.vol', [1 2 50]);
[r, c, n] = size(imgStack);

%%
img = normImage(imgStack(:, :, 3));

%% Find circle containing image

xc = r/2;
yc = c/2;
circ = false(r, c);
for x = 1:r
    for y = 1:c
        if (x-xc)^2 + (y-yc)^2 <= xc^2
            circ(x, y) = 1;
        end
    end
end


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

imf = fspecial('gaussian', 4, 2);
imgB2 = imfilter(imfilter(img, imf), imf);
imgB3 = medfilt2(imgB2, [4,4]);
bone1 = imgB3 < 0.10;
se = strel('disk', 5);
bone2 = imopen(bone1, se);
se = strel('disk', 7);
bone3 = imclose(bone2, se);
% filter out middle
middle = ~bwfill(imp2, 'holes');
bone4 = middle.*circ.*bone3;
shadeArea(bone4, [0 0 1])


%% Find the last region for completeness

rest1 = not(bone4);
rest2 = rest1.*circ.*middle;
shadeArea(rest2, [0 1 0])
