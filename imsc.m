function imsc(in, varargin)
    imagesc(in);
    colormap gray;
    axis image tight off
    for ii = 1:length(varargin)
        if strcmpi(varargin{ii}, 'colormap')
            colormap(varargin{ii+1});
        elseif strcmpi(varargin{ii}, 'title')
            title(varargin{ii+1});
        elseif strcmpi(varargin{ii}, 'axis')
            eval(['axis ' varargin{ii+1}]);
        elseif strcmpi(varargin{ii}, 'colorbar')
            colorbar;
        end
    end
end
