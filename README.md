# PCKV

This is a sample code (in MATLAB) of our work [PCKV](https://www.usenix.org/system/files/sec20-gu.pdf) which was publushed in USENIX Security 20'


When using this code:
1. The two implementations are PG1.m and PG2.m, which correspond to the results in Fig.1(a) and Fig.10(b) of the paper. Note that results in Fig.10 are averaged MSE of the top 50 frequent keys.
2. The code might not work in very old Matlab environment versions (my version is Matlab2018b and upper).
3. To make the running faster, the number of implementation repeats (N_repeat in the code) is set to be 1. Thus, the curves might not as smooth as the results in the paper, but they have the same trend. You can set a large number of repeats to obtain a smooth 
