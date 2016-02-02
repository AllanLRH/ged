inPath = 'smallData/';
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

% filenames= {'5.05_ID1662_769_v7.3_double', ...
%     '5.05_ID1662_770_v7.3_double', ...
%     '5.05_ID1662_771_v7.3_double', ...
%     '5.05_ID1662_772_v7.3_double', ...
%     '5.05_ID1662_773_v7.3_double', ...
%     '5.05_ID1684_806_v7.3_double', ...
%     '5.05_ID1684_809_v7.3_double', ...
%     '5.05_ID1689_805_v7.3_double', ...
%     '5.05_ID1689_807_v7.3_double', ...
%     '5.05_ID1689_808_v7.3_double'};

filenames = {'5.05_ID1689_805_pag_v7.3_double.mat', '5.05_ID1662_773_pag_v7.3_double.mat', '5.05_ID1689_807_pag_v7.3_double.mat', ...
'5.05_ID1662_771_pag_v7.3_double.mat', '5.05_ID1684_809_pag_v7.3_double.mat', '5.05_ID1689_808_pag_v7.3_double.mat', '5.05_ID1662_769_pag_v7.3_double.mat', ...
'5.05_ID1662_770_pag_v7.3_double.mat', '5.05_ID1662_772_pag_v7.3_double.mat', '5.05_ID1684_806_pag_v7.3_double.mat'};

figure(1); clf;
load('annotations.mat')
for i = 1:length(filenames)
    nameID = regexpi(filenames{i}, 'ID.+?(?=_v[\d.]+)', 'match'); nameID = nameID{1};
    disp(filenames{i});
    inputFilename = [inPath filenames{i}];
    load(inputFilename);
    showSlice = round(size(newVol,3)/2);
    imagesc(newVol(:,:,showSlice)); title(sprintf('Bias corrected slice %d', showSlice)); colormap(gray); axis image tight;

    title('Select Bone');
    x = ginput(1);
    aBoneExample = round([x(2),x(1),showSlice]);
    title('Select Cavity');
    x = ginput(1);
    aCavityExample = round([x(2),x(1),showSlice]);
    title('Select Implant');
    x = ginput(1);
    anImplantExample = round([x(2),x(1),showSlice]);

    implantThreshold = (newVol(anImplantExample(1), anImplantExample(2), ...
                        anImplantExample(3)) + newVol(aBoneExample(1), ...
                        aBoneExample(2), aBoneExample(3)))/2;
    implant = segmentImplant3d(newVol, implantThreshold);

    xMax = round(size(implant)/2);
    x1 = 0;
    x2 = -(xMax(2)-1):xMax(2);
    x3 = -(xMax(3)-1):xMax(3);
    accepted = false;
    [origo, R, ~] = getAxes3d(implant);
    while ~accepted
        slice = squeeze(sample3d(newVol, origo, R, x1, x2, x3));

        imagesc(slice); title('Saggital slice'); colormap(gray); axis image tight;
        marks = zeros(4, 3);
        for j = 1:size(marks, 1)
            title(sprintf('Select mark %d', j));
            x = ginput(1);
            marks(j,:) = [x(2), showSlice, x(1)];
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
    p.(nameID).marks = marks;
    p.(nameID).inputFilename = inputFilename;
    p.(nameID).origo = origo;
    p.(nameID).aBoneExample = aBoneExample;
    p.(nameID).aCavityExample = aCavityExample;
    p.(nameID).anImplantExample = anImplantExample;
    p.(nameID).R = R;
    p.(nameID).size = size(newVol);
    p.(nameID).avoidEdgeDistance = avoidEdgeDistance;
    p.(nameID).minSlice = minSlice;
    p.(nameID).maxSlice = maxSlice;
    p.(nameID).halfEdgeSize = halfEdgeSize;
    p.(nameID).filterRadius = filterRadius;
    p.(nameID).maxIter = maxIter;
    p.(nameID).maxDistance = maxDistance;
    p.(nameID).SHOWRESULT = SHOWRESULT;
    p.(nameID).SAVERESULT = SAVERESULT;
end

save([outPath,'annotations.mat'], 'p');
