clc; close all; clear;
addpath("../dataset");

%% Prep data
load T                         % Load dataset as table
load varnames                  % Load cell array of variable names

% Convert to matlab array/matrix
time = datenum(T{:,1});     % time separate for easy use of other data
data_raw = table2array(T(:,2:end));
data = normalize(data_raw);
nvars = size(data,2);

%% Box plot
figure
boxplot(data, 'Labels', varnames, 'Orientation', 'horizontal')
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

clearvars Max Min Mean Median Mode StdDev Variance

%% Histograms
% figure
% for i = 1:nvars
%     subplot(4,6,i)
%     hist(data_raw(:,i), 100)
%     title(convertCharsToStrings(varnames{i}))
% end

subhists(data_raw, 3:7, varnames);
subhists(data_raw, 8:14, varnames);
subhists(data_raw, 15:21, varnames);
subhists(data_raw, [1 2 nvars-1 nvars], varnames);

%% Save
save('imported_data.mat','data','data_raw','stats','T','time','varnames') 

%% Functions

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
