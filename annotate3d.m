SMALLDATA = true;
APPEND = true;

avoidEdgeDistance = 10;
minSlice = 1;
maxSlice = 150;
halfEdgeSize = 0;
filterRadius = 2;
maxIter = 3;
maxDistance = 100;
noMarks = 3;

filenamePattern = '*v7.3_double.mat';
annotationsPrefix = fullfile('.'); % Annotation file prefix (input)
if SMALLDATA
    scaleFactor = 1; % scaling factor used in the analysis fase w.r.t. annotation file
    analysisPrefix = fullfile('smallData'); % Analysis files prefix (input)
else
    scaleFactor = 2; % scaling factor used in the analysis fase w.r.t. annotation file
    analysisPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
end

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

%filenames = {'5.05_ID1689_805_pag_v7.3_double.mat', '5.05_ID1662_773_pag_v7.3_double.mat', '5.05_ID1689_807_pag_v7.3_double.mat', ...
%'5.05_ID1662_771_pag_v7.3_double.mat', '5.05_ID1684_809_pag_v7.3_double.mat', '5.05_ID1689_808_pag_v7.3_double.mat', '5.05_ID1662_769_pag_v7.3_double.mat', ...
%'5.05_ID1662_770_pag_v7.3_double.mat', '5.05_ID1662_772_pag_v7.3_double.mat', '5.05_ID1684_806_pag_v7.3_double.mat'};
tmp = dir(fullfile(analysisPrefix,filenamePattern));
filenames = {tmp(:).name};

figure(1);
if APPEND
    load(fullfile(annotationsPrefix,'annotations.mat'), 'p');
else
    p = [];
end
for i = 1:length(filenames)
    clf;
    fprintf('%d/%d: %s\n', i,length(filenames),filenames{i});
    
    nameID = regexpi(filenames{i}, 'ID.+?(?=_v[\d.]+)', 'match');
    nameID = nameID{1};
    if(isfield(p,nameID))
        fprintf(' Updating %s\n', nameID);
        choice = questdlg(sprintf('Annotations on "%s" already exists.',nameID), 'Question', 'Overwrite','Skip','Skip');
    else
        fprintf(' Creating %s\n', nameID);
        choice = 'Overwrite';
    end
    
    if(strcmp(choice,'Overwrite'))
        fprintf(' Reading\n');
        inputFilename = fullfile(analysisPrefix,filenames{i});
        load(inputFilename);
        
        fprintf(' Annotating\n')
        showSlice = round(size(newVol,3)/2);
        imagesc(newVol(:,:,showSlice));
        title(sprintf('Original image slice %d/%d', showSlice, size(newVol,3))); colormap(gray); axis image tight;
        
        fprintf('  Select Implant\n');
        title('Select Implant');
        x = fliplr(ginput(1));
        implantSamples = round([x,showSlice]);
        
        fprintf('  Select Cavity\n');
        title('Select Cavity');
        x = fliplr(ginput(1));
        cavitySamples = round([x,showSlice]);
        
        fprintf('  We need at least 10 examples of bone spread out over the volume for 2. degree polynomial bias correction in 3D\n')
        title('Select a bone samples near cavity');
        x = fliplr(ginput(1));
        boneSamples = round([x,showSlice]);
        
        title('Select 4 Bone samples near edges');
        x = fliplr(ginput(4));
        boneSamples = [boneSamples;round([x,showSlice*ones(4,1)])];
        
        showSlice = round(size(newVol,1)/2);
        imagesc(squeeze(newVol(showSlice,:,:))); axis image tight;
        title('Select 4 Bone samples near edges');
        x = fliplr(ginput(4));
        boneSamples = [boneSamples;round([showSlice*ones(4,1),x])];
        
        showSlice = round(size(newVol,2)/2);
        imagesc(squeeze(newVol(:,showSlice,:))); axis image tight;
        title('Select 4 Bone samples near edges');
        x = fliplr(ginput(4));
        boneSamples = [boneSamples;round([x(:,1),showSlice*ones(4,1),x(:,2)])];
        
        fprintf(' Segmenting implant\n')
        implantThreshold = (newVol(implantSamples(1), implantSamples(2), ...
            implantSamples(3)) + newVol(boneSamples(1,1), ...
            boneSamples(1,2), boneSamples(1,3)))/2;
        implant = segmentImplant3d(newVol, implantThreshold);
        
        fprintf(' Annotating implant marks\n')
        xMax = round(size(implant)/2);
        x1 = 0;
        x2 = -(xMax(2)-1):xMax(2);
        x3 = -(xMax(3)-1):xMax(3);
        accepted = false;
        [origo, R, D] = getAxes3d(implant);
        while ~accepted
            slice = squeeze(sample3d(newVol, origo, R, x1, x2, x3));
            
            imagesc(slice); title('Saggital slice'); colormap(gray); axis image tight;
            marks = zeros(noMarks, 3);
            for j = 1:size(marks, 1)
                title(sprintf('Select mark %d/%d', j, noMarks));
                x = fliplr(ginput(1));
                marks(j,:) = [showSlice, x];
            end
            v = marks(end,:)-marks(1,:);
            v = v'/sqrt(sum(v.^2));
            %disp(abs(dot(v,[0,0,1])));
            if dot(v,[0,0,1]) > 0.9998 % 1 degree
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
        p.(nameID).aBoneExample = boneSamples;
        p.(nameID).aCavityExample = cavitySamples;
        p.(nameID).anImplantExample = implantSamples;
        p.(nameID).R = R;
        p.(nameID).size = size(newVol);
        p.(nameID).avoidEdgeDistance = avoidEdgeDistance;
        p.(nameID).minSlice = minSlice;
        p.(nameID).maxSlice = maxSlice;
        p.(nameID).halfEdgeSize = halfEdgeSize;
        p.(nameID).filterRadius = filterRadius;
        p.(nameID).maxIter = maxIter;
        p.(nameID).maxDistance = maxDistance;
        p.(nameID).scaleFactor = scaleFactor;
        save(fullfile(annotationsPrefix,'annotations.mat'), 'p');
    end
end

