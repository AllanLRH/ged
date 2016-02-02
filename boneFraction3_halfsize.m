load ('annotations.mat'); % load p
halfSizedDataPath = 'halfSizeData';
pathseperator = '/';
datasets = fieldnames(p);
scale = 2.0;

for ii = 1:length(datasets)
    % struct for current dataset
    s = scaleBoneFractionParameters(p.(char(datasets(ii))), scale);
    disp(s.inputFilename);
    [~, fn, fe]       = fileparts(s.inputFilename);
    s.inputFilename     = [halfSizedDataPath pathseperator fn fe];
    s.SHOWRESULT        = false;
    s.SAVERESULT        = true;
    s.outputFilename    = [halfSizedDataPath pathseperator fn '_'];
    analyse3d(s.inputFilename, s.aBoneExample, s.aCavityExample, ...
              s.anImplantExample, s.avoidEdgeDistance, s.minSlice, s.maxSlice, ...
              s.halfEdgeSize, s.filterRadius, s.maxIter, s.maxDistance, s.SHOWRESULT, ...
              s.SAVERESULT, s.origo, s.R, s.marks, outputFilename);
    save([halfSizedDataPath pathseperator fn '_boneFraction3Parameters_'], 's')
end

%{
p{ii,6}=150
p{ii,7}=250
outPath = '../gedData/smallData/';
save([outPath,'annotations.mat'],'p');
%}
