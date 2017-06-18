function [xc] = bayer2rgb( xb, M, N, type)
%BAYER2RGB Summary of this function goes here
%   Detailed explanation goes here

xb=double(xb);

X=size(xb,1);
Y=size(xb,2);

red_mask = repmat([0 0; 1 0], X/2, Y/2);
green_mask = repmat([1 0; 0 1], X/2, Y/2);
blue_mask = repmat([0 1; 0 0], X/2, Y/2);

    R=xb.*red_mask;
    G=xb.*green_mask;
    B=xb.*blue_mask;

if (type==1)
    xc=nearest(R,G,B);
end  

if (type==2)
    xc=bilinear(R,G,B);
end

xc=resize(xc,[M N]);



end

