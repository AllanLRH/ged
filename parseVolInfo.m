%% parseVolInfo: Get information from .vol.info files as a struct
function infoStruct = parseVolInfo(filename)
    if ~strcmp(strtrim(filename(end-4:end)), '.info')
        filename = [filename '.info'];
    end
    fid = fopen(filename);
    if fid > 0
        infoStruct = struct;
        fgetl(fid);  % Throw away first line
        for ii = 1:4
            rawText = fgetl(fid);  %  get line
            %  split at '=' info cell array
            lineValues = cellfun(@strtrim, strsplit(rawText, '='), 'uniformOutput', false);
            if any(isletter(lineValues{2}))  % the value of the key-value pair is not a number
                infoStruct.(lineValues{1}) = lineValues{2};
            else
                infoStruct.(lineValues{1}) = str2num(lineValues{2});
            end
        end
    else  % File didn't open correctly
        error('Could not open info file for filename %s', filename)
    end

end
