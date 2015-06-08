%% getFileGroups: Get a cell array with cell arrays of file pairs
function fileGroups = getFileGroups(folderPath)
    % Get list of info files
    if strcmp(folderPath(end), '/')
        cont = dir([folderPath '*.vol.info']);
    else
        cont = dir([folderPath '/*.vol.info']);
    end
    cont = {cont.name};
    % Preallocate
    fileGroups = cell(0);
    temp = cell(0);
    for ii = 1:length(cont)
        fileInfo = parseVolInfo(cont{ii});
        temp{length(temp)+1} = cont{ii};  % Append to temp
        if fileInfo.NUM_Z ~= 256
            fileGroups{length(fileGroups)+1} = temp;  % Write temp to fileGroups
            temp = cell(0);  % Make new empty temp
        end
    end
    fileGroups{length(fileGroups)+1} = temp;  % Write the last temp info fileGroups

end
