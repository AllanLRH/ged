function [x, crop, n, angles] = alignImages(vol, histologyImage, zAxisFactor, sigma, x, crop, n, angles, makeFigures)
    % sigma = 10;
    % crop = [-11.8688, 397.5750, 91.9780, 418.7880];

    imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);

    if (makeFigures)
        [r, c]=ndgrid(linspace(crop(1), crop(2), size(imslice, 1)), linspace(crop(3), crop(4), size(imslice, 2)));
        tmp = interpn(histologyImage, r, c, 'linear', NaN);
        imDiff = imslice-tmp;

        figure(3); imagesc(imDiff); title('Initial'); colormap(gray); drawnow;
        figure(4); imshowpair(imslice, tmp); title('Initial'); colormap(gray); drawnow;
        print('-dpng', ['camillaFigures/fig_' num2str(0) '.png'], '-r300');
    end

    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    %     Outer minimization routine    %
    %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
    sigma = 1.05*sigma;
    for ii = 1:30
        sigma = sigma/1.05;
        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        %     We minimize difference by cropping histologyImage       %
        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
        d = 1000;  % Step size for minimization function
        v = imDifference(imsliceSmoothed, histologyImage, sigma, crop)
        for jj = 1:100  % This is the cropping part
            % Gradient components
            dv = [];
            dv(1) = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[1, 0, 0, 0]) - v;
            dv(2) = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[0, 1, 0, 0]) - v;
            dv(3) = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[0, 0, 1, 0]) - v;
            dv(4) = imDifference(imsliceSmoothed, histologyImage, sigma, crop+[0, 0, 0, 1]) - v;

            cropTest = crop - d*dv;
            vTest = imDifference(imsliceSmoothed, histologyImage, sigma, cropTest);
            while (vTest > v) && (d > 0.0000001)
                d = d/10;
                cropTest = crop-d*dv;
                vTest = imDifference(imsliceSmoothed, histologyImage, sigma, cropTest);
            end
            if vTest < v
                crop = cropTest;
                v = vTest
            else
                break;
            end
        end
        if (makeFigures)
            [r, c]=ndgrid(linspace(crop(1), crop(2), size(imslice, 1)), linspace(crop(3), crop(4), size(imslice, 2)));
            tmp = interpn(double(histologyImage), r, c, 'linear', NaN);
            imDiff = imslice-tmp;
            figure(3); imagesc(imDiff); title('Cropping'); colormap(gray); drawnow;
            figure(4); imshowpair(imslice, tmp); title('Cropping'); colormap(gray); drawnow;
            print('-dpng', ['camillaFigures/fig_' num2str(ii) '_A.png'], '-r300');
        end

        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        %     We minimize difference by rotation and location of slicing  %
        %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
        d = 10;
        % The current value of v is that which correspond to the current
        % value of crop, so we don't need to recalculate v.
        %    v = imDifference(imsliceSmoothed, histologyImage, sigma, crop)

        for jj = 1:100
            % plane normal vector ORIGO adjustments

            v1 = dImDifference(v, vol, histologyImage, crop, sigma, x+[1,0,0], n, zAxisFactor, angles);
            v2 = dImDifference(v, vol, histologyImage, crop, sigma, x+[0,1,0], n, zAxisFactor, angles);
            v3 = dImDifference(v, vol, histologyImage, crop, sigma, x+[0,0,1], n, zAxisFactor, angles);

            % plane normal vector adjustments
            v4 = dImDifference(v, vol, histologyImage, crop, sigma, x, n+[1,0,0], zAxisFactor, angles);
            v5 = dImDifference(v, vol, histologyImage, crop, sigma, x, n+[0,1,0], zAxisFactor, angles);
            v6 = dImDifference(v, vol, histologyImage, crop, sigma, x, n+[0,0,1], zAxisFactor, angles);

            % Adjustment of z-axis, required to obtain rotation in imageslice-plane
            v7 = dImDifference(v, vol, histologyImage, crop, sigma, x, n, zAxisFactor, angles+[0,0,1]);

            xTest = x - d*[v1, v2, v3];
            nTest = n - d*[v4, v5, v6];
            aTest = angles - d*[0, 0, v7];

            imslice = extractSlice(vol, xTest(1), xTest(2), xTest(3), nTest(1), nTest(2), nTest(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, aTest);
            imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
            vTest = imDifference(imsliceSmoothed, histologyImage, sigma, crop);
            while (vTest > v) && (d > 0.0000001)
                d = d/10;

                xTest = x - d*[v1, v2, v3];
                nTest = n - d*[v4, v5, v6];
                aTest = angles - d*[0, 0, v7];
                imslice = extractSlice(vol, xTest(1), xTest(2), xTest(3), nTest(1), nTest(2), nTest(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, aTest);
                imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
                vTest = imDifference(imsliceSmoothed, histologyImage, sigma, crop);
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

        %param = fminunc(@(p) imDifference(imsliceSmoothed, histologyImage, sigma, p), param);
        imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
        if (makeFigures)
            [r, c]=ndgrid(linspace(crop(1), crop(2), size(imslice, 1)), linspace(crop(3), crop(4), size(imslice, 2)));
            tmp = interpn(double(histologyImage), r, c, 'linear', NaN);
            imDiff = imslice-tmp;
            figure(3); imagesc(imDiff); title('Slicing'); colormap(gray); drawnow;
            figure(4); imshowpair(imslice, tmp); title('Slicing'); colormap(gray); drawnow;
            print('-dpng', ['camillaFigures/fig_' num2str(ii) '_B.png'], '-r300');
        end
    end
end

function dv = dImDifference(v, vol, histologyImage, crop, sigma, x, n, zAxisFactor, angles)
    imslice = extractSlice(vol, x(1), x(2), x(3), n(1), n(2), n(3), max([size(vol, 1), size(vol, 2)])/2, zAxisFactor, angles);
    imsliceSmoothed = -imgaussfilt(normImage(imslice), sigma);
    dv = imDifference(imsliceSmoothed, histologyImage, sigma, crop) - v;
end
