% Global plotting parameters
FONTSIZE = 18;
SMALLFONTSIZE = 12;
MARKERSIZE = 15;
LINEWIDTH=3;
PROGRESSOUTPUT=true;

% Prefixes for the data files
setup = setPrefixes3d();
annotationsPrefix = setup.annotationsPrefix;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;
annotationsFilename = setup.annotationsFilename;

load(annotationsFilename); % load p
datasets = fieldnames(p);

for i = 1:1%length(datasets)
    % Things may have moved, so we ensure that the prefix of the input
    % filename is proper
    [~, fn, fe] = fileparts(datasetSetup.inputFilename);
    datasetSetup.inputFilename=fullfile(inputPrefix,[fn,fe]); % load p

    % Output filenames are modified to include inputFilename identifier
    datasetSetup.outputFilenamePrefix = fullfile(analysisPrefix,[fn, '_']);

    fprintf('%d/%d: %s\n',i,length(datasets),datasetSetup.inputFilename);

    visualize3d(datasetSetup, FONTSIZE, SMALLFONTSIZE, MARKERSIZE, LINEWIDTH, PROGRESSOUTPUT);
end
