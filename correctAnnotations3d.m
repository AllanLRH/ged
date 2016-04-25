VERBOSE = true;

% Prefixes for the data files
setup = setPrefixes3d();
annotationsFilename = setup.annotationsFilename;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;

if VERBOSE
  fprintf('Correct annotations: VERBOSE = %d\n', VERBOSE);
end

if VERBOSE
  fprintf('  loading %s\n', annotationsFilename);
end
load(annotationsFilename, 'p'); % load p
datasets = fieldnames(p);

choice = 'Overwrite';
for i = 12:length(datasets)
  datasetSetup = p.(datasets{i});  % struct for current dataset
  
  if isfield(datasetSetup, 'oldR')
    if strcmp(choice, 'Skip all')
      continue
    end
    choice = questdlg(sprintf('Data "%s" appears already to have been updated.', datasets{i}), 'Question', 'Overwrite', 'Skip', 'Skip all', 'Skip');
    if ~strcmp(choice, 'Overwrite')
      continue
    end
  end
  
  % Things may have moved, so we ensure that the prefix of the input
  % filename is proper
  [~, fn, fe] = fileparts(datasetSetup.inputFilename);
  datasetSetup.imageFilename = fullfile(inputPrefix, [fn, fe]); % load p
  
  % Output filenames are modified to include inputFilename identifier
  datasetSetup.outputFilenamePrefix = fullfile(analysisPrefix, [fn, '_']);
  
  fprintf('%d/%d: %s\n', i, length(datasets), datasetSetup.inputFilename);
  x = correct3d(datasetSetup, setup.masksSuffix, VERBOSE);
  % 4 points are returned: 1. The stop point of the micro thread, the reference point (rf), 2. The macro thread below rf, 3. 10 micro threads higher than rf, 4. 3 macro threads lower than rf.
  disp(x);
  o = datasetSetup.origo';
  w = x(:, 3) - x(:, 4); w = w / norm(w);
  v = x(:, 1) - o;
  u = cross(v, w); u = u / norm(u);
  v = cross(w, u);
  R = [u, v, w];
  marks = R'*bsxfun(@plus,x,-o); %R'*(x(:, [3, 2, 4, 1]) - o * ones(1, 4));
  p.(datasets{i}).oldR = p.(datasets{i}).R;
  p.(datasets{i}).oldMarks = p.(datasets{i}).marks;
  p.(datasets{i}).R = R;
  p.(datasets{i}).marks = marks;
  p.(datasets{i}).xMarks = x;
end
save(annotationsFilename, 'p');
