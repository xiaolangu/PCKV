function data = GenData(N_user,N_key,sigma_f,sigma_m,distribution)


switch distribution
    case 'UU'
        temp_key = randi(N_key,1,N_user); % uniform
        value = 2*rand(N_key,1)-1; % uniform
    case 'GG'
        temp_key = ceil(abs(sigma_f*randn(1,N_user*2*ceil(3*sigma_f/N_key)))); % gaussian
        temp_key = [1:N_key temp_key]; 
        temp_key(find(temp_key>N_key)) = [];
        temp_key = temp_key(1:N_user);
        
        value = sigma_m*randn(ceil(3*sigma_m*N_key),1); % gaussian
        value(find(value>1)) = []; 
        value(find(value<-1)) = []; 
        value = value(1:N_key);
end        
temp_value = value(temp_key);
data = [temp_key' temp_value];
end
    

function value = generate_value(x,lb,ub)

sigma = (ub-lb)/12;
value = sigma*randn(size(x)) + x;
value(find(value<lb)) = lb;
value(find(value>ub)) = ub;
end