(vol, histologyImage, xyz, sigma, crop, planeNormal, angles, zAxisFactor)
    % sigma = 10;
    % crop = [-11.8688, 397.5750, 91.9780, 418.7880];
    x = xyz;
    n = planeNormal;
    r1 = crop(1);
    r2 = crop(2);
    c1 = crop(3);
    c2 = crop(4);

    imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
    [r, c]=ndgrid(linspace(r1, r2, size(imslice, 1)), linspace(c1, c2, size(imslice, 2)), NaN);
    % tmp = interpn(histologyImage, r, c);
    % imDiff = imslice-tmp;
    %figure(2); imagesc(imDiff); colormap(gray); drawnow; figure(1);
    % figure(2); imshowpair(imslice, tmp); colormap(gray); drawnow; figure(1);

    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    %     Outer minimization routine    %
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    for ii = 1:10
        imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
        d = 1000;  % Step size for minimization function
        v = imDifference(histologyImage, imsliceSmoothed, sigma, crop)
        for jj = 1:100  % This is the cropping part
            % Gradient components
            v1 = imDifference(histologyImage, imsliceSmoothed, sigma, crop+[1, 0, 0, 0]) - v;
            v2 = imDifference(histologyImage, imsliceSmoothed, sigma, crop+[0, 1, 0, 0]) - v;
            v3 = imDifference(histologyImage, imsliceSmoothed, sigma, crop+[0, 0, 1, 0]) - v;
            v4 = imDifference(histologyImage, imsliceSmoothed, sigma, crop+[0, 0, 0, 1]) - v;

            cropTest = crop - d*[v1, v2, v3, v4];
            vTest = imDifference(histologyImage, imsliceSmoothed, sigma, cropTest);
            while (vTest > v) && (d > 0.0000001)
                d = d/10;
                cropTest = crop-d*[v1, v2, v3, v4];
                vTest = imDifference(histologyImage, imsliceSmoothed, sigma, cropTest);
            end
            if vTest < v
                crop = cropTest;
                v = vTest
            else
                break;
            end
        end

        d = 10;
        imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
        imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
        v = imDifference(histologyImage, imsliceSmoothed, sigma, crop)

        for jj = 1:100
            % plane normal vector ORIGO adjustments
            imslice = extractSlice(vol, x(1)+1, x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v1 = imDifference(histologyImage, imsliceSmoothed, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2)+1, x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v2 = imDifference(histologyImage, imsliceSmoothed, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2), x(3)+1, n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v3 = imDifference(histologyImage, imsliceSmoothed, sigma, crop) - v;

            % plane normal vector adjustments
            imslice = extractSlice(vol, x(1), x(2), x(3), n(1)+1, n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v4 = imDifference(histologyImage, imsliceSmoothed, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2)+1, n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v5 = imDifference(histologyImage, imsliceSmoothed, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3)+1, max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v6 = imDifference(histologyImage, imsliceSmoothed, sigma, crop) - v;

            % Adjustment of z-axis, required to obtain rotation in imageslice-plane
            imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles+[0, 0, 1]);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v7 = imDifference(histologyImage, imsliceSmoothed, sigma, crop) - v;

            xTest = x - d*[v1, v2, v3];
            nTest = n - d*[v4, v5, v6];
            aTest = angles - d*[0, 0, v7];
            imslice = extractSlice(vol, xTest(1), xTest(2), xTest(3), nTest(1), nTest(2), nTest(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, aTest);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            vTest = imDifference(histologyImage, imsliceSmoothed, sigma, crop);
            while(vTest > v)
                d = d/10;
                xTest = x - d*[v1, v2, v3];
                nTest = n - d*[v4, v5, v6];
                aTest = angles - d*[0, 0, v7];
                imslice = extractSlice(vol, xTest(1), xTest(2), xTest(3), nTest(1), nTest(2), nTest(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, aTest);
                imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
                vTest = imDifference(histologyImage, imsliceSmoothed, sigma, crop);
            end
            if(vTest < v)
                x = xTest;
                n = nTest;
                angles = aTest;
                v = vTest
            else
                break;
            end
        end

        %param = fminunc(@(p) imDifference(histologyImage, imsliceSmoothed, sigma, p), param);
        r1 = crop(1);
        r2 = crop(2);
        c1 = crop(3);
        c2 = crop(4);

        imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
        % [r, c]=ndgrid(linspace(r1, r2, size(imslice, 1)), linspace(c1, c2, size(imslice, 2)), NaN);
        % tmp = interpn(double(histologyImage), r, c);
        % imDiff = imslice-tmp;
        %figure(2); imagesc(imDiff); colormap(gray); drawnow; figure(1);
        % figure(2); imshowpair(imslice, tmp); colormap(gray); drawnow; figure(1);
    end
end
