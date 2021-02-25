function [Freq,Mean] = PCKV_UE(data,N_key,l,a,b,p)


N_user = size(data,1);

% Perturbation (user-side)
counter = zeros(2,N_key+l);
if isa(data,'cell') == 1
    for i = 1:N_user       
        S = data{i};
        [key,value] = PadSample(S,N_key,l);
        x = randsrc(1,1,[[-1 1]; [(1-value)/2 (1+value)/2]]);
        y = randsrc(1,N_key+l,[[-1 1 0]; [b/2 b/2 1-b]]);
        y(key) = randsrc(1,1,[[x -x 0]; [a*p a*(1-p) 1-a]]); 
        counter(1,:) = counter(1,:) + ceil(0.5*y);
        counter(2,:) = counter(2,:) + ceil(-0.5*y);
    end
else
    for i = 1:N_user       
        key = data(i,1); value = data(i,2);
        x = randsrc(1,1,[[-1 1]; [(1-value)/2 (1+value)/2]]);
        y = randsrc(1,N_key+l,[[-1 1 0]; [b/2 b/2 1-b]]);
        y(key) = randsrc(1,1,[[x -x 0]; [a*p a*(1-p) 1-a]]); 
        counter(1,:) = counter(1,:) + ceil(0.5*y);
        counter(2,:) = counter(2,:) + ceil(-0.5*y);
    end
end

% Aggregation (server-side)
Freq = zeros(N_key,1);
Mean = nan*zeros(N_key,1);
for i = 1:N_key
    n1 = counter(1,i); n2 = counter(2,i);
    freq = ((n1+n2)/N_user-b)*l/(a-b);
    
    Freq(i) = Clip(freq,1/N_user,1);
    N = N_user*Freq(i)/l;
    
    A = [a*p-b/2 a*(1-p)-b/2; a*(1-p)-b/2 a*p-b/2];
    b_n = [n1; n2] - N_user*b/2;
    est = A\b_n;

    n1 = Clip(est(1),1,N);
    n2 = Clip(est(2),1,N);
    
    Mean(i) = (n1-n2)/N;

end

end



function [key,value] = PadSample(S,N_key,l)

N_S = size(S,1);
eta = N_S/(max(N_S,l));

if binornd(1,eta) == 1
    index = randi(N_S);
    key = S(index,1);
    value = S(index,2);
else
    key = N_key+randi(l);
    value = 0;
end

end


function x = Clip(x,lb,ub)

if x<lb
    x=lb;
end
if x>ub
    x=ub;
end

end
