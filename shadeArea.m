function shadeArea( alphaMap, varargin )

if ~isempty(varargin)
    color = varargin{1};
else
    color = [1 0 0];
end
[r, c] = size(alphaMap);

colorMat = zeros(r, c, 3);
for ii = 1:3
    colorMat(:,:,ii) = color(ii);
end

hold on
h = imshow(colorMat);
set(h, 'alphadata', 0.25*alphaMap)


end

