clear; home; close all

im1 = normImage(loadGed('5.05_ID1662_769_0001.vol', 1));

entropySums = zeros([20, 1]);
cnt = 1;
ei = zeros(2048, 2048, 19);
for ii = 2:20
    im2 = normImage(loadGed('5.05_ID1662_769_0001.vol', ii));
    ei(:, :, cnt) = energyImage(im1, im2, 60);
    entropySums(cnt) = sum(sum(ei(:,:,cnt)));
    % im1 = im2;
    cnt = cnt + 1
end

plot(entropySums)
