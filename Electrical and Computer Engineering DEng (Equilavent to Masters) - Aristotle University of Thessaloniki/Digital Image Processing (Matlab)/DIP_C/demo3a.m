%Mourouzi Christos
 %7571 
 
 x=load('shapes.mat','-mat');
 
 I=x.I;
 
 %Prewitt
 ypr=myedge(I,'prewitt',0.06);
 
 %Sobel
 ysob=myedge(I,'sobel',0.08);
 
 %Laplacian Gausiann
 ylog=myedge(I,'log',0.6);

 %plot the result
 subplot(2,2,1);
 imshow(I);
 title('Image')
 subplot(2,2,2);
 imshow(ypr);
 title('Prewitt: Thr=0.06')
 subplot(2,2,3)
 imshow(ysob); 
 title('Sobel: Thr=0.08')
 subplot(2,2,4); 
 imshow(ylog);
 title('LoG: Thr=0.6')

 
