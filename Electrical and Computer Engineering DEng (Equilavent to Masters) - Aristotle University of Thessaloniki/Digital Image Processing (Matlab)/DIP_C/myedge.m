 %Mourouzi Christos
 %7571 

function [y] = myedge(x,type,thr )


[M N]=size(x);
y=zeros(M,N);

Hpr=[1 1 1; 0 0 0; -1 -1 -1]; %prewitt mask
Hsob=[1 2 1; 0 0 0 ; -1 -2 -1]; %sobel mask
Hlog=[0 0 -1 0 0; 0 -1 -2 -1 0; -1 -2 16 -2 -1; 0 -1 -2 -1 0; 0 0 -1 0 0]; %log mask

%Prewitt
if strcmp(type,'prewitt')
    g=conv2(x,Hpr);
end    

%Sobel
if strcmp(type,'sobel') 
    g=conv2(x,Hsob);
end    

%Lalacian Gaussian
if strcmp(type,'log') 
    g=conv2(x,Hlog);
end

%Threshold
for i=1:M
    for j=1:N
        if g(i,j)>thr
            y(i,j)=1;
        end
    end
end
            
end

