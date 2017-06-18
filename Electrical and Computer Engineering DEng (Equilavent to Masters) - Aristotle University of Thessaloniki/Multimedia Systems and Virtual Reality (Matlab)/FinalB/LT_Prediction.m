function [ e ] = LT_Prediction( d, dd, Nc, bc)

%Calculate estimated samples d''

ddd = zeros(1, 40);
e = zeros(1, 40);
for i = 1:40
    ddd(i) = bc * dd(length(dd) + i - Nc);
end
        
%Calculate e

for i = 1:40
    e(i) = d(i) - ddd(i);
end
    
end

