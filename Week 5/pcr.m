function rsqPCR = pcr(dataX, dataY)
%PCR Summary of this function goes here
%   Detailed explanation goes here

%% Prep data
X = dataX;
Y = dataY;
[n, ~] = size(dataX);

%% Get Principle Components (PCA)
[PCALoadings, PCAScores, ~, ~, Expl] = pca(X, 'Economy', false);
                                            % ^ Important to set to false
% Get num PC to explain >95% of var
% figure;
% plot(1:10, 100*cumsum(PCAVar(1:10))/sum(PCAVar(1:10)));
% xlabel('Num of PC')
% ylabel('Explained Variance in X');
pc = find(100*cumsum(Expl)/sum(Expl)>=95,1,'first');

%% Principle Component Regression
% Get regression factors for each PC
betaPCR = regress(Y, PCAScores(:,1:pc));

% Transform B's from PCs to Beta Coefficients for actual vars
betaPCR = PCALoadings(:,1:pc)*betaPCR;
betaPCR = [mean(Y) - mean(X)*betaPCR; betaPCR];

% Generate prediction
yfitPCR = [ones(n,1) X]*betaPCR;

% Visually test fit of prediction
figure;
plot(Y, yfitPCR, 'bo');
xlabel('Observed Response')
ylabel('Fitted Response')
title("PCR (PC: " + num2str(pc) + ")");

% Find statistical r^2
TSS = sum(Y.^2);
RSS = sum((Y - yfitPCR).^2);
rsqPCR = 1 - RSS/TSS;
fprintf('Rsq for PCR = %2.2f%%\n',100*rsqPCR);

end
