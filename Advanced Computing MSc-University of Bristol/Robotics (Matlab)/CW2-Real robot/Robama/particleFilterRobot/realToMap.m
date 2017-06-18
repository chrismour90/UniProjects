function [i,j] = realToMap(x,y,Ox,Oy,res)
    i = round((x+1-Ox)/res);
    j = round((y+1-Oy)/res);
end