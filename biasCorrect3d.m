function im = biasCorrect3d(im,mask)

for i = 1:size(im,3)
    im(:,:,i) = im(:,:,i) - biasCorrect(im(:,:,i),mask(:,:,i));
end