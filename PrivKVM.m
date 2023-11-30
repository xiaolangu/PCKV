function [Freq, Mean] = PrivKVM(data,N_key,N_iter,epsilon)

% for key perturbation (1st round)
p1 = exp(epsilon/2)/(exp(epsilon/2)+1); 

% for value perturbation (all rounds)
p2 = exp(epsilon/(2*N_iter))/(exp(epsilon/(2*N_iter))+1); 

Mean = zeros(N_key,1);

counter = Perturb(data,N_key,p1,p2,Mean);
[Freq, Mean] = Calibrate(counter,N_key,p1,p2,Mean);

p1 = 0.5;
for i = 2:N_iter    
    counter = Perturb(data,N_key,p1,p2,Mean);
    [~, Mean] = Calibrate(counter,N_key,p1,p2,Mean);
end


end


function counter = Perturb(data,N_key,p1,p2,Mean)

if isa(data,'cell') == 1
    counter = Perturb_cell(data,N_key,p1,p2,Mean);
else
    counter = Perturb_matrix(data,N_key,p1,p2,Mean);
end

end



function counter = Perturb_cell(data,N_key,p1,p2,Mean)

N_user = size(data,1);
counter = zeros(3,N_key); % output

randIndex = randi(N_key,N_user,1);
randBit = randsrc(N_user,1,[[0 1]; [p1 1-p1]]); 
randSign = randsrc(N_user,1,[[-1 1]; [1-p2 p2]]); 
        
for i = 1:N_user  
    S = data{i};
    index = randIndex(i);
    [~,loc] = ismember(index,S(:,1)); % whether key=index is in the first col
    
    % perturb the key and discrete the value
    if loc > 0
        % key exists
        key = randsrc(1,1,[[0 1]; [1-p1 p1]]);
        value = randsrc(1,1,[[-1 1]; [(1-S(loc,2))/2 (1+S(loc,2))/2]]);
    else
        % key does not exist
        m = Mean(index);
        key = randBit(i);
        value = randsrc(1,1,[[-1 1]; [(1-m)/2 (1+m)/2]]);
    end
    
    % perturb the value
    value = key*value*randSign(i);
    
    counter(1,index) = counter(1,index) + (value == 1);
    counter(2,index) = counter(2,index) + (value == -1);
    counter(3,index) = counter(3,index)+1;
end
   
end

function counter = Perturb_matrix(data,N_key,p1,p2,Mean)

N_user = size(data,1);
counter = zeros(3,N_key); % output

randIndex = randi(N_key,N_user,1);
randBit = randsrc(N_user,1,[[0 1]; [p1 1-p1]]); 
randSign = randsrc(N_user,1,[[-1 1]; [1-p2 p2]]); 
for i = 1:N_user  
    key = data(i,1); value = data(i,2);
    index = randIndex(i);
    
    % perturb the key and discrete the value
    if index == key
        % key exists
        key = randsrc(1,1,[[0 1]; [1-p1 p1]]);
        value = randsrc(1,1,[[-1 1]; [(1-value)/2 (1+value)/2]]);
    else
        % key does not exist
        m = Mean(index);
        key = randBit(i);
        value = randsrc(1,1,[[-1 1]; [(1-m)/2 (1+m)/2]]);
    end
    
    % perturb the value
    value = key*value*randSign(i);
    
    counter(1,index) = counter(1,index) + (value == 1);
    counter(2,index) = counter(2,index) + (value == -1);
    counter(3,index) = counter(3,index)+1;
end
   
end



function [Freq, Mean] = Calibrate(counter,N_key,p1,p2,oldMean)

Freq = zeros(N_key,1);
Mean = zeros(N_key,1);

for i = 1:N_key
    
    
    n1 = counter(1,i); n2 = counter(2,i);
    N = n1+n2;
    if N == 0
        Freq(i) = 0;
        Mean(i) = oldMean(i);
        continue;
    end
        
    Freq(i) = (p1-1+N/counter(3,i))/(2*p1-1);

    n1 = ((p2-1)*N+n1)/(2*p2-1); n1 = Clip(n1,0,N);
    n2 = ((p2-1)*N+n2)/(2*p2-1); n2 = Clip(n2,0,N);
                       
    Mean(i) = Clip((n1-n2)/N,-1,1);    
    
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