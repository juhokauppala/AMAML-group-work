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
pretreated_data = pretreat(raw_data);

%% Week 5 (modeling)
addpath("Week 5");
results.pls = pls(pretreated_data);
results.pcr = pcr(pretreated_data);

%results.spline_pls = spline_pls(pretreated_data);
results.sparse_pls = sparse_pls(pretreated_data);
results.kernel_pls = kernel_pls(pretreated_data);
