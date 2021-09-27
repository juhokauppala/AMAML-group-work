%% Pretreating data
clc; clearvars; close all;

% Get data
addpath("../dataset");
data = get_data();

% Normalize
normalized = normalize(data.values);