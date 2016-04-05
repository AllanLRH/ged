clear; close all; clc
SMALLDATA = true;
SHOWRESULT = false;
SAVERESULT = true;
nRadiiRegionPoints = 25;
% radiiRegionBorders = [50, 150, 250, 350, 900, 1000];  %% Check units
radiiRegionBorders = [0 50;
                      50 150;
                      150 250;
                      250 350;
                      350 900;
                      900 1000];

% Prefixes for the data files
%annotationsPrefix = fullfile('~','akiraMount','ged'); % Annotation file prefix (input)
annotationsPrefix = fullfile('.'); % Annotation file prefix (input)
if SMALLDATA
    %    inputPrefix = fullfile('~','akiraMount','ged','smallData'); % Analysis files prefix (input)
    %    analysisPrefix = fullfile('~','akiraMount','ged','smallData'); % Analysis files prefix (input)
    inputPrefix = fullfile('smallData'); % Analysis files prefix (input)
    % analysisPrefix = fullfile('smallData'); % Analysis files prefix (input)
    analysisPrefix = fullfile('smallDataTryout'); % Analysis files prefix (input)
    radiiRegionBorders = radiiRegionBorders/(5*4);  % mu/voxel * scalefactor
else
    %    inputPrefix = fullfile('~','akiraMount','ged','halfSizeData'); % Analysis files prefix (input)
    %    analysisPrefix = fullfile('~','akiraMount','ged','halfSizeData'); % Analysis files prefix (input)
    inputPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
    analysisPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
    radiiRegionBorders = radiiRegionBorders/(5*2);  % mu/voxel * scalefactor
end

load(fullfile(annotationsPrefix,'annotations.mat')); % load p
% datasets = fieldnames(p);

datasets = {'ID1662_772', 'ID1886_812pag', 'ID1937_817pag', 'ID1798_775_pag', ...
'ID5597_782_pag', 'ID1689_807', 'ID1662_773', 'ID1937_816pag', 'ID1937_819pag', ...
'ID1689_805', 'ID1662_769', 'ID1684_806', 'ID1798_774_pag', 'ID1798_779_pag', ...
'ID1684_809', 'ID1662_771', 'ID1662_770', 'ID1689_808', 'ID1937_815pag', ...
'ID1937_818pag'};

for i = 1:length(datasets)
    s = p.(datasets{i});  % struct for current dataset
    [~, fn, fe] = fileparts(s.inputFilename);
    s.inputFilename=fullfile(inputPrefix,[fn,fe]); % load p
    fprintf('%d/%d: %s\n',i,length(datasets),s.inputFilename);
    s.outputFilenamePrefix = fullfile(analysisPrefix,[fn, '_']);
    analyse3d(s.inputFilename, s.aBoneExample, s.aCavityExample, ...
        s.anImplantExample, s.avoidEdgeDistance, s.minSlice, s.maxSlice, ...
        radiiRegionBorders, s.halfEdgeSize, s.filterRadius, s.maxIter, ...
        s.maxDistance, SHOWRESULT, SAVERESULT, s.origo, s.R, s.marks, ...
        s.outputFilenamePrefix, nRadiiRegionPoints);
end

%{
p{i,6}=150
p{i,7}=250
outPath = '../gedData/smallData/';
save([outPath,'annotations.mat'],'p');
%}
