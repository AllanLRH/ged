clear; close all; clc
SMALLDATA = true;
SHOWRESULT = false;
SAVERESULT = true;
%nRadiiRegionPoints = 25;
% radiiRegionBorders = [50, 150, 250, 350, 900, 1000];  %% Check units
%radiiRegionBorders = [0 50;
%                      50 150;
%                      150 250;
%                      250 350;
%                      350 900;
%                      900 1000];

% Prefixes for the data files
%annotationsPrefix = fullfile('~','akiraMount','ged'); % Annotation file prefix (input)
annotationsPrefix = fullfile('.'); % Annotation file prefix (input)
load(fullfile(annotationsPrefix,'annotations.mat')); % load p
if SMALLDATA
        inputPrefix = fullfile('~','akiraMount','ged','smallData'); % Analysis files prefix (input)
        analysisPrefix = fullfile('~','akiraMount','ged','smallData'); % Analysis files prefix (input)
    %inputPrefix = fullfile('smallData'); % Analysis files prefix (input)
    %analysisPrefix = fullfile('smallData'); % Analysis files prefix (input)
    %analysisPrefix = fullfile('smallDataTryout'); % Analysis files prefix (input)
    %radiiRegionBorders = radiiRegionBorders/(5*4);  % mu/voxel * scalefactor
else
        inputPrefix = fullfile('~','akiraMount','ged','halfSizeData'); % Analysis files prefix (input)
        analysisPrefix = fullfile('~','akiraMount','ged','halfSizeData'); % Analysis files prefix (input)
    %inputPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
    %analysisPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
    %analysisPrefix = fullfile('halfSizeDataTryout'); % Analysis files prefix (input)
    %radiiRegionBorders = radiiRegionBorders/(5*2);  % mu/voxel * scalefactor
end

datasets = fieldnames(p);
nDatasets = length(datasets);

for ii = 1:nDatasets
    s = scaleBoneFractionParameters(p.(char(datasets(ii))), 2.0);
                                  % s = p.(datasets{ii});  % struct for current dataset
    [~, fn, fe] = fileparts(s.inputFilename);
    s.inputFilename=fullfile(inputPrefix,[fn,fe]); % load p
    fprintf('%d/%d: %s\n',ii,nDatasets,s.inputFilename);
    s.outputFilenamePrefix = fullfile(analysisPrefix,[fn, '_']);
    analyse3d(s.inputFilename, s.aBoneExample, s.aCavityExample, ...
        s.anImplantExample, s.avoidEdgeDistance, s.minSlice, s.maxSlice, ...
        radiiRegionBorders, s.halfEdgeSize, s.filterRadius, s.maxIter, ...
        s.maxDistance, SHOWRESULT, SAVERESULT, s.origo, s.R, s.marks, ...
        s.outputFilenamePrefix, nRadiiRegionPoints);
end
