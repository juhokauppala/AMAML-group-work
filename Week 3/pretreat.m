function [treated] = pretreat(raw_data)
%% Get data
varnames = raw_data.varnames;
time_full = raw_data.time;
time_full = time_full - min(time_full) + 1;
nvars = length(varnames);

%% Remove downtime period
% Given how much data is available, removing everything before downtime
% period could help prevent different performance from before maintainance
% affecting the result on a maintained system.

% Plot before
data_raw = raw_data.values;
subtimeplots(time_full, data_raw(:,[1:4 end]), varnames([1:4 end]));

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
subtimeplots(time_full, data_raw(:,[1:4 end]), varnames([1:4 end]));

%% Remove Iron Outlet
% Variables got renamed in get_data() from the cleaner ones with spaces 
% we had before, we might want them back by the end
idx = find(contains(varnames,'IronConcentrate'));
data_raw(:,idx) = [];
varnames(idx) = [];
nvars = nvars - 1;

%% Outlier Removal
% PCA
[~, ~, ~, TSQUARED, ~] = pca(normalize(data_raw));

% Outliers
OUTLIER_THRESHOLD = 100;
outliers = TSQUARED >= OUTLIER_THRESHOLD;
data_outr = data_raw(~outliers, :);
time_full = time_full(~outliers, :);
p_reduced = 100*(1 - size(data_outr,1)/size(data_raw,1));
fprintf('Dataset reduced by %2.2f%% with outlier removal\n',p_reduced);


% Plot results with histograms
% figure
% nbins = 200;
% subplot(2,1,1)
% histogram(TSQUARED,nbins)
% subplot(2,1,2)
% histogram(TSQUARED(~outliers),nbins)
% sgtitle({"Histograms of T^2 values","(Percent Reduction in Data = " + ...
%                                         num2str(round(p_reduced,1)) + "%)"})

%% Average fast (20s inc) variables into 1hr inc, using 1hr inc time var
time = unique(time_full);
n = length(time);
treated = zeros(length(time),size(data_outr,2));
for t = 1:n
    idxa = find(time_full == time(t),1,'first');
    idxb = find(time_full == time(t),1,'last');
    treated(t,:) = mean(data_outr(idxa:idxb,:));
end
% CANCELLED - DOING THIS WORSENS RESULTS, DATA MUST ALREADY BE ADJUSTED.
% Align output silica conc to the previous process values that actually
% determine it:
% lag = 1;    % hrs lag time before pred var affected
% for t = 1:n-lag
%     treated(t,end) = treated(t+lag,end);
% end
% treated = treated(1:end-lag,:); % Remove incomplete final sample(s)
% time = time(1:end-lag,:);       % Remove incomplete final sample(s)

%% Normalize cleaned data
treated = normalize(treated);

%% Plot cleaned/treated dataset
subhists(treated, 3:7, varnames);
subhists(treated, 8:14, varnames);
subhists(treated, 15:nvars-1, varnames);
subhists(treated, [1 2 nvars], varnames);

% Time plot after
subtimeplots(time, treated(:,[1:4 end]), varnames([1:4 end]));

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

function subtimeplots(time, data, names)
    figure
    width = 1;
    height = ceil(size(data,2)/width);
    j = 0;
    for i = 1:height*width
        j = j + 1;
        subplot(height, width, j)
        plot(time, data(:,i))
        title(convertCharsToStrings(names{i}))
    end
end
end
