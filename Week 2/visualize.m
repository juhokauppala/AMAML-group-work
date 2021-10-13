%% Based on visualize_JR on 26.9. 17:30

function [] = visualize(raw_data)

%% Prep data
varnames = raw_data.varnames(2:end);

% Convert to matlab array/matrix
time = raw_data.time;     % time separate for easy use of other data
data_raw = raw_data.values(:,2:end);
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
end