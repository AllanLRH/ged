function [v,m] = getMajorAxis(M)

%{
[x1,x2,x3]=ndgrid(1:size(M,1),1:size(M,2),1:size(M,3));
X = [x1(M),x2(M),x3(M)];
m = mean(X,1);
X = X-ones(size(X,1),1)*m;
C = X'*X/sum(sum(sum(M)));
[V,~] = eig(C);
v = V(:,3);
%}

[x1,x2,x3] = ind2sub(size(M),find(M));
X = [x1(:),x2(:),x3(:)];
m = mean(X,1);
C = cov(X);
[v,~] = eigs(C,1);
