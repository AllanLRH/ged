%% loadDataset: Loads a dataset from the specified dataset name and path.
% Provides transparent interface for a dateset, as if it were one file
% datafile: A datafile from the dataset
% slice: A vector with slice indices to be returned
function out = loadDataset(datafile, slice)
    fileMap = ceil(slice/256);
    fileGroup = getFileGroup(datafile);
    fileMapUnique = unique(fileMap);
    out = zeros(2048, 2048, length(slice));
    cnt = 1;
    for ii = 1:length(fileMapUnique)
        slicesInThisFile = slice(fileMap==ii) - 256*(ii-1);
        nSlices = length(slicesInThisFile);
        out(:, :, cnt:(cnt+nSlices-1)) = loadGed(fileGroup{ii}, slicesInThisFile);
        cnt = cnt + nSlices;
    end
end


