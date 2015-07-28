function varargout = imsc(in, varargin)
    subaxis(1, 1, 1, 'Spacing', 0.0, 'PaddingTop', 0.06, 'Margin', 0.01);
    h = imagesc(in);
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
    if nargout == 1
        varargout{1} = h;
    end
end
