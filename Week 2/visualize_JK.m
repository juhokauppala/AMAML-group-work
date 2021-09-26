%% Based on visualize_JR on 26.9. 17:30

clc; close all; clearvars;
addpath("../dataset");

%% Prep data
T = get_data();                         % pull raw mining data as table
varnames = {T};

% Convert to matlab array/matrix
time = datenum(T{:,1});     % time separate for easy use of other data
data_raw = table2array(T(:,2:end));
data = normalize(data_raw);

%% Box plot
figure
boxplot(data)
grid on

%% Statistical description
Max = max(data_raw)';
Min = min(data_raw)';
Mean = mean(data_raw)';
Median = median(data_raw)';
Mode = mode(data_raw)';
StdDev = std(data_raw)';
Variance = var(data_raw)';

stats = table(Max, Min, Mean, Median, Mode, StdDev, Variance, ...
            'RowNames', varnames)

%% Histograms
histograms = 1;
boxplots = 2;
figure;
for i = 1:size(data_raw,2)
    subplot(6,4,i)
    hist(data_raw(:,i))
    title(varnames{i})
end