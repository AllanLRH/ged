load ('../gedData/smallData/annotations.mat'); % load p

%for i = 1:length(p)
i = 10;
inputFilename = p{i,1};
aBoneExample = p{i,2};
aCavityExample = p{i,3};
anImplantExample = p{i,4};
avoidEdgeDistance = p{i,5};
minSlice = p{i,6};
maxSlice = p{i,7};
halfEdgeSize = p{i,8};
filterRadius = p{i,9};
maxIter = p{i,10};
maxDistance = p{i,11};
SHOWRESULT = p{i,12};
SAVERESULT = p{i,13};
outputFilename = p{i,14};
origo = p{i,15};
R = p{i,16};
marks = p{i,17};
analyse3d(inputFilename, aBoneExample, aCavityExample, anImplantExample, avoidEdgeDistance, minSlice, maxSlice, halfEdgeSize, filterRadius, maxIter, maxDistance, SHOWRESULT, SAVERESULT, origo, R, marks, outputFilename);

%end

%{
p{i,6}=150
p{i,7}=250
outPath = '../gedData/smallData/';
save([outPath,'annotations.mat'],'p');
%}
