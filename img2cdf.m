function cdf = img2cdf(inImg)
    % Determine if input data is image or PDF
    if all(size(inImg) > 1)
        data = double(inImg(:));
    else
        data = double(inImg);
    end
    [cnt, ~] = hist(data, 256);  % keep only counts data, discard bins
    cdf = cumsum(cnt);
    cdf = cdf./cdf(end);  % normalize comultative histogram
end
