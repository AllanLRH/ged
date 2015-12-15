%% loadDataset: Loads a dataset from the specified dataset name and path.
% Provides transparent interface for a dateset, as if it were one file
% datafile: A datafile from the dataset
% slice: A vector with slice indices to be returned
function out = loadDataset(datafile, slice)
    fileMap = ceil(slice/256);
    fileGroup = getFileGroup(datafile);
    out = NaN(2048, 2048, length(slice)); % Defect 20151215: 2048x2048 skal ikke v�re hardcoded!!!! Lav en fkt som kan finde ud af det fra billedet selv.
    cnt = 1;
    for sl = slice
        filename = fileGroup{fileMap};
        out(:, :, cnt) = loadGed(filename, sl-((fileMap-1)*256));
        cnt = cnt + 1;
    end
end


