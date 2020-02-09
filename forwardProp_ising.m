function NMN = forwardProp_ising(NMN)

Ngd = NMN.Ngd; % No. of grid
i_spike = NMN.i_spike;
i_zeros = NMN.i_zeros;
Z = ones(Ngd, Ngd) * -1;

    W = NMN.W;
    V = NMN.V;
    U = V * W;
       
    U_sp = U(i_spike, :);
    U_zr = U(i_zeros, :);
    
    [Z_sp, ctr] = hist3(U_sp, [Ngd, Ngd]);
    [Z_zr, ~] = hist3(U_zr, ctr);
    
    Z = Z_sp ./ (Z_sp + Z_zr);
    Z(isnan(Z)) = 0;


neighbor = NMN.neighbor; 
Z_orig = Z;
Z(1, :) = [];
Z(end, :) = [];
Z(:, 1) = [];
Z(:, end) = [];
Z_all = repmat(Z(:), 1, 8);
NMN.cost =  -sum(sum(Z_all .* Z_orig(neighbor)))/(Ngd.^2);







