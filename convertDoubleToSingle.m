setup = setPrefixes3d();
annotationsFilename = setup.annotationsFilename;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;

load(annotationsFilename, 'p'); % load p
datasets = fieldnames(p);

for i = 1:length(datasets)
  datasetSetup = p.(datasets{i});  % struct for current dataset
  
  % Things may have moved, so we ensure that the prefix of the input
  % filename is proper
  [~, fn, fe] = fileparts(datasetSetup.inputFilename);
  imageFilename=fullfile(inputPrefix, [fn, fe]); % load p
  load(imageFilename, 'newVol');
  newVol = single(newVol);
  outputFilename = strrep(imageFilename,'double','single');
  fprintf('%s -> %s\n', imageFilename, outputFilename)
  save(outputFilename, 'newVol');
end
