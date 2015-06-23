filenames = {'5.05_ID1662_770_0001.vol', '5.05_ID1662_771_0001.vol', '5.05_ID1662_772_0001.vol', ...
             '5.05_ID1662_773_0001.vol', '5.05_ID1684_806_0001.vol', '5.05_ID1684_809_0001.vol', ...
             '5.05_ID1689_805_0001.vol', '5.05_ID1689_807_0001.vol', '5.05_ID1689_808_0001.vol'};

for ii = 1:length(filenames)
    img = 255*normImage(loadGed(['data/' filenames{ii}], 1));
    imwrite(img, ['firstImageInStack/' filenames{ii} '.tiff']);
end
