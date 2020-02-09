function NMN = plotNMs(NMN)

fs = NMN.fs;
colors = [0 0 1; 1 0 0; 0 0.5 0; 0.9 0.5 0; 0 0 0];


% Get NMs
W = NMN.W;
A = NMN.A;
M = getM(A);
L = size(W, 1);
H = size(W, 2);
impulse = zeros(M, 1);
impulse(1) = 1;
LB = getV(A, L, impulse);
NMs = LB * W;

[NMs, polar_val] = polarize(NMs);
NMN.NMs = NMs;

for h = 1:H
    W(:, h) = W(:, h) * polar_val(h);
end
NMN.W = W;

% Plot time domain NMs
figure
subplot(211)
for h = 1:H
    t = (1:M) ./fs ;
    set(gca, 'ColorOrder', colors(h,:));
    plot(t, NMs(:,h), 'linewidth', 3);
    hold on
end
legend('NM1', 'NM2');
xlabel('time (s)', 'fontsize', 20);
set(gca,'FontSize',20);

% Plot frequency Domain NMs
subplot(212)
NFFT = 2^nextpow2(M) * 4;
f = fs/2*linspace(0,1,NFFT/2+1);

F_NMN = [];
F_NMN_mag = [];
for h = 1:H
    F_NMN(:, h) = fft(NMs(:, h),NFFT)/M;
    F_NMN_mag(:, h) = abs(F_NMN(1:NFFT/2+1, h));
    set(gca, 'ColorOrder', colors(h,:));
    plot(f, F_NMN_mag(:, h), 'linewidth', 3);
    hold on
end
legend('NM1', 'NM2');
xlabel('frequency (Hz)', 'fontsize', 20);
xlim([0, fs/2]);
set(gca,'FontSize',20)
suptitle(['NMs Estimated by NMN '])





