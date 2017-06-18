function [ LAR,CurrFrmResd ] = RPE_frame_ST_coder( s0 )

A = [20 20 20 20 13.637 15 8.334 8.824].';
B = [0 0 4 -5 0.184 -3.5 -0.666 -2.235].';


ACF = zeros(1, 9);
for k = 1:9 
    %input signal is divided in 160 non-overlapping frames having length of 20 ms
    sum = 0;
    for i = k:160
        sum = sum + s0(i) * s0(i+1-k);
    end
    ACF(1, k) = sum;
end
rs = ACF;

% Estimate w

R = toeplitz(rs(1:8));
r = rs(2:end);
w = r * inv(R);

% Calculate rc

rc = poly2rc([1; -w.']); 

% Calculate LAR

LAR = zeros(8, 1);
for i = 1:8
    if abs(rc(i)) < 0.675
        LAR(i) = rc(i);
    elseif abs(rc(i)) < 0.950
        LAR(i) = sign(rc(i))*(2 * abs(rc(i)) - 0.675);
    else
        LAR(i) = sign(rc(i))*(8 * abs(rc(i)) - 6.375);
    end
end

% Quantization and coding of LAR

LAR = round(A.*LAR + B);

% Decode quantized LAR

LARc = (LAR - B) ./ A;

% Calculate w

rc = lar2rc(LARc);
w = rc2poly(rc);


% Calculate the final decoded signal

sd = zeros(length(s0), 1);
sd(1:9, 1) = s0(1:9, 1);
for n = 10:length(s0)
    sd(n, 1) = 0;
    for k = 1:length(w)
        sd(n, 1) = sd(n, 1) + w(1, k) * s0(n-k, 1);
    end
end

% Calculate d(n)

d = s0 - sd;

CurrFrmResd=d;

end

