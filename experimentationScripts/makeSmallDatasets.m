clear; home; close all;

fileGroups = {{'../data/5.05_ID1662_769_0001.vol', '../data/5.05_ID1662_769_0002.vol', '../data/5.05_ID1662_769_0003.vol', '../data/5.05_ID1662_769_0004.vol'}, {'../data/5.05_ID1662_770_0001.vol', '../data/5.05_ID1662_770_0002.vol', '../data/5.05_ID1662_770_0003.vol', '../data/5.05_ID1662_770_0004.vol'}, {'../data/5.05_ID1662_771_0001.vol', '../data/5.05_ID1662_771_0002.vol', '../data/5.05_ID1662_771_0003.vol', '../data/5.05_ID1662_771_0004.vol'}, {'../data/5.05_ID1662_772_0001.vol', '../data/5.05_ID1662_772_0002.vol', '../data/5.05_ID1662_772_0003.vol', '../data/5.05_ID1662_772_0004.vol'}, {'../data/5.05_ID1662_773_0001.vol', '../data/5.05_ID1662_773_0002.vol', '../data/5.05_ID1662_773_0003.vol', '../data/5.05_ID1662_773_0004.vol'}, {'../data/5.05_ID1684_806_0001.vol', '../data/5.05_ID1684_806_0002.vol', '../data/5.05_ID1684_806_0003.vol', '../data/5.05_ID1684_806_0004.vol'}, {'../data/5.05_ID1684_809_0001.vol', '../data/5.05_ID1684_809_0002.vol', '../data/5.05_ID1684_809_0003.vol', '../data/5.05_ID1684_809_0004.vol'}, {'../data/5.05_ID1689_805_0001.vol', '../data/5.05_ID1689_805_0002.vol', '../data/5.05_ID1689_805_0003.vol', '../data/5.05_ID1689_805_0004.vol'}, {'../data/5.05_ID1689_807_0001.vol', '../data/5.05_ID1689_807_0002.vol', '../data/5.05_ID1689_807_0003.vol', '../data/5.05_ID1689_807_0004.vol'}, {'../data/5.05_ID1689_808_0001.vol', '../data/5.05_ID1689_808_0002.vol', '../data/5.05_ID1689_808_0003.vol', '../data/5.05_ID1689_808_0004.vol'}};
scaleFactor = 2;

for ii = 1:length(fileGroups)
    fprintf('\nii: %d\n', ii)
    group = fileGroups{ii};
    endData = parseVolInfo(group{end});
    numZ = endData.NUM_Z;
    % vol = NaN*ones(2048, 2048, 256*3+numZ);
    groupInfo = cellfun(@parseVolInfo, group);
    numZ = sum(cell2mat({groupInfo.NUM_Z}));
    fname = group{1};
    vol = loadDataset(fname, 1:numZ);
    if any(isnan(vol))
        error('vol contains %d NaNs\n', sum(isnan(vol(:))))
    end
    [x1q, x2q, x3q] = ndgrid(linspace(1, size(vol, 1), size(vol, 1)/scaleFactor), linspace(1, size(vol, 2), size(vol, 2)/scaleFactor), linspace(1, size(vol, 3), size(vol, 3)/scaleFactor));
    newVol = interpn(vol, x1q, x2q, x3q);

    save(['../halfSizeData/' fname(9:end-9) '_v7.3_double.mat'], 'newVol', '-v7.3');
    newVol = uint8(256*newVol);
    save(['../halfSizeData/' fname(9:end-9) '_v7.3_uint8.mat'], 'newVol', '-v7.3');
end
