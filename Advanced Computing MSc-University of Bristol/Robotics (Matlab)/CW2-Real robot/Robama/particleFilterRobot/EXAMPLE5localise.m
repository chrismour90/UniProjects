clf;        %clears figures
clc;        %clears console
clear;      %clears workspace
close all;
axis equal; %keeps the x and y scale the same
COM_CloseNXT('all')
 map=[0,0;66,0;66,44;44,44;44,66;110,66;110,110;0,110];  %default map
% map = [0,0;43,0;43,47;108,47;108,100;0,100];
 %map = [-30,0;-30,40;30,40;30,60;5,60;45,90;85,60;60,60;60,40;120,40;120,60;95,60;135,90;175,60;150,60;150,40;210,40;210,60;185,60;225,90;265,60;240,60;240,40;300,40;300,0]; %repeated features
% map = [0,0;60,0;60,50;100,50;70,0;110,0;150,80;30,80;30,40;0,80]; %long map
noiseLevel(:,1) = [0,0,0]; %no noise
%noiseLevel(:,1) = [1,0.01,0.005];
% lbotSim = BotSim(map,[0.01,0.005,0]);  %sets up a botSim object a map, and debug mode on.
adminKey = rand(1);
botSim = BotSim(map,noiseLevel);  %sets up a botSim object a map, and debug mode on.
botSim.drawMap();
% drawnow;
%botSim.randomPose(10); %puts the robot in a random position at least 10cm
%away from a wall
% drawnow;
 botSim.setBotPos([88 88]);
% botSim.setBotPos([30.3508 24.3282]);
% botSim.setBotPos([112 23]);
% x = 70 + randn(1)*5;
% y = 45 + randn(1)*5;
% botSim.setBotPos([y x]);
botSim.setBotAng(-pi);
botSim.drawBot(3,'r');
target = botSim.getRndPtInMap(10);  %gets random target.
botTarget = BotSim(map,[0,0,0]);
target = [44,22];
% target = [213 20];
botTarget.setBotPos(target);
botTarget.drawBot(3,'b');

% drawnow

tic %starts timer

%your localisation function is called here.
% returnedBot = localise2(botSim,map,target); %Where the magic happens
% rPos = returnedBot.getBotPos();
% rAng = returnedBot.getBotAng();>>
% rPos = [40,20];%returnedBot.getBotPos();
% rAng = botSim.getBotAng();%returnedBot.getBotAng();
% rPos = botSim.getBotPos();
% [positions angles] = pathPlan(rPos,rAng,target,map)
% for i = 1:size(positions,1)
%     botSim.turn(angles(i));
%     botSim.move(positions(i));
% end
% figure(1)
% botSim.drawBot(5,'g');
% drawnow;
% [rPos,rAng,target]
returnedBot = localise(map,target); %Where the magic happens
resultsTime = toc %stops timer

%calculated how far away your robot is from the target.
% resultsDis =  distance(target, returnedBot.getBotPos(adminKey))
resultsDis =  distance(target, returnedBot.getBotPos())
%path = returnedBot.getBotPath()