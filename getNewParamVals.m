function newNMN = getNewParamVals(NMN)

Nparam = NMN.Nparam;
Nw = NMN.Nw;
newNMN = NMN;

r = floor(Nparam * rand(1)) + 1;
tmp = sign(rand(1) - 0.5);

if r <= 1
%    updata alpha
    sA = NMN.sA;
    newA = NMN.A +  tmp * sA;
    [newA, idxA]= criteriaOfA(newA, sA);
    newNMN.V = NMN.V_all(:, :, idxA);
    newNMN.A = newA;
else
    % update a random weight in W
    j = randi([1, Nw]);
    newW = NMN. W;
    newW(j) = NMN.W(j) + tmp * NMN.sW(j);
    [newW, ~] = normalize(newW); % Normalize weights
    newNMN.W = newW;
end

