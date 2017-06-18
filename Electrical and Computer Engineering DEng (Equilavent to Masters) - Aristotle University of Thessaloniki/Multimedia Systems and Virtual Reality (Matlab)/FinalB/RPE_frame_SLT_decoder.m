function [s0,CurrFrmResd] = RPE_frame_SLT_decoder(LAR,Nc,bc,CurrFrmExFull,PrevFrmResd)


% Decode quantized LAR
A = [20 20 20 20 13.637 15 8.334 8.824].';
B = [0 0 4 -5 0.184 -3.5 -0.666 -2.235].';
%QLB used to decode b
QLB = [0.1 0.35 0.65 1];

LARc = (LAR - B) ./ A;

% Decode the other values
for j = 1:4
    Nd = Nc;
    if bc == 0
        bd = QLB(1);
    elseif bc == 1
        bd = QLB(2);
    elseif bc == 2
        bd = QLB(3);
    else
        bd = QLB(4);
    end
    % Calc d'
    for i =1:40
        dd_d((j-1)*40 + i) = CurrFrmExFull((j-1)*40 + i) + bd * PrevFrmResd(length(PrevFrmResd) + i - Nd);
    end
    PrevFrmResd = [PrevFrmResd dd_d((j-1)*40 + 1:(j-1)*40 + 40)];
end

CurrFrmResd = dd_d;

% Calculate decoded rc

rcd = zeros(8, 1);
for i = 1:8
    if abs(LARc(i)) < 0.675
        rcd(i) = LARc(i);
    elseif abs(LARc(i)) < 1.225
        rcd(i) = sign(LARc(i)) *(0.5 * abs(LARc(i)) + 0.3375);
    else
        rcd(i) = sign(LARd(i)) * (0.125 * abs(LARd(i)) + 0.796875);
    end
end
w = rc2poly(rcd);
zmax = 6;
Hs = zeros(1, zmax);
for z = 1:zmax
    ssum = 0;
    for ki = 1:8
        ssum = ssum + w(ki) * z ^ (-ki);
    end
    Hs(z) = 1 / (1 - ssum);
end
s_decod = zeros(1, length(CurrFrmResd));
s_decod(1:zmax + 1) = CurrFrmResd(1:zmax + 1);
for n = zmax + 1:length(CurrFrmResd)
    s_decod(n) = 0;
    for k = 1:length(Hs)
        s_decod(n) = s_decod(n) + Hs(k) * CurrFrmResd(n-k);
    end
end

s_decod1=s_decod(1:160);

s0 = zeros(length(s_decod1), 1);
beta = 28180 * 2 ^ (-15);
s0(1, 1) = s_decod1(1, 1);
for k = 2:length(s_decod)
    s0(k) = s_decod1(k) + beta * s0(k-1, 1);
end


end

