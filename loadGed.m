
function imageData = loadGed(imageName, varargin)
%LOADGED Loads image
%   imageName is the data file
%   Optional argument 1 is selected range of images (vector, counting from 1)
%   Optional argument 2 is data formatting string

% Extract arguments
fileInfo = parseVolInfo(imageName);
idx = 1;
if ~isempty(varargin) && isnumeric(varargin{1})
    idx = varargin{1};
    if any(idx > fileInfo.NUM_Z)
        pos = find(idx > fileInfo.NUM_Z);
        error('Can''t load slice %d from file %s', pos, imageName)
    end
end

formatString = 'float=>double';
if ~isempty(varargin)
    if ischar(varargin{1})
        formatString = varargin{1};
    elseif length(varargin) == 2 && ischar(varargin{2})
        formatString = varargin{2};
    end
end

% Open image and preallocate
fid = fopen(imageName, 'r');
if fid == -1
    error(['File did not load correctly! ' imageName])
end
dims = [fileInfo.NUM_X, fileInfo.NUM_Y length(idx)];
imageData = zeros(dims);

% Load image
cnt = 1;
for i = idx
    fseek(fid, 4*(prod(dims(1:2)))*(i-1), 'bof');
    imageData(:, :, cnt) = reshape(fread(fid, prod(dims(1:2)), formatString), dims(1:2));
    cnt = cnt + 1;
end

% close image file
fclose(fid);

end

