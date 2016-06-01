SAVERESULT = true;
VERBOSE = true;
SMALLDATA = false;

% Prefixes for the data files
setup = setPrefixes3d(SMALLDATA);
annotationsFilename = setup.annotationsFilename;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;

if VERBOSE
  fprintf('Analysing bone: SAVERESULT=%d, VERBOSE=%d, SMALLDATA=%d\n', SAVERESULT, VERBOSE, SMALLDATA);
end

if VERBOSE
  fprintf('  loading %s\n', annotationsFilename);
end
load(annotationsFilename, 'p'); % load p
datasets = fieldnames(p);

for i = 2:length(datasets)
  datasetSetup = p.(datasets{i});  % struct for current dataset
  datasetSetup.maxDistance = 1000/20; % 1000 mu in units of 20 mu voxels as in 1/4 resolution
  datasetSetup.distanceStep = 10/20; % 10 mu in units of 20 mu voxels as in 1/4 resolution
  datasetSetup = scaleBoneFractionParameters(datasetSetup, setup.scaleFactor);

  datasetSetup.distanceStep = 1/2; % But in general, we want to sample in step of 1/2 voxels
  datasetSetup.filterRadius = 2; % We want to filter with fixed voxels size regardless of scale

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
