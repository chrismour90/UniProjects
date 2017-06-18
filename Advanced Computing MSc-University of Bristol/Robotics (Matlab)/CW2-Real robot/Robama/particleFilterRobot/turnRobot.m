function wheelTurn = turnRobot(angle,mB,mC)
    % distance between center of the wheels: d1=10.5 cm
    % radius of wheel: d2=4 cm
    % (phi/360)*2*pi*(d1/2) = (wheelTurn/360)*2*pi*(d2/2)
    phi = abs(angle)*180/pi;
    wheelTurn = round(5.25/2.00*phi);
    mB.TachoLimit = wheelTurn;
    mC.TachoLimit = wheelTurn;
    if(angle > 0)
        mB.Power = 20;
        mC.Power = -20;
    else
        mB.Power = -20;
        mC.Power = 20;
    end
    mB.SendToNXT();
    mC.SendToNXT();
    mC.WaitFor();
%     mB.WaitFor();
    mB.Stop('brake');
    mC.Stop('brake');
end