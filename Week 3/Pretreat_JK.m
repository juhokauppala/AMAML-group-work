%% Pretreating data
clc; clearvars; close all;

% Get data
addpath("../dataset");
data = get_data();

% Normalize
normalized = normalize(data.values);

% Pca
[COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(normalized);

% Outliers
OUTLIER_THRESHOLD = 100;
outliers = TSQUARED >= OUTLIER_THRESHOLD;
data_without_outliers = normalized(~outliers, :);

