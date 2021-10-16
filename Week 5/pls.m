function rsqPLS = pls(data)
%PLS Summary of this function goes here
%   Detailed explanation goes here

%% Prep data
X = data(:,1:end-1);
Y = data(:,end);
[n, m] = size(X);

% clear temp variables
clearvars data

%% Finding PCs
[~, ~, ~, ~, ~, PCTVAR, ~, ~] = ...
                                    plsregress(X, Y, m, 'cv', 30);
pc = find(cumsum(100*PCTVAR(2,:))/sum(PCTVAR(2,:))>95,1);

% figure
% plot(0:m, MSE(2,:));

%% PLS with PCs
[~, ~, ~, ~, beta, ~, ~, ~] = ...
                                    plsregress(X, Y, pc, 'cv', 30);
yfit = [ones(n,1) X]*beta;
TSS = sum(Y.^2);
RSS = sum((Y-yfit).^2);
rsqPLS = 1 - RSS/TSS;
fprintf('Rsq for PLS = %2.2f%%\n',100*rsqPLS);
end

