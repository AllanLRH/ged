clear; close all; home

vol = 1:(15*15*9);
vol = reshape(vol, [15 15 9]);

f = 3;

newVolSize = [5 5 3];
newVol = NaN*ones(newVolSize);
for ii = 1:newVolSize(1)
    for jj = 1:newVolSize(2)
        for kk = 1:newVolSize(3)
            iVol = ii*f;
            jVol = jj*f;
            kVol = kk*f;
            newVol(ii, jj, kk) = vol(iVol, jVol, kVol);
        end
    end
end
