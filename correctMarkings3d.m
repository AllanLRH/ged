VERBOSE = true;

% Prefixes for the data files
setup = setPrefixes3d();
annotationsPrefix = setup.annotationsPrefix;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;
annotationsFilename = setup.annotationsFilename;

load(annotationsFilename, 'p'); % load p
datasets = fieldnames(p);

for i = 1:length(datasets)
  o = p.(datasets{i}).origo;
  x = p.(datasets{i}).xMarks;
  x = x([2,1,3],:);
  w = x(:, 3) - x(:, 4); w = w / norm(w);
  v = x(:, 1) - o;
  u = cross(v, w); u = u / norm(u);
  v = cross(w, u);
  R = [u, v, w];
  marks = R'*bsxfun(@plus,x,-o); %R'*(x(:, [3, 2, 4, 1]) - o * ones(1, 4));
  p.(datasets{i}).R = R;
  p.(datasets{i}).marks = marks;
  p.(datasets{i}).xMarks = x;    
end
save(annotationsFilename, 'p'); % load p
