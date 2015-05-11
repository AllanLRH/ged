function intensity = intensityCurveFun( img, circ, N )
    %% Find implant
    lowThreshold = 0.6386;
    highThreshold = 0.7033;
    imp1 = lowThreshold < img & img < highThreshold;
    % Also fill the inner part of the implant
    se = strel('square', 30);
    imp2 = imclose(imp1, se);  % Make implant solid
    imp3 = imopen(imp2, se);  % Remote white dots inside/outside implant circle
    imp4 = bwfill(imp3, 'holes');  % Fill the middle of the implant in case it's not

    %% Find image intensity curve
    dm = abs(sgnDstFromImg(img));
    dmMin = min(dm(:));
    dmMax = max(dm(:));
    distVals = linspace(dmMin, dmMax, N);
    distDelta = distVals(2) - distVals(1);
    intensity = zeros(1, N);
    for ii = 1:N
        distVal = distVals(ii);
        distMask = (dm > distVal-0.5*distDelta) & (dm < distVal+0.5*distDelta);
        distMask = logical(distMask .* ~imp4 .* circ);
        intensity(ii) = mean(mean(img(distMask)));
    end

end

