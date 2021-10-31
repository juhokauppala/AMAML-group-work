function rsqPLS = pls(dataX, dataY)
%PLS Summary of this function goes here
%   Detailed explanation goes here

%% Prep data
X = dataX;
Y = dataY;
[n, m] = size(X);

% clear temp variables
clearvars data

% Finding PCs - we're not sole finding PCs using the explained 
% variance.

m = 20; % number of consecutive measurements kept in the model
for j = 1:20
    for i = 1:(length(X)-(m+1))
        [XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(X(i:(i+m),:), Y(i:(i+m)), j);
        % resusbtitution
        yfitPLSRes = [ones(size(X(i:(i+m),:),1),1) X(i:(i+m),:)]*BETA;
        heatmapcR(i).beta = BETA;
        TSSRes = sum((Y(i:(i+m)) - mean(Y(i:(i+m)))).^2);
        RSSRes = sum((Y(i:(i+m)) - yfitPLSRes).^2);
        rsquaredRes(i) = 1 - RSSRes/TSSRes; % cal: resubstitution
    end
    meanR2(j) = nanmean(rsquaredRes'); % Aim is to see here that on average, the fitness is better
end

for i = 1:length(heatmapcR)
    for j = 1:size(X, 2)
        cdata(i,j) = heatmapcR(i).beta(j,1);
    end
end

% Use this to plot only 1 heatmap
offset_1 = 0;
% Use this to plot 10 heatmaps
offset_10 = 0:390:3900;

for offset = offset_1
    figure;
    heatmap(cdata(1 + offset:20 + offset,:)'); % Differences with time. %%put also variale name coefficients on axis next to the beta
    xlabel("Observations no."); ylabel("Beta Coefficients");
end

figure 
plot(rsquaredRes(1:20))
xlabel("Observations");
xticklabels(1:20);
ylabel("R2");

% %% PLS with PCs
% [~, ~, ~, ~, beta, ~, ~, ~] = ...
%                                     plsregress(X, Y, pc, 'cv', 10);
% yfit = [ones(n,1) X]*beta;
% TSS = sum(Y.^2);
% RSS = sum((Y-yfit).^2);
% rsqPLS = 1 - RSS/TSS;

rsqPLS = max(meanR2)*100;

fprintf('Rsq for PLS = %2.2f%%\n',rsqPLS);
end

