wz=4000*pi;

%monada 1
w01=20432.6;
q1=1.99;
num1=[1 0 wz^2];
A1=1;
C1=w01^2;
B1=w01/q1;
den1=[A1 B1 C1];

sys1=tf(num1,den1);

k1=(wz^2)/(w01^2);

%monada 2
w02=wz;
q2=0.89;

A2=1;
C2=w02^2;
B2=w02/q2;
den2=[A2 B2 C2];

sys2=tf(num1,den2);

k2=(wz^2)/(w02^2);

%monada 3
w03=7709.43;
q3=1.99;

A3=1;
C3=w03^2;
B3=w03/q3;
den3=[A3 B3 C3];

sys3=tf(num1,den3);

k3=(wz^2)/(w03^3);


sys1a=series(sys1,sys2);

sys=series(sys1a,sys3);



a=db2mag(5);


SYS=a*sys;
%synoliki aposvesi
SYSINV=inv(SYS);

ltiview(sys1,sys2,sys3,sys,SYS,SYSINV)