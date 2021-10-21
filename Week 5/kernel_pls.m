function rsqKPLS = kernel_pls(dataX, dataY)
%PLS Summary of this function goes here
%   Detailed explanation goes here
%% Prep data
% Get data
X = dataX;
Y = dataY;

% Meta variables
m = size(X,2);

% Normalize - it's already pretreated
X = zscore(X);

%% Finding PCs
[~, ~, ~, ~, ~, PCTVAR, ~, ~] = ...
                                    plsregress(X, Y, m);
pc = find(cumsum(100*PCTVAR(2,:))/sum(PCTVAR(2,:))>95,1);

%% Compute Kernel Matrix
kerneltype = 'gaussian'; mod = "gamma"; modval = 10;    % Seems to improve with higher modval, likely overfitting
% kerneltype = 'sigmoid'; mod = "gamma"; modval = 0.1;  % 16%
% kerneltype = 'laplacian'; mod = "gamma"; modval = 0.02; % 22%
% kerneltype = 'polynomial'; mod = "degree"; modval = 4;

kfun = Kernel('type', kerneltype, mod, modval);
kmat = kfun.computeMatrix(X, X);

%% Compute K-PLS
[~, Yest, ~] = dualpls(kmat,kmat,Y,pc);

%% Get Results
TSS = sum(Y.^2);
RSS = sum((Y-Yest).^2);
rsqKPLS = 1 - RSS/TSS;
fprintf('Rsq for K-PLS = %2.2f%%\n',100*rsqKPLS);

%% Visually test fit of prediction
figure;
plot(Y, Yest, 'b.');
xlabel('Observed Response')
ylabel('Estimated Response')
title("K-PLS (PC: " + num2str(pc) + ")");
