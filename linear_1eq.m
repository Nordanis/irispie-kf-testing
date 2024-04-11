
close all
clear

%% Load model

m = Model.fromFile("models/linear_1eq.matlab", linear=true, growth=true, std=0);

parameters = jsondecode(fileread("models/linear_1eq.json"));
% parameters.ss_diff_y_tnd = 0;
% parameters.std_ant_shk_y_gap = 0;

m = assign(m, parameters);

m = solve(m);
m = steady(m);

start_filt = qq(2015,1);
end_filt = qq(2022,4);
range = start_filt:end_filt;

%% Test on FRED data

d = databank.fromSheet("data/obs_db.csv", includeComments=false);

f = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth", override=d);

% figure; plot(range, [f.Smooth.Mean.y f.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toSheet(f.Smooth.Mean, "test/out0_1eq_mean_mat.csv", includeComments=false); 
databank.toSheet(f.Smooth.Std, "test/out0_1eq_std_mat.csv", includeComments=false); 

%% Test on FRED data with missing periods

d.obs_y(qq(2020, 1):qq(2021, 4)) = NaN;

f = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth", override=d);

% figure; plot(range, [f.Smooth.Mean.y f.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toSheet(f.Smooth.Mean, "test/out1_1eq_mean_mat.csv", includeComments=false);
databank.toSheet(f.Smooth.Std, "test/out1_1eq_std_mat.csv", includeComments=false);

%% Test on empty database

d = struct();

f = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth", override=d);

% figure; plot(range, [f.Smooth.Mean.y f.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toSheet(f.Smooth.Mean, "test/out2_1eq_mean_mat.csv", includeComments=false);
databank.toSheet(f.Smooth.Std, "test/out2_1eq_std_mat.csv", includeComments=false);

%% Test on some random data

d = struct();
values = [1.20, 1.03, 0.91, 1.97, 0.32, 0.91, 1.41, 1.48];
d.obs_y = Series(start_filt:start_filt+length(values)-1, values);

f = kalmanFilter(m, d, range, relative=false, output="pred,filter,smooth", override=d);

% figure; plot(range, [f.Smooth.Mean.y f.Smooth.Mean.y_tnd], "LineWidth", 2); grid on; legend("Level", "Trend");
databank.toSheet(f.Smooth.Mean, "test/out3_1eq_mean_mat.csv", includeComments=false);
databank.toSheet(f.Smooth.Std, "test/out3_1eq_std_mat.csv", includeComments=false);
