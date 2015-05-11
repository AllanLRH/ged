function h = shadeLinker( img, mask, varargin )
%shadeLinker subplot with shaded and original image with linked axes

h = figure;
ha(1) = subplot(121);
imsc(img)
shadeArea(mask, [1 0 0]);
ha(2) = subplot(122);
if nargin > 2 && strcmp(varargin{1}, 'mask')
    imsc(mask)
else
    imsc(img)
end
linkaxes(ha, 'xy');
maximize

end
