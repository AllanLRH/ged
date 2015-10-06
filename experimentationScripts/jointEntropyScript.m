% make random images (ensuring that the values are integer and 1 or above
% for matlab indexing)
clear; home; close all;
N = 100;
I = round(abs(3*randn(N,N)+5)) + 1;
J = round(abs(1*randn(N,N)+3)) + 1;

figure;
subplot(131)
imagesc(I)
title('I')
colormap('gray')
colorbar

subplot(132)
imagesc(J)
title('J')
colormap('gray')
colorbar



% reorder data
val = [I(:),J(:)];

% make histogram
H = zeros(max(I(:)), max(J(:)));
for i = 1:size(val,1);
    H(val(i,1), val(i,2)) = H(val(i,1), val(i,2)) + 1;
end
subplot(133)
imagesc(H); colormap(gray); axis equal tight;
xlabel('J values'); ylabel('I values'); title('Joint histogram');

% alternative histogram calculation
I==1
J==7
(I==1) & (J==7)
sum(sum((I==1) & (J==7)))

% Calculate joint entropy
H = H/sum(H(:));
ind = H>0;
-sum(H(ind).*log(H(ind)))
-sum(H(ind).*log2(H(ind)))
