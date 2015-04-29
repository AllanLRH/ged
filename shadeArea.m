function shadeArea( alphaMap, color, varargin )

if ~isempty(varargin)
    alpha = varargin{1};
else
    alpha = 0.08;
end
[r, c] = size(alphaMap);

colorMat = zeros(r, c, 3);
for ii = 1:3
    colorMat(:,:,ii) = color(ii);
end

hold on
h = imshow(colorMat);
set(h, 'alphadata', alpha*alphaMap)

end
