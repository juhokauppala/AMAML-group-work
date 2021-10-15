%% Based on visualize_JR on 26.9. 17:30

function [] = visualize(raw_data)

%% Prep data
varnames = raw_data.varnames;

% Convert to matlab array/matrix
time = raw_data.time;     % time separate for easy use of other data
data_raw = raw_data.values;
data = normalize(data_raw);
nvars = size(data,2);

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
subhists(data_raw, 3:7, varnames);
subhists(data_raw, 8:14, varnames);
subhists(data_raw, 15:nvars-2, varnames);
subhists(data_raw, [1 2 nvars-1 nvars], varnames);

function subhists(data, columns, names)
    figure
    width = 1;
    height = ceil(length(columns)/width);
    j = 0;
    for i = columns
        j = j + 1;
        subplot(height, width, j)
        histogram(data(:,i), 100)
        title(convertCharsToStrings(names{i}))
    end
end
end
