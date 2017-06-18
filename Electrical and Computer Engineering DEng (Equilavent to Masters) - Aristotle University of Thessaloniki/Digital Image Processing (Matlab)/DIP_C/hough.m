%Mourouzi Christos
%7571 

function [ H ] = hough( x,dr,da )

[iHeight,iWidth]=size(x);
distMax=round(sqrt(iHeight^2 + iWidth^2)); %max possible distance

theta=-90:da:89;    %range of theta
rho=-distMax:dr:distMax;    %range of rho

H=zeros(length(rho),length(theta)); %initialize Hough Matrix

%scan edge image

for ix=1:iWidth
       for iy=1:iHeight
           if x(iy,ix)~=0
               
               %Fill H
               for iTheta=1:length(theta)
                   t=theta(iTheta)*pi/180;
                   
                   %calculate distance
                   dist=ix*cos(t)+iy*sin(t);
                   
                   %find rho value closest to this
                   [d, iRho]=min(abs(rho-dist));
                   
                   if d <= 1
                       H(iRho,iTheta)=H(iRho,iTheta)+1; 
                       
                   end
                   
               end
               
           end
       end            
 end


end

