function [ s ] = pre_emphasis( sof )

s = zeros(length(sof), 1);
beta = 28180 * 2 ^ (-15);
s(1, 1) = sof(1, 1);
for k = 2:length(sof)
    s(k, 1) = sof(k, 1) - beta * sof(k-1, 1);
end



end

