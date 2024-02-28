
close all
clear

%% Load model

m = Model.fromFile("models/linear_1eq.matlab", linear=true, growth=true, std=0);

parameters = jsondecode(fileread("models/linear_1eq.json"));
parameters.ss_diff_y_tnd = 0;
parameters.std_ant_shk_y_gap = 0;

m = assign(m, parameters);

m = solve(m);
m = steady(m);

c = acf(m);
select = ["y_gap"];
c(select, select, 1)

start_filt = qq(2000,1);
end_filt = qq(2022,4);
range = start_filt-4:end_filt;

%% Test on FRED data

d = databank.fromCSV("data/fred_data_for_matlab.csv");

d.obs_y = 100*log(d.GDPC);

f0 = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth");

figure; plot(range, [f0.Smooth.Mean.y f0.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");

%% Test on FRED data with missing periods

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
d.obs_y = Series(start_filt:start_filt+length(values)-1, values);

f3 = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth");

figure; plot(range, [f3.Smooth.Mean.y f3.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");

