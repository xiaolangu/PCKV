% real-world data

% Plot setting
clc; clear; close all;
set(0,'defaulttextinterpreter','latex'); 
set(0,'defaultlinelinewidth',1.5); 
set(0,'DefaultLineMarkerSize',8); 
set(0,'DefaultTextFontSize', 14); 
set(0,'DefaultAxesFontSize',14); 



%% load data: (data, N_user, N_key)
load data_clothing_rating.mat; l=2; 



[Freq, Mean] = true_result(data,N_user,N_key);


%% Algorithms
Epsilon = [0.1 1:6];
N_epsilon = length(Epsilon);
N_alg = 2;
N_round = N_alg*N_epsilon;

mse_f = cell(N_round,1);
mse_m = cell(N_round,1);

N_repeat = 1;

for index = 1:N_round
    
    t = ceil(index/N_epsilon);
    i = mod(index-1,N_epsilon) + 1;
    epsilon = Epsilon(i);   
    
    temp_f = zeros(N_key,N_repeat);
    temp_m = zeros(N_key,N_repeat);
    
   for j = 1:N_repeat       
       switch t
           case 1
               a = 0.5; b = 2/(exp(epsilon)+3); p = exp(epsilon)/(exp(epsilon)+1);
               [freq, mean] = PCKV_UE(data,N_key,l,a,b,p);
           case 2
                a = (l*(exp(epsilon)-1)+2)/(l*(exp(epsilon)-1)+2*(N_key+l)); 
                b = (1-a)/(N_key+l-1); 
                p = (l*(exp(epsilon)-1)+1)/(l*(exp(epsilon)-1)+2);
                [freq, mean] = PCKV_GRR(data,N_key,l,a,b,p); 
       end
        
        temp_f(:,j) = (freq-Freq).^2;
        temp_m(:,j) = (mean-Mean).^2;          
   end   
    
   mse_f{index} = sum(temp_f,2)/N_repeat;
   mse_m{index} = sum(temp_m,2)/N_repeat;
   
end


N_top = 50;
tab = sortrows([(1:N_key)' Freq],2,'descend');
top_index = tab(1:N_top,1);
MSE_freq = zeros(N_alg,N_epsilon);
MSE_mean = zeros(N_alg,N_epsilon);
for index = 1:N_round
    t = ceil(index/N_epsilon);
    i = mod(index-1,N_epsilon) + 1;
    MSE_freq(t,i) = sum(mse_f{index}(top_index))/N_top;
    MSE_mean(t,i) = sum(mse_m{index}(top_index))/N_top;

end




%% Plot
figure;
ah1 = TightPlots(1, 2, 900,[10 7],[60,70],[50,10],[70,15],'pixels');

axes(ah1(1));
plot(Epsilon,MSE_freq,'*-'); hold on;
set(gca, 'YScale', 'log');
legend('PCKV-UE','PCKV-GRR');
xticks(Epsilon);
xlabel('$\epsilon$');
ylabel('Averaged MSE of ${\hat{f}_k}$');


axes(ah1(2));
plot(Epsilon,MSE_mean,'*-'); hold on;
set(gca, 'YScale', 'log');
legend('PCKV-UE','PCKV-GRR');
xticks(Epsilon);
xlabel('$\epsilon$');
ylabel('Averaged MSE of ${\hat{m}_k}$');


    

    
