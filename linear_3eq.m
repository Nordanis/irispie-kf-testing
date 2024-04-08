
close all
clear

%% Load model

m = Model.fromFile("models/linear_3eq.matlab", "linear", 1, "growth", 1, "std", 0);

parameters = jsondecode(fileread("models/linear_3eq.json"));
% parameters.ss_diff_y_tnd = 0;
% parameters.std_ant_shk_y_gap = 0;
% parameters.std_ant_shk_diff_cpi = 0;
% parameters.std_ant_shk_rs = 0;

m = assign(m, parameters);

m = solve(m);
m = steady(m);

c = acf(m);
select = ["y_gap", "diff_cpi", "cpi"];
c(select, select, 1)

start_filt = qq(2000,1);
end_filt = qq(2022,4);
range = start_filt:end_filt;

%% Test on FRED data

d = databank.fromCSV("data/fred_data_for_matlab.csv");

d.obs_cpi = 100*log(d.CPI);
d.obs_y = 100*log(d.GDPC);
d.obs_rs = d.TB3M;

[~, f, ~, ~, ~, ~] = filter(m, d, range, "relative", 0);

figure; plot(range, [f.mean.y f.mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toCSV(f.mean, "data/out0_3eq_mat.csv");

%% Test on FRED data with missing periods

d.obs_cpi(qq(2021, 1):qq(2021, 4)) = NaN;
d.obs_y(qq(2020, 1):qq(2021, 4)) = NaN;

[~, f, ~, ~, ~, ~] = filter(m, d, range, "relative", 0);

figure; plot(range, [f.mean.y f.mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toCSV(f.mean, "data/out1_3eq_mat.csv");

%% Test on empty database

d = struct();

[~, f, ~, ~, ~, ~] = filter(m, d, range, "relative", 0);

figure; plot(range, [f.mean.y f.mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toCSV(f.mean, "data/out2_3eq_mat.csv");

%% Test on some random data

d = struct();
values = [1.20, 1.03, 0.91, 1.97, 0.32, 0.91, 1.41, 1.48];
d.obs_y = Series(start_filt:start_filt+length(values)-1, values);
d.obs_cpi = Series(start_filt:start_filt+3-1, [10, NaN, 12]);

[~, f, ~, ~, ~, ~] = filter(m, d, range, "relative", 0);

figure; plot(range, [f.mean.y f.mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toCSV(f.mean, "data/out3_3eq_mat.csv");

%% Test on FRED data with only one GDP observable

d = databank.fromCSV("data/fred_data_for_matlab.csv");

d.obs_cpi = 100*log(d.CPI);
d.obs_y = 100*log(d.GDPC{range(1)});
d.obs_rs = d.TB3M;

[~, f, ~, ~, ~, ~] = filter(m, d, range, "relative", 0);

figure; plot(range, [f.mean.y f.mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toCSV(f.mean, "data/out4_3eq_mat.csv");
