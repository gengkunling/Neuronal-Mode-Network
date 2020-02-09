function neighbor = getNeighbor(N)
[idx, idy] = ind2sub(N,[1:N.^2]);
idx = reshape(idx, N, N);
idy = reshape(idy, N, N);
idx(1, :) = [];
idx(end, :) = [];
idx(:, 1) = [];
idx(:, end) = [];
idy(1, :) = [];
idy(end, :) = [];
idy(:, 1) = [];
idy(:, end) = [];

nb1.idx = idx;
nb1.idy = idy + 1;

nb2.idx = idx + 1;
nb2.idy = idy;

nb3.idx = idx;
nb3.idy = idy - 1;

nb4.idx = idx - 1;
nb4.idy = idy;

nb5.idx = idx + 1;
nb5.idy = idy + 1;

nb6.idx = idx - 1;
nb6.idy = idy - 1;

nb7.idx = idx - 1;
nb7.idy = idy + 1;

nb8.idx = idx + 1;
nb8.idy = idy - 1;


for i= 1:8
    eval(['idx_n = nb', int2str(i), '.idx(:);']);
    eval(['idy_n = nb', int2str(i), '.idy(:);']);
    neighbor(:, i) = sub2ind([N, N], idx_n, idy_n);
end


