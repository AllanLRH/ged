function imdiff = imDifference(J, I, sigma, p)
% Calculate the gradient magnitude of J and compare it with an interplated,
% smoothed portion of the gradient magnitude of I.

    [Jx, Jy] = gradient(J);
    GJ = sqrt(Jx.^2 + Jy.^2);

    [r, c]=ndgrid(linspace(p(1), p(2), size(J, 1)), linspace(p(3), p(4), size(J, 2)));
    [Ix, Iy] = gradient(imgaussfilt(interpn(I, r, c, 'linear', NaN), sigma));
    GI = sqrt(Ix.^2 + Iy.^2);

    T = normImage(GJ) - normImage(GI);
    imdiff = mean(T(~isnan(T)).^2);
end
