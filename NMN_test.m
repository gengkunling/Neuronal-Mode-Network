clc
clear all
% close all

% Evaluate the NMN performance using the test data
load training_results.mat
load test_data.mat
V_test = getV(NMN.A, NMN.L, x_test);

% Get ROC
U_train = NMN.V * NMN.W;
discard_idx = NMN.discard_idx;
x_test(discard_idx) = [];
y_test(discard_idx) = [];
V_test(discard_idx, :) = [];
U_test = V_test * NMN.W;

figure
resolution_evaluation = 10:20:100;
for kkk = resolution_evaluation
    ye_test = get_ye_test(U_train, NMN.y, U_test, kkk);
    [fpr, tpr, th, auc] = perfcurve(y_test, ye_test, 1);
    plot(fpr, tpr, 'linewidth', 2);
    hold on
end
legend('Ngd(eval) = 10', 'Ngd(eval) = 30', 'Ngd(eval) = 50', 'Ngd(eval) = 70', 'Ngd(eval) = 90', 'location', 'southeast')
xlabel('False Positive Ratio (FPR)')
ylabel('True Positive Ratio (TPR)')
xlim([0 0.1])









