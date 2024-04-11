
!transition-variables

y, y_tnd, diff_y_tnd
y_gap
Y


!shocks

ant_shk_y_gap


!shocks

shk_y_tnd, shk_y_gap


!parameters

ss_diff_y
c0_y_gap


!log-variables

Y


!transition-equations

y = y_tnd + y_gap;

diff_y_tnd = 4*diff(y_tnd);

diff_y_tnd = ss_diff_y + shk_y_tnd;

y_gap = ...
    + c0_y_gap * y_gap{-1} ...
    + ant_shk_y_gap ...
    + shk_y_gap ...
!! y_gap = 0;

y = 100*log(Y);
% Y = exp(y/100);


!measurement-variables

obs_y
obs_diff_y
obs_Y
obs_y_gap
obs_y_gap4


!log-variables

obs_Y


!measurement-equations

obs_y = y;
obs_diff_y = 4*diff(y);
obs_Y = Y;
obs_y_gap = y_gap;
obs_y_gap4 = y_gap{-4};

