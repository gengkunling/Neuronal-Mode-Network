function [PDM, polar_val] = polarize(PDM)
[~, H] = size(PDM);
for h = 1:H
    [~, idx] = max(abs(PDM(:, h)));
    polar_val(h) = sign(PDM(idx, h));
    PDM(:, h) = PDM(:, h) * polar_val(h);
end