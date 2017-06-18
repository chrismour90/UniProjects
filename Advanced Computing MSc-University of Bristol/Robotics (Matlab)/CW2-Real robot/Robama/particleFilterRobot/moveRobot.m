function wheelTurn = moveRobot(distance,mB,mC)
    % distance between center of the wheels: d1=10.5 cm
    % radius of wheel: d2=4 cm
    % distance = (wheelTurn/360)*2*pi*(d2/2)
    wheelTurn = round((distance*360)/(pi*4));
    mB.TachoLimit = wheelTurn;
    mC.TachoLimit = wheelTurn;
    mB.Power = 30;
    mC.Power = 30;
    mB.SendToNXT();
    mC.SendToNXT();
    mC.WaitFor();
%     mB.WaitFor();
    mB.Stop('brake');
    mC.Stop('brake');
end