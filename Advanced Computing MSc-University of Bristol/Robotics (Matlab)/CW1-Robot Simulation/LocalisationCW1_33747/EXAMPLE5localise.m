clf;        %clears figures
clc;        %clears console
clear;      %clears workspacez
axis equal; %keeps the x and y scale the same
map=[0,0;60,0;60,45;20,45;20,59;70,59;70,30;80,10;106,30;106,105;0,105];  %default map 
%map=[0,0;120,0;120,64;57,64;57,98;37,98;37,118;0,118]; 
%map=[0,0;60,0;60,50;100,50;70,0;110,0;150,80;30,80;30,40;0,80]; 
%map= [-30,0;-30,40;30,40;30,60;5,60;45,90;85,60;60,60;60,40;120,40;120,60;95,60;135,90;175,60;150,60;150,40;210,40;210,60;185,60;225,90;265,60;240,60;240,40;300,40;300,0];

%botSim = BotSim(map,[0.01,0.005,0]);  %sets up a botSim object a map, and debug mode on.
botSim = BotSim(map,[0,0,0]);  %sets up a botSim object a map, and debug mode on.
botSim.drawMap();
drawnow;
botSim.randomPose(0); %puts the robot in a random position at least 10cm away from a wall
%botSim.setBotPos([140 65]);
%target = botSim.getRndPtInMap(10);  %gets random target.
target=[20 20];
tic %starts timer

%your localisation function is called here.
[returnedBot, estimated_bot] = localise(botSim,map,target); %Where the magic happens

resultsTime = toc %stops timer

resultsDis =  distance(target, returnedBot.getBotPos())



