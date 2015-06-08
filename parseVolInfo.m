%% parseVolInfo: Get information from .vol.info files as a struct
function infoStruct = parseVolInfo(filename)
    if ~strcmp(strtrim(filename(end-4:end)), '.info')
        filename = [filename '.info'];
    end
    fid = fopen(filename);
    if fid > 0
        infoStruct = struct;
        fgetl(fid);  % Throw away first line
        for ii = 1:3
            rawText = fgetl(fid);
            lineValues = cellfun(@strtrim, strsplit(rawText, '='), 'uniformOutput', false);
            infoStruct.(lineValues{1}) = str2num(lineValues{2});
        end
    else
        error('Could not open info file for filename %s', filename)
    end

end
