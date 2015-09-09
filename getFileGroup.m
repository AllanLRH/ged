function fileGroup = getFileGroup(datafile)
    basename = datafile(1:end-8);
    fileGroup = glob([basename '*.vol']);
end
