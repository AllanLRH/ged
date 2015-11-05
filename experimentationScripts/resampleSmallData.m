clear; home; close all

fileCell = dir('../smallData/');
fileNames = {fileCell.name};

parfor ii = 3:length(fileNames)
    loadStruct = load(['../smallData/' fileNames{ii}]);
    newVol = loadStruct.newVol;
    newVol = newVol(:,:,1:4:size(newVol,3));
    parsave(['../newSmallData/' fileNames{ii}], newVol);
end

