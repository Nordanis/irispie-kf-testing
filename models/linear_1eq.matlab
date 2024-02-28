
!transition-variables

    y, y_tnd, diff_y_tnd
    y_gap


!shocks

    ant_shk_y_gap


!shocks

    shk_y_tnd, shk_y_gap


!parameters

    ss_diff_y_tnd
    c0_y_gap


!transition-equations

    y = y_tnd + y_gap;

    diff(y_tnd) = diff_y_tnd/4;

    diff_y_tnd = ss_diff_y_tnd + shk_y_tnd;
    % y_tnd = shk_y_tnd;

    y_gap = ...
        + c0_y_gap * y_gap{-1} ...
        + ant_shk_y_gap ...
        + shk_y_gap ...
    !! y_gap = 0;


!measurement-variables

    obs_y
    obs_y_gap
    obs_y_gap4


!measurement-equations

    obs_y = y;
    obs_y_gap = y_gap;
    obs_y_gap4 = y_gap{-4};

