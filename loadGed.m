function imageData = loadGed(imageName, varargin)
%LOADGED Loads image
%   imageName is the data file
%   Optional argument 1 is selected range of images (vector, counting from 1)
%   Optional argument 2 is data formatting string

% Extract arguments
idx = 0;
if ~isempty(varargin) && isnumeric(varargin{1})
    idx = varargin{1};
end

if ~isempty(varargin)
    if ischar(varargin{1})
        formatString = varargin{1};
    elseif length(varargin) == 2 && ischar(varargin{2})
        formatString = varargin{2};
    else
        formatString = 'float=>double';
    end
end

% Open image and preallocate
fid = fopen(imageName, 'r');
if fid < 1
    error(['File did not load correctly! ' imageName])
end
dims = [2048 2048];
imageData = zeros([2048 2048 length(idx)]);

% Load image
if idx(1) > 0
    cnt = 1;
    for i = idx
        fseek(fid, (prod(dims))^2*i-1, 'bof');
        imageData(:, :, cnt) = reshape(fread(fid, prod(dims), formatString), dims);
        cnt = cnt + 1;
    end
else
    imageData = reshape(fread(fid, prod(dims), formatString), dims);
end

% close image file
fclose(fid);

end

