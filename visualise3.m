VERBOSE = true;

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

if setup.makeLatex
    latexFilename = fullfile(setup.latexPrefix, 'autoMain.tex'); % pdf filename prefix (output)
    fid = fopen(latexFilename, 'wt');
else
    fid = [];
end

if VERBOSE
    fprintf('Visualising bone: FONTSIZE=%d, SMALLFONTSIZE=%d, MARKERSIZE=%d, LINEWIDTH=%d, PROGRESSOUTPUT=%d, VERBOSE=%d\n', FONTSIZE, SMALLFONTSIZE, MARKERSIZE, LINEWIDTH, PROGRESSOUTPUT, VERBOSE);
end

if VERBOSE
    fprintf('  loading %s\n',annotationsFilename);
end
load(annotationsFilename, 'p'); % load p
datasets = fieldnames(p);

for i = 1:1%length(datasets)
    datasetSetup = p.(datasets{i});  % struct for current dataset

    % Things may have moved, so we ensure that the prefix of the input
    % filename is proper
    [~, fn, fe] = fileparts(datasetSetup.inputFilename);
    datasetSetup.imageFilename=fullfile(inputPrefix,[fn,fe]);
    
    % Input and output filenames are modified to include inputFilename identifier
    datasetSetup.inputFilenamePrefix = fullfile(analysisPrefix,[fn, '_']);
    datasetSetup.figurePrefix = latexClean(fullfile(setup.figurePrefix,[fn, '_']),false);

    % Fix missing data from setup
    datasetSetup.MicroMeterPerPixel = setup.MicroMeterPerPixel;
    % do we fix dataSetup.scaleFactor as well?

    fprintf('%d/%d: %s\n',i,length(datasets),datasetSetup.inputFilename);
    if ~isempty(fid)
        fnEsc = strrep(fn, '_', '\_');
        fprintf(fid, '\\clearpage\n');
        fprintf(fid, '\\section{%s}\n',fnEsc);
    end
    visualise3d(datasetSetup, setup.parametersSuffix, setup.masksSuffix, setup.segmentsSuffix, setup.edgeEffectSuffix, setup.fractionsSuffix, setup.numberSlicesToShow, fid, FONTSIZE, SMALLFONTSIZE, MARKERSIZE, LINEWIDTH, PROGRESSOUTPUT, VERBOSE);
end
