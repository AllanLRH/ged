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

imf = fspecial('gaussian', 4, 2);
imgB2 = imfilter(imfilter(img, imf), imf);
imgB3 = medfilt2(imgB2, [4,4]);
bone1 = imgB3 < 0.10;
figure
cnt = 1;
for ii = 1:2:10
    for jj = 1:2:10
        subplot(5, 5, cnt)
        se = strel('disk', ii);
        bone2 = imopen(bone1, se);
        se = strel('disk', jj);
        bone3 = imclose(bone2, se);
        imagesc(img)
        shadeArea(bone3, [0 0 1])
        cnt = cnt + 1;
        t = title(sprintf('open %d, close %d', ii, jj));
        t.FontSize = 10;
        t.FontWeight = 'normal';
        colormap gray
    end
end
