clear; close; home

sideLength = 256;
vol = normImage(makeCircle(sideLength, 80, [sideLength/2 sideLength/2]) - makeCircle(sideLength, 90, [sideLength/2 sideLength/2]));
vol = repmat(vol, 1, 1, 120);

planePoints = 128;  % points along one direction, will be squared
angle = 60;
for z = 0:0.05:1.20
    %z = 0.7;
    imslice = getSlice(vol, [1,1,0], angle, z, planePoints);
    imslice(isnan(imslice)) = 0.5;
    imagesc(imslice)
    colormap gray
    colorbar
    caxis([0 1])
    title(z);
    drawnow
end