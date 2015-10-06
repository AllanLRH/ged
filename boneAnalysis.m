home; close all

clear DFull majorAxis ans maxDistance totalVolume boneVolume
clear no x1 dBoneVolume origo x2 dRelativeBoneVolume r x3 img
clear dTotalVolume resampledBoneMask xMax dist resampledDistance

if not(all([exist('savedBoneMasks') exist('savedImplantMasks')]))
    load('5.05_ID1662_769_0001_masks_v6.mat');
end
% implantMask, boneMask;

savedImplantMasks = imresize(savedImplantMasks, 1/4);
savedBoneMasks = imresize(savedBoneMasks, 1/4);
DFull = sgnDstFromImg(savedImplantMasks);

xMax = size(savedBoneMasks)/4;
x1 = -(xMax(1)-1):xMax(1);
x2 = -(xMax(2)-1):xMax(2);
x3 = 0:10;
[majorAxis,origo] = getMajorAxis(savedImplantMasks);
resampledBoneMask = sample3d(single(savedBoneMasks),origo,majorAxis,x1,x2,x3);
resampledDistance = sample3d(DFull,origo,majorAxis,x1,x2,x3);
maxDistance = 30;
[boneVolume, totalVolume] = boneFractionFunction(resampledBoneMask,resampledDistance,maxDistance);
dBoneVolume = (boneVolume(3:end)-boneVolume(1:end-2))/2;
dTotalVolume = (totalVolume(3:end)-totalVolume(1:end-2))/2;
dRelativeBoneVolume = dBoneVolume./dTotalVolume;

figure(1)
plot(boneVolume); xlabel('radius'); ylabel('bone integral');
hold on
plot(totalVolume);
hold off
legend('Bone fraction volume', 'Total band volume')

figure(2)
plot((2:(maxDistance-1)),dRelativeBoneVolume); xlabel('radius'); ylabel('bone integral');

figure(3)
for no=-100:100
    img = sample3d(single(savedBoneMasks),origo,majorAxis,x1,x2,no);
    dist = sample3d(DFull,origo,majorAxis,x1,x2,no);
    imshow(img>0.5); axis image; xlabel('x'); ylabel('y');
    hold on;
    r=1;
    contour(dist, r*[0:5:25],'r');
    hold off;
    drawnow;
%     saveas(gcf, sprintf('maskMovie/%3.3d_frame.png', no))
end
