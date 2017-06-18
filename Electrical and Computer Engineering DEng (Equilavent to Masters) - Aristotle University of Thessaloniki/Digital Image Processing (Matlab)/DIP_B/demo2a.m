%Mourouzi Christos
%AEM:7571

%% Convolution
A=rand(400,600); %create image of size 400x600
k=fspecial('gaussian',[9 9],2); %create gaussian gilter

%Convolution A*k with myconv2
Y1=myconv2(A,k);

%Convolution A*k with myconv2freq
Y2=myconv2freq(A,k);

%Convolution A*k with conv2
Y3=conv2(A,k);

%% Show results
figure; imshow(A)

figure; imshow(Y1)

figure; imshow(Y2)
 
figure; imshow(Y3)

%% MSE
%Mean Squared Error between Y1 and Y3
D = abs(Y1-Y3).^2;
MSE1 = sum(D(:))/numel(Y1)

%Mean Squared Error between Y1 and Y3
D = abs(Y2-Y3).^2;
MSE2 = sum(D(:))/numel(Y2)