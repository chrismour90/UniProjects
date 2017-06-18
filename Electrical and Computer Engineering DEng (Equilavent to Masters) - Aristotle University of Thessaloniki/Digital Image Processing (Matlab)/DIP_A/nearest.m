function [ xc ] = nearest(R, G, B )
M=size(R,1);
N=size(R,2);

%interpolate red
for i=2:size(R,1)
    for j=2:size(R,2)
        if (R(i,j)~=0)
            R(i,j-1)=R(i,j);
            R(i-1,j-1)=R(i,j);
            R(i-1,j)=R(i,j);
        end
    end
end    

R(1:M,1)=R(1:M,2); %left border
R(1:M,N)=R(1:M,N-1); %right border
R(1,1:N)=R(2,1:N); %top border
R(M,1:N)=R(M-1,1:N); %bottom border

%interpolate blue
for i=2:size(B,1)
    for j=2:size(B,2)
        if (B(i,j)~=0)
            B(i-1,j)=B(i,j);
            B(i-1,j-1)=B(i,j);
            B(i,j-1)=B(i,j);
        end
    end
end    

B(1:M,1)=B(1:M,2); %left border
B(1:M,N)=B(1:M,N-1); %right border
B(1,1:N)=B(2,1:N); %top border
B(M,1:N)=B(M-1,1:N); %bottom border

%interpolate green
for i=2:size(G,1)
    for j=1:size(G,2)
        if (G(i,j)==0)
            G(i,j)=G(i-1,j);
        end
    end
end    

G(1:M,1)=G(1:M,2); %left border
G(1:M,N)=G(1:M,N-1); %right border
G(1,1:N)=G(2,1:N); %top border
G(M,1:N)=G(M-1,1:N); %bottom border

 xc(:,:,1)=R; xc(:,:,2)=G; xc(:,:,3)=B;




end

