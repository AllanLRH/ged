SMALLDATA = true;
SHOWRESULT = false;
SAVERESULT = true;

% Prefixes for the data files
%annotationsPrefix = fullfile('~','akiraMount','ged'); % Annotation file prefix (input)
annotationsPrefix = fullfile('.'); % Annotation file prefix (input)
if SMALLDATA
    %    inputPrefix = fullfile('~','akiraMount','ged','smallData'); % Analysis files prefix (input)
    %    analysisPrefix = fullfile('~','akiraMount','ged','smallData'); % Analysis files prefix (input)
    inputPrefix = fullfile('smallData'); % Analysis files prefix (input)
    analysisPrefix = fullfile('smallData'); % Analysis files prefix (input)
else
    %    inputPrefix = fullfile('~','akiraMount','ged','halfSizeData'); % Analysis files prefix (input)
    %    analysisPrefix = fullfile('~','akiraMount','ged','halfSizeData'); % Analysis files prefix (input)
    inputPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
    analysisPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
end

load(fullfile(annotationsPrefix,'annotations.mat')); % load p
datasets = fieldnames(p);

%{
datasets = {...
    'ID1662_771_pag', 'ID5598_784_pag', 'ID5598_788_pag', 'ID5598_787_pag', ...
    'ID1886_811b_pag', 'ID1684_809_pag', 'ID5597_780_pag', 'ID1662_769_pag', ...
    'ID1798_778_pag', 'ID1689_808_pag', 'ID1689_805_pag', 'ID5597_783_pag', ...
    'ID1886_810b_pag', 'ID5597_781_pag', 'ID5598_786_pag', 'ID1886_813_pag', ...
    'ID1886_814b_pag', 'ID1798_776_pag', 'ID1662_773_pag', 'ID1684_806_pag', ...
    'ID1662_772_pag', 'ID5598_785_pag', 'ID1662_770_pag', 'ID1798_777_pag', ...
    'ID1689_807_pag'};
%}

for i = 1:length(datasets)
    s = p.(datasets{i});  % struct for current dataset
    
    [~, fn, fe] = fileparts(s.inputFilename);
    s.inputFilename=fullfile(inputPrefix,[fn,fe]); % load p
    fprintf('%d/%d: %s\n',i,length(datasets),s.inputFilename);
    s.outputFilenamePrefix = fullfile(analysisPrefix,[fn, '_']);
    analyse3d(s.inputFilename, s.aBoneExample, s.aCavityExample, ...
        s.anImplantExample, s.avoidEdgeDistance, s.minSlice, s.maxSlice, ...
        s.halfEdgeSize, s.filterRadius, s.maxIter, s.maxDistance, SHOWRESULT, ...
        SAVERESULT, s.origo, s.R, s.marks, s.outputFilenamePrefix);
end

%{
p{i,6}=150
p{i,7}=250
outPath = '../gedData/smallData/';
save([outPath,'annotations.mat'],'p');
%}
