function J = sample3d(I,o,R,U1,U2,U3)

% Gram schmidt
u1 = R(:,1);
u2 = R(:,2);
u3 = R(:,3);

% Create grid
[U1, U2, U3] = ndgrid(U1, U2, U3);
C = u1*U1(:)' + u2*U2(:)' + u3*U3(:)';
J = reshape(interpn(I, C(1, :)+o(1), C(2, :)+o(2), C(3, :)+o(3), 'linear', NaN), size(U1));
