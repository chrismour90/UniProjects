function [ Nc, bc ] = LT_Estimation( d, dd )

%Calculate R 

R = zeros(1, 120);

temp_r = zeros(1, 120);


DLB = [0.2 0.5 0.8];
R(:) = 0;
temp_r(:) = 0;
for lambda = 40:120
    for i = 1:40
        R(lambda) = R(lambda) + d(i) * dd(length(dd) + i - lambda);
        temp_r(lambda) = temp_r(lambda) + dd(length(dd) + i - lambda) ^ 2;
    end
end

% Find N

[num idx] = max(R(:));
N = idx;
if N < 40
    N = 40;
end
    
% Find b.

b = R(N) / temp_r(N);
      
% Quantize and code N, b

% N between [40-120] 
Nc = N;
% b encoded using 2bits each
if b <= DLB(1)
    bc = 0;
elseif b > DLB(1) && b <= DLB(2)
    bc = 1;
elseif b > DLB(2) && b <= DLB(3)
    bc = 2;
else
    bc = 3;
end
    
   

end



