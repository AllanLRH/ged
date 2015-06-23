    %% getFileGroups: Get a cell array with cell arrays of file pairs
function fileGroups = getFileGroups(folderPath)
    % Get list of info files
    if exist(folderPath, 'dir') ~= 7
        error('Specied folder does not exist. folder specified was %s', folderPath)
    end
    if strcmp(folderPath(end), '/')
        cont = dir([folderPath '*.vol.info']);
    else
        cont = dir([folderPath '/*.vol.info']);
    end
    cont = {cont.name};
    if strcmp(folderPath(end), '/')
        cont = strcat(folderPath, cont);
    else
        cont = strcat([folderPath '/'], cont);
    end
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
