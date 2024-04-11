
# Test Kalman filter

import numpy as np
import irispie as ir


## Load model

model = ir.load("results/linear_1eq.dill", )

# model.assign(
#     ss_diff_y_tnd=0,
#     std_ant_shk_y_gap=0,
# )

# model.solve()
# model.steady()
# model.check_steady()

start_filt = ir.qq(2015,1)
end_filt = ir.qq(2022,4)
filt_span = start_filt >> end_filt

# Chart template

ch = ir.Chartpack(
    span=filt_span,
    legend=["Level", "Trend"],
)

fig = ch.add_figure("Level/trend comparison", )

fig.add_charts((
    "Output | Potential output: y | y_tnd",
))


## Test on FRED data

obs_db = ir.Databox.from_sheet(
    "data/obs_db.csv",
    description_row=True,
    date_creator=ir.Period.from_iso_string,
)

out, _ = model.kalman_filter(obs_db,
    filt_span,
    diffuse_factor=1e8,
    stds_from_data=True,
    shocks_from_data=True,
    prepend_initial=True, )

# ch.plot(out.smooth_med, )
s = out.smooth_med.copy()
s.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
s.to_sheet("test/out0_1eq_mean_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )
t = out.smooth_med.copy()
t.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
t.to_sheet("test/out0_1eq_std_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )


## Test on FRED data with missing periods

obs_db["obs_y"][ir.qq(2020, 1) >> ir.qq(2021, 4)] = np.nan

out, _ = model.kalman_filter(obs_db,
    filt_span,
    diffuse_factor=1e8,
    stds_from_data=True,
    shocks_from_data=True,
    prepend_initial=True, )

# ch.plot(out.smooth_med, )
s = out.smooth_med.copy()
s.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
s.to_sheet("test/out1_1eq_mean_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )
t = out.smooth_med.copy()
t.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
t.to_sheet("test/out1_1eq_std_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )


## Test on empty database

obs_db = ir.Databox()

out, _ = model.kalman_filter(obs_db,
    filt_span,
    diffuse_factor=1e8,
    stds_from_data=True,
    shocks_from_data=True,
    prepend_initial=True, )

# ch.plot(out.smooth_med, )
s = out.smooth_med.copy()
s.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
s.to_sheet("test/out2_1eq_mean_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )
t = out.smooth_med.copy()
t.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
t.to_sheet("test/out2_1eq_std_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )


## Test on some random data

obs_db = ir.Databox()
values = (1.20, 1.03, 0.91, 1.97, 0.32, 0.91, 1.41, 1.48)
obs_db["obs_y"] = ir.Series(start_date=start_filt, values=values, )

out, _ = model.kalman_filter(obs_db,
    filt_span,
    diffuse_factor=1e8,
    stds_from_data=True,
    shocks_from_data=True,
    prepend_initial=True, )

# ch.plot(out.smooth_med, )
s = out.smooth_med.copy()
s.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
s.to_sheet("test/out3_1eq_mean_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )
t = out.smooth_med.copy()
t.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
t.to_sheet("test/out3_1eq_std_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )


## Test on FRED data with only one GDP observable

obs_db = ir.Databox.from_sheet(
    "data/obs_db.csv",
    description_row=True,
    date_creator=ir.Period.from_iso_string,
)

obs_db["obs_y"] = obs_db["obs_y"](filt_span[0])

out, _ = model.kalman_filter(obs_db,
    filt_span,
    diffuse_factor=1e8,
    stds_from_data=True,
    shocks_from_data=True,
    prepend_initial=True, )

# ch.plot(out.smooth_med, )
s = out.smooth_med.copy()
s.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
s.to_sheet("test/out4_1eq_mean_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )
t = out.smooth_med.copy()
t.keep(model.get_names(kind=ir.TRANSITION_VARIABLE | ir.UNANTICIPATED_SHOCK, ))
t.to_sheet("test/out4_1eq_std_pyt.csv", description_row=False, date_formatter=ir.Period.to_iso_string, )

