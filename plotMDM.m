function plotMDM(NMN)
Ngd = NMN.Ngd;
y = NMN.y;


i_spike = find(y == 1);
i_zeros = find(y == 0);


W = NMN.W;
V = NMN.V;
U = V * W;
U_quant = zeros(size(U));
H = NMN.H;
A = NMN.A;
L = NMN.L;
M = getM(A);

for h = 1:H
    u = U(:, h);
    min_u(h)  = min(u);
    max_u(h)  = max(u);
    range = linspace(min_u(h), max_u(h), Ngd);
    delta(h) = range(2) - range(1);
    U_quant(:, h) = round((u - min_u(h) )./ delta(h)) + 1;
end



u1 = U(i_spike, 1);
u2 = U(i_spike, 2);

figure
scatter(u1, u2, 'x', 'r');
hold on

o1 = U(i_zeros, 1);
o2 = U(i_zeros, 2);
gg = scatter(o1, o2, 'b');
legend('spike', 'zeros');
title('Scatter Plot', 'fontsize', 20)
xlim([min_u(1), max_u(1)])
ylim([min_u(2), max_u(2)])
gca_cp = gca;

U_sp_quant = U_quant(i_spike, :);
U_trigger = unique(U_sp_quant, 'rows'); % Table for trigger region
[~, s2] = ismember(U_sp_quant, U_trigger, 'rows');
spike_t = s2(s2 ~= 0);
N_spike_t = hist(spike_t, unique(spike_t));

U_zr_quant = U_quant(i_zeros, :);
U_non_trigger = unique(U_zr_quant, 'rows'); % Table for non-trigger region
[~, s4] = ismember(U_zr_quant, U_trigger, 'rows');
spike_f = s4(s4 ~= 0);
N_spike_f = hist(spike_f, unique(spike_t));

p_spike =   N_spike_t ./ (N_spike_t + N_spike_f);

ZZ = ones(Ngd) * (-0.2);
for i = 1:length(U_non_trigger)
    ZZ( Ngd - U_non_trigger(i, 2) + 1,  U_non_trigger(i, 1)) = 0;
end

for i = 1:length(U_trigger)
    ZZ( Ngd - U_trigger(i, 2) + 1,  U_trigger(i, 1)) = p_spike(i);
end

figure
[cmap]=buildcmap('wbcgyr');
imagesc(ZZ)
colormap(cmap)

x_tick = (get(gca_cp, 'XTick') - min_u(1))/ delta(1) + 1;
set(gca, 'XTick', x_tick, 'fontsize', 20);
set(gca, 'XTickLabel', get(gca_cp, 'XTickLabel'));

y_tick = (get(gca_cp, 'YTick') - min_u(2))/ delta(2);
y_tick = fliplr(Ngd - y_tick);
set(gca, 'YTick', y_tick, 'fontsize', 14);
set(gca, 'YTickLabel', flipud(get(gca_cp, 'YTickLabel')));
title('MDM', 'fontsize', 14)
xlabel('u1', 'fontsize', 14)
ylabel('u2', 'fontsize', 14)
h = colorbar;
set(h, 'ylim', [0 , 1])
ylabel(h, 'p', 'fontsize', 14);












