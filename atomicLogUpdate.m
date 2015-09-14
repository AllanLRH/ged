function atomicLogUpdate(fid, baseFilename, message)
    %atomicLogUpdate(fid, baseFilename, message)
    % By writing to an open "temporary" file, and copying that file to the "real" logfile on every save, the save is atomic
    % and hopefulle protected from crashes.
    %
    % fid: A file handle in append ('a') mode to the "temporary" logfile. The name of the file should be [baseFilename '_temp.txt']
    % baseFilename: The filename of the log, without the '.txt'-extension (full filename should be [baseFilename '.txt'])
    % message: The line to be written into the log.
    %
    fprintf(fid, [message '\n']);
    copyfile([baseFilename '_temp.txt'], [baseFilename '.txt'])
end
