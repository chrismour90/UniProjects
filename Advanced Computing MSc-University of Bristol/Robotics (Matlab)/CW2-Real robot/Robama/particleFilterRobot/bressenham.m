function ret = bressenham(map,sx,sy,ex,ey)
    dX = ex - sx;
    dY = ey - sy;
    steep = (abs(dY) >= abs(dX));
    if(steep)
        [sx,sy] = swap(sx,sy);
        [ex,ey] = swap(ex,ey);
        dX = ex - sx;
        dY = ey - sy;
    end
    xstep = 1;
    if(dX < 0)
        xstep = -1;
        dX = -dX;
    end
    ystep = 1;
    if(dY < 0)
        ystep = -1;
        dY = -dY;
    end
    twoDy = 2*dY;
    twoDytwoDx = twoDy - 2*dX;
    e = twoDy - dX;
    ty = sy;
    tx = sx;
    ret = map;
    while(tx ~= ex)
        if(steep) 
            Ix = ty;
            Iy = tx;
        else
            Ix = tx;
            Iy = ty;
        end
%         [I(Ix,Iy) Ix Iy height d minimum]
%         tz = sheight + (eheight-sheight)*(distance(tx,ty,sx,sy)/distance(sx,sy,ex,ey));
%         disp([tz (distance(tx,ty,sx,sy)/distance(sx,sy,ex,ey))]);
%         if(map(Ix,Iy) < 1)
%             ret = 0;
%             break;
%         end
%         I(Ix,Iy) = tz;
        ret(Ix,Iy) = 1;
        if(e > 0)
            e = e + twoDytwoDx;
            ty = ty + ystep; 
        else
            e = e + twoDy;
        end
%         I(Ix,Iy) = 0;
        tx = tx + xstep; 
    end
%     if(steep)
%         I(ey,ex) = -100;
%     else
%         I(ex,ey) = -100;
%     end
end
