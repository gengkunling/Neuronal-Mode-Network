function ye_test = get_ye_test(U_train, y, U_test, Ngd)

i_spike = find(y == 1);
i_zeros = find(y == 0);
U_sp = U_train(i_spike, :);
U_zr = U_train(i_zeros, :);
U_range(1, :) = max(U_train);
U_range(2, :) = min(U_train);
[~, ctr] = hist3(U_range, [Ngd, Ngd]);
[Z_sp, ctr] = hist3(U_sp, ctr);
[Z_zr, ~] = hist3(U_zr, ctr);
Z = Z_sp ./ (Z_sp + Z_zr);

% Probability Predictions
U_test_quant = [];
delta1 = ctr{1,1}(2) - ctr{1,1}(1);
delta2 = ctr{1,2}(2) - ctr{1,2}(1);
U_test(:, 1) = clampValue(U_test(:, 1), min(U_train(:, 1)), max(U_train(:, 1)));
U_test(:, 2) = clampValue(U_test(:, 2), min(U_train(:, 2)), max(U_train(:, 2)));
U_test_quant(:, 1) = floor((U_test(:, 1) - min(U_train(:, 1)) )./ (delta1+0.00000001)) + 1;
U_test_quant(:, 2) = floor((U_test(:, 2) - min(U_train(:, 2)) )./ (delta2+0.00000001)) + 1;
test_index = (U_test_quant(:, 2) - 1) * Ngd + U_test_quant(:, 1);
ye_test =  Z(test_index);
ye_test(isnan(ye_test)) = 0;
