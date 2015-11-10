function [x, crop, n, angles] = alignImages(vol, histologyImage, zAxisFactor, sigma, x, crop, n, angles, makeFigures)
    % sigma = 10;
    % crop = [-11.8688, 397.5750, 91.9780, 418.7880];
    a = angles(3);
    
    imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);

    if (makeFigures)
     [r, c]=ndgrid(linspace(crop(1), crop(2), size(imslice, 1)), linspace(crop(3), crop(4), size(imslice, 2)));
     tmp = interpn(histologyImage, r, c);
     imDiff = imslice-tmp;

     figure(2); imagesc(imDiff); title('Initial'); colormap(gray); drawnow;
     figure(3); imshowpair(imslice, tmp); title('Initial'); colormap(gray); drawnow;
    end
    
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    %     Outer minimization routine    %
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    for ii = 1:10
        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        %     We minimize difference by cropping histologyImage       %
        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
        d = 1000;  % Step size for minimization function
        v = imDifference(imsliceSmoothed, histologyImage, sigma, crop)
        for jj = 1:100  % This is the cropping part
            % Gradient components
            v1 = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[1, 0, 0, 0]) - v;
            v2 = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[0, 1, 0, 0]) - v;
            v3 = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[0, 0, 1, 0]) - v;
            v4 = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[0, 0, 0, 1]) - v;

            cropTest = crop - d*[v1, v2, v3, v4];
            vTest = imDifference(imsliceSmoothed, histologyImage, sigma, cropTest);
            while (vTest > v) && (d > 0.0000001)
                d = d/10;
                cropTest = crop-d*[v1, v2, v3, v4];
                vTest = imDifference(imsliceSmoothed, histologyImage, sigma, cropTest);
            end
            if vTest < v
                crop = cropTest;
                v = vTest;
            else
                break;
            end
        end
        if (showFigures)
            [r, c]=ndgrid(linspace(crop(1), crop(2), size(imslice, 1)), linspace(crop(3), crop(4), size(imslice, 2)));
            tmp = interpn(double(histologyImage), r, c, NaN);
            imDiff = imslice-tmp;
            figure(2); imagesc(imDiff); title('Cropping'); colormap(gray); drawnow;
            figure(3); imshowpair(imslice, tmp); title('Cropping'); colormap(gray); drawnow;
        end

        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        %     We minimize difference by rotation and location of slicing  %
        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        d = 10;
        %   imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
        %   imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
        % The current value of v is that which correspond to the current
        % value of crop, so we don't need to recalculate v.
        %    v = imDifference(imsliceSmoothed, histologyImage, sigma, crop)

        f = @(delta) imDifference(-imgaussfilt(normImage(extractSlice(vol, delta(1), delta(2), delta(3), delta(4), delta(5), delta(6), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, [0,0,delta(7)])), sigma), histologyImage, sigma, crop) - v;
        for jj = 1:100
            % plane normal vector ORIGO adjustments
            for kk = 1:7
                delta = zeros(7,1);
                delta(kk) = 1;
                v(kk) = f([x,n,a]+delta);
            end
            %{
            imslice = extractSlice(vol, x(1)+1, x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v1 = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2)+1, x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v2 = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2), x(3)+1, n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v3 = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;

            % plane normal vector adjustments
            imslice = extractSlice(vol, x(1), x(2), x(3), n(1)+1, n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v4 = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2)+1, n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v5 = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;

            imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3)+1, max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v6 = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;

            % Adjustment of z-axis, required to obtain rotation in imageslice-plane
            imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles+[0, 0, 1]);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            v7 = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;

            xTest = x - d*[v1, v2, v3];
            nTest = n - d*[v4, v5, v6];
            aTest = angles - d*[0, 0, v7];

            imslice = extractSlice(vol, xTest(1), xTest(2), xTest(3), nTest(1), nTest(2), nTest(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, aTest);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            vTest = imDifference(imsliceSmoothed, histologyImage, sigma, crop);
            %}
            deltaTest = [x,n,a] - d*v;
            vTest = f(deltaTest);
            while (vTest > v) && (d > 0.0000001)
                d = d/10;
                %{
                xTest = x - d*[v1, v2, v3];
                nTest = n - d*[v4, v5, v6];
                aTest = angles - d*[0, 0, v7];
                imslice = extractSlice(vol, xTest(1), xTest(2), xTest(3), nTest(1), nTest(2), nTest(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, aTest);
                imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
                vTest = imDifference(imsliceSmoothed, histologyImage, sigma, crop);
                %}
                deltaTest = [x,n,a] - d*v;
                vTest = f(deltaTest);
            end
            if(vTest < v)
                %{
                x = xTest;
                n = nTest;
                angles = aTest;
                %}
                x = deltaTest(1:3);
                n = deltaTest(4:6);
                a = deltaTest(7);
                v = vTest
            else
                break;
            end
        end
        
        angles(3) = a;
        %param = fminunc(@(p) imDifference(imsliceSmoothed, histologyImage, sigma, p), param);
        imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
        % r1 = crop(1);
        % r2 = crop(2);
        % c1 = crop(3);
        % c2 = crop(4);
        if (showFigures)
            [r, c]=ndgrid(linspace(crop(1), crop(2), size(imslice, 1)), linspace(crop(3), crop(4), size(imslice, 2)));
            tmp = interpn(double(histologyImage), r, c, NaN);
            imDiff = imslice-tmp;
            figure(2); imagesc(imDiff); title('Slicing'); colormap(gray); drawnow;
            figure(3); imshowpair(imslice, tmp); title('Slicing'); colormap(gray); drawnow;
        end
    end
end
