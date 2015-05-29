function varargout = shadeLinker( img, mask, varargin )
%shadeLinker subplot with shaded and original image with linked axes

h = figure;
maskColor = [0 0 1];
if nargin > 2  % Non-default behaviour
    if strcmpi(varargin{1}, 'imgAndMask') || strcmpi(varargin{1}, 'maskAndImg')  % Plot mask left, image right
        % ha(1) = subplot(121);
        ha(1) = subaxis(1, 2, 1, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0.01);
        imsc(img)
        set(gca, 'LooseInset', [0,0,0,0]);
        % ha(2) = subplot(122);
        ha(2) = subaxis(1, 2, 2, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0.01);
        imsc(mask)
        set(gca, 'LooseInset', [0,0,0,0]);
    elseif strcmpi(varargin{1}, 'shadeAndMask') || strcmpi(varargin{1}, 'maskAndShade')  % Plot shaded image left, image right
        % ha(1) = subplot(121);
        ha(1) = subaxis(1, 2, 1, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0.01);
        imsc(img)
        set(gca, 'LooseInset', [0,0,0,0]);
        shadeArea(mask, maskColor);
        % ha(2) = subplot(122);
        ha(2) = subaxis(1, 2, 2, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0.01);
        imsc(mask)
        set(gca, 'LooseInset', [0,0,0,0]);
    end
else  % Default behaviour: Plot shaded image left, image right
    % ha(1) = subplot(121);
    ha(1) = subaxis(1, 2, 1, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0.01);
    imsc(img)
    set(gca, 'LooseInset', [0,0,0,0]);
    shadeArea(mask, maskColor);
    % ha(2) = subplot(122);
    ha(2) = subaxis(1, 2, 2, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0.01);
    imsc(img)
    set(gca, 'LooseInset', [0,0,0,0]);
end

if nargout == 1
    varargout{1} = h;
end

linkaxes(ha, 'xy');
maximize

end



