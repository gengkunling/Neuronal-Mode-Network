clc
clear all
load NHPDan-041012-TH-CSP-5msBin.mat
Nd = size(CA3spikes_CSP, 3);
Ntrial = size(CA3spikes_CSP, 2);
zero_buffer = zeros(Nd, 1);
x1_all = [];
x2_all = [];
y1_all = [];
y2_all = [];

r = 1;
zeros_idx = [];
for i = 1:40
    x1 = CA3spikes_CSP(1, i, :);
    x2 = CA3spikes_CSP(2, i, :);
    y1 = CA1spikes_CSP(1, i, :);
    y2 = CA1spikes_CSP(2, i, :);
    x1_all = [x1_all; squeeze(x1)] ;
    x2_all = [x2_all; squeeze(x2)] ;
    y1_all = [y1_all; squeeze(y1)] ;
    y2_all = [y2_all; squeeze(y2)] ;
    x1_all = [x1_all; zero_buffer];
    x2_all = [x2_all; zero_buffer];
    y1_all = [y1_all; zero_buffer];
    y2_all = [y2_all; zero_buffer];
    zeros_idx = [zeros_idx, r * Nd + 1 : (r + 1) * Nd];
    r = r + 2;
end

Nt = (r - 1) / 2;
save('train_10set', 'x1_all', 'x2_all', 'y1_all', 'y2_all', 'Nt', 'deltaT', 'zeros_idx');

% save('data_test_set', 'x1_all', 'x2_all', 'y1_all', 'y2_all', 'Nt', 'deltaT');