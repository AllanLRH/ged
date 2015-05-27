function varargout = shadeLinker( img, mask, varargin )
%shadeLinker subplot with shaded and original image with linked axes

h = figure;
maskColor = [0 0 1];
if nargin > 2  % Non-default behaviour
    if strcmpi(varargin{1}, 'imgAndMask') || strcmpi(varargin{1}, 'maskAndImg')  % Plot mask left, image right
        ha(1) = subplot(121);
        imsc(img)
        ha(2) = subplot(122);
        imsc(mask)
    elseif strcmpi(varargin{1}, 'shadeAndMask') || strcmpi(varargin{1}, 'maskAndShade')  % Plot shaded image left, image right
        ha(1) = subplot(121);
        imsc(img)
        ha(2) = subplot(122);
        imsc(img)
        shadeArea(mask, maskColor);
    end
else  % Default behaviour: Plot shaded image left, image right
    ha(1) = subplot(121);
    imsc(img)
    shadeArea(mask, maskColor);
    ha(2) = subplot(122);
    imsc(img)
end

if nargout == 1
    varargout{1} = h;
end

linkaxes(ha, 'xy');
maximize

end



