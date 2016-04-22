SHOWRESULT = false;
SAVERESULT = true;

% Prefixes for the data files
setup = setPrefixes3d();
annotationsPrefix = setup.annotationsPrefix;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;
annotationsFilename = setup.annotationsFilename;

load(annotationsFilename); % load p
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

for i = 1:1%length(datasets)
    datasetSetup = p.(datasets{i});  % struct for current dataset
    
    % Things may have moved, so we ensure that the prefix of the input
    % filename is proper
    [~, fn, fe] = fileparts(datasetSetup.inputFilename);
    datasetSetup.inputFilename=fullfile(inputPrefix,[fn,fe]); % load p

    % Output filenames are modified to include inputFilename identifier
    datasetSetup.outputFilenamePrefix = fullfile(analysisPrefix,[fn, '_']);

    fprintf('%d/%d: %s\n',i,length(datasets),datasetSetup.inputFilename);
    analyse3d(datasetSetup, SHOWRESULT, SAVERESULT);
end

%{
p{i,6}=150
p{i,7}=250
outPath = '../gedData/smallData/';
save([outPath,'annotations.mat'],'p');
%}
