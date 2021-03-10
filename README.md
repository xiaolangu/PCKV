# PCKV


Data collection under local differential privacy (LDP) has been mostly studied for homogeneous data. Real-world applications often involve a mixture of different data types suchas key-value pairs, where the frequency of keys and mean of values under each key must be estimated simultaneously. For key-value data collection with LDP, it is challenging to achieve a good utility-privacy tradeoff since the data contains two dimensions and a user may possess multiple key-value pairs. There is also an inherent correlation between key and values which if not harnessed, will lead to poor utility. To address this issue, we propose a **Locally Differentially Private Correlated Key-Value (PCKV)** data collection framework that utilizes correlated perturbations to enhance utility. 

Main contributions are summarized as follows:
1. We propose the PCKV framework with two mechanisms PCKV-UE and PCKV-GRR under two baseline perturbation protocols: Unary Encoding (UE) and Generalized Randomized Response (GRR). Our scheme is non-interactive (compared with PrivKVM) as the mean of values is estimated in one round. We theoretically analyze the expectation and MSE and show its asymptotic unbiasedness.
2. We adapt the Padding-and-Sampling protocol for key-value data, which handles large domain better than the sampling protocol used in PrivKVM.
3. We show the budget composition of our correlated perturbation mechanism, which has a tighter bound than using the sequential composition of LDP.
4. We propose a near-optimal budget allocation approach with closed-form solutions for PCKV-UE and PCKV-GRR under the tight budget composition. The utility-privacy tradeoff of our scheme is improved by both the tight budget composition and the optimized budget allocation.
5. We evaluate our scheme using both synthetic and realworld datasets, which is shown to have higher utility (i.e., less MSE) than existing schemes. Results also validate the correctness of our theoretical analysis and the improvements of the tight budget composition and optimized budget allocation.



## Implementation

This is a sample code (in MATLAB) of our work [PCKV](https://www.usenix.org/system/files/sec20-gu.pdf) [USENIX Security 20']

When using this code:
1. The two implementations are PG1.m and PG2.m, which correspond to the results in Fig.1(a) and Fig.10(b) of the paper. Note that results in Fig.10 are averaged MSE of the top 50 frequent keys.
2. The code might not work in very old Matlab environment versions (my version is Matlab2018b and upper).
3. To make the running faster, the number of implementation repeats (N_repeat in the code) is set to be 1. Thus, the curves might not as smooth as the results in the paper, but they have the same trend. You can set a large number of repeats to obtain a smooth 
