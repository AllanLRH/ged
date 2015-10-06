clear; home; close all

im1 = normImage(loadGed('5.05_ID1662_769_0001.vol', 1));

n = 4;

entropySums = zeros([20, 1]);
cnt = 1;
ei = zeros(2048, 2048, n-1);
for ii = 2:n
    im2 = normImage(loadGed('5.05_ID1662_769_0001.vol', ii));
    ei(:, :, cnt) = energyImage(im1, im2, 60);
    entropySums(cnt) = sum(sum(ei(:,:,cnt)));
    disp(entropySums(cnt))
    cnt = cnt + 1;
end

subplot(131)
imsc(ei(:,:,1))
subplot(132)
imsc(ei(:,:,2))
subplot(133)
imsc(ei(:,:,3))
% plot(entropySums, '-o')
