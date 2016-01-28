clear; home; close all

load('../annotations.mat')

fieldNames = {'inputFilename', 'aBoneExample', 'aCavityExample', ...
'anImplantExample', 'avoidEdgeDistance', 'minSlice', 'maxSlice', ...
'halfEdgeSize', 'filterRadius', 'maxIter', 'maxDistance', 'SHOWRESULT', ...
'SAVERESULT', 'outputFilename', 'origo', 'R', 'marks'};

fileID = {'ID1662_769', 'ID1662_770', 'ID1662_771', 'ID1662_772','ID1662_773', ...
'ID1684_806', 'ID1684_809', 'ID1689_805', 'ID1689_807', 'ID1689_808'};

for ii = 1:length(fileID)
    for jj = 1:length(fieldNames)
        pStruct.(fileID{ii}).(fieldNames{jj}) = p{ii, jj};
    end
end

newNames = cellfun(@(x) strrep(x, 'gedData/', ''), {p{:, 1}}, 'uniformOutput', false);
for ii = 1:length(newNames)
    whosAns = whos('-file', newNames{ii});
    pStruct.(fileID{ii}).size = whosAns.size;
end


