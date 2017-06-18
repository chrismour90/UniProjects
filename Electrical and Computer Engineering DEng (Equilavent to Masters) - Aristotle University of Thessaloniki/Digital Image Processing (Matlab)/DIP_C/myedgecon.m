 %Mourouzi Christos
 %7571 

function [y] = myedgecon( x, type, thr, Tnorm, Targ, r )

[M,  N]=size(x);
y=zeros(M,N);
g=zeros(M,N);
theta = zeros(M,N);

Hpr=[1 1 1; 0 0 0; -1 -1 -1];
Hsob=[1 2 1; 0 0 0 ; -1 -2 -1];
Hlog=[0 0 -1 0 0; 0 -1 -2 -1 0; -1 -2 16 -2 -1; 0 -1 -2 -1 0; 0 0 -1 0 0];

%Prewitt
if strcmp(type,'prewitt')
    g=conv2(x,Hpr);
    Sx=fspecial('prewitt');
    Sy=Sx';
    Gx=imfilter(x,Sx);
    Gy=imfilter(x,Sy);
  
end    

%Sobel
if strcmp(type,'sobel') 
    g=conv2(x,Hsob);
    Sx=fspecial('sobel');
    Sy=Sx';
    Gx=imfilter(x,Sx);
    Gy=imfilter(x,Sy);
end 

%Laplacian Gaussian
if strcmp(type,'log') 
    g=conv2(x,Hlog);
    Sx=fspecial('LoG');
    Sy=Sx';
    Gx=imfilter(x,Sx);
    Gy=imfilter(x,Sy);  
end

%Threshold
for i=1:M
    for j=1:N
        if g(i,j)>thr
            y(i,j)=1;
        end
    end
end

a=atan(Gx/Gy);

%Edge link
for i=1:M-r
        for j=1:M-r
            if (y(i,j)> 0)
                for k=1+i:i+r
                    for l=1+j:j+r
                        
                    if sqrt(g(i,j)^(2) + g(k,l)^(2))<Tnorm 
                            theta(i,j) = a(i,j)*tan(Gy(i,j)/Gx(i,j));
                            theta(k,l) = a(k,l)*tan(Gy(k,l)/Gx(k,l));
                            if sqrt(theta(i,j)^(2) + theta(k,l)^(2))<Targ
                            y(i,j)=1;
                                 
                            end
                    end
                        
                    end
                    
                end
               if((i>r)&&(j>r))
                   for k=i-r:i
                       for l=j-r:j
                           if sqrt(g(i,j)^(2) + g(k,l)^(2))<Tnorm 
                                 theta(i,j) = a(i,j)*tan(Gy(i,j)/Gx(i,j));
                                 theta(k,l) = a(k,l)*tan(Gy(k,l)/Gx(k,l));
                               
                                 if sqrt(theta(i,j)^(2) + theta(k,l)^(2))<Targ
                                 y(i,j)=1;
                                 
                                 end
                           end
                       end
                   end
               end 
                
                
                
                
            end    
        end
end




            

end






