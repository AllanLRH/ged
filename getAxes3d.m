function [m,U,D] = getAxes3d(M)

[x1,x2,x3] = ind2sub(size(M),find(M));
X = [x1(:),x2(:),x3(:)];
m = mean(X,1);
C = cov(X);
[U,D] = eigs(C);
D = diag(D);
