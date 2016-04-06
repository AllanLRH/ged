clear; close all; home

dataPath = '../smallData/';
dirInfo = dir(fullfile(dataPath, '*.mat'));
dirNames = {dirInfo.name};

load(fullfile(dataPath, dirNames{3}))
whos

% x3RegionOfInterest, minSlice, maxSlice, bone, cavity, neither, distances


%%

for ii = 1:3
    for jj = 1:7
        f1 = fractions{ii, jj};
        dd = f1{1};
        [x1, x2, x3] = ndgrid(linspace(1, size(dd, 1), size(dd, 1)/4), ...
                              linspace(1, size(dd, 2), size(dd, 2)/4), ...
                              linspace(1, size(dd, 3), size(dd, 3)/4));
        x3d = interpn(single(dd), x1, x2, x3);
        figure;
        isosurface(x3d > 0.5)
        title(sprintf('ii, jj = %d, %d', ii, jj))
        drawnow
    end
end

%% Plot the fractions
% First index is vertical regions
% Second index is radial regions: x3RegionOfInterest, minSlice, maxSlice, bone, cavity, neither, distances
[rows, cols] = size(fractions);
for r = 1:rows
    for c = 1:cols
        figure
        hold on
        plot(fractions{r, c}{7}, fractions{r, c}{4})
        plot(fractions{r, c}{7}, fractions{r, c}{5})
        plot(fractions{r, c}{7}, fractions{r, c}{6})
        legend('bone', 'cavity', 'neither')
        title(sprintf('r,c = %d, %d', r, c))
        hold off
        drawnow
    end
end

%% Print min and max slice
[rows, cols] = size(fractions);
for c = 1:cols
    for r = 1:rows
        fprintf('Vertical: %d\t', r)
        fprintf('MinSlice, maxSlice: %.0f, %.0f\n', fractions{r,c}{2}, fractions{r,c}{3})
    end
end



%%
for ii = 1:3
    figure
    for jj = 1:10:250
        hold on;
        imsc(fractions{ii}{1}(:,:,jj));
        title(sprintf('%d: %d', ii, jj));
        pause(0.1)
        drawnow;
        hold off
    end
    pause(0.4)
end

