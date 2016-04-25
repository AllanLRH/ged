function V = transform3d(o, R, U)
  %
  %V = R * U + o * ones(1,size(U,2));
  V = bsxfun(@plus, R * U, o);
end