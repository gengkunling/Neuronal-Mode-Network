clc;
clear all;
close all;

tic

%% Load training data
load train_data

%% Initialization of NMN model
% LVN Parameters
L = 5; % No. of Laguerre basis functions
H = 2; % No. of NMs, fixed to 2, cannot change
Ngd = 40; % The grid resolution of MDM
M = 100; % Memory length of the system
discard_idx = 1:M;

% Simulated Aneealing Related Parameters
SA.tmpt = 10;
SA.MAX_GLOBAL_ITR = 1500;
SA.MAX_LOCAL_ITR = 2e2;
SA.TOTAL_ITR = SA.MAX_GLOBAL_ITR * SA.MAX_LOCAL_ITR;
SA.COOL_CONST = 0.99;

% Step size
sA = 1e-2; sW = 1e-1 * ones(L, H);

% Construct NMN
NMN = initilize_NMN(x_train, L, H, sA, sW, y_train, fs, Ngd, M, discard_idx);
NMN.neighbor = getNeighbor(Ngd);

% Parameters for monitoring
SA.MAX_MON_ITR = 1e4;
if SA.TOTAL_ITR <= SA.MAX_MON_ITR
    SA.MON_ITR = SA.TOTAL_ITR;
    SA.SHRINK_SIZE = 1;
else
    SA.MON_ITR = SA.MAX_MON_ITR;
    SA.SHRINK_SIZE = SA.TOTAL_ITR / SA.MAX_MON_ITR;
end
monitor.A = zeros(1, SA.MON_ITR);
monitor.cost = zeros(1, SA.MON_ITR);
monitor.W = zeros(NMN.L, NMN.H, SA.MON_ITR);



%% Simulated Annealing
NMN = forwardProp_ising(NMN);
N_parallel = feature('numcores'); % No. of paramllization units, cannot exceed the no. of CPU cores
spmd(N_parallel)
    for global_itr = 1:SA.MAX_GLOBAL_ITR
        SA.tmpt = SA.tmpt * SA.COOL_CONST;
        for local_itr = 1:SA.MAX_LOCAL_ITR
            i = local_itr + (global_itr - 1) * SA.MAX_LOCAL_ITR;
            
            % Propose New Parameters values and compute that Cost
            newNMN = getNewParamVals(NMN);
            newNMN = forwardProp_ising(newNMN);
            
            % Update by Metropolis acceptance algorithm
            cost = NMN.cost;
            newCost = newNMN.cost;
            if newCost < cost
                p = 1;
            else
                p = exp((cost - newCost)/SA.tmpt);
            end
            Update = rand(1) <= p;
            if Update == 1
                NMN = newNMN;
            end
            
            % Monitor Values
            if mod(i, SA.SHRINK_SIZE) == 0
                im = floor(i / SA.SHRINK_SIZE);
                monitor.A(:, im) = NMN.A;
                monitor.cost(im) = NMN.cost;
                
                monitor.W(:, :, im) = NMN.W;
                
            end
        end
    end
end


% Collect the best results from all the parallel units
cost = [];
for i = 1:length(NMN)
    tmp = NMN{i};
    cost = [cost, tmp.cost];
end
[~, idx] = min(cost);
NMN = NMN{idx};
monitor = monitor{idx};
SA = SA{idx};

warning off


% Get the estimated output of NMN (firing prbabilities)
NMN.ye = get_ye(NMN);

% Plot the monitor parameters
plotParams(monitor, SA, NMN)

% Plot NMs
NMN = plotNMs(NMN);

% Plot MDM
plotMDM(NMN)


save training_results.mat NMN SA monitor


