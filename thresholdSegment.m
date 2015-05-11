clear; close all; clc

% imgStack = loadGed('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/data/volfloat/5.05_ID1662_769_pag0001.vol', 1);
% imgStack = loadGed('/Users/allan/migMount/eScience/XRay/apu05.esci.nbi.dk.0_localhost/tandlaege/disc_backups/disc2/volfloat/5.05_ID1662_769_0001.vol', [1 25 50]);
imgStack = loadGed('5.05_ID1662_769_0001.vol', [1 50 255]);
[r, c, n] = size(imgStack);

%%
img = normImage(imgStack(:, :, 1));
ha(1) = subplot(121);

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

lowThreshold = 0.6386;
highThreshold = 0.7033;
imp1 = lowThreshold < img & img < highThreshold;
% Also fill the inner part of the implant
se = strel('square', 30);
imp2 = imclose(imp1, se);  % Make implant solid
imp3 = imopen(imp2, se);  % Remote white dots inside/outside implant circle
imp4 = bwfill(imp3, 'holes');  % Fill the middle of the implant in case it's not
h = imsc(img);
shadeArea(imp4, [1 0 0]);


%% Find bone/soft tissue

highThreshold = 0.4488;
lowThreshold = 0.3054;
imf = fspecial('gaussian', 4, 2);
imgB2 = imfilter(imfilter(img, imf), imf);
imgB3 = medfilt2(img, [4,4]);
bone1 = (lowThreshold < imgB3) & (imgB3 < highThreshold);
se = strel('square', 4);
bone2 = imopen(bone1, se);
se = strel('square', 2);
bone3 = imdilate(bone2, se);
bone4 = ~imp2.*circ.*bone3;
shadeArea(bone4, [0 0 1])


%% Find the last region for completeness

rest1 = not(bone4);
rest2 = rest1.*circ.*(~imp2);
shadeArea(rest2, [0 1 0])

%% Finalize plotting

ha(2) = subplot(122);
imsc(img)
linkaxes(ha, 'xy');
