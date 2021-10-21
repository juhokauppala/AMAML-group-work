%% BM20A6100 Advanced Data Analysis and Machine Learning
%  Project work
%  Mining process B2
%  Juho Kauppala
%  Joshua Reeder

%% Read data
clc; clearvars; close all;
addpath("dataset");

raw_data = get_data();

%% Week 2 (visualization)
addpath("Week 2");
visualize(raw_data);

%% Week 3 (pretreatment)
addpath("Week 3");
[pretreated_dataX, pretreated_dataY] = pretreat(raw_data);

%% Week 5 (modeling)
addpath("Week 5");
results.pls = pls(pretreated_dataX, pretreated_dataY);
results.pcr = pcr(pretreated_dataX, pretreated_dataY);


results.sparse_pls = sparse_pls(pretreated_dataX, pretreated_dataY);
results.kernel_pls = kernel_pls(pretreated_dataX, pretreated_dataY);

%% Sparse PLS code
% <include>sparse_pls.m</include>
%% Sparse PLS function: S
% <include>S.m</include>
%% Sparse PLS function: find_lambda
% <include>find_lambda.m</include>
%% Sparse PLS function: update_uv
% <include>update_uv.m</include>
%% Sparse PLS function: spls (From public github implementation)
% <include>spls.m</include>