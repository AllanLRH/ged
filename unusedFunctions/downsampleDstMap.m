function smallDstMap = downsampleDstMap(dstMap)
    newSize = round(size(dstMap)/4);
    slices = 1:4:size(dstMap, 3);
    if slices(end) ~= newSize(3)
        fprintf('Dimmension mismatch\n');
        fprintf('newSize: %d,  %d,  %d\n', newSize(1), newSize(2), newSize(3));
        fprintf('slices(end)) %d\n', slices(end));
    end
    smallDstMap = NaN*zeros(newSize);
    for ii = slices

    end
end
