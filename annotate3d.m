inPath = '../gedData/smallData/';
outPath = '../gedData/smallData/';
avoidEdgeDistance = 10;
minSlice = 1;
maxSlice = 150;
halfEdgeSize = 0;
filterRadius = 2;
maxIter = 3;
maxDistance = 100;
SHOWRESULT = true;
SAVERESULT = true;

filenames= {'5.05_ID1662_769_v7.3_double', ...
    '5.05_ID1662_770_v7.3_double', ...
    '5.05_ID1662_771_v7.3_double', ...
    '5.05_ID1662_772_v7.3_double', ...
    '5.05_ID1662_773_v7.3_double', ...
    '5.05_ID1684_806_v7.3_double', ...
    '5.05_ID1684_809_v7.3_double', ...
    '5.05_ID1689_805_v7.3_double', ...
    '5.05_ID1689_807_v7.3_double', ...
    '5.05_ID1689_808_v7.3_double'};


p = cell(length(filenames),15);
figure(1); clf;
for i = 1:length(filenames)
    inputFilename = [inPath,filenames{i},'.mat'];
    load(inputFilename);
    showSlice = round(size(newVol,3)/2);
    imagesc(newVol(:,:,showSlice)); title(sprintf('Bias corrected slice %d',showSlice)); colormap(gray); axis image tight;
    title('Select Bone');
    x = ginput(1);
    boneExample = [x(2),x(1),showSlice];
    title('Select Cavity');
    x = ginput(1);
    cavityExample = [x(2),x(1),showSlice];
    title('Select Implant');
    x = ginput(1);
    implantExample = [x(2),x(1),showSlice];
    
    showSlice = round(size(newVol,1)/2);
    imagesc(squeeze(newVol(:,showSlice,:))); title(sprintf('Bias corrected slice %d',showSlice)); colormap(gray); axis image tight;
    marks = zeros(4,3);
    for j = 1:size(marks,1)
        title(sprintf('Select mark %d',j));
        x = ginput(1);
        marks(j,:) = [x(2),showSlice,x(1)];
    end
    p(i,:) = {inputFilename,boneExample,cavityExample,implantExample,avoidEdgeDistance, minSlice, maxSlice, halfEdgeSize, filterRadius, maxIter, maxDistance, SHOWRESULT, SAVERESULT, [outPath,p{i,1}], marks};
end

save([outPath,'annotations.mat'],'p');
