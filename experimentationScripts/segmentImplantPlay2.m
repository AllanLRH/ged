%% Load image, fit histogram of selected data and create masks

clear; close all;
makeDebugPlots = true;
for ii = [1 7 12 20 40 75 100 150 200 215 256 290 320 360 367 380 400 550 750 900 950 980 988 992 996 997 998 999 1000]
%%
% ii = 200;
im = normImage(loadDataset('../data/5.05_ID1662_770_0001.vol', ii));
imMed = medfilt2(im, [6 6]);
circ1 = makeCircle(size(im, 1), round(0.2*size(im, 1)), size(im)/2);
[cnt, xax] = hist(imMed(circ1), 100);
% Set up fittype and options.
ft = fittype('gauss2');
% ft = fittype( '1/((70*(x-a))^2 + 1)  + c/((70*(x-b))^2 + 1)', 'independent', 'x', 'dependent', 'y' );  % Normalize data to do this
opts = fitoptions('Method', 'NonlinearLeastSquares');
opts.Display = 'Off';
opts.Robust = 'LAR';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
% opts.StartPoint = [0.8*max(cnt(:)) 0.35 0.028 0.8*max(cnt(:)) 0.53 0.037];
% Fit model to data.
[fitresult, gof] = fit(xax', cnt', ft, opts);
% Select the parameters with the largest mu
[mu, maxMuIdx] = max([fitresult.b1 fitresult.b2]);
sigma = [fitresult.c1 fitresult.c2]; sigma = sigma(maxMuIdx);

% Plot fit
if makeDebugPlots
    figure
    plot(fitresult, xax, cnt)
    title(sprintf('ii: %d, RMSE: %.f', ii, gof.rmse))
    disp(ii)
    disp(gof)
end

if fitresult.rmse > 3500
    warning('RMSE is %.2f for ii %d', gof.rmse, ii)
end

% Use mean and standard deviation to find implant
msk0 = imMed > (mu - 2.2*sigma) & imMed < (mu + 2.2*sigma);
% Do morphology to clean up Mask
msk1 = imdilate(msk0, strel('disk', round(size(im, 1)/200)));
msk2 = imerode(msk1, strel('disk', round(size(im, 1)/120)));
msk3 = imdilate(msk2, strel('disk', round(size(im, 1)/220)));
msk4 = imfill(msk3, 'holes');
% Find object with largest area
area = regionprops(msk4, 'area'); area = cell2mat({area.Area});
[~, maxAreaIdx] = max(area);
% find centroid for that object
centroid = regionprops(msk4, 'centroid'); centroid = centroid(maxAreaIdx);
centroid = cell2mat({centroid.Centroid});
% Find bounding box for that object
boundingBox = regionprops(msk4, 'boundingBox'); boundingBox = boundingBox(maxAreaIdx);
boundingBox = cell2mat({boundingBox.BoundingBox});
% Coordinates in form [x y w h]
radius = round(max(boundingBox(3:4))/2);
circ2 = makeCircle(size(im, 1), radius, centroid);
msk5 = msk4 .* circ2;

%% Plot the steps above
if makeDebugPlots
    figure; maximize, pause(0.7)
    subplot(231)
    imsc(im)
    shadeArea(msk0, [1 0 0], 0.3)
    shadeArea(msk1.*not(msk0), [1 1 0], 0.3)
    title('msk0 (R) -> msk1 (Y)'); drawnow;
    subplot(232)
    imsc(im)
    shadeArea(msk2, [1 0 0], 0.3)
    title('msk2'); drawnow;
    subplot(233)
    imsc(im)
    shadeArea(msk3, [1 0 0], 0.3)
    title('msk3'); drawnow;
    subplot(234)
    imsc(im)
    shadeArea(msk4, [1 0 0], 0.3)
    title('msk4'); drawnow;
    subplot(235)
    imsc(im)
    shadeArea(xor(msk4, circ2), [0 1 1], 0.25)
    title('xor(msk4, circ2)'); drawnow;
    subplot(236)
    imsc(im)
    shadeArea(msk5, [1 0 0], 0.3)
    title('msk5 (final, "msk4 .* circ2"'); drawnow;
    userinput = 'halted';
    while strcmp(userinput, 'halted')
        userinput = input('Press enter to continue');
    end
    close all
end

%%
end

