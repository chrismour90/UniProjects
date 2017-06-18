function [move,turn,step] = vectorToCommand(vec,currentAng,step,maxMove)
    move = norm(vec);
    turn = mod(atan2(vec(2),vec(1))-currentAng,2*pi);
    if(turn > pi)
        turn = turn - 2*pi;
    end
    if(move > maxMove)
        move = maxMove;
        step = step - 1;
    end
end