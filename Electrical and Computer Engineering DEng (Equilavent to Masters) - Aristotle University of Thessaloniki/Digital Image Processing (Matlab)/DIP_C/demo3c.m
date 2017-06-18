 %Mourouzi Christos
 %7571 

 x=load('illinois.mat','-mat');
 
 I=x.I;
 
 %find edges
 BW=myedge(I,'log',0.8);
 
 
 %compute hough matrix 
 C=hough(BW,10,1);

 %show hough matrix
 figure, imshow(imadjust(mat2gray(C)),[])
 xlabel('\theta (degrees)'), ylabel('\rho');
 axis on, axis normal, hold on;
 colormap(hot)


