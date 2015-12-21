function J = sample3d(I,x,R,U,V,W)

% Gram schmidt
w = R(:,3);
u = R(:,2);
v = R(:,1);

% Create grid
[U, V, W] = ndgrid(U, V, W);
C = u*U(:)' + v*V(:)' + w*W(:)';
J = reshape(interpn(I, C(1, :)+x(1), C(2, :)+x(2), C(3, :)+x(3), 'linear', 0), size(U));
