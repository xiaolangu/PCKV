function [Freq, Mean] = KVUE(data,N_key,epsilon)

p = exp(epsilon)/(exp(epsilon)+2); % perturb into itself among three states
q = 1/(exp(epsilon)+2); 
Freq = zeros(N_key,1);
Mean = zeros(N_key,1);


%% Perturb
if isa(data,'cell') == 1
    counter = Perturb_cell(data,N_key,p,q);
else
    counter = Perturb_matrix(data,N_key,p,q);
end

for i = 1:N_key
    N = counter(3,i);
    n1 = (2*counter(1,i)-(1-p)*N)/(3*p-1);
    n2 = (2*counter(2,i)-(1-p)*N)/(3*p-1);
    
    n1 = Clip(n1,0,N); n2 = Clip(n2,0,N);
    if N>0 
        Freq(i) = (n1+n2)/N;
    end
    if n1+n2 > 0
        Mean(i) = (n1-n2)/(n1+n2);
    end
end


end





function counter = Perturb_cell(data,N_key,p,q)

N_user = size(data,1);
counter = zeros(3,N_key); % output
randIndex = randi(N_key,N_user,1);
randBit = randsrc(N_user,1,[[1 -1 0]; [q q p]]); % perturb from 0

for i = 1:N_user  
    S = data{i};
    index = randIndex(i);
    [~,loc] = ismember(index,S(:,1)); % whether key=index is in the first col
    
    % initialize and perturb the value
    if loc > 0
        % key exists
        value = randsrc(1,1,[[-1 1]; [(1-S(loc,2))/2 (1+S(loc,2))/2]]);
        if value == 1
            value = randsrc(1,1,[[1 -1 0]; [p q q]]);
        else % value = -1
            value = randsrc(1,1,[[1 -1 0]; [q p q]]);
        end
    else
        % key does not exist
        value = randBit(i);
    end
       
    counter(1,index) = counter(1,index) + (value == 1);
    counter(2,index) = counter(2,index) + (value == -1);
    counter(3,index) = counter(3,index)+1;
end
   
end

function counter = Perturb_matrix(data,N_key,p,q)

N_user = size(data,1);
counter = zeros(3,N_key); % output
randIndex = randi(N_key,N_user,1);
randBit = randsrc(N_user,1,[[1 -1 0]; [q q p]]); % perturb from 0

for i = 1:N_user  
    key = data(i,1); value = data(i,2);
    index = randIndex(i);
    
    % initialize and perturb the value
    if index == key
        % key exists
        value = randsrc(1,1,[[-1 1]; [(1-value)/2 (1+value)/2]]);
        if value == 1
            value = randsrc(1,1,[[1 -1 0]; [p q q]]);
        else % value = -1
            value = randsrc(1,1,[[1 -1 0]; [q p q]]);
        end
    else
        % key does not exist
        value = randBit(i);
    end
    
    counter(1,index) = counter(1,index) + (value == 1);
    counter(2,index) = counter(2,index) + (value == -1);
    counter(3,index) = counter(3,index)+1;
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
