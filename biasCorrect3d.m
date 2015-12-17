function J = biasCorrect3d(I,mask)
%BIASCORRECT Calculate the quadratic bias field on I(mask)
%
%  J = biasCorrect3d(I,mask)
%    J - a 3 dimensional least square fit to I(mask)
%    I - a 3 dimensional matrix of doubles
%    mask - a 3 dimensional matrix, where elements to be considered are true or non-zero
%
%  BIASCORRECT fits a 3 dimensional second degree polynomial to I(mask),
%  and returns the fit as an matrix. Max 10% of the number elements in
%  I(mask) are evaluated but at least 10000 or the number of true elements
%  in mask, whichever is the smallest.
%
%  Example:
%
%    % Make a synthetic matrix I
%    M = 30;
%    N = 40;
%    O = 50;
%    [x1,x2,x3] = ndgrid(linspace(0,1,M),linspace(0,1,N),linspace(0,1,O));
%    Phi = [ones(numel(x1),1), x1(:), x2(:), x3(:), x1(:).^2, x1(:).*x2(:), x1(:).*x3(:), x2(:).^2, x2(:).*x3(:), x3(:).^2];
%    a=randn(size(Phi,2),1);
%    I = reshape(Phi*a,M,N,O);
%    % Caclulate the bias field
%    J = biasCorrect3d(I,true([M,N,O]));
%    % Correct the image for the bias field.  The result should be 0 up to
%    % numerical precision.
%    disp(max(max(max(abs(I-J)))));
%
%                     Copyright, Jon Sporring, DIKU, December 2015.

[x1,x2,x3] = ndgrid(linspace(0,1,size(I,1)),linspace(0,1,size(I,2)),linspace(0,1,size(I,3)));

% Calculations are done on the smaller set specified by mask
ind = find(mask ~= 0);
N = floor(min(sum(mask(:)),max(0.1*numel(ind),10000)));
ind = ind(randi(length(ind),[N,1]));
Phi = [ones(numel(ind),1), x1(ind), x2(ind), x3(ind), x1(ind).^2, x1(ind).*x2(ind), x1(ind).*x3(ind), x2(ind).^2, x2(ind).*x3(ind), x3(ind).^2];
a = (Phi'*Phi)\(Phi'*I(ind));

% The result is returned on the full image.
J = a(1)*ones(size(I));
J = J+a(2)*x1;
J = J+a(3)*x2;
J = J+a(4)*x3;
J = J+a(5)*x1.^2;
J = J+a(6)*x1.*x2;
J = J+a(7)*x1.*x3;
J = J+a(8)*x2.^2;
J = J+a(9)*x2.*x3;
J = J+a(10)*x3.^2;
%J = reshape(Phi*a,size(I,1),size(I,2),size(I,3));
disp(max(abs(a)));