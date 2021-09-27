%% Pretreating data
clc; clearvars; close all;

% Get data
addpath("../dataset");
data = get_data();

% Normalize
normalized = normalize(data.values);

%% Removing outliers
% Pca
[~, ~, ~, TSQUARED, ~] = pca(normalized);

% Outliers
OUTLIER_THRESHOLD = 100;
outliers = TSQUARED >= OUTLIER_THRESHOLD;
data_without_outliers = normalized(~outliers, :);

%% Pretreat
% Pca without outliers

% Wait what do we actually do here?

