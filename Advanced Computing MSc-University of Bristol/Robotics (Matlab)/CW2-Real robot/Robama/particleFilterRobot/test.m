COM_CloseNXT all %prepares workspace
h=COM_OpenNXT(); %look for USB devices
COM_SetDefaultNXT(h); %sets default handle
mB = NXTMotor('B');
mC = NXTMotor('C');
% moveRobot(30,mB,mC);
turnRobot(-pi/4,mB,mC)
%%
COM_CloseNXT all %prepares workspace
h=COM_OpenNXT(); %look for USB devices
COM_SetDefaultNXT(h); %sets default handle
mA = NXTMotor('A');
mA.Power = -20;
mA.TachoLimit = 90;
mA.SendToNXT();
%%
COM_CloseNXT all %prepares workspace
h=COM_OpenNXT(); %look for USB devices
COM_SetDefaultNXT(h); %sets default handle
mA = NXTMotor('A');
mA.Power = -20;
mA.TachoLimit = 90;
mA.SendToNXT();
mA.Power = 20;
mA.TachoLimit = 10;
measurements = ones(1,18)*-2;
OpenUltrasonic(SENSOR_4);
for i = 1:18
    mA.SendToNXT()
    mA.WaitFor();
    mA.Stop('brake');
    measurements(i) = GetUltrasonic(SENSOR_4);
end
measurements
%%
ang = -90:10:90;
pl = zeros(2,18);
plot(0,0);
hold on;
for i = 1:18
    if(measurements(i) < 255)
        tmp = measurements(i);
    else
       tmp = 5;
    end
    x = tmp*cos(ang(i+1)*pi/180);
    y = tmp*sin(ang(i+1)*pi/180);
    scatter(y,x);
    plot([0,y],[0,x]);
end
%%
COM_CloseNXT all;  
h = COM_OpenNXT();
COM_SetDefaultNXT(h);

OpenUltrasonic(SENSOR_4); %open usensor on port 4
mot = NXTMotor('A');  %motor connected to port C
mot.ResetPosition();  %only do this once at the start
mot.SmoothStart = 1;
rad=zeros(12,1);
[tmp ang] = ultraScan(mot,50,12)
tmp

%%
close all
botSim.setBotPos([95 88]);
botSim.setBotAng(-pi);
botSim.drawMap()
botSim.drawBot(3,'r');
target = [22,22];
[sc,CR] = botSim.ultraScan();
filt = T<50;
d = norm(T.*filt - sc.*filt);
%[rad] = scanRobot();
[sc rad]
hold on
scatter(CR(:,1),CR(:,2),'marker','o','lineWidth',3); %draws crossingpoints
%%
T = rad
%%
plot(0,0);
hold on
len = size(rad,1);
for i=1:len
    x = rad(len-i+1)*cos(2*pi/len*(i-1));
    y = rad(len-i+1)*sin(2*pi/len*(i-1));
    plot([0,x],[0,y]);
    scatter(x,y);
end
hold off;