w01=16996.02;
q1=0.766;
num1=w01^2;
A1=1;
C1=num1;
B1=w01/q1;
den1=[A1 B1 C1];

sys1=tf(num1,den1);

w02=31415.93;
q2=3.424;
num2=w02^2;
A2=1;
C2=num2;
B2=w02/q2;
den2=[A2 B2 C2];

sys2=tf(num2,den2);

k = db2mag(5);


sys=series(sys1,sys2);

SYS=k*sys;

SYSINV=inv(SYS);

ltiview(sys1,sys2,SYS)
