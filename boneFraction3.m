SAVERESULT = true;
VERBOSE = true;

% Prefixes for the data files
setup = setPrefixes3d();
annotationsFilename = setup.annotationsFilename;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;

if VERBOSE
  fprintf('Analysing bone: SAVERESULT=%d, VERBOSE=%d\n', SAVERESULT, VERBOSE);
end

if VERBOSE
  fprintf('  loading %s\n', annotationsFilename);
end
load(annotationsFilename, 'p'); % load p
datasets = fieldnames(p);

for i = 28%1:length(datasets)
  datasetSetup = p.(datasets{i});  % struct for current dataset
  
  % Things may have moved, so we ensure that the prefix of the input
  % filename is proper
  [~, fn, fe] = fileparts(datasetSetup.inputFilename);
  % We will work on the reduced data
  fn = strrep(fn,'double','single');

  datasetSetup.imageFilename=fullfile(inputPrefix, [fn, fe]); % load p
  
  % Output filenames are modified to include inputFilename identifier
  datasetSetup.outputFilenamePrefix = fullfile(analysisPrefix, [fn, '_']);
  
  % Fix missing data from setup
  datasetSetup.MicroMeterPerPixel = setup.MicroMeterPerPixel;
  
  fprintf('%d/%d: %s\n', i, length(datasets), datasetSetup.inputFilename);
  analyse3d(datasetSetup, setup.masksSuffix, setup.segmentsSuffix, setup.edgeEffectSuffix, setup.fractionsSuffix, SAVERESULT, VERBOSE);
end
