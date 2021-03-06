%% implantMask2SideImage: Covnert implant mask to image of the side of the implant.
% To improve: Rotate to match major axis
function img = implantMask2SideImage(mask)
    width = 1200;
    img = zeros(width, size(mask, 3));
    for ii = 1:size(mask, 3)
        [x, ~] = find(mask(:, :, ii));
        minX = min(x);
        maxX = max(x);
        img(minX:maxX, ii) = 1;
    end

end
