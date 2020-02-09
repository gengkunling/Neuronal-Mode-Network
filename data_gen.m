clc
clear all
close all

Ntrain = 1024*10;
Ntest = 1024*2;
Nd = Ntrain + Ntest; 
NoiseFree = 1;
alpha = 0.7; 
y0 = 0; 
W = [-1 1 1 0 0; 1 0.5 0 1 -1;]';
L = size(W, 1); H = size(W, 2); 
[W, ~] = polarize(W);

% Generate inputs and outputs
thetax = 0.9; 
x = double(rand(Nd, 1) > thetax);



figure
subplot(511)
stem(x, 'Marker', 'None');
ylabel('x')


V = getV(alpha, L, x);
U = V * W;
u1 = U(:, 1);
u2 = U(:, 2);
t = 1:length(u1);
subplot(512)
plot(t, u1, t, u2, 'linewidth', 2)
ylabel('u')



thetay = 3;
 
yc = u1 - u2 - u1.^2 + u2.^3 - u1.*u2.^2 + 10 * u1.^3 .* u2.^2;

z = double(yc > thetay);

ns = 0.5;
N_spike = sum(z == 1);
rn = rand(Nd, 1);
n_th = 1 - (N_spike * ns) / Nd;
n = double(rn > n_th);

y = double(z + n >= 1);




subplot(513)
stem(z, 'Marker', 'None')
ylabel('z');

subplot(514)
stem(n, 'Marker', 'None')
ylabel('n');

subplot(515)
stem(y, 'Marker', 'None');
ylabel('y')



M = getM(alpha);
impulse = zeros(M, 1);
impulse(1) = 1;
LB = getV(alpha, L, impulse);
True_PDM = LB * W;
colors = [0 0 1; 1 0 0; 0 0.5 0; 0.9 0.5 0; 0 0 0];
fs = 200;

figure
subplot(211)
for h = 1:H
    t = (1:M) ./fs *1000 ;
    set(gca, 'ColorOrder', colors(h,:));
    plot(t, True_PDM(:,h), 'linewidth', 2);
    hold on
end
legend('NM 1', 'NM 2');
xlabel('time (ms)', 'fontsize', 12);


% Plot frequency Domain PDMs
subplot(212)
NFFT = 2^nextpow2(M) * 4;
f = fs/2*linspace(0,1,NFFT/2+1);

F_LVN = [];
F_LVN_mag = [];
for h = 1:H
    F_LVN(:, h) = fft(True_PDM(:, h),NFFT)/M;
    F_LVN_mag(:, h) = abs(F_LVN(1:NFFT/2+1, h));
    set(gca, 'ColorOrder', colors(h,:));
    plot(f, F_LVN_mag(:, h), 'linewidth', 2);
    hold on
end
xlabel('frequency (Hz)', 'fontsize', 12);

x_train = x(1:Ntrain);
y_train = y(1:Ntrain);
x_test = x(Ntrain+1:end);
y_test = y(Ntrain+1:end);

save train_data.mat x_train  y_train fs 
save test_data.mat x_test  y_test fs