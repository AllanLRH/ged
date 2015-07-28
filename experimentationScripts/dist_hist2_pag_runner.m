%% Ny knogle (mikrogevind)
clear; close all; clc
%%{
%% Auto med membran

%      sample fileno topslice bottomslice
matrix=[770    2      100      600;
        775    12     100      600;
        780    27     240      740;
        785    32     100      600;
        811    18     80       580;
        816    23     150      650];

%matrix=[770    2      100      100];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%%{
%% Auto uden membran

%      sample fileno topslice bottomslice
matrix=[773    5      95       595;
        778    15     200      700;
        788    35     400      900;
        814    21     400      900;
        819    26     130      630];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Tom

%      sample fileno topslice bottomslice
matrix=[769    1      420      920;
        774    11     375      875;
        779    16     370      870;
        784    31     130      630;
        810    17     100      600;
        815    22     120      620];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end
%%}
%% Easy

%      sample fileno topslice bottomslice
matrix=[771   3       375      875;
        776   13      200      700;
        781   28      200      700;
        786   33      350      850;
        807   9       400      900;
        812   19      100      600;
        817   24       50      550];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Crystal

%      sample fileno topslice bottomslice
matrix=[772   4       200      700;
        777   14      300      800;
        782   29      350      850;
        787   34      300      800;
        808   10      100      600;
        813   20      150      650;
        818   25      100      600];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end










%% Gammel knogle (makrogevind)

%%{
%% Auto med membran

%      sample fileno topslice bottomslice
matrix=[770    2      600    1000;
        775    12     700    1000;
        780    27     850    1000;
        785    32     700    1000;
        811    18     650    1000;
        816    23     800    1000];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end
%%}
%% Auto uden membran

%      sample fileno topslice bottomslice
matrix=[773    5      675      1000;
        778    15     800      1000;
        788    35     1        225;
        814    21     1        275;
        819    26     750      1000];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Tom

%      sample fileno topslice bottomslice
matrix=[769    1      1      420;
        774    11     1      325;
        779    16     1      250;
        784    31     650    1000;
        810    17     700    1000;
        815    22     725    1000];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Easy

%      sample fileno topslice bottomslice
matrix=[771   3         1       250;
        776   13      800      1000;
        781   28        1       150;
        786   33        1       300;
        807   9         1       300;
        812   19      700      1000;
        817   24      650      1000];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Crystal

%      sample fileno topslice bottomslice
matrix=[772   4       700      1000;
        777   14        1       250;
       % 782   29        0   ;
        787   34        1       200;
        808   10      700      1000;
        813   20      750      1000;
        818   25      650      1000];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end









%% Over mikrogevindet

%%{
%% Auto med membran

%      sample fileno topslice bottomslice
matrix=[770    2      1       100;
        775    12     1       100;
        780    27     1       240;
        785    32     1       100;
        811    18     1        80;
        816    23     1       150];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Auto uden membran

%      sample fileno topslice bottomslice
matrix=[773    5        1        95;
        778    15       1       200;
        788    35     900      1000;
        814    21     900      1000;
        819    26       1       130];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Tom

%      sample fileno topslice bottomslice
matrix=[769    1      920      1000;
        774    11     875      1000;
        779    16     870      1000;
        784    31       1       130;
        810    17       1       100;
        815    22       1       120];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end
%%}
%% Easy

%      sample fileno topslice bottomslice
matrix=[771   3       875      1000;
        776   13        1       200;
        781   28      700      1000;
        786   33      850      1000;
        807   9       900      1000;
        812   19        1       100;
        817   24        1        50];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%% Crystal

%      sample fileno topslice bottomslice
matrix=[772   4         1       200;
        777   14      800      1000;
        782   29        1       350;
        787   34      800      1000;
        808   10        1       100;
        813   20        1       150;
        818   25        1       100];

for s=1:size(matrix,1)
    dist_hist2_pag(matrix(s,(2:4)))
end

%}