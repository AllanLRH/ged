clear; home; close all;

volDir = fullfile('..', 'volfloat');
dirCell = dir(fullfile(volDir, '*0001.vol'));
nameCell = {dirCell.name}; % Cell with all *001.vol files
fileGroups = cellfun(@getFileGroup, fullfile(volDir, nameCell), 'uniformOutput', false);
scaleFactorMat = [2 4];
pathSep = strtrim(fullfile(' ', ' '));  % '/' on Unix, '\' on Windows

for ii = 1:length(fileGroups)
    tic;
    fprintf('\nProcessing dataset %d of %d\n', ii, length(fileGroups))
    group = fileGroups{ii};
    groupInfo = cellfun(@parseVolInfo, group);
    numZ = sum(cell2mat({groupInfo.NUM_Z}));  % Number of slices in dataset
    fname = group{1};
    fprintf('\tLoading dataset\n')
    vol = loadDataset(fullfile(volDir, fname), 1:numZ);
    % Example: nameIdPart of "volfloat/5.05_ID1662_769_pag0001.vol" is "5.05_ID1662_769_pag".
    nameIdPart = regexpi(fname(10:end), pathSep, 'split'); nameIdPart = nameIdPart{end};
    nameIdPart = regexpi(nameIdPart, '([\d.]+_)?ID\d+_\d+_[a-zA-Z]*', 'match');
    for sf = scaleFactorMat
        fprintf('\tScaling dataset with scale factor %d\n', sf)
        [x1q, x2q, x3q] = ndgrid(linspace(1, size(vol, 1), size(vol, 1)/sf), ...
                                 linspace(1, size(vol, 2), size(vol, 2)/sf), ...
                                 linspace(1, size(vol, 3), size(vol, 3)/sf));
        newVol = interpn(vol, x1q, x2q, x3q);
        fprintf('\tSaving dataset\n')
        if sf == 4
            save(char(fullfile('..', 'smallData', [nameIdPart '_v7.3_double.mat'])), 'newVol', '-v7.3');
        elseif sf == 2
            save(char(fullfile('..', 'halfSizeData', [nameIdPart '_v7.3_double.mat'])), 'newVol', '-v7.3');
        end
    end  % for scaleFactor
    toc
end
