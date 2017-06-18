function [rad] = scanRobot()

addpath(genpath('C:\Program Files\RWTHMindstormsNXT'))
%An example of the ultrasound scanning function
clf;        %clears figures
clc;        %clears console
clear;      %clears workspace

%real_angles=[0:45:315];
%real_distance=[85 25 17 26 18.25 24.75 19.5 25];

COM_CloseNXT all;  
h = COM_OpenNXT();
COM_SetDefaultNXT(h);

OpenUltrasonic(SENSOR_4); %open usensor on port 4
mot = NXTMotor('A');  %motor connected to port C
mot.ResetPosition();  %only do this once at the start

mot.SmoothStart = 1;
rad1=zeros(6,1);
%performs a 360 degree scan at 20% power with plotting on
[rad1 ang1] = ultraScan(mot,50,4);
mot.Power = 50;
mot.TachoLimit = 360;
mot.SendToNXT();
mot.WaitFor();
[rad2 ang2] = ultraScan(mot,50,4);
rad =[rad1;rad2];

return; 

