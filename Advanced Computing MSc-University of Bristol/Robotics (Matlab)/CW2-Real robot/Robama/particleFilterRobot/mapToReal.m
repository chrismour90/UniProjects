function [x,y] = mapToReal(i,j,Ox,Oy,res)
    x = (i-1)*res+Ox;
    y = (j-1)*res+Oy;
end