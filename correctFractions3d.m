VERBOSE = true;

% Prefixes for the data files
setup = setPrefixes3d();
annotationsPrefix = setup.annotationsPrefix;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;
annotationsFilename = setup.annotationsFilename;
fractionsSuffix = setup.fractionsSuffix;

load(annotationsFilename, 'p'); % load p
datasets = fieldnames(p);

for i = 1:length(datasets)
  [~, fn, fe] = fileparts(p.(datasets{i}).inputFilename);
  inputFilenamePrefix = fullfile(analysisPrefix,[fn, '_']);
  inputFilename = [inputFilenamePrefix, fractionsSuffix];
  disp(inputFilename);
  load(inputFilename, 'fractions');
  disp(fractions);
  x1 = fractions{1};
  x2 = fractions{2};
  x3 = fractions{3};
  bone = fractions{4};
  cavity = fractions{5};
  neither = fractions{6};
  distances = fractions{7};
  save(inputFilename, 'x1', 'x2', 'x3', 'bone', 'cavity', 'neither', 'distances');
end
