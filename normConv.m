%% normConv: Perform normalized convolution
function out = normConv(img, mask, kernel)
   out = conv2(img.*mask, kernel, 'same') ./ conv2(mask, kernel, 'same');
   out(~mask) = 0;
end
