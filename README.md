# irispie-kf-testing

Repository for testing purposes.

How to run:
- use latest irispie
- use GPM IRIS: https://github.com/IRIS-Solutions-Team/IRIS-Toolbox/releases/tag/Release-20221026
1) Python: run linear_3eq_model.py
2) Python: run linear_3eq_kf.py
3) MATLAB: run linear_3eq.m
4) In *pyt.csv: rename string "-Q" to "Q" (i.e. change "2000-Q1" to "2000Q1")
5) In *pyt.csv: rename string "__quarterly__" to "" (i.e. leave it empty)
6) In *pyt.csv: rename string "__unknown__" to "" (i.e. leave it empty)
7) MATLAB: run compare_results.m

Do the same for 1eq models as well.

