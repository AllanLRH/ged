clear; home; close all;

fileGroups = {{'../data/5.05_ID1662_769_0001.vol', '../data/5.05_ID1662_769_0002.vol', '../data/5.05_ID1662_769_0003.vol', '../data/5.05_ID1662_769_0004.vol'}, {'../data/5.05_ID1662_770_0001.vol', '../data/5.05_ID1662_770_0002.vol', '../data/5.05_ID1662_770_0003.vol', '../data/5.05_ID1662_770_0004.vol'}, {'../data/5.05_ID1662_771_0001.vol', '../data/5.05_ID1662_771_0002.vol', '../data/5.05_ID1662_771_0003.vol', '../data/5.05_ID1662_771_0004.vol'}, {'../data/5.05_ID1662_772_0001.vol', '../data/5.05_ID1662_772_0002.vol', '../data/5.05_ID1662_772_0003.vol', '../data/5.05_ID1662_772_0004.vol'}, {'../data/5.05_ID1662_773_0001.vol', '../data/5.05_ID1662_773_0002.vol', '../data/5.05_ID1662_773_0003.vol', '../data/5.05_ID1662_773_0004.vol'}, {'../data/5.05_ID1684_806_0001.vol', '../data/5.05_ID1684_806_0002.vol', '../data/5.05_ID1684_806_0003.vol', '../data/5.05_ID1684_806_0004.vol'}, {'../data/5.05_ID1684_809_0001.vol', '../data/5.05_ID1684_809_0002.vol', '../data/5.05_ID1684_809_0003.vol', '../data/5.05_ID1684_809_0004.vol'}, {'../data/5.05_ID1689_805_0001.vol', '../data/5.05_ID1689_805_0002.vol', '../data/5.05_ID1689_805_0003.vol', '../data/5.05_ID1689_805_0004.vol'}, {'../data/5.05_ID1689_807_0001.vol', '../data/5.05_ID1689_807_0002.vol', '../data/5.05_ID1689_807_0003.vol', '../data/5.05_ID1689_807_0004.vol'}, {'../data/5.05_ID1689_808_0001.vol', '../data/5.05_ID1689_808_0002.vol', '../data/5.05_ID1689_808_0003.vol', '../data/5.05_ID1689_808_0004.vol'}};

for ii = 1:length(fileGroups)
    disp('ii')
    disp(ii)
    group = fileGroups{ii};
    endData = parseVolInfo(group{end});
    numZ = endData.NUM_Z;
    vol = NaN*ones(2048, 2048, (256*(length(group) - 1) + numZ));
    for jj = 1:(length(group)-1)
        disp('jj')
        disp(jj)
        tempVol = loadGed(group{jj}, 1:256);
        % d(:, :, 1:size(b,3)) = b
        vol(:, :, (256*(jj-1)+1) : (256*jj)) = tempVol;
    end
    vol(:, :, (jj*256+1):size(vol,3)) = loadGed(group{jj+1}, 1:numZ);
    if any(isnan(vol))
        error('vol contains %d NaNs\n', sum(isnan(vol)))
    end
    newVol = imresize(vol, 1/4);
    name = group{1}
    save(['../smallData/' name(9:end-9) '_v6_double.mat'], 'newVol', '-v6');
    save(['../smallData/' name(9:end-9) '_v7.3_double.mat'], 'newVol', '-v7.3');
    newVol = uint8(256*normImage(newVol));
    save(['../smallData/' name(9:end-9) '_v6_uint8.mat'], 'newVol', '-v6');
    save(['../smallData/' name(9:end-9) '_v7.3_uint8.mat'], 'newVol', '-v7.3');
end
