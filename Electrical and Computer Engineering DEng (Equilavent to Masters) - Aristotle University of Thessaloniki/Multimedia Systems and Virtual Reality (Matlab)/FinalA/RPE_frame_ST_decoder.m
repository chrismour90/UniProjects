function [ s0 ] = RPE_frame_ST_decoder( LAR, PrevFrmResd )

% Calculate decoded reflection coefficients

A = [20 20 20 20 13.637 15 8.334 8.824].';
B = [0 0 4 -5 0.184 -3.5 -0.666 -2.235].';

LARc = (LAR - B) ./ A;
rc_decod = lar2rc(LARc);
w = rc2poly(rc_decod) ;
Hs = zeros(1, 11);
for z = 1:11
    for ki = 2:9
        Hs(z) = 1 / (1 - w(ki) * z ^ -ki);
    end
end
s_decod1 = conv(PrevFrmResd, Hs);

s_decod=s_decod1(1:160);

s0 = zeros(length(s_decod), 1);
beta = 28180 * 2 ^ (-15);
s0(1, 1) = s_decod(1, 1);
for k = 2:length(s_decod)
    s0(k) = s_decod(k) + beta * s0(k-1, 1);
end



end

