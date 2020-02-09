function NMN = initilize_NMN(x_train, L, H, sA, sW, y_train, fs, Ngd, M, discard_idx)
% build the structure and intilizations of the parameters for NMN
Nd = length(x_train);                          % data length
NMN.x = x_train;                            % input of the NMN
NMN.L = L;                                % No. of Laguerre basic function
NMN.H = H;                                % No. of hidden units/NMs

NMN.W = -1 + 2 * rand(L, H);              % weight matrix of NMN
NMN.A = 0.5;                              % crtitical parameter alpha
NMN.V = zeros(Nd, L);                     % outputs of the filter bank
NMN.sA = sA;                              % step size of updating B
NMN.sW = sW;                              % step size of updating W
NMN.Nw = numel(NMN.W);                        % No. of NM weights
NMN.Nparam = NMN.Nw + 1;                 % No. of total number of parameters in NMN

% Calculate all filter bank outputs Vs for different alphas
nA = 1 / sA;
NMN.V_all = zeros(Nd, L, nA);
for i = 1:nA
    iA = i * sA;
    NMN.V_all(:, :, i) = getV(iA, L, x_train);
end
NMN.V_all(discard_idx, :, :) = [];
[NMN.A, idxA]= criteriaOfA(NMN.A, NMN.sA); 
NMN.V = NMN.V_all(:, :, idxA);


NMN.M = M;
NMN.discard_idx = discard_idx;
y_train(discard_idx) = [];
NMN.y = y_train;
NMN.x(discard_idx) = [];
NMN.Nd = length(NMN.y);            
NMN.fs = fs;
NMN.Ngd = Ngd;


NMN.i_spike = find(y_train == 1);
NMN.i_zeros = find(y_train == 0);
