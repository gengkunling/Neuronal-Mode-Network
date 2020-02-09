function M = getM(alpha)
M = (-30 - log(1-alpha)) ./ log(alpha);
M = ceil(M);