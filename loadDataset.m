%% loadDataset: Loads a dataset from the specified dataset name and path.
% Provides transparent interface for a dateset, as if it were one file
% datafile: A datafile from the dataset
% slice: A vector with slice indices to be returned
function out = loadDataset(datafile, slice)
    fileGroup = getFileGroup(datafile);  % names of datafiles in dataset (cell)
    fileGroupInfo = cellfun(@parseVolInfo, fileGroup);
    x = unique(cell2mat({fileGroupInfo.NUM_X}));
    y = unique(cell2mat({fileGroupInfo.NUM_Y}));
    maxZ = max(cell2mat({fileGroupInfo.NUM_Z}));
    sumZ = sum(cell2mat({fileGroupInfo.NUM_Z}));
    if any(slice > sumZ)  % check that requested slices is in data
        idx = find(slice > sumZ);
        error('Slice %d not in stack containing datafile %s', idx, datafile);
    end
    fileMap = ceil(slice/maxZ);  % map each slice to a file from fileGroup by index
    out = NaN(x, y, length(slice));  % preallocate output
    cnt = 1;
    for sl = slice-((fileMap-1)*maxZ)
        filename = fileGroup{fileMap(cnt)};  % set filename for current slices
        out(:, :, cnt) = loadGed(filename, sl);
        cnt = cnt + 1;
    end
    if any(isnan(out(:)))
        error('out contains %d NaNs\n', sum(isnan(out(:))))
    end

end


