function J = biasCorrect(I,mask)
%BIASCORRECT Calculate the quadratic bias field on I(mask)
%
%  J = biasCorrect(I,mask)
%    J - a 2 dimensional least square fit to I(mask)
%    I - a 2 dimensional image of doubles
%    mask - a 2 dimensional matrix, where elements to be considered are true or non-zero
%
%  BIASCORRECT fits a 2 dimensional second degree polynomial to I(mask),
%  and returns the fit as an image. Max 10% of the number elements in
%  I(mask) are evaluated but at least 10000 or the number of true elements
%  in mask, whichever is the smallest.
%
%  Example:
%
%    % Make a synthetic matrix I
%    M = 30;
%    N = 40;
%    [r,c] = ndgrid(linspace(0,1,M),linspace(0,1,N));
%    Phi = [ones(numel(r),1), r(:), c(:), r(:).^2, r(:).*c(:), c(:).^2];
%    a=randn(size(Phi,2),1);
%    I = reshape(Phi*a,M,N);
%    % Caclulate the bias field
%    J = biasCorrect(I,true([M,N]));
%    % Correct the image for the bias field.  The result should be 0 up to
%    % numerical precision.
%    disp(max(max(abs(I-J))));
%
%  Corrected error for non-square matrices. Jon Sporring, December 2015
%
%                     Copyright, Jon Sporring, DIKU, October 2014.


[r,c] = ndgrid(linspace(0,1,size(I,1)),linspace(0,1,size(I,2)));
Phi = [ones(numel(r),1), r(:), c(:), r(:).^2, r(:).*c(:), c(:).^2];

% Calculations are done on the smaller set specified by mask
ind = find(mask ~= 0);
N = floor(min(numel(ind),max(0.1*numel(ind),10000)));
ind = ind(randi(length(ind),[N,1]));
a = (Phi(ind,:)'*Phi(ind,:))\(Phi(ind,:)'*I(ind));

% The result is returned on the full image.
J = reshape(Phi*a,size(I,1),size(I,2));
