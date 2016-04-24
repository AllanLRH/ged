function V = transform3d(o, R, U)
  %
  V = bsxfun(@plus, R * U, o);
end