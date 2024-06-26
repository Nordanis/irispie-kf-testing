
# Short example of a linear gap model

import irispie as ir
import re
import json


## Create model object

m = ir.Simultaneous.from_file("models/linear_1eq.model", linear=True, )

with open("models/linear_1eq.model", "rt") as f:
    x = f.read()

x = re.sub(r"\[(.\d+)\]", r"{\1}", x)
x = x.replace("unanticipated-", "")
x = x.replace("anticipated-", "")
x = x.replace("#", "%", )

with open("models/linear_1eq.matlab", "wt+") as f:
    f.write(x)


## Assign parameters

parameters = dict(
    ss_diff_y=1.5,
    c0_y_gap=0.75,
    c0_y_tnd=1,
    std_shk_y_tnd=3,
    std_shk_y_gap=1.0,
)

with open("models/linear_1eq.json", "wt+") as f:
    json.dump(parameters, f, indent=4, )

m.assign(parameters, )


## Calculate steady state

m.steady()

chk = m.check_steady()

print(m.get_steady_levels(round=4, ))


## Calculate first-order solution matrices

m.solve(clip_small=False, )
sol = m._variants[0].solution

ir.save(m, "results/linear_1eq.dill", )

c, dimn = m.get_acov()
print(dimn.select(c[0], ["y_gap"]))

c, dn = m.get_acov(up_to_order=4, )
r, dn = m.get_acorr(acov=c, )

var = m._variants[0]
sol = m._variants[0].solution
cov_u = m.get_cov_unanticipated_shocks()


## Run shock simulation

start_sim = ir.ii(1)
sim_horizon = 40
end_sim = start_sim + sim_horizon - 1
sim_range = start_sim >> end_sim

deviation = True
ss_db = ir.Databox.steady(m, sim_range, deviation=deviation, )

in_db = ss_db.copy()

in_db["ant_shk_y_gap"].alter_num_variants(2, )
in_db["ant_shk_y_gap"][start_sim>>start_sim+3] = [(1, 1.5, 0.5, 0.2), 0]

in_db["shk_y_gap"].alter_num_variants(2, )
in_db["shk_y_gap"][start_sim>>start_sim+3] = [0, (1, 1.5, 0.5, 0.2)]

sim_db, *_ = m.simulate(in_db, sim_range, deviation=deviation, num_variants=2, )


## Plot results

sim_ch = ir.Chartpack(
    span=start_sim-1>>end_sim,
    highlight=start_sim>>start_sim+3,
    legend=["Anticipated", "Unanticipated"],
)

fig = sim_ch.add_figure("Anticipated vs. unanticipated", )

fig.add_charts((
    "Output gap: y_gap",
    "Anticipated output gap shocks: ant_shk_y_gap",
    "Unanticipated output gap shocks: shk_y_gap",
))

# sim_ch.plot(sim_db, )


## Load data from a CSV file

fred_db = ir.Databox.from_sheet(
    "data/fred_data.csv",
    description_row=True,
)


## Preprocess data

fred_db["y"] = 100*ir.log(fred_db["GDPC"])
fred_db["y_tnd"], fred_db["y_gap"] = ir.hpf(fred_db["y"], )

print(fred_db)


## Plot historical data

plot_range = ir.qq(2010,1)>>ir.qq(2022,4)


hist_ch = ir.Chartpack(
    span=plot_range,
)

fig = hist_ch.add_figure("Historical data", )

fig.add_charts((
    "Output | Potential output: y | y_tnd",
    "Output gap: y_gap",
))

# hist_ch.plot(fred_db, )


# ## Run a forecast

# start_fcast = ir.qq(2021,3)
# end_fcast = ir.qq(2026,4)
# fcast_range = start_fcast >> end_fcast

# print("Necessary initial conditions")
# for i in m.get_initials(): print(i)

# mm = m.copy()
# mm.alter_num_variants(2)

# p = ir.PlanSimulate(mm, fcast_range)
# p.swap(fcast_range[0], ("y_gap", "shk_y_gap"))

# fcast_db, *_ = mm.simulate(fred_db, fcast_range, )

# fcast_ch = sim_ch.copy()
# fcast_ch.span = start_fcast-30*4 >> end_fcast
# fcast_ch.highlight = start_fcast >> end_fcast
# fcast_ch.plot(fcast_db, )


# ## Save results to a CSV file

# fcast_db.to_sheet(
# "results/linear_1eq.csv",
# frequency_span={ir.QUARTERLY: ir.qq(2000,1)>>fcast_range[-1], },
# )

