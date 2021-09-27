clc; clearvars; close all;

%% Get data
addpath("../dataset");
all_data = get_data();
varnames = all_data.varnames;
time_full = all_data.time;
time_full = time_full - min(time_full) + 1;
nvars = length(varnames);

% Normalize
normalized = normalize(all_data.values);

%% Remove downtime period
% Given how much data is available, removing everything before downtime
% period could help prevent different performance from before maintainance
% affecting the result on a maintained system.

% Plot before
data_raw = all_data.values;
x = 21;
subtimeplots(time_full, data_raw, x:min(x+4-1, nvars), varnames);

% Based on histogram(time_full), the maintenance seems to be between
% 7.36772e5 and 7.36782e5
% When reset to 0, time threshold becomes 20 = min(time_full) + 19
TIME_THRESHOLD = min(time_full) + 19;
after_maintenance_filter = time_full > TIME_THRESHOLD;
after_maintenance_time = time_full(after_maintenance_filter);
after_maintenance_data = data_raw(after_maintenance_filter, :);

% To apply:
time_full = after_maintenance_time;
data_raw = after_maintenance_data;

% Plot after
subtimeplots(time_full, data_raw, x:min(x+4-1, nvars), varnames);

%% Remove Iron Outlet
% Variables got renamed in get_data() from the cleaner ones with spaces 
% we had before, we might want them back by the end
idx = find(contains(varnames,'IronConcentrate'));
normalized(:,idx) = [];
varnames(idx) = [];
nvars = nvars - length(idx);

%% Outlier Removal
% PCA
[~, ~, ~, TSQUARED, ~] = pca(normalized);

% Outliers
OUTLIER_THRESHOLD = 100;
outliers = TSQUARED >= OUTLIER_THRESHOLD;
data_without_outliers = normalized(~outliers, :);
p_reduced = 100*(1 - size(data_without_outliers,1)/size(normalized,1));

% Plot results with histograms
figure
nbins = 200;
subplot(2,1,1)
histogram(TSQUARED,nbins)
subplot(2,1,2)
histogram(TSQUARED(~outliers),nbins)
sgtitle({"Histograms of T^2 values","(Percent Reduction in Data = " + ...
                                        num2str(round(p_reduced,1)) + "%)"})
                                    
%% Time averaging fast (20s inc) variables
% inc =  5:10:length(time_full);
% data_full = data;
% time = zeros(length(inc),1);
% data = zeros(length(inc),nvars);
% fastvars = 3:21;
% i = 0;
% for t = inc
%     i = i + 1;
%     low = t-4; high = min(t+5,time_full(end));
%     time(i) = mean(time_full(low:high));
%     data(i,:) = mean(data_full(low:high, :));
% end
% % TODO reduce data size by combining very fast data. Since the output
% % variable only updates every hour, using data for every 20s is excessive.
% % Still working out how to do this tho.

%% functions

function subtimeplots(time, data, columns, names)
    figure
    width = 1;
    height = ceil(length(columns)/width);
    j = 0;
    for i = columns
        j = j + 1;
        subplot(height, width, j)
        scatter(time, data(:,i), '.')
        title(convertCharsToStrings(names{i}))
    end
end
