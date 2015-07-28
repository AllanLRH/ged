clear; close all; clc

imageBytes = 134217728;
biasImg = zeros([2048 2048]);
filesInfo = dir('*.vol');
fileNames = {filesInfo.name};
fileSizes = [filesInfo.bytes];
cnt = 0;
for ii = length(fileNames)
    nImgInFile = fileSizes(ii)/imageBytes;
    for jj = 1:nImgInFile
        img = normImage(loadGed(fileNames{ii}, jj));
        biasImg = biasImg + imrotate(img, 360*rand, 'nearest', 'crop');
        cnt = cnt + 1;
        disp(jj/nImgInFile)
    end
end
biasImg = biasImg/cnt;

se = strel('disk', 12);
biasImgOpened = imopen(biasImg, se);

save('biasImg.mat', 'biasImg');
save('biasImgOpened.mat', 'biasImgOpened');
