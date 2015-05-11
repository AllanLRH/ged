function h = shadeLinker( img, mask, varargin )
%shadeLinker subplot with shaded and original image with linked axes

h = figure;
maskColor = [0 0 1];
if nargin > 2  % Non-default behaviour
    if strcmpi(varargin{1}, 'imgAndMask')  % Plot mask left, image right
        ha(1) = subplot(121);
        imsc(mask)
        ha(2) = subplot(122);
        imsc(img)
    elseif strcmpi(varargin{1}, 'shadeAndMask')  % Plot shaded image left, image right
        ha(1) = subplot(121);
        imsc(img)
        shadeArea(mask, maskColor);
        ha(2) = subplot(122);
        imsc(mask)
    end
else  % Default behaviour: Plot shaded image left, image right
    ha(1) = subplot(121);
    imsc(img)
    shadeArea(mask, maskColor);
    ha(2) = subplot(122);
    imsc(img)
end

linkaxes(ha, 'xy');
maximize

end


