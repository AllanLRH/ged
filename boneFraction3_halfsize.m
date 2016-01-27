load ('annotations.mat'); % load p
halfSizedDataPath = 'halfSizeData';
pathseperator = '/';

for itr = 1:size(p,1)
    pItr = scaleBoneFractionParameters({p{itr, :}}, 2.0);
    inputFilename     = pItr{1};
    [~, fn, fe]       = fileparts(inputFilename);
    inputFilename     = [halfSizedDataPath pathseperator fn fe];
    aBoneExample      = pItr{2};
    aCavityExample    = pItr{3};
    anImplantExample  = pItr{4};
    avoidEdgeDistance = pItr{5};
    minSlice          = pItr{6};
    maxSlice          = pItr{7};
    halfEdgeSize      = pItr{8};
    filterRadius      = pItr{9};
    maxIter           = p{itr,10};
    maxDistance       = pItr{11};
    SHOWRESULT        = false;
    SAVERESULT        = true;
    % outputFilename    = p{itr,14};
    outputFilename    = [halfSizedDataPath pathseperator fn '_'];
    origo             = pItr{15};
    R                 = pitr{16};
    marks             = pItr{17};
    analyse3d(inputFilename, aBoneExample, aCavityExample, anImplantExample, ...
              avoidEdgeDistance, minSlice, maxSlice, halfEdgeSize, ...
              filterRadius, maxIter, maxDistance, SHOWRESULT, SAVERESULT, ...
              origo, R, marks, outputFilename);
end

%{
p{itr,6}=150
p{itr,7}=250
outPath = '../gedData/smallData/';
save([outPath,'annotations.mat'],'p');
%}
