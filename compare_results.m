
close all
clear

%% Load results

titles = {'all FRED', 'FRED with NaNs', 'empty', 'random', 'FRED with one GDP'};

mod = '3eq';

figure;
for i = 0:4
    pyt = databank.fromCSV(['data/out', num2str(i), '_', mod, '_pyt.csv']);
    mat = databank.fromCSV(['data/out', num2str(i), '_', mod, '_mat.csv']);
    subplot(2, 3, i + 1);
    plot([pyt.y mat.y], "linewidth", 2);
    hold on;
    plot([pyt.y_tnd mat.y_tnd], "--", "linewidth", 2)
    grid on;
    title([mod, ' y: ', titles{i + 1}]);
    hl = legend("pyt y", "mat y", "pyt y trend", "mat y trend");
    hl.Location       = 'southoutside';
    hl.Orientation    = 'horizontal';
    hl.NumColumns     = 12;
end

figure;
for i = 0:4
    pyt = databank.fromCSV(['data/out', num2str(i), '_', mod, '_pyt.csv']);
    mat = databank.fromCSV(['data/out', num2str(i), '_', mod, '_mat.csv']);
    subplot(2, 3, i + 1);
    plot([pyt.y/mat.y * 100 - 100], "linewidth", 2);
    grid on;
    title([mod, ' y pct: ', titles{i + 1}]);
    hl.Location       = 'southoutside';
    hl.Orientation    = 'horizontal';
    hl.NumColumns     = 12;
end

mod = '1eq';

figure;
for i = 0:4
    pyt = databank.fromCSV(['data/out', num2str(i), '_', mod, '_pyt.csv']);
    mat = databank.fromCSV(['data/out', num2str(i), '_', mod, '_mat.csv']);
    subplot(2, 3, i + 1);
    plot([pyt.y mat.y], "linewidth", 2);
    hold on;
    plot([pyt.y_tnd mat.y_tnd], "--", "linewidth", 2)
    grid on;
    title([mod, ' y: ', titles{i + 1}]);
    hl = legend("pyt y", "pyt y trend", "mat y", "mat y trend");
    hl.Location       = 'southoutside';
    hl.Orientation    = 'horizontal';
    hl.NumColumns     = 12;
end

figure;
for i = 0:4
    pyt = databank.fromCSV(['data/out', num2str(i), '_', mod, '_pyt.csv']);
    mat = databank.fromCSV(['data/out', num2str(i), '_', mod, '_mat.csv']);
    subplot(2, 3, i + 1);
    plot([pyt.y/mat.y * 100 - 100], "linewidth", 2);
    grid on;
    title([mod, ' y pct: ', titles{i + 1}]);
    hl.Location       = 'southoutside';
    hl.Orientation    = 'horizontal';
    hl.NumColumns     = 12;
end

