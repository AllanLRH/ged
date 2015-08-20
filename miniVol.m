clear; close all; clc

orgVol = loadGed('data/5.05_ID1662_769_0001.vol', 1:3:255);

vol = zeros(128, 128, size(orgVol, 3));
for k = 1:size(orgVol, 3)
    vol(:, :, k) = imresize(orgVol(:,:,k), 1/16);
    if mod(k, 10) == 0
        disp(k/size(orgVol, 3)*100)
    end
end

save('minivol.mat', 'vol' ,'-v6');
