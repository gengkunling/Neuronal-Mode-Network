function ye = get_ye(NMN)

W = NMN.W;
V = NMN.V;
U = V * W;



y = NMN.y;
Ngd = NMN.Ngd;

i_spike = find(y == 1);
i_zeros = find(y == 0);
U_sp = U(i_spike, :);
U_zr = U(i_zeros, :);
U_range(1, :) = max(U);
U_range(2, :) = min(U);
[~, ctr] = hist3(U_range, [Ngd, Ngd]);
[Z_sp, ctr] = hist3(U_sp, ctr);
[Z_zr, ~] = hist3(U_zr, ctr);
Z = Z_sp ./ (Z_sp + Z_zr);

delta1 = ctr{1,1}(2) - ctr{1,1}(1);
delta2 = ctr{1,2}(2) - ctr{1,2}(1);

U_quant(:, 1) = floor((U(:, 1) - min(U(:, 1)) )./ (delta1+0.00000001)) + 1;
U_quant(:, 2) = floor((U(:, 2) - min(U(:, 2)) )./ (delta2+0.00000001)) + 1;
idx = (U_quant(:, 2) - 1) * Ngd + U_quant(:, 1);
ye =  Z(idx);
ye(isnan(ye)) = 0;

