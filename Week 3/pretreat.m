function [treated] = pretreat(raw_data)
%% Get data
varnames = raw_data.varnames;
time_full = raw_data.time;
time_full = time_full - min(time_full) + 1;
nvars = length(varnames);

% Normalize
data_norm = normalize(raw_data.values);

%% Remove downtime period
% Given how much data is available, removing everything before downtime
% period could help prevent different performance from before maintainance
% affecting the result on a maintained system.

% Plot before
data_raw = raw_data.values;
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
data_norm(:,idx) = [];
varnames(idx) = [];
nvars = nvars - length(idx);

%% Outlier Removal
% PCA
[~, ~, ~, TSQUARED, ~] = pca(data_norm);

% Outliers
OUTLIER_THRESHOLD = 100;
outliers = TSQUARED >= OUTLIER_THRESHOLD;
data_outr = data_norm(~outliers, :);
p_reduced = 100*(1 - size(data_outr,1)/size(data_norm,1));

% Plot results with histograms
figure
nbins = 200;
subplot(2,1,1)
histogram(TSQUARED,nbins)
subplot(2,1,2)
histogram(TSQUARED(~outliers),nbins)
sgtitle({"Histograms of T^2 values","(Percent Reduction in Data = " + ...
                                        num2str(round(p_reduced,1)) + "%)"})

                                    
%% Average fast (20s inc) variables into 1hr inc, using 1hr inc time var
time = unique(time_full);
n = length(time);
treated = zeros(length(time),size(data_outr,2));
for t = 1:length(time)
    idxa = find(time_full == time(t),1,'first');
    idxb = find(time_full == time(t),1,'last');
    treated(t,:) = mean(data_outr(idxa:idxb,:));
end
% Align output silica conc to the previous process values that actually
% determine it:
for t = 1:length(time)-1
    treated(t,end) = treated(t+1,end);
end
treated = treated(1:end-1,:); % Remove incomplete final sample

%% Plot cleaned/treated dataset
subhists(treated, 3:7, varnames);
subhists(treated, 8:14, varnames);
subhists(treated, 15:nvars-1, varnames);
subhists(treated, [1 2 nvars], varnames);

%% functions

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
        axis([-3 3 0 inf])
    end
end

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
end
