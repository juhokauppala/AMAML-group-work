function [result] = pcr(data)
%PCR Summary of this function goes here
%   Detailed explanation goes here
%% Prep data
X = data(:,1:end-1);
Y = data(:,end);
[n m] = size(data);
Yc = Y - mean(Y);

%% Get Principle Components (PCA)
[PCALoadings, PCAScores, PCAVar] = pca(X, 'Economy', false);
                                            % ^ Important to set to false
% Get num PC to explain >95% of var
% figure;
% plot(1:10, 100*cumsum(PCAVar(1:10))/sum(PCAVar(1:10)));
% xlabel('Num of PC')
% ylabel('Explained Variance in X');
pc = find(100*cumsum(PCAVar(1:10))>90,1,'first');

%% NEW CONTENT - Principle Component Regression
% Step 2: Get regression factors for each of the 4 PCs
betaPCR = regress(Yc, PCAScores(:,1:pc));

% Step 3: Transform B's from PCs to Beta Coefficients for actual vars
betaPCR = PCALoadings(:,1:pc)*betaPCR;
betaPCR = [mean(Y) - mean(X)*betaPCR; betaPCR];

% Step 4: Generate prediction
yfitPCR = [ones(n,1) X]*betaPCR;

% Visually test fit of prediction
figure;
plot(Yc, yfitPCR, 'bo');
xlabel('Observed Response')
ylabel('Fitted Response')

% Find statistical r^2
TSS = sum(Yc.^2);
RSS = sum((Y - yfitPCR).^2);
rsqPCR = 1 - RSS/TSS

%% Compute result
result = [];
end
