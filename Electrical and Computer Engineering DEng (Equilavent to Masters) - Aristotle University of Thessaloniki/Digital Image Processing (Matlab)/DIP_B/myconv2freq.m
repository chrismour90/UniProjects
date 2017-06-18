%Mourouzi Christos
%AEM: 7571

function [ g ] = myconv2freq( A, h )
[r,c] = size(A);
[m,n] = size(h);

%Fourier Transform of A with zero-pad
F=fft2(A, r + m -1,c + n - 1);

%Fourier Transform of h with zero-pad
H= fft2(h, r + m -1,c + n - 1);

%Convolution in frequency is the multiplication element per element of Fourier
%Transformed Matrices, H and F
G= H.*F;

%Inverse Fourier Transform of G is the final result
g= ifft2(G,r + m -1,c + n - 1);


end

