function J = sample3d(I,x,u,w,U,V,W)

% Gram schmidt
w = w/sqrt(sum(w.^2));
u = u - (w'*u)*w; u = u/sqrt(sum(u.^2));
v = [w(2)*u(3)-w(3)*u(2), w(3)*u(1)-w(1)*u(3), w(1)*u(2)-w(2)*u(1)]';

% Create grid
[U, V, W] = ndgrid(U, V, W);
C = u*U(:)' + v*V(:)' + w*W(:)';
%J = reshape(interpn(I, C(1,:) + size(I,1)/2, C(2,:) + size(I,2)/2, C(3,:) + size(I,3)/2 'linear', 0), size(U));
J = reshape(interpn(I, C(1, :)+x(1), C(2, :)+x(2), C(3, :)+x(3), 'linear', 0), size(U));
