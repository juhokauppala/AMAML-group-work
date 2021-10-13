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