%monada 1
w01=12441.93;
wz1=4809.17;
q1=0.59;
num1=[1 0 wz1^2];
A1=1;
C1=w01^2;
B1=w01/q1;
den1=[A1 B1 C1];

sys1=tf(num1,den1);


%monada 2
w02=16319.94;
q2=1.85;
wz2=11609.71;
num2=[1 0 wz2^2];
A2=1;
C2=w02^2;
B2=w02/q2;
den2=[A2 B2 C2];

sys2=tf(num2,den2);

%synoliki apokrisi

sys=series(sys1,sys2);
a=db2mag(10);

SYS=a*sys;
%synoliki aposvesi
SYSINV=inv(SYS);

ltiview(inv(sys))