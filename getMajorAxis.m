function [axis,m] = getMajorAxis(M)

[m,~,U] = getMajorAxis(M);

axis = U(:,end);
