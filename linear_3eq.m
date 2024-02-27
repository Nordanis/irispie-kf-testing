
close all
clear

%% Load model

m = Model.fromFile("models/linear_3eq.matlab", linear=true, growth=true, std=0);

parameters = jsondecode(fileread("models/linear_3eq.json"));
parameters.ss_diff_y_tnd = 0;

m = assign(m, parameters);

m = solve(m);
m = steady(m);

c = acf(m);
select = ["y_gap", "diff_cpi", "cpi"];
c(select, select, 1)

range = qq(2000,1)-4:qq(2022,4);

%% Test on FRED data

d = databank.fromCSV("data/fred_data_for_matlab.csv");

d.obs_cpi = 100*d.CPI;
d.obs_y = 100*d.GDPC;
d.obs_rs = d.TB3M;

f0 = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth");

figure; plot(range, [f0.Smooth.Mean.y f0.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");

%% Test on FRED data with missing periods

d.obs_cpi(qq(2021, 1):qq(2021, 4)) = NaN;
d.obs_y(qq(2020, 1):qq(2021, 4)) = NaN;

f1 = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth");

figure; plot(range, [f1.Smooth.Mean.y f1.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");

%% Test on empty database

d = struct();

f2 = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth");

figure; plot(range, [f2.Smooth.Mean.y f2.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");

%% Test on some random data

d = struct();
values = [1.20, 1.03, 0.91, 1.97, 0.32, 0.91, 1.41, 1.48];
d.obs_y = Series(range(1):range(1)+length(values)-1, values);
d.obs_cpi = Series(range(1):range(1)+2, [10, NaN, 12]);

f3 = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth");

figure; plot(range, [f3.Smooth.Mean.y f3.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");

