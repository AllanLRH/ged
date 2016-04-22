function setup = setPrefixes3d()

SMALLDATA = true;

% Visualization parameters
setup.numberSlicesToShow = 3; % The number of exemplar slices generated

% Prefixes for the data files
%annotationsPrefix = fullfile('~','akiraMount','ged'); % Annotation file prefix (input)
setup.annotationsPrefix = fullfile('.'); % Annotation file prefix (input)
dataPrefix = fullfile('~','akiraMount','ged');
latexPrefix = fullfile('~','akiraMount','gedTex');
if SMALLDATA
    setup.scaleFactor = 1; % scaling factor used in the analysis fase w.r.t. annotation file
    setup.inputPrefix = fullfile(dataPrefix,'smallData'); % Analysis files prefix (input)
    setup.analysisPrefix = fullfile(dataPrefix,'smallData'); % Analysis files prefix (input)
    setup.figurePrefix = fullfile(latexPrefix,'figuresSmall'); % pdf filename prefix (output)
else
    setup.scaleFactor = 2; % scaling factor used in the analysis fase w.r.t. annotation file
    setup.inputPrefix = fullfile(dataPrefix,'halfSizeData'); % Analysis files prefix (input)
    setup.analysisPrefix = fullfile(dataPrefix,'halfSizeData'); % Analysis files prefix (input)
    setup.figurePrefix = fullfile(latexPrefix,'figuresMedium'); % pdf filename prefix (output)
end

% Prefixes for the data files
setup.MicroMeterPerPixel = 5*4/setup.scaleFactor;

% Filenames
setup.annotationsFilename = fullfile(annotationsPrefix,'annotations.mat');
setup.parameterSuffix = 'params.mat';
setup.masksSuffix = 'masks.mat';
setup.segmentsSuffix = 'segments.mat';
setup.edgeEffectSuffix = 'edgeEffect.mat';
setup.fractionsSuffix = 'fractions.mat';