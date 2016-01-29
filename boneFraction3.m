inPath = '';

load([inPath,'annotations.mat']); % load p
%load ('annotations.mat'); % load p
datasets = fieldnames(p);

for i = 1:length(datasets)
    s = p.(char(datasets(i)));  % struct for current dataset
    disp(s.inputFilename);
    analyse3d(s.inputFilename, s.aBoneExample, s.aCavityExample, ...
    s.anImplantExample, s.avoidEdgeDistance, s.minSlice, s.maxSlice, ...
    s.halfEdgeSize, s.filterRadius, s.maxIter, s.maxDistance, s.SHOWRESULT, ...
    s.SAVERESULT, s.origo, s.R, s.marks, s.outputFilename);
end

%{
p{i,6}=150
p{i,7}=250
outPath = '../gedData/smallData/';
save([outPath,'annotations.mat'],'p');
%}
