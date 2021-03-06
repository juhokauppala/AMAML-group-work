function [data] = read_data_from_csv()
%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: C:\Users\juhok\AppData\Local\Temp\temp8257800883906076237tmp\MiningProcess_Flotation_Plant_Database.csv
%
% Auto-generated by MATLAB on 24-Sep-2021 14:30:24

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 24);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["date", "IronFeed", "SilicaFeed", "StarchFlow", "AminaFlow", "OrePulpFlow", "OrePulpPH", "OrePulpDensity", "FlotationColumn01AirFlow", "FlotationColumn02AirFlow", "FlotationColumn03AirFlow", "FlotationColumn04AirFlow", "FlotationColumn05AirFlow", "FlotationColumn06AirFlow", "FlotationColumn07AirFlow", "FlotationColumn01Level", "FlotationColumn02Level", "FlotationColumn03Level", "FlotationColumn04Level", "FlotationColumn05Level", "FlotationColumn06Level", "FlotationColumn07Level", "IronConcentrate", "SilicaConcentrate"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["IronFeed", "SilicaFeed", "StarchFlow", "AminaFlow", "OrePulpFlow", "OrePulpPH", "OrePulpDensity", "FlotationColumn01AirFlow", "FlotationColumn02AirFlow", "FlotationColumn03AirFlow", "FlotationColumn04AirFlow", "FlotationColumn05AirFlow", "FlotationColumn06AirFlow", "FlotationColumn07AirFlow", "FlotationColumn01Level", "FlotationColumn02Level", "FlotationColumn03Level", "FlotationColumn04Level", "FlotationColumn05Level", "FlotationColumn06Level", "FlotationColumn07Level", "IronConcentrate", "SilicaConcentrate"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["IronFeed", "SilicaFeed", "StarchFlow", "AminaFlow", "OrePulpFlow", "OrePulpPH", "OrePulpDensity", "FlotationColumn01AirFlow", "FlotationColumn02AirFlow", "FlotationColumn03AirFlow", "FlotationColumn04AirFlow", "FlotationColumn05AirFlow", "FlotationColumn06AirFlow", "FlotationColumn07AirFlow", "FlotationColumn01Level", "FlotationColumn02Level", "FlotationColumn03Level", "FlotationColumn04Level", "FlotationColumn05Level", "FlotationColumn06Level", "FlotationColumn07Level", "IronConcentrate", "SilicaConcentrate"], "DecimalSeparator", ",");

% Import the data
table_data = readtable("MiningProcess_Flotation_Plant_Database.csv", opts);

%% Convert to output type
data.time = datenum(table_data{:,1});
data.varnames = table_data.Properties.VariableNames(2:end);
data.values = table2array(table_data(:, 2:end));

%% Clear temporary variables
clear opts
end

