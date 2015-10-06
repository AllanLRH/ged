function invMap = cdf2pdf( cdf )
    s = linspace(0, 1, 256);  % preallocate
    invMap = zeros(1, length(cdf));  % preallocate
    for ii = 1:length(cdf)
        invMap(ii) = find(cdf >= s(ii), 1);  % first index on the x-axis which corresponds to a value >= value of the CDF.
    end
end

