function [Freq, Mean] = true_result(data,N_user,N_key)

temp_result = zeros(N_key,2);

if isa(data,'cell') == 1 
    for i = 1:N_user
        S = data{i};
        len = size(S,1);
        for j = 1:len
            temp_result(S(j,1),:) = temp_result(S(j,1),:) + [1 S(j,2)];
        end
    end
else % data is not a cell, then each user has only one key
    for i = 1:N_user
        key = data(i,1); value = data(i,2);
        temp_result(key,:) = temp_result(key,:) + [1 value];
    end
end
    

Freq = temp_result(:,1)/N_user;
Mean = temp_result(:,2)./temp_result(:,1);

end


