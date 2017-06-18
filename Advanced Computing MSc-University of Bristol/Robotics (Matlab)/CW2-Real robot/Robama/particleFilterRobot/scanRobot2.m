function [rad] = scanRobot2(no,mot)

%addpath(genpath('C:\Program Files\RWTHMindstormsNXT'))
%An example of the ultrasound scanning function
% clf;        %clears figures
% clc;        %clears console
% clear;      %clears workspace

%real_angles=[0:45:315];
%real_distance=[85 25 17 26 18.25 24.75 19.5 25];
% COM_CloseNXT('all') %prepares workspace
% h=COM_OpenNXT(); %look for USB devices
% COM_SetDefaultNXT(h); %sets default handle
% mot = NXTMotor('A');

OpenUltrasonic(SENSOR_4); %open usensor on port 4
mot.ResetPosition();  %only do this once at the start
mot.SmoothStart = 1;
% rad=zeros(8,1);
%performs a 360 degree scan at 20% power with plotting on

% [rad ang1] = ultraScan2(mot,70*((m*2)-1),8,360);
% [rad ang1] = ultraScan2(mot,25*dir,no,360);
% size(rad)
% if(dir < 0)
%     rad = flipud(rad);
% end
[rad ang1] = ultraScan2(mot,20,no,360);
mot.Power = 40;
mot.TachoLimit = 360;
mot.SendToNXT();
mot.WaitFor();
return; 

