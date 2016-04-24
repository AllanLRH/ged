function J = sample3d(I, o, R, U1, U2, U3)
  %
  if size(o,1) < size(o,2)
    o = o';
  end
  
  [U1, U2, U3] = ndgrid(U1, U2, U3);
  C = transform3d(o, R, [U1(:)'; U2(:)'; U3(:)']);
  J = reshape(interpn(I, C(1, :), C(2, :), C(3, :), 'linear', NaN), size(U1));
end