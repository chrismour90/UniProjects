y=[power(2,20) power(2,21) power(2,22) power(2,23)];

%SERIAL
timeS=[2.69 5.93 12.87 28.33];

%PROCESSES=2^3=8 const N=2^17, 2^18, 2^19, 2^20
timeM1=[1.73 3.66 8.07 17.8];

%N=2^20=const P=1 , 2 , 4 , 8
timeM2=[2 3.87 7.73 17.8];

%plot serial with const Processes
figure(1)
plot(timeS,y,'g',timeM1,y,'b');

%plot serial with const N
figure (2)
plot(timeS,y,'g',timeM2,y,'b');

%plot all
figure (3)
plot(timeS,y,'g',timeM1,y,'b',timeM2,y,'m');