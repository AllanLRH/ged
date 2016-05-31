function setup = setPrefixes3d(varargin)
  % Generate datastructure of parameters for the pipeline.
  %
  % E.g.,
  %   setup = setPrefixes3d(SMALLDATA)
  % where SMALLDATA is an optional boolean, true implies 1/4 resolution and
  % false 1/2. Default is true.
  %
  
  if nargin > 0
    SMALLDATA = varargin{1};
  else
    SMALLDATA = true;
  end
  
  % Visualization parameters
  setup.numberSlicesToShow = 3; % The number of exemplar slices generated
  setup.makeLatex = true;
  
  % Prefixes for the data files
  %annotationsPrefix = fullfile('~', 'akiraMount', 'ged'); % Annotation file prefix (input)
  %dataPrefix = fullfile('~', 'akiraMount', 'ged');
  %setup.latexPrefix = fullfile('~', 'akiraMount', 'gedTex');
  dataPrefix = fullfile('..','data');
  setup.annotationsPrefix = fullfile(dataPrefix); % Annotation file prefix (input)
  setup.latexPrefix = fullfile('..', 'tex');
  if SMALLDATA
    setup.scaleFactor = 1; % scaling factor used in the analysis fase w.r.t. annotation file
    setup.inputPrefix = fullfile(dataPrefix, 'smallData'); % Analysis files prefix (input)
    setup.analysisPrefix = fullfile(dataPrefix, 'smallData'); % Analysis files prefix (input)
    setup.figurePrefix = fullfile(setup.latexPrefix, 'figuresSmall'); % pdf filename prefix (output)
  else
    setup.scaleFactor = 2; % scaling factor used in the analysis fase w.r.t. annotation file
    setup.inputPrefix = fullfile(dataPrefix, 'halfSizeData'); % Analysis files prefix (input)
    setup.analysisPrefix = fullfile(dataPrefix, 'halfSizeData'); % Analysis files prefix (input)
    setup.figurePrefix = fullfile(setup.latexPrefix, 'figuresMedium'); % pdf filename prefix (output)
  end
  
  % data filename selector
  setup.filenamePattern = '*v7.3_single.mat';
  
  % Prefixes for the data files
  setup.MicroMeterPerPixel = 5*4/setup.scaleFactor;
  
  % Filenames
  setup.annotationsFilename = fullfile(setup.annotationsPrefix, 'annotations.mat');
  setup.parametersSuffix = 'params.mat';
  setup.masksSuffix = 'masks.mat';
  setup.segmentsSuffix = 'segments.mat';
  setup.edgeEffectSuffix = 'edgeEffect.mat';
  setup.fractionsSuffix = 'fractions.mat';
