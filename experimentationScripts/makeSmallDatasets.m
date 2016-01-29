% clear; home; close all;

volDir = fullfile('..', 'volfloat');
dirCell = dir(fullfile(volDir, '*0001.vol'));
nameCell = {dirCell.name}; % Cell with all *001.vol files
fileGroups = cellfun(@getFileGroup, fullfile(volDir, nameCell), 'uniformOutput', false);

halfSizeStruct.factor = 2;
halfSizeStruct.savePath = fullfile('..', 'halfSizeData');
quarterSizeStruct.factor = 4;
quarterSizeStruct.savePath = fullfile('..', 'smallData');
scaleCell = {halfSizeStruct, quarterSizeStruct};

pathSep = strtrim(fullfile(' ', ' '));  % '/' on Unix, '\' on Windows
try
% for ii = 1:length(fileGroups)
    tic;
    group = fileGroups{ii};
    fprintf('\nProcessing dataset %d of %d\nDataset name:\t%s\n', ii, length(fileGroups), group{1})
    groupInfo = cellfun(@parseVolInfo, group);
    numZ = sum(cell2mat({groupInfo.NUM_Z}));  % Number of slices in dataset
    fname = group{1};
    fprintf('\tLoading dataset\n')
    vol = loadDataset(fullfile(volDir, fname), 1:numZ);
    % Example: nameIdPart of "volfloat/5.05_ID1662_769_pag0001.vol" is "5.05_ID1662_769_pag".
    nameIdPart = regexpi(fname, pathSep, 'split'); nameIdPart = nameIdPart{end};
    nameIdPart = regexpi(nameIdPart, '([\d.]+_)?ID\d+_[\da-zA-Z]+_[a-zA-Z]*', 'match');
    nameIdPart = nameIdPart{1};
    for sf = 1:length(scaleCell)
        scaleStruct = scaleCell{sf};
        fprintf('\tScaling dataset with scale factor %d\n', scaleStruct.factor)
        [x1q, x2q, x3q] = ndgrid(linspace(1, size(vol, 1), size(vol, 1)/scaleStruct.factor), ...
                                 linspace(1, size(vol, 2), size(vol, 2)/scaleStruct.factor), ...
                                 linspace(1, size(vol, 3), size(vol, 3)/scaleStruct.factor));
        newVol = interpn(vol, x1q, x2q, x3q);
        fprintf('\tSaving dataset\n')
        save(char(fullfile(scaleStruct.savePath, [nameIdPart '_v7.3_double.mat'])), 'newVol', '-v7.3');
        clear('newVol', 'x1q', 'x2q', 'x3q')
    end  % for scaleFactor
    clear('vol')
    toc
catch me
    fprintf('There was an error:\n%s\n\n', me.message)
end  % try
quit
% end  % for length(fileGroups)
