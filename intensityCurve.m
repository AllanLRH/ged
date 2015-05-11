clear; close all; clc

%% Find circle containing image
r = 2048;
c = 2048;
xc = r/2;
yc = c/2;
circ = false(r, c);
for x = 1:r
    for y = 1:c
        if (x-xc)^2 + (y-yc)^2 <= xc^2
            circ(x, y) = 1;
        end
    end
end

N = 100;
intensity = zeros(1, N);
parfor jj = 1:255
    disp(jj/255)
    img = loadGed('5.05_ID1662_769_0001.vol', jj);
    intensity = intensity + intensityCurveFun(img, circ, N);
end
intensity = intensity/100;
plot(intensity)
