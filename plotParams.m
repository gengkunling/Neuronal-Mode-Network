function plotParams(monitor, SA, NMN)

x = NMN.x;
y = NMN.y;
ye = NMN.ye;

%% Plot the actual inputs and outputs, predicted outputs
Nshow = 1000;
figure
Ns = length(x);
subplot(311)
stem(x(1:Ns), 'Marker', 'None');
xlim([0, Nshow]);
ylabel('x', 'fontsize', 12)
subplot(312)
stem(y(1:Ns), 'Marker', 'None');
xlabel('time(s)');
ylabel('y', 'fontsize', 12)
xlim([0, Nshow]);
subplot(313)
plot(ye(1:Ns), 'Marker', 'None');
xlabel('time(s)');
ylabel('ye')
xlim([0, Nshow]);


%% Plot the NMSE vs. iterations
figure
t = (1: SA.MON_ITR) * SA.SHRINK_SIZE;
plot(t, monitor.cost, 'linewidth', 2)
xlabel('iteration #'); ylabel('cost');
% ylim([0 1000])
disp('--------------------------------------------');

%% Plot the change of Alphas, W and TH Vs. iteration
figure
plot(t, monitor.A, 'linewidth', 2);
ylabel('Alpha');
xlabel('iteration #');
legend('alpha1', 'alpha2');


W = monitor.W;
figure
cnt = 1;
L = NMN.L;
H = NMN.H;
for l = 1:L
    for j = 1:H
        subplot(L, H, cnt)
        plot(t, reshape(W(l, j, :), SA.MON_ITR, 1), 'linewidth', 2);
        cnt = cnt + 1;
    end
end
suptitle(['W tracking curve for input #', int2str(i)]);





