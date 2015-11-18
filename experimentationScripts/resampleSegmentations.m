clear; home; close all

fileCell = dir('../segmentations/*.mat');
fileNames = {fileCell.name}
disp('---------------------------------')
disp('Starting resampling')
disp(length(fileNames))
disp('---------------------------------')

for ii = 1:length(fileNames)
    fprintf('\nii: %d\n\n\n', ii)
    load(['../segmentations/' fileNames{ii}]);  % savedBoneMasks, savedImplantMasks
    tmpBone = zeros(512, 512, 250);
    tmpImplant = zeros(512, 512, 250);
    for jj = 1:4:1000
        fprintf('jj: %d\n', jj)
        tmpBone(:,:,jj) = imresize(double(savedBoneMasks(:,:,jj)), [512 512]);
        tmpImplant(:,:,jj) = imresize(double(savedImplantMasks(:,:,jj)), [512 512]);
    end
    savedBoneMasks = logical(tmpBone);
    savedImplantMasks = logical(tmpImplant);
    save(['../smallSegmentations/' fileNames{ii}], 'savedBoneMasks', 'savedImplantMasks');
end
