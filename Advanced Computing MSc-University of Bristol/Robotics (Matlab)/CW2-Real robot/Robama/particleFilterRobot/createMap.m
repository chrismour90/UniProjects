function [ret,Ox,Oy] = createMap(map,res)
    minX = min(map(:,1))-10;
    maxX = max(map(:,1))+10;
    minY = min(map(:,2))-10;
    maxY = max(map(:,2))+10;
    Ox = minX;
    Oy = minY;
    X = round((maxX - minX)/res)+1;
    Y = round((maxY - minY)/res)+1;
    gridMap = zeros(X,Y);
    A = gridMap;
    mapEx = [map;[map(1,1),map(1,2)]];
    N = size(mapEx,1)-1;
    for i = 1:N
        [sPx,sPy] = realToMap(mapEx(i,1),mapEx(i,2),Ox,Oy,res);
        [ePx,ePy] = realToMap(mapEx(i+1,1),mapEx(i+1,2),Ox,Oy,res);
        A = bressenham(A,sPx,sPy,ePx,ePy);
    end
%     subplot(1,3,1),imshow(gridMap);
%     subplot(1,3,2),imshow(A);
    B = imfill(A,'holes');
%     subplot(1,3,3),imshow(B);
    ret = B;
end