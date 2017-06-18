function [ sof ] = offset_compensation( so )

sof = zeros(length(so), 1);
alpha = 32735 * 2 ^ (-15);
sof(1, 1) = so(1, 1);
for k = 2:length(so)
    sof(k, 1) = so(k, 1) - so(k-1, 1) + alpha * sof(k-1, 1);
end

end

