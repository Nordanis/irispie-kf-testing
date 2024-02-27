
# Test Kalman filter

import numpy as np
import irispie as ir


## Load model

model = ir.load("results/linear_3eq.dill", )

model.assign(
    ss_diff_y_tnd=0,
)

model.solve()
model.steady()
model.check_steady()

start_filt = ir.qq(2000,1)
end_filt = ir.qq(2022,4)
filt_span = start_filt >> end_filt
ext_filt_span = start_filt + model.max_lag >> end_filt

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
    description="US macro data from FRED",
)

obs_db["obs_cpi"] = 100*ir.log(obs_db["CPI"])
obs_db["obs_y"] = 100*ir.log(obs_db["GDPC"])
obs_db["obs_rs"] = obs_db["TB3M"]

out0, _ = model.kalman_filter(obs_db, ext_filt_span, )
ch.plot(out0["smooth_mean"], )


## Test on FRED data with missing periods

obs_db["obs_cpi"][ir.qq(2021, 1) >> ir.qq(2021, 4)] = np.nan
obs_db["obs_y"][ir.qq(2020, 1) >> ir.qq(2021, 4)] = np.nan

out1, _ = model.kalman_filter(obs_db, ext_filt_span, )
ch.plot(out1["smooth_mean"], )


## Test on empty database

obs_db = ir.Databox()

out2, _ = model.kalman_filter(obs_db, ext_filt_span, )
ch.plot(out2["smooth_mean"], )


## Test on some random data

obs_db = ir.Databox()
values = (1.20, 1.03, 0.91, 1.97, 0.32, 0.91, 1.41, 1.48)
obs_db["obs_y"] = ir.Series(start_date=start_filt, values=values, )
obs_db["obs_cpi"] = ir.Series(start_date=start_filt, values=(10, None, 12, ), )

out3, _ = model.kalman_filter(obs_db, ext_filt_span, )
ch.plot(out3["smooth_mean"], )


## Compare transition variables from the smoother and from the simulation

sim_db, *_ = model.simulate(out0["smooth_mean"], filt_span, )

variable_names = model.get_names(kind=ir.TRANSITION_VARIABLE, )

max_abs = lambda x: np.max(np.abs(x))

compare_db = ir.Databox()
for n in variable_names:
    diff = out0["smooth_mean"][n] - sim_db[n]
    compare_db[n] = diff.apply(max_abs, ) if diff else None

