
close all
clear

%% Load results

titles = {'all FRED', 'FRED with NaNs', 'empty', 'random'};
mods = {'3eq'}; % '1eq'

for i = 1:length(mods)
    mod = mods{i};

    figure;
    for i = 0:3
        pyt = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_pyt.csv'], includeComments=false);
        mat = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_mat.csv'], includeComments=false);
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
    for i = 0:3
        pyt = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_pyt.csv'], includeComments=false);
        mat = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_mat.csv'], includeComments=false);
        subplot(2, 3, i + 1);
        plot([pyt.y/mat.y * 100 - 100], "linewidth", 2);
        grid on;
        title([mod, ' y pct: ', titles{i + 1}]);
    end

    figure;
    for i = 0:3
        pyt = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_pyt.csv'], includeComments=false);
        mat = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_mat.csv'], includeComments=false);
        subplot(2, 3, i + 1);
        plot([pyt.shk_y_gap mat.shk_y_gap], "linewidth", 2);
        grid on;
        title([mod, ' shk y gap: ', titles{i + 1}]);
        hl = legend("pyt y", "mat y");
        hl.Location       = 'southoutside';
        hl.Orientation    = 'horizontal';
        hl.NumColumns     = 12;
    end

    figure;
    for i = 0:3
        pyt = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_pyt.csv'], includeComments=false);
        mat = databank.fromSheet(['test/out', num2str(i), '_', mod, '_mean_mat.csv'], includeComments=false);
        subplot(2, 3, i + 1);
        plot([pyt.shk_y_gap/mat.shk_y_gap * 100 - 100], "linewidth", 2);
        grid on;
        title([mod, ' shk y gap pct: ', titles{i + 1}]);
    end
end
