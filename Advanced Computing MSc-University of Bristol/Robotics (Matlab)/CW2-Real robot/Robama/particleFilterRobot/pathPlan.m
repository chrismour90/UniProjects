function [moveCommands turnCommands] = pathPlan(currentPos,currentAng,target,map,Ox,Oy,res,print)
%Worst pathplanning function ever.  Assumes there are no obstacles and
%generates random movment instructions
    turnCommands = [];
    [mx,my] = realToMap(currentPos(1),currentPos(2),Ox,Oy,res);
    [mtx,mty] = realToMap(target(1),target(2),Ox,Oy,res);
    infGridMap = map;
    x = mx;
    y = my;
    g = 0;
    Id = 1;
    opened = [];
    closed = [mx,my,Id,-1];
    prevId = 1;
    noPath = 0;
    if(print)
        pathShow = map(:,:,[1,1,1]);
        pathShow(mx,my,1) = 1;
        pathShow(mx,my,2:3) = 0;
        pathShow(mtx,mty,3) = 1;
        pathShow(mtx,mty,1:2) = 0;
    end
    covered = 0;
    while(~(x == mtx && y == mty))
%         size(opened)
        for i = -1:1
            for j = -1:1
                if(abs(i+j) ~= 1)
                    continue;
                end
                ix = x + i;
                iy = y + j;
                if(infGridMap(ix,iy) == 0)
                    continue;
                end
                isX = find(closed(:,1) == ix);
                isY = find(closed(:,2) == iy);
                isC = intersect(isX,isY);
                if(isC)
                    continue;
                end
                g = covered + 1;
                h = norm([mtx-ix, mty - iy]);
                f = g + h;
%                 [x,y,mx,my]
                if(size(opened,1) > 0)
                    isX = find(opened(:,1) == ix);
                    isY = find(opened(:,2) == iy);
                    isO = intersect(isX,isY);
                    if(isO)
                        if(opened(isO,4) > f)
                            opened(isO,3) = g;
                            opened(isO,4) = f;
                            opened(isO,6) = prevId;
                        end
                    else
                        Id = Id + 1;
                        opened = [opened;[ix,iy,g,f,Id,prevId]];
                    end
                else if(x == mx && y == my)
                        Id = Id + 1;
                        opened = [opened;[ix,iy,g,f,Id,prevId]];
                    end
                end
            end
        end
%         size(opened)
        if(size(opened,1) == 0)
          	figure(7);
            imshow(pathShow);
            noPath = 1;
            'no path'
            break;
        end
        [isC,I] = sort(opened(:,4),'ascend');
        x = opened(I(1),1);
        y = opened(I(1),2);
        covered = opened(I(1),3);
        nId = opened(I(1),5);
        prevId = opened(I(1),6);
        closed = [closed;[x,y,nId,prevId]];
        prevId = nId;
        opened(I(1),:) = [];
%         tmp = pathShow;
%         opened
%         closed
%         for i = 1:size(closed,1)
%             tmp(closed(i,1),closed(i,2),1) = 0;
%             tmp(closed(i,1),closed(i,2),2) = 0;
%             tmp(closed(i,1),closed(i,2),3) = 1;
%         end
%         imshow(tmp);
%         waitforbuttonpress;

    end
    if(noPath)
        moveCommands = NaN;
        turnCommands = NaN;
        return;
    end
%     toc
%     tic;
%     size(closed)
%     'target found'
    pathF = [x,y];
    Id = find(closed(:,3) == closed(end,end));
    while(prevId ~= -1)
        x = closed(Id,1);
        y = closed(Id,2);
        prevId = closed(Id,4);
        Id = find(closed(:,3) == prevId);
        pathF = [x,y;pathF];
    end
%     toc
%     pathF
%     figure
    if(print)
        for i = 1:size(pathF,1)
            pathShow(pathF(i,1),pathF(i,2),1) = 1;
            pathShow(pathF(i,1),pathF(i,2),2) = 0;
            pathShow(pathF(i,1),pathF(i,2),3) = 0;
        end
    end
%     figure(3);
%     imshow(flipdim(gridMap,1))
%     imshow(gridMap)
%     imshow(infGridMap);
%     imshow(imrotate(pathShow,90));
    visible = pathF(1,:);
    visibility = visible;
    index = 1;
    ix = visible(1);
    iy = visible(2);
    [rx,ry] = mapToReal(ix,iy,Ox,Oy,res);
    real = [rx,ry];
    while(~(ix == mtx && iy == mty))
        ret = 1;
        while(ret == 1 && index <= size(pathF,1))
            prevx = ix;
            prevy = iy;
            ix = pathF(index,1);
            iy = pathF(index,2);
            ret = bressenhamMap(infGridMap,visible(1),visible(2),ix,iy);
%             [visible,ix,iy,ret]
%             waitforbuttonpress;
            index = index + 1;
        end
%         index
        if(index < size(pathF,1))  
            ix = prevx;
            iy = prevy;
        end
        visible = [ix,iy];
        if(print)
            pathShow(ix,iy,1) = 0;
            pathShow(ix,iy,2) = 0;
            pathShow(ix,iy,3) = 1;
            pathShow(prevx,prevy,1) = 0;
            pathShow(prevx,prevy,2) = 1;
            pathShow(prevx,prevy,3) = 0;
        end
        visibility = [visibility;[ix,iy]];
        [x,y] = mapToReal(ix,iy,Ox,Oy,res);
        real = [real;[x,y]];
%         imshow(pathShow)
%         keyboard
    end
%     figure(1)
%     imshow(infGridMap);
%     figure(2);
%     subplot(1,3,3), imshow(imrotate(pShow,90));
    if(print)
        figure(7);
        imshow(pathShow);
    end
    moveCommands = real;
    turnCommands = visibility;
end