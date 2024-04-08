
# Test Kalman filter

import numpy as np
import irispie as ir


## Load model

model = ir.load("results/linear_1eq.dill", )

# model.assign(
#     ss_diff_y_tnd=0,
#     std_ant_shk_y_gap=0,
# )

model.solve()
model.steady()
model.check_steady()

start_filt = ir.qq(2000,1)
end_filt = ir.qq(2022,4)
filt_span = start_filt >> end_filt
ext_filt_span = start_filt >> end_filt

# Chart template

ch = ir.Chartpack(
    span=ext_filt_span,
    legend=["Level", "Trend"],
)

fig = ch.add_figure("Level/trend comparison", )

fig.add_charts((
    "Output | Potential output: y | y_tnd",
))


## Test on FRED data

obs_db = ir.Databox.from_sheet(
    "data/fred_data_for_python.csv",
    description_row=True,
)

obs_db["obs_y"] = 100*ir.log(obs_db["GDPC"])

out, _ = model.kalman_filter(obs_db,
                              ext_filt_span,
                              diffuse_factor=1e8,
                              stds_from_data=True,
                              shocks_from_data=True,
                              prepend_initial=True,
                              )
ch.plot(out.smooth_med, )
out.smooth_med.to_sheet("data/out0_1eq_pyt.csv")


## Test on FRED data with missing periods

obs_db["obs_y"][ir.qq(2020, 1) >> ir.qq(2021, 4)] = np.nan

out, _ = model.kalman_filter(obs_db,
                              ext_filt_span,
                              diffuse_factor=1e8,
                              stds_from_data=True,
                              shocks_from_data=True,
                              prepend_initial=True,
                              )
ch.plot(out.smooth_med, )
out.smooth_med.to_sheet("data/out1_1eq_pyt.csv")


## Test on empty database

obs_db = ir.Databox()

out, _ = model.kalman_filter(obs_db,
                              ext_filt_span,
                              diffuse_factor=1e8,
                              stds_from_data=True,
                              shocks_from_data=True,
                              prepend_initial=True,
                              )
ch.plot(out.smooth_med, )
out.smooth_med.to_sheet("data/out2_1eq_pyt.csv")


## Test on some random data

obs_db = ir.Databox()
values = (1.20, 1.03, 0.91, 1.97, 0.32, 0.91, 1.41, 1.48)
obs_db["obs_y"] = ir.Series(start_date=start_filt, values=values, )

out, _ = model.kalman_filter(obs_db,
                              ext_filt_span,
                              diffuse_factor=1e8,
                              stds_from_data=True,
                              shocks_from_data=True,
                              prepend_initial=True,
                              )
ch.plot(out.smooth_med, )
out.smooth_med.to_sheet("data/out3_1eq_pyt.csv")


## Test on FRED data with only one GDP observable

obs_db = ir.Databox.from_sheet(
    "data/fred_data_for_python.csv",
    description_row=True,
)

obs_db["obs_y"] = 100*ir.log(obs_db["GDPC"][ext_filt_span[0]])
obs_db["obs_diff_y"] = ir.diff(100*ir.log(obs_db["GDPC"]), -1)

out, _ = model.kalman_filter(obs_db,
                              ext_filt_span,
                              diffuse_factor=1e8,
                              stds_from_data=True,
                              shocks_from_data=True,
                              prepend_initial=True,
                              )
ch.plot(out.smooth_med, )
out.smooth_med.to_sheet("data/out4_1eq_pyt.csv")


## Compare transition variables from the smoother and from the simulation

sim_db, *_ = model.simulate(out.smooth_med, filt_span, )

variable_names = model.get_names(kind=ir.TRANSITION_VARIABLE, )

max_abs = lambda x: np.max(np.abs(x))

compare_db = ir.Databox()
for n in variable_names:
    diff = out.smooth_med[n] - sim_db[n]
    compare_db[n] = diff.apply(max_abs, ) if diff else None
    if compare_db[n] > 1e-12:
        print(f"{n} difference > 1e-12 ({compare_db[n]})")

