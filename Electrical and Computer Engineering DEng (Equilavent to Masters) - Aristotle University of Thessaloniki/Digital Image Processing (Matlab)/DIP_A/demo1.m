%Mourouzi Christos
%7571

I=imread('march.png'); %read image

%original size Nearest Neighbor
RGB=bayer2rgb(I,960,1280,1);
figure(1); title('960 x 1280 Nearest Neighbor')
imshow(uint8(RGB))

%resize Nearest Neighbor
RGB=bayer2rgb(I,320,420,1);
figure(2); title('320 x 420 Nearest Neighbor')
imshow(uint8(RGB))

%original size Bilinear
RGB=bayer2rgb(I,960,1280,2);
figure(3); title('960 x 1280 Bilinear')
imshow(uint8(RGB))

%resize Bilinear
RGB=bayer2rgb(I,320,420,2);
figure(4); title('320 x 420 Bilinear') 
imshow(uint8(RGB))



