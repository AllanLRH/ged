inPath = '../gedData/smallData/';
outPath = '';
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


p = cell(length(filenames),17);
figure(1); clf;
for i = 1:length(filenames)
    disp(filenames{i});
    inputFilename = [inPath,filenames{i},'.mat'];
    load(inputFilename);
    showSlice = round(size(newVol,3)/2);
    imagesc(newVol(:,:,showSlice)); title(sprintf('Bias corrected slice %d',showSlice)); colormap(gray); axis image tight;
    
    title('Select Bone');
    x = ginput(1);
    boneExample = round([x(2),x(1),showSlice]);
    title('Select Cavity');
    x = ginput(1);
    cavityExample = round([x(2),x(1),showSlice]);
    title('Select Implant');
    x = ginput(1);
    implantExample = round([x(2),x(1),showSlice]);
    
    implantThreshold = (newVol(implantExample(1),implantExample(2),implantExample(3))+newVol(boneExample(1),boneExample(2),boneExample(3)))/2;
    implant = segmentImplant3d(newVol, implantThreshold);
    
    xMax = round(size(implant)/2);
    x1 = 0;
    x2 = -(xMax(2)-1):xMax(2);
    x3 = -(xMax(3)-1):xMax(3);
    accepted = false;
    [origo,R,~] = getAxes3d(implant);
    while ~accepted
        slice = squeeze(sample3d(newVol,origo,R,x1,x2,x3));
        
        imagesc(slice); title('Saggital slice'); colormap(gray); axis image tight;
        marks = zeros(4,3);
        for j = 1:size(marks,1)
            title(sprintf('Select mark %d',j));
            x = ginput(1);
            marks(j,:) = [x(2),showSlice,x(1)];
        end
        v = marks(end,:)-marks(1,:);
        v = v'/sqrt(sum(v.^2));
        %disp(abs(dot(v,[0,0,1])));
        if abs(dot(v,[0,0,1])) > 0.9998 % 1 degree
            accepted = true;
        else
            disp('Orientation corrected, repeat input');
            v = R*v;
            R(:,3) = v;
            R(:,2) = R(:,2) - dot(R(:,2),R(:,3))*R(:,3);
            R(:,2) = R(:,2)/sqrt(sum(R(:,2).^2));
            R(:,1) = R(:,1) - dot(R(:,1),R(:,2))*R(:,2) - dot(R(:,1),R(:,3))*R(:,3);
            R(:,1) = R(:,1)/sqrt(sum(R(:,1).^2));
        end
    end
    p(i,:) = {inputFilename,boneExample,cavityExample,implantExample,avoidEdgeDistance, minSlice, maxSlice, halfEdgeSize, filterRadius, maxIter, maxDistance, SHOWRESULT, SAVERESULT, [outPath,p{i,1}], origo, R, marks};
end

save([outPath,'annotations.mat'],'p');
