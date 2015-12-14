for ii = [1 20 40 100 200 400 550 750 900 950 980 988 992 996 997 998 999 1000]
    figure; maximize; pause(2);
    im = normImage(loadDataset('../data/5.05_ID1662_770_0001.vol', ii));
    subplot(231); imsc(im); title('im'); drawnow; pause(0.2)
    im2 = im.^2.5;
    subplot(232); imsc(im2); title('im2'); drawnow; pause(0.2)
    e31 = edge(im, 'canny', [0.0001 0.6]) .* makeCircle(size(im, 1), round(0.25*size(im, 1)), size(im)/2); imsc(e31)
    subplot(234); imsc(e31); title('e31'); drawnow; pause(0.2)
    e32 = imdilate(e31, strel('disk', 6)); imsc(e32)
    subplot(235); imsc(e32); title('e32'); drawnow; pause(0.2)
    e33 = imclose(e32, strel('disk', 200)); imsc(e33)
    subplot(236); imsc(e33); title('e33'); drawnow; pause(0.2)
end
