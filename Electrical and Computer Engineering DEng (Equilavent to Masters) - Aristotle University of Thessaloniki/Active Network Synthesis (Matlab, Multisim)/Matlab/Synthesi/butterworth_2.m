w0=2000*pi;

%monada 1
w01=8042.48;
q1=1.1;
num1=[-2*w01*q1 0];
A1=1;
C1=w01^2;
B1=w01/q1;
den1=[A1 B1 C1];

sys1=tf(num1,den1);

k1=((2*q1*w01*w0)^2)/((w01^2-w0^2)^2+(((w01/q1)^2)*w0^2));
k1=sqrt(k1);
%monada 2
w02=4908.74;
q2=1.1;
num2=[-2*w02*q2 0];
A2=1;
C2=w02^2;
B2=w02/q2;
den2=[A2 B2 C2];

sys2=tf(num2,den2);

k2=((2*q2*w02*w0)^2)/((w02^2-w0^2)^2+(((w02/q2)^2)*w0^2));
k2=sqrt(k2);
%monada 3
w03=10005.39;
q3=2.88;
num3=[-2*w03*q3 0];
A3=1;
C3=w03^2;
B3=w03/q3;
den3=[A3 B3 C3];

sys3=tf(num3,den3);
k3=((2*q3*w03*w0)^2)/((w03^2-w0^2)^2+(((w03/q3)^2)*w0^2));
k3=sqrt(k3);
%monada 4
w04=3945.73;
q4=2.88;
num4=[-2*w04*q4 0];
A4=1;
C4=w04^2;
B4=w04/q4;
den4=[A4 B4 C4];

sys4=tf(num4,den4);
k4=((2*q4*w04*w0)^2)/((w04^2-w0^2)^2+(((w04/q4)^2)*w0^2));
k4=sqrt(k4);
%synoliki apokrisi
sys1a=series(sys1,sys2);
sys2a=series(sys3,sys4);

k=k1*k2*k3*k4;
a=db2mag(5)/k;

sys=series(sys1a,sys2a);

SYS=a*sys
%synoliki aposvesi
SYSINV=inv(SYS);

ltiview(sys1,sys2,sys3,sys4,sys,SYS,SYSINV);




