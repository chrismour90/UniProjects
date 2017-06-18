% Mourouzi Christos
% AEM: 7571

function B = myconv2(A, k)
[r,c] = size(A);
[m,n] = size(k);
h = rot90(k, 2); %flip matrix h

Rep = padarray(A, [(m*2-2)/2 , (n*2-2)/2]); %zero-pad array A

%Convolution B=A*h

B = zeros(r+m-1,n+c-1);
for x = 1 : r+m-1
    for y = 1 : n+c-1
        for i = 1 : m
            for j = 1 : n
                B(x, y) = B(x, y) + (Rep(x+i-1, y+j-1) * h(i, j));
            end
        end
    end
end
