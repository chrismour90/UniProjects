function [botSim] = localise(map,target)
%This function returns botSim, and accepts, botSim, a map and a target.
%LOCALISE Template localisation function
COM_CloseNXT('all') %prepares workspace
h=COM_OpenNXT(); %look for USB devices
COM_SetDefaultNXT(h); %sets default handle
mB = NXTMotor('B');
mC = NXTMotor('C');
mA = NXTMotor('A');
%% GridMap setup
res = 2;
botSim = BotSim(map);
[gridMap,Ox,Oy] = createMap(map,res);
segSize = floor((35/res)/2)*2+1;
se = strel('square',segSize);
infGridMap = imerode(gridMap,se);
[x,y] = realToMap(target(1),target(2),Ox,Oy,res);
radius = floor(segSize/2) + 1;
if(botSim.pointInsideMap(target) && infGridMap(x,y) == 0)
    for i = -radius:radius
        for j = -radius:radius
            if(botSim.pointInsideMap([target(1)+res*i,target(2)+res*j]) == 1)
                infGridMap(x+i,y+j) = 1;
            end
        end
    end
end
infGridMapTmp = infGridMap;
if(botSim.pointInsideMap(target) == 0)
    'target outside map'
    botSim = NaN;
    return;
end
planShow = 0;
imageShow = 0;
% if botSim.debug()
%     figure(1)
%     subplot(1,3,1), imshow(gridMap)
%     subplot(1,3,2), imshow(infGridMap)
%     subplot(1,3,3), imshow(gridMap - infGridMap)
% end
%% setup code
%you can modify the map to take account of your robots configuration space
modifiedMap = map; %you need to do this modification yourself
botSim.setMap(modifiedMap);
position = [];
toGoal = Inf;
pathP = [];
pathA = [];
% while(norm(target-position) > 8)

%generate some random particles inside the map
num =1000; % number of particles
% noiseLevel(:,1) = [1,0.01,0.01];
noiseLevel(:,1) = [1,0,0];
particles(num,1) = BotSim; %how to set up a vector of objects
scanNo =8;
for i = 1:num
    particles(i) = BotSim(modifiedMap,noiseLevel);  %each particle should use the same map as the botSim object
    particles(i).randomPose(0); %spawn the particles in random locations
    particles(i).setMotionNoise(0.05);
    particles(i).setTurningNoise(0.07);
    particles(i).setScanConfig(particles(i).generateScanConfig(scanNo),[0,0]);

end
%     particles(1).setBotPos([22,88]);
%     particles(1).setBotAng(-pi);
%         particles(2).setBotPos([33,88]);
%     particles(2).setBotAng(-pi);
% particles(1).setBotPos(botSim.getBotPos);
% particles(1).setBotAng(botSim.getBotAng);
%% Localisation code
maxNumOfIterations = 50;
n = 0;
converged = 0; %The filter has not converged yet
botSim.setScanConfig(botSim.generateScanConfig(scanNo),[0,0]);
botScan = botSim.ultraScan();
mNo = size(botScan,1);
partWeight = ones(num,1).*(1/num);
w = zeros(1,num*mNo);
WE = zeros(1,num);
replan = 0;
step = 0;
me = BotSim(modifiedMap);

distanceFromStart = [0 0];
distanceBeep = 0;

% me.setBotPos([88,88]);
% me.setBotAng(-pi);
% MA = -pi;

r = 0;
close = 0;
ratioMin = 0.6;
convergenceRadius = 10;
prevIndeces = zeros(1,num);
minN = 0;
maxMove = 50;
maxMoveLimit = 50;
initRandomness = 0.6;
remainRandomness= 0.2;
distanceToGoal = 10;
%     while(converged == 0 && n < maxNumOfIterations) %%particle filter loop
while(toGoal > distanceToGoal && n < maxNumOfIterations)
    %% Write code for updating your particles scans
    n = n+1; %increment the current number of iterations
%     disp(n)
%     [botScan,CR] = botSim.ultraScan(); %get a scan from the real robot.
    botScanRaw = scanRobot2(scanNo,mA);
    botScan = median(botScanRaw,2)
%     botScan = [27    27    29   255    87    86    96    86    82    80    80   104    23    22    21    22    24    30]';
    filt = botScan<120';
    botScan = botScan .* filt;
    %% Write code for scoring your particles
    totalWeight = 0;
    indeces = zeros(1,num);
    indecesM = zeros(1,num);
    P = zeros(num,2);
    A = zeros(num,2);

    for i= 1:num
        %         prevPos(:,i) = particles(i).getBotPos()';
        [distances, crossingPoint]  = particles(i).ultraScan(); %performs a simulated scan
%         [distances,crossingPoint,f2] = particles(i).ultraScanAdv();
%         filter2 = f2;
%         f2'
        distances = round(distances);
        p = particles(i).getBotPos();
        a = particles(i).getBotAng();
        tmpW = 0;
        tmpA = a;
%         p(1) = -7*cos(a) + p(1);
%         p(2) = -7*sin(a) + p(2);
        for j = 1:mNo
%             F = filt.*filter2;
%             [distances.*F]';
%             [botScan.*F]';
%             d = norm(distances.*F - botScan.*F);
            d = norm(distances - botScan);
            index = (i-1)*mNo + j;
            %             weigth = exp(-d);
            weigth = exp(-0.5*d);
            w(index) = weigth;%*partWeight(i);
            W(j) = weigth;%*partWeight(i);
%             totalWeight = totalWeight + weigth;
            if(weigth > tmpW)
                tmpW = weigth;%*partWeight(i);
                tmpA = a;
            end
            a = mod(a + 2*pi/mNo,2*pi);
            distances = [distances(2:end);distances(1)];
%             filter2 = [filter2(2:end);filter2(1)];
        end
        WE(i) = tmpW;
        tmpA = mod(tmpA,2*pi);
        if(tmpA > pi)
            tmpA = tmpA - 2*pi;
        end
%         [WE,p,tmpA]
%         p(1) = 7*cos(tmpA) + p(1);
%         p(2) = 7*sin(tmpA) + p(2);
        P(i,:) = p;
        A(i) = tmpA;
        totalWeight = totalWeight + tmpW;
    end
%     WE(1)
    w = w./sum(w);
    WE = WE./sum(WE);
%     [ind,ind] = max(WE)
%     P(ind,:)
%     W
    if (imageShow )
        figure(1);
        hold off; %the drawMap() function will clear the drawing when hold is off
        botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
        botSim.drawBot(30,'g'); %draw robot with line length 30 and green
        for i =1:num
            if(prevIndeces(i) == 0)
                 particles(i).drawBot(3);
            end
            if(prevIndeces(i) == 1)
                 particles(i).drawBot(15,'y');
            end
            if(prevIndeces(i) == 2)
                 particles(i).drawBot(20,'m');
            end
%             if(i == ind)
%                 particles(ind).drawBot(indeces(i)); %draw particle with line length 3 and default color
%                 particles(ind).drawScanConfig();
%                 particles(i).drawBot(40,'r');
%             end
            %             scatter(crossingPoint(:,1),crossingPoint(:,2),'marker','x','lineWidth',3); %draws crossingpoints
%             if(mod(i,50) == 0)
%                 CR = crossingPoint.*[f2,f2];
%                 scatter(CR(:,1),CR(:,2),'marker','o','lineWidth',5); %draws crossingpoints
        	
        end
        hold off;
%         plot(w)
    end
    %% Write code for resampling your particles
    group = zeros(num,2);
    groupAng = zeros(num,2);
    %         chosen = zeros(1,num);
%     disp(totalWeight)
%     disp(sum(WE))
    for i = 1:num
        r = (sum(WE))*rand(1,1);
        tmp = WE(1);
        j = 1;
        %        waitforbuttonpress;
        while(tmp < r && j < num)
            j = j + 1;
            tmp = tmp + WE(j);
            %             if(j > num*mNo)
            %                 [sum(w) totalWeight r]
            %             end
        end
        pos = P(j,:);
        ang = A(j);
        indecesM(floor((j-1)/mNo)+1) =  indecesM(floor((j-1)/mNo)+1) + w(j);
        indeces(i) = prevIndeces(floor((j-1)/mNo)+1);
        group(i,:) = pos;
        groupAng(i,:) = [cos(ang),sin(ang)];
        partWeight(i) = WE(j);
        %            chosen(i) = j;
        particles(i).setBotPos(pos);
        particles(i).setBotAng(ang);
        %        particles(i) = particles(j);
    end
    partWeight = partWeight./sum(partWeight);
    prevIndeces = zeros(1,num);
    if(imageShow)
    figure(2)
    subplot(4,1,1)
    scatter(0,0);
    hold on
    for i= 1:num
            if(indeces(i) == 0)
                 scatter(i,WE(i),'b');
            end
            if(indeces(i) == 1)
                 scatter(i,WE(i),'y');
            end
            if(indeces(i) == 2)
                 scatter(i,WE(i),'m');
            end
    end
    hold off;
    subplot(4,1,2),plot(P(:,1));
    subplot(4,1,3),plot(P(:,2));
    subplot(4,1,4),plot(groupAng);
%     end
    figure(3);

        hold off; %the drawMap() function will clear the drawing when hold is off
        botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
        botSim.drawBot(30,'g'); %draw robot with line length 30 and green
        for i =1:num
            if(indeces(i) == 0)
                 particles(i).drawBot(3);
            end
            if(indeces(i) == 1)
                 particles(i).drawBot(15,'y');
            end
            if(indeces(i) == 2)
                 particles(i).drawBot(20,'m');
            end
%             particles(i).drawBot(indeces(i)); %draw particle with line length 3 and default color
        end
        hold off;
%         plot(w)
        drawnow;
    end
    %% Write code to check for convergence
    MM = sum((group.*[partWeight,partWeight]));
    groupHat = pdist2(group,MM);
    groupIn = groupHat < convergenceRadius;
    ratio = sum(groupIn)/num;
    tmp = sum(groupAng.*[partWeight,partWeight]);
    
    MA = atan2(tmp(2),tmp(1));
    me.setBotPos(MM);
    me.setBotAng(MA);
%     ratio = 0;
%     ratio = 1;
%     MM = me.getBotPos();
%     converged

    if(ratio > 0.8 && norm(distanceFromStart) > 50 && distanceBeep == 0)
        NXT_PlayTone(440, 1500);
        'location'
        me.getBotPos()
        distanceBeep = 1;
        keyboard;
    end

    if(ratio > 0.75 && me.insideMap() && n > minN)
%         'asf'
%     if(ratio > 1 && me.insideMap() && n > 3)
        if(scanNo == 8)
            scanNo = 4;
            mNo = 1;
            botSim.setScanConfig(botSim.generateScanConfig(scanNo),[0,0]);
            for i = 1:num
                particles(i).setScanConfig(particles(i).generateScanConfig(scanNo),[0,0]);
            end
        end
        if(converged == 0)
            replan = 1;
        end
        converged = 1;
    else
        converged = 0;
        if(scanNo == 4)
            scanNo = 8;
            mNo = 8;
            botSim.setScanConfig(botSim.generateScanConfig(scanNo),[0,0]);
            for i = 1:num
                particles(i).setScanConfig(particles(i).generateScanConfig(scanNo),[0,0]);
            end
        end
    end
    
    if(me.insideMap() && converged)
        position = me.getBotPos();
        %         [botSim.getBotPos() position]
        toGoal = norm(target-position);
        if(toGoal < 10)
            'at stop'
            break;
        end
    else
        toGoal = Inf;
    end
    if (botSim.debug() && 0)
        subplot(1,3,1);
        hold off; %the drawMap() function will clear the drawing when hold is off
        botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
        botSim.drawBot(30,'g'); %draw robot with line length 30 and green
        for i =1:num
            if(indeces(i) == 0)
                 particles(i).drawBot(3);
            end
            if(indeces(i) == 1)
                 particles(i).drawBot(15,'y');
            end
            if(indeces(i) == 2)
                 particles(i).drawBot(20,'m');
            end
%             particles(i).drawBot(indeces(i)); %draw particle with line length 3 and default color
        end
        hold off;
%         plot(w)
        drawnow;
        waitforbuttonpress
    end
    %% Write code to decide how to move next
    if(converged == 0)
        %Not converged and no previous path was planned
        [tmp1,index] = min(botScan);
        rMin = mod((index-1)*2*pi/scanNo,2*pi);
        [tmp2,index] = max(botScan)
        rMax = mod((index-1)*2*pi/scanNo,2*pi);
        if(rMax > pi)
            rMax = rMax - 2*pi;
        end
        r = rMax;
        close = 0;
        move = 10;
        if(move > maxMove)
            move = maxMove;
        end
        turn = r + -pi/6+2*pi/6*rand();
%         if(tmp1 < 12)
%             %Not to crash in an obstacle
%             'close to obstacle'
%             if(rMin < pi/4)
%                 r = -pi/4;
%                 close = 1;
% %                 move = 5;
%             end
%             if(rMin > 7*pi/4)
%                 r = pi/4;
%                 close = 1;
% %                 move = 5;
%             end
%         end
 
    else
        if(replan == 1 || size(pathP,1) == 0)
            %f just converged or (converged and no plan exists)
%             x = 7*cos(MA);
%             y = 7*sin(MA);
%             MM = [MM(1)+x,MM(2)+y];
            [x,y] = realToMap(MM(1),MM(2),Ox,Oy,res);
            infGridMapTmp = infGridMap;
            if(botSim.pointInsideMap(MM) && infGridMap(x,y) == 0)
                %robot can be located close to obstacle
                for i = -radius:radius
                    for j = -radius:radius
                        if(botSim.pointInsideMap([MM(1)+res*i,MM(2)+res*j]) == 1)
                            infGridMapTmp(x+i,y+j) = 1;
                        end
                    end
                end
            end
%             subplot(1,3,2),

            [pathP, pathA] = pathPlan(MM,MA,target,infGridMapTmp,Ox,Oy,res,planShow);
            sP = me.getBotPos();
            sA = me.getBotAng();
            nextWaypoint = pathP(1,:);
            step = 1;
            replan = 0;
        end
        step = step + 1;
        if(size(pathP,1) < step && size(pathP,1) ~= 1)
            converged = 0;
            pathP = [];
        else
            if(size(pathP,1) == 1)
            %planned path was traversed and robot is still not in the
            %designated location
%             turn = 0;
%             move = 0;
%             pathP = [];
%             'out of arrray'
%             converged = 0;
            'one step to goal'
            nextWaypoint = pathP(step,:);
            actualPosition = me.getBotPos();
            correction = actualPosition;
            nextMove = nextWaypoint - correction;
            actualPosition
            nextMove
            [move,turn,step] = vectorToCommand(nextMove,me.getBotAng(),step,30);
            move
            turn
            if( move > maxMoveLimit)
                'invalid move'
                move = 0;
                converged = 0;
                pathP = [];
            end
            else
            prevWaypoint = nextWaypoint;
            nextWaypoint = pathP(step,:);
            actualPosition = me.getBotPos();
            correction = actualPosition - prevWaypoint;
            nextMove = nextWaypoint - prevWaypoint - correction;
            actualPosition
            nextWaypoint
            nextMove;
            [move,turn,step] = vectorToCommand(nextMove,me.getBotAng(),step,30);
            move;
            turn;
            if( move > maxMoveLimit)
                'invalid move'
                move = 0;
                converged = 0;
                pathP = [];
            end
            end
        end
    end
    if (1)
        figure(4)
%         subplot(1,3,1)
        hold off; %the drawMap() function will clear the drawing when hold is off
        botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
%         botSim.drawBot(30,'g'); %draw robot with line length 30 and green
%         best.drawBot(10,'b');
%         botSim.drawScanConfig();
        CR = zeros(scanNo,2);
        CRNOT = zeros(scanNo,2);
        AN = botSim.getBotAng();
        PO = botSim.getBotPos();
        PO = MM;
        AN = MA;
        x = -7*cos(AN);
        y = -7*sin(AN);
        PO = [PO(1)+x PO(2)+y];
        B = botScan;
%         botScanRaw
%         botScan'
        bs = size(botScan,1);
        for i=1:bs
            x = B(i)*cos(2*pi/bs*(i-1)+AN) + PO(1);
            y = B(i)*sin(2*pi/bs*(i-1)+AN) + PO(2);
            CR(i,1) = x;
            CR(i,2) = y;
            x = botScan(i)*cos(2*pi/bs*(i-1)+AN) + PO(1);
            y = botScan(i)*sin(2*pi/bs*(i-1)+AN) + PO(2);
            CRNOT(i,1) = x;
            CRNOT(i,2) = y;
        end
        scatter(CRNOT(:,1),CRNOT(:,2),'marker','o','lineWidth',3); %draws crossingpoints
        scatter(CR(:,1),CR(:,2),'marker','x','lineWidth',3); %draws crossingpoints
        me.drawBot(30,'k');
        scatter(target(1),target(2),'kx');
        if(converged == 1)
            % text(minX+10,minY,'Converged not');
            pos = [MM(1)-4 MM(2)-4 8 8];
            rectangle('Position',pos,'Curvature',[1 1],'EdgeColor',[0 0 1]);
            % axis equal
        end
        tmp = sprintf('Ratio %.3f',ratio);
        if(close == 1)
            pos = [MM(1)-5 MM(2)-5 10 10];
            rectangle('Position',pos,'Curvature',[1 1],'EdgeColor',[1 0 0]);
        else
            pos = [MM(1)-5 MM(2)-5 10 10];
            rectangle('Position',pos,'Curvature',[1 1],'EdgeColor',[0 1 0]);
        end
        if(size(pathP,1) > 0 && converged == 1)
                scatter(pathP(:,1),pathP(:,2),'kx');
                plot(pathP(:,1),pathP(:,2),'g');
        end

        title(tmp);
        drawnow;
%         keyboard
    end
%     keyboard
    %botSim.turn(turn); %turn the real robot.
    me.turn(turn);
    %turn(angle,mB,mC);
    %botSim.move(move); %move the real robot. These movements are recorded for marking
    turnRobot(turn,mB,mC);
    distanceAfterMove = GetUltrasonic(SENSOR_4);
    [distanceAfterMove move]
    if(distanceAfterMove < move || distanceAfterMove > 120)
        step = step -1;
        move = 0;
        converged = 0;
    end
    moveRobot(move,mB,mC);
    distanceFromStart(1) = move*cos(turn) + distanceFromStart(1);
    distanceFromStart(2) = move*sin(turn) + distanceFromStart(2);
    me.move(move);

    for i =1:num %for all the particles.
        particles(i).turn(turn); %turn the particle in the same way as the real robot
        particles(i).move(move); %move the particle in the same way as the real robot
%         if(particles(i).insideMap() == 0)
%             particles(i).randomPose(0);
%             partWeight(i) = 1/num;
%             prevIndeces(i) = 1;
%         end
        if(particles(i).insideMap() == 0)
            %             particles(i).randomPose(0);
            if(me.insideMap())
                MM = me.getBotPos();
                MA = me.getBotAng();
                x = normrnd(MM(1),0.5);
                y = normrnd(MM(2),0.5);
                a = normrnd(MA,0.1);
                particles(i).setBotPos([x,y]);
                particles(i).setBotAng(a);
                partWeight(i) = 1/num;
                prevIndeces(i) = 1;
            else
                particles(i).randomPose(0);
                partWeight(i) = 1/num;
                prevIndeces(i) = 1;
                %             A = A + 1;
            end
        end
    end
 
    if (imageShow)
           figure(5);
        hold off; %the drawMap() function will clear the drawing when hold is off
        botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
        botSim.drawBot(30,'g'); %draw robot with line length 30 and green
        for i =1:num
            particles(i).drawBot(3); %draw particle with line length 3 and default color
        end
        hold off;
        drawnow;
    end
    %% Write code to take a percentage of your particles and respawn in randomised locations (important for robustness)
    if(n <= minN)
        resample = ceil(initRandomness*num);
    else
        resample = ceil(remainRandomness*num);
    end
    for i = 1:resample
        index = floor(rand(1)*num)+1;
        particles(index).randomPose(0); %spawn the particles in random locations
        partWeight(index) = 1/num;
        prevIndeces(index) = 2;
    end
    %% Position update

            
%     waitforbuttonpress;
end
NXT_PlayTone(440, 1500);
me.getBotPos()
% if botSim.debug()
%     figure(2)
%     %     subplot(1,3,1)
%     hold off; %the drawMap() function will clear the drawing when hold is off
%     botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
%     botSim.drawBot(30,'g'); %draw robot with line length 30 and green
%     me.drawBot(10,'k');
%     scatter(target(1),target(2),'kx');
%     title('Arrived to target');
%     drawnow;
%     %     waitforbuttonpress
% end
% end
end
