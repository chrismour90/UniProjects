 %Mourouzi Christos
 %7571 

 x=load('illinois.mat','-mat');
 
 I=x.I;
  
 %Prewitt
 yedgepr=myedgecon(I,'prewitt', 0.06, 1 , 0.7, 1);
 %Sobel
 yedgesob=myedgecon(I,'sobel', 0.08, 1 , 0.7, 1);
 
 %plot the results
 subplot(2,2,1);
 imshow(I);
 title('Image')
 subplot(2,2,2);
 imshow(yedgepr);
 title('Prewitt: Thr=0.06, Tnorm=1, Targ=0.7,r=1')
 subplot(2,2,3)
 imshow(yedgesob);
 title('Prewitt: Thr=0.01, Tnorm=1, Targ=0.7,r=1')
 
 